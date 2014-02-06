//
//  MTAlphonso.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTAlphonso.h"
#import "asapi/asapi.h"

#define ALPHONSO_API_KEY   "Alphonso-ios-sdktest-app-API-key-7Gt281Np4"

@interface MTAlphonso ()
@property (nonatomic, strong) asapi *asapi_thang;
@end


@implementation MTAlphonso

- (id)init
{
    self = [super init];
    if (self) {

        self.asapi_thang = [asapi sharedInstance];
		
		asapi_err_t errcode = [self.asapi_thang init_with_api_key:[NSString stringWithUTF8String:ALPHONSO_API_KEY] and_status_callback:^(asapi_state *state){
			if(state.err == ASAPI_SUCCESS) {

				/* The completion block may be invoked in a background thread
				* and UI operations are not allowed on any thread other than
				* the main thread. Switch threads before proceeding.
				*/
				NSNumber *state_m = [[NSNumber alloc] initWithInt:state.state];
				[self performSelectorOnMainThread:@selector(progress_callback:)
									  withObject:state_m
								   waitUntilDone:NO];
			} else {
				NSNumber *err_m = [[NSNumber alloc] initWithInt:state.err];
				[self performSelectorOnMainThread:@selector(progress_callback_err:)
									  withObject:err_m
								   waitUntilDone:NO];
			}
		} and_result_callback:^(asapi_match *content) {
			NSLog(@"Got a Tagline %@, brand %@, Hits %ld, Timestamp %@", content.tagline, content.brand, (long)content.hits, content.start );
			NSDictionary *tagDict = @{MTTaggerWordKey : content.brand, MTTaggerIsProductKey : @(1), MTTaggerSourceName : @"Alphonso" };
			[self.delegate didTagContent:tagDict];
		}];
		
		if(errcode == ASAPI_SUCCESS){
			NSLog( @"Alphonso: called setup" );
		} else {
			NSLog( @"Alphonso: Setup went le Crap" );
		}
	}
	
    return self;
}


- (void) progress_callback:(NSNumber *)state_m
{
    asapi_state_t state = (asapi_state_t)[state_m integerValue];
    NSString *msg;
    
    switch (state) {
        case ASAPI_STATE_INACTIVE:
            msg = [NSString stringWithFormat:@"State: Inactive"];
            break;
			
        case ASAPI_STATE_ACTIVE:
            msg = [NSString stringWithFormat:@"State: Active"];
            break;
			
        case ASAPI_STATE_LISTENING:
            msg = [NSString stringWithFormat:@"State: Listening"];
            break;
			
    }
	
	NSLog(@"progress status says: %@", msg );
    
    if(state == ASAPI_STATE_ACTIVE){
        [self start_listening];
    }
}



- (void) progress_callback_err:(NSNumber *)errNum
{
    NSLog( @"Got Callback: %d", (int)[errNum integerValue] );
}



- (void) start_listening
{
    asapi_err_t errcode = [self.asapi_thang start];
    
    if(errcode == ASAPI_SUCCESS){
        NSLog( @"Alphonso Start Good" );
    } else {
        NSLog( @"Alphonso Start went shit" );
    }
}
@end
