//
//  MTViewController.m
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTViewController.h"
#import "MTSocketWrapper.h"
#import "MTPlayerChooseCardViewController.h"
#import "MTCard.h"

@interface MTViewController ()<MTSocketWrapperDelegate>

@property (nonatomic,strong) MTSocketWrapper *wrapper;

@property (weak, nonatomic) IBOutlet UIView *containerViewContainer;
@property (weak, nonatomic) IBOutlet UIView *userJoinContainer;
@property (weak, nonatomic) IBOutlet UIView *waitingForPlayersContainer;
@property (weak, nonatomic) IBOutlet UIView *playerChooseCardContainer;

@property (weak, nonatomic) IBOutlet MTPlayerChooseCardViewController *playerChooseCardController;


#define kPlayTimerLength 30
@property (strong, nonatomic) NSTimer *playTimer;
@property (assign, nonatomic) NSInteger playClock;

@end


@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wrapper = [[MTSocketWrapper alloc] init];
    self.wrapper.delegate = self;
    
    self.playTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(playTimerTick) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

    [self appWillEnterForeground];
    
    
    for( UIViewController *childController in self.childViewControllers ){
        if( [childController isKindOfClass:[MTPlayerChooseCardViewController class]] ){
            self.playerChooseCardController = (MTPlayerChooseCardViewController*)childController;
        }
    }
	
	self.userJoinContainer.alpha = 1.0;
	self.waitingForPlayersContainer.alpha = 0.0;
	self.playerChooseCardContainer.alpha = 0.0;
    
//    MTCard *card1 = [[MTCard alloc] init];
//    card1.sentence = @"I'm suffering from a severe case of <<WORD>>.";
//    card1.words = @[@"Toyota"];
//    
//    MTCard *card2 = [[MTCard alloc] init];
//    card2.sentence = @"Tonight is 50 cent shot night. We gettin' <<WORD>> wasted fa sure.";
//    card2.words = @[@"Toyota"];
//
//    MTCard *card3 = [[MTCard alloc] init];
//    card3.sentence = @"This is a card 3";
//    
//    MTCard *card4 = [[MTCard alloc] init];
//    card4.sentence = @"This is a card 4";
//    
//    MTCard *card5 = [[MTCard alloc] init];
//    card5.sentence = @"This is a card 5";
//    
//    NSMutableArray *cards = [NSMutableArray array];
//    [cards addObject:card1];
//    [cards addObject:card2];
//    [cards addObject:card3];
//    [cards addObject:card4];
//    [cards addObject:card5];
//
//    self.playerChooseCardController.cards = cards;
//    
//    [self transitionToContainerView:self.playerChooseCardContainer];
//    
//    [self startPlayTimer];
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

-(void) startPlayTimer;
{
    self.playClock = kPlayTimerLength;
    [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
}

-(void) stopPlayTimer;
{
    self.playClock = kPlayTimerLength;
    [self.playTimer invalidate];
}

-(void) playTimerTick;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTPlayTimerTickNotification object:nil userInfo:@{MTPlayTimerTickTimeKey:@(self.playClock)}];
    self.playClock = self.playClock - 1;
    if( self.playClock < 0 ) [self stopPlayTimer];
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
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Your socket has disconnected. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void) didDisconnect;
{
    // TODO: resume
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