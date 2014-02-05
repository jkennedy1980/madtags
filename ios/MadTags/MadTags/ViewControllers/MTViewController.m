//
//  MTViewController.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTViewController.h"
#import "MTSocketWrapper.h"

@interface MTViewController ()<MTSocketWrapperDelegate>

@property (nonatomic,strong) MTSocketWrapper *wrapper;

@end


@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wrapper = [[MTSocketWrapper alloc] init];
    self.wrapper.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

    [self appWillEnterForeground];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}

-(void) appWillEnterForeground;
{
    [self.wrapper connect];
}

-(void) appWillEnterBackground;
{
    [self.wrapper disconnect];
}


#pragma mark - Wrapper Delegate

-(void) didConnect;
{
    [self.wrapper joinGameWithCode:@"1234" username:@"Josh Kennedy"];
}

-(void) didDisconnect;
{
    
}

-(void) changeToGamePhase:(NSString*) gamePhase data:(NSDictionary*) dictionary;
{
    
}

@end