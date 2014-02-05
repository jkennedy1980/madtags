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

@property (weak, nonatomic) IBOutlet UIView *containerViewContainer;
@property (weak, nonatomic) IBOutlet UIView *userJoinContainer;
@property (weak, nonatomic) IBOutlet UIView *waitingForPlayersContainer;

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

-(void) transitionToContainerView:(UIView*) containerView;
{
    containerView.alpha = 0.0;
    [self.containerViewContainer bringSubviewToFront:containerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        containerView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        for( UIView *subview in self.containerViewContainer.subviews ){
            if( subview != containerView ){
                subview.alpha = 0.0;
            }
        }
        
    }];
}

-(void) didClickJoinWithGameCode:(NSString*) gameCode username:(NSString*) username;
{
    [self.wrapper joinGameWithCode:@"1234" username:@"Josh Kennedy"];
}

#pragma mark - Wrapper Delegate

-(void) didConnect;
{
    
}

-(void) didDisconnect;
{
    
}

-(void) changeToGamePhase:(NSString*) gamePhase data:(NSDictionary*) dictionary;
{
    if( [@"waitingForPlayers" isEqualToString:gamePhase] ){
        [self transitionToContainerView:self.waitingForPlayersContainer];
    }else{
        NSLog( @"Unknown game phase: %@", gamePhase );
    }
}

@end