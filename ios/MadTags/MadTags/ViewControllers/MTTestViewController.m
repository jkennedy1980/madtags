//
//  MTTestViewController.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTTestViewController.h"
#import "SRWebSocket.h"

@interface MTTestViewController ()<SRWebSocketDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pingResponseLabel;
@property (nonatomic, strong) SRWebSocket *rocket;
@end

@implementation MTTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	NSURL *url = [NSURL URLWithString:@"ws://localhost:80"];
	self.rocket = [[SRWebSocket alloc] initWithURL:url];
	self.rocket.delegate = self;
	[self.rocket open];
}

- (IBAction)didClickSendPing:(id)sender {
	[self.rocket send:[NSString stringWithFormat:@"join"]];
}

#pragma mark - Rocket Delegate

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
	NSString *leMessage = (NSString*) message;
	NSLog(@"Did Receive Message: %@", leMessage );
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
	NSLog(@"Socket did open: %@", webSocket );
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
	NSLog( @"Shit a hamster: %@, %@", webSocket, error );
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
	NSLog( @"Did close socket: %@, code=%d, reason=%@, clean:%d", webSocket, (int)code, reason, wasClean );
}

@end
