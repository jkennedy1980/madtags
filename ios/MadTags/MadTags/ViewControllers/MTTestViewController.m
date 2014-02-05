//
//  MTTestViewController.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTTestViewController.h"
#import "SocketIO.h"

@interface MTTestViewController ()<SocketIODelegate>

@property (weak, nonatomic) IBOutlet UILabel *pingResponseLabel;
@property (nonatomic, strong) SocketIO *socket;
@end

@implementation MTTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.socket = [[SocketIO alloc] initWithDelegate:self];
	[self.socket connectToHost:@"localhost" onPort:80];
}

- (IBAction)didClickSendPing:(id)sender {
//	[self.rocket send:[NSString stringWithFormat:@"join"]];
	[self.socket sendEvent:@"join" withData:@{@"username" : @"fucker", @"gameCode" : @"1234"}];
}

#pragma mark - SocketIO Delegate

- (void) socketIODidConnect:(SocketIO *)socket;
{
	NSLog( @"Did Connect");
}
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error;
{
	NSLog( @"Did Disconnect");
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
