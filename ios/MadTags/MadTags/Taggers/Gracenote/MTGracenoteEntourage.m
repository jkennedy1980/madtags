//
//  MTGracenoteEntourage.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTGracenoteEntourage.h"
#import <GracenoteACR/GnSdkManager.h>
#import <GracenoteACR/GnUser.h>
#import <GracenoteACR/GnAcrAudioConfig.h>
#import <GracenoteACR/GnAcrMatch.h>
#import <GracenoteACR/GnStorageSqlite.h>
#import <GracenoteACR/GnFPCache.h>
#import <GracenoteACR/GnACR.h>
#import <GracenoteACR/GnAudioSourceiOSMic.h>

@interface MTGracenoteEntourage ()<GnAudioSourceDelegate,IGnAcrStatusDelegate,IGnAcrResultDelegate>

@property (nonatomic, strong) GnSdkManager          *sdkManager;
@property (nonatomic, strong) GnACR                 *acr;
@property (nonatomic, strong) GnAudioSourceiOSMic   *audioSource;
@property (nonatomic, strong) GnUser                *acrUser;

@end

@implementation MTGracenoteEntourage



/*** Enter your client id, client tag, and license info here ***/
#define CLIENT_ID  @"2839552"
#define CLIENT_TAG  @"66DE1E462C767D888445ABA7E3FD5250"
#define LICENSE_INFO  @"-- BEGIN LICENSE v1.0 96A6FDD2 --\nlicensee: Gracenote, Inc.\nname:\nnotes: Lic Gen 2.1\nstart_date: 0000-00-00\nclient_id: 2839552\nvideoid_explore: enabled\nacr: enabled\nepg: enabled\n-- SIGNATURE 96A6FDD2 --\nlAADAgAesS6pZeqk5laaXhQuzwuW7uLpft2A52aojgS6S/y6AB6SRkp3SWIKJ9g8mNv744R2V0EIIbDQz8ei8ab6FQw=\n-- END LICENSE 96A6FDD2 --"



- (id)init
{
    self = [super init];
    if (self) {
		NSError* error = nil;

		// Do any additional setup after loading the view, typically from a nib.
		
		// Initialize the Entourage SDK
		self.sdkManager = [[GnSdkManager alloc] initWithLicense:LICENSE_INFO error:nil];
		
		if(self.sdkManager){
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
			NSString *cacheFolderPath = [paths objectAtIndex:0];
			[GnStorageSqlite setStorageFolder:cacheFolderPath error:&error];
			[GnFPCache setStorageFolder:cacheFolderPath error:&error];
		}
		
		NSLog( @"Starting" );
		self.acrUser = [self getUserACR];
		if (!self.acrUser) {
			NSLog(@"Error: Invalid User");
		}
		
		// Create a GnAcr object for this user
		self.acr = [[GnACR alloc] initWithUser:self.acrUser error:nil];
		
		// Set up an audio configuration
		GnAcrAudioConfig *config =
		[[GnAcrAudioConfig alloc] initWithAudioSourceType:GnAcrAudioSourceMic
												sampleRate:GnAcrAudioSampleRate44100
													format:GnAcrAudioSampleFormatPCM16
											   numChannels:1];
		
		// Initialize the GnAcr's audio configuration
		[self.acr audioInitWithAudioConfig:config];
		
		// Initialize the audio source (i.e. device microphone)
		self.audioSource = [[GnAudioSourceiOSMic alloc] initWithAudioConfig:config];
		
		// Assign the delegates
		self.audioSource.audioDelegate = self;
		self.acr.resultDelegate = self;
		self.acr.statusDelegate = self;
		
        [self.audioSource start];
	}
	return self;
}

#pragma mark - Serialized Gracenote User Record

-(GnUser*)getUserACR {
    NSError *error = nil;
    GnUser *user = nil;
    NSString *savedUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"StoredUserKey"];
    
    if (savedUser)
    {
        user = [[GnUser alloc] initWithSerializedUser:savedUser error:&error];
    }
    else
    {
        user  = [[GnUser alloc] initWithClientId:CLIENT_ID
                                     clientIdTag:CLIENT_TAG
                                      appVersion:@"any string you prefer, e.g. '1.0'"
                                registrationType:GnUserRegistrationType_NewUser error:&error];
        
        if (user) {
            [[NSUserDefaults standardUserDefaults] setObject:user.serializedUser
                                                      forKey:@"StoredUserKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (error) {
        NSLog(@"%@", [NSString stringWithFormat:@"getUserACR: ERROR: %@", error.localizedDescription]);
    }
    return user;
}



-(void)audioBytesReady:(void const * const)bytes length:(int)length
{
    // this callback is called from a background thread. It is important to not block this
    // callback for very long. It is advised to offload UI updates and expensive computations to the main thread.
    NSError *error = nil;
    
    error = [self.acr writeBytes:bytes length:length];
    if (error) {
        NSLog(@"audioBytesReady error: %@", error);
    }
}


-(void)acrResultReady:(GnResult*)result
{
    @autoreleasepool {
        // ACR query results will be returned in this callback
        // Below is an example of how to access the result metadata.
        
        // These callbacks may occur on threads other than the main thread.
        // Be careful not to block these callbacks for long periods of time.
        
        NSEnumerator *matches = result.acrMatches;
        
        // For this example we're only looking at the first match, but there could be multiple
        // matches in a result
        NSString *textToDisplay = @"";
        GnAcrMatch *match = [matches nextObject];
        if (!match)
        {
            textToDisplay = @"NO MATCH";
        } else {
            textToDisplay = match.title.display;
        }
        
		NSDictionary *tagDict = @{ MTTaggerWordKey : match.title.display, MTTaggerIsTVShowKey : @(YES), MTTaggerSourceNameKey : @"Gracenote" };
		[self.delegate didTagContent:tagDict];
        NSLog( @"RESULT: %@, %@, %@", match.title.display, match, tagDict );
    }
}


-(void)acrStatusReady:(GnAcrStatus *)status
{
    @autoreleasepool {
        // This status callback will be called periodically with status from the ACR subsystem
        // You can use these statuses as you like.
        
        // These callbacks may occur on threads other than the main thread.
        // Be careful not to block these callbacks for long periods of time.
        
        // Not all statuses are enumerated here. SDK documentation contains all of the possible
        // GnAcrStatus values
        
        NSString *message = nil;
        
        switch (status.statusType) {
            case GnAcrStatusTypeSilent:
                message = [NSString stringWithFormat:@"Audio Silent %10.2f", status.value];
                break;
            case GnAcrStatusTypeSilentRatio:
                message = [NSString stringWithFormat:@"Silent Ratio %10.3f", status.value];
                break;
            case GnAcrStatusTypeError:
                message = [NSString stringWithFormat:@"ERROR %@ (0x%x)", [status.error localizedDescription], status.error.code];
                break;
            case GnAcrStatusTypeMusic:
                message = [NSString stringWithFormat:@"Audio Music"];
                break;
            case GnAcrStatusTypeNoise:
                message = [NSString stringWithFormat:@"Audio Noise"];
                break;
            case GnAcrStatusTypeSpeech:
                message = [NSString stringWithFormat:@"Audio Speech"];
                break;
            case GnAcrStatusTypeOnlineLookupComplete:
                message = [NSString stringWithFormat:@"Online Lookup Complete"];
                break;
            case GnAcrStatusTypeQueryBegin:
                message = [NSString stringWithFormat:@"Online Query Begin"];
                break;
			case GnAcrStatusTypeFingerprintStarted:
                message = [NSString stringWithFormat:@"Fingerprint Started"];
				break;
				
			case GnAcrStatusTypeFingerprintGenerated:
                message = [NSString stringWithFormat:@"Fingerprint Generated"];
				break;
				
            case GnAcrStatusTypeRecordingStarted:
                message = [NSString stringWithFormat:@"Recording Started"];
                break;
            case GnAcrStatusTypeTransition:
                message = [NSString stringWithFormat:@"Transition"];
                break;
            default:
                break;
        }
		
		NSLog(@"Status: %@", message);
        
        if (message != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"GRACENOTE STATUS: %@", message );
            });
        }
    }
}



@end
