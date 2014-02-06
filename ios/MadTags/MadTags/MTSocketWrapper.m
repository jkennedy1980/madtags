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
        [self.socket connectToHost:@"JOSHs-MacBook-Pro.local" onPort:80];
    }
}

-(void) disconnect;
{
    [self.socket disconnect];
}

-(void) joinGameWithCode:(NSString*) gameCode username:(NSString*) username;
{
    [self.socket sendEvent:@"joinClient" withData:@{ @"username": @"Josh Kennedy", @"gameCode": @"1234" }];
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
    if( [@"changeGamePhase" isEqualToString:eventName] ){
        NSDictionary *args = [[dict objectForKey:@"args"] objectAtIndex:0];
        
        NSDictionary *data = [args objectForKey:@"data"];
        NSString *phaseName = [args objectForKey:@"phase"];
        
        [self.delegate changeToGamePhase:phaseName data:data];
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
}

@end
