//
//  MTSocketWrapper.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTSocketWrapper.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "MTTaggers.h"

@interface MTSocketWrapper ()<SocketIODelegate>

@property (nonatomic, strong) SocketIO *socket;

@end


@implementation MTSocketWrapper

- (id)init
{
    self = [super init];
    if (self) {
        self.socket = [[SocketIO alloc] initWithDelegate:self];
    }
    return self;
}

-(void) connect;
{
    if( !self.socket.isConnected ){
        //[self.socket connectToHost:@"192.168.1.3" onPort:80];
        [self.socket connectToHost:@"madtags.jit.su" onPort:80];
    }
}

-(void) disconnect;
{
    [self.socket disconnect];
}


-(void) joinGameWithCode:(NSString*) gameCode username:(NSString*) username;
{
    [self.socket sendEvent:@"joinClient" withData:@{ @"username": username, @"gameCode": gameCode }];
}

-(void) restartGame:(NSString*)gameCode;
{
    [self.socket sendEvent:@"restart" withData:@{ @"gameCode": gameCode }];
}

-(void) startGameWithCode:(NSString*) gameCode;
{
    [self.socket sendEvent:@"start" withData:@{ @"gameCode": gameCode }];
}

-(void) sendJudgeEndOfPlayMessage:(NSString*) gameCode;
{
    [self.socket sendEvent:@"getSubmissions" withData:@{ @"gameCode": gameCode }];
}

-(void) sendPlayerEndOfPlayMessage:(NSString*) gameCode selectedCardString:(NSString*) cardString;
{
    [self.socket sendEvent:@"submit" withData:@{ @"gameCode": gameCode, @"selectedSentence": cardString }];
}

-(void) sendToGameCode:(NSString*) gameCode tag:(NSDictionary*)tagDict;
{
	NSString *word = [tagDict objectForKey:MTTaggerWordKey];
	NSString *source  = [tagDict objectForKey:MTTaggerSourceNameKey];
	if( !source ) source = @"Gracenote";
	
    [self.socket sendEvent:@"tag" withData:@{ @"gameCode": gameCode, @"tag": word, @"source" :  source}];
}

-(void) sendJudgementSentence:(NSString*) sentence;
{
    [self.socket sendEvent:@"judgement" withData:@{ @"sentence": sentence }];
}

-(void) reconnect;
{
    [self.socket disconnect];
    [self connect];
}


#pragma mark - SocketIO Delegate

- (void) socketIODidConnect:(SocketIO *)socket;
{
	NSLog( @"Did Connect");
    [self.delegate didConnect];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error;
{
	NSLog( @"Did Disconnect");
    [self.delegate didDisconnect];
}

- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet;
{
	NSLog( @"Did Receive");
}

- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet;
{
	NSLog( @"didReceiveJSON");
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet;
{
	NSLog( @"didReceiveEvent");
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [packet.data dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                        error: nil];
    
    NSString *eventName = [dict objectForKey:@"name"];
	
    if( [@"gamePhase" isEqualToString:eventName] ){
		
        NSDictionary *args = [[dict objectForKey:@"args"] objectAtIndex:0];
        
        NSDictionary *data = [args objectForKey:@"data"];
        NSString *phaseName = [args objectForKey:@"phase"];
        
        [self.delegate changeToGamePhase:phaseName data:data];
		
    } else if( [@"tag" isEqualToString:eventName] ){
		
//        NSDictionary *args = [[dict objectForKey:@"args"] objectAtIndex:0];
//        
//        NSDictionary *data = [args objectForKey:@"data"];
//		NSString *tagWord = [data objectForKey:@"tag"];
//		NSString *source = [data objectForKey:@"source"];
//		NSDictionary *tagDict = @{MTTaggerWordKey : tagWord, MTTaggerSourceNameKey : source};
//        
//        [self.delegate clientsDidDiscoverTag:tagDict];
		
	}
	
	NSLog( @"dict: %@", dict );
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet;
{
	NSLog( @"didSendMessage");
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error;
{
	NSLog( @"onError");
	[self.delegate didError:error];
}

@end
