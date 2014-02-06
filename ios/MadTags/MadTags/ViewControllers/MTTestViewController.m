//
//  MTTestViewController.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTTestViewController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "MTAlphonso.h"
#import "MTGracenoteEntourage.h"

@interface MTTestViewController ()<SocketIODelegate>

@property (weak, nonatomic) IBOutlet UILabel *pingResponseLabel;
@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, strong) MTAlphonso *leAlphonso;
@property (nonatomic, strong)MTGracenoteEntourage *entouage;
@end

@implementation MTTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.socket = [[SocketIO alloc] initWithDelegate:self];
//	[self.socket connectToHost:@"Snickers.local" onPort:80];
//	self.leAlphonso = [[MTAlphonso alloc] init];
	self.entouage = [[MTGracenoteEntourage alloc] init];
}

- (IBAction)didClickSendPing:(id)sender {
	[self.socket sendEvent:@"ping" withData:@{@"message" : @"test"}];
}

- (IBAction)didClickDone:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPokeAlphonso:(id)sender {
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
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [packet.data dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
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
