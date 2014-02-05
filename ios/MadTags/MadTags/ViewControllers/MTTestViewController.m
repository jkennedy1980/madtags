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
	self.rocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"http://localhost"]];
}

- (IBAction)didClickSendPing:(id)sender {
}

@end
