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
#import "MTJudgeViewController.h"
#import "MTWaitingForPlayersViewController.h"
#import "MTUserJoinViewController.h"

@interface MTViewController ()<MTSocketWrapperDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) MTSocketWrapper *wrapper;

@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;

@property (weak, nonatomic) IBOutlet UIView *containerViewContainer;
@property (weak, nonatomic) IBOutlet UIView *userJoinContainer;
@property (weak, nonatomic) IBOutlet UIView *waitingForPlayersContainer;
@property (weak, nonatomic) IBOutlet UIView *playerChooseCardContainer;
@property (weak, nonatomic) IBOutlet UIView *judgeGameContainer;

@property (weak, nonatomic) MTUserJoinViewController *userJoinViewController;
@property (weak, nonatomic) MTWaitingForPlayersViewController *waitingForPlayersController;
@property (weak, nonatomic) MTPlayerChooseCardViewController *playerChooseCardController;
@property (weak, nonatomic) MTJudgeViewController *judgeGameController;

@property (assign, nonatomic) BOOL isJudge;

#define kPlayTimerLength 10
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
        if( [childController isKindOfClass:[MTUserJoinViewController class]] ){
            self.userJoinViewController = (MTUserJoinViewController*) childController;
            self.userJoinViewController.delegate = self;
        }else if( [childController isKindOfClass:[MTWaitingForPlayersViewController class]] ){
            self.waitingForPlayersController = (MTWaitingForPlayersViewController*) childController;
        }else if( [childController isKindOfClass:[MTPlayerChooseCardViewController class]] ){
            self.playerChooseCardController = (MTPlayerChooseCardViewController*)childController;
        }else if( [childController isKindOfClass:[MTJudgeViewController class]] ){
            self.judgeGameController = (MTJudgeViewController*)childController;
        }
    }
	
	self.userJoinContainer.alpha = 1.0;
	self.waitingForPlayersContainer.alpha = 0.0;
	self.playerChooseCardContainer.alpha = 0.0;
    self.judgeGameContainer.alpha = 0.0;
    
    
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

- (IBAction)didClickNewGame:(id)sender;
{
    // Secret button hit, must be having problems, panic!
	[self.wrapper restartGame:@"1234"];
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
    if( self.playClock < 0 ){
        [self stopPlayTimer];
        if( self.isJudge ){
            [self sendJudgeEndOfPlayMessage];
        }else{
            [self sendPlayerEndOfPlayMessage];
        }
    }
}

-(void) sendPlayerEndOfPlayMessage;
{
    MTCard *selectedCard = self.playerChooseCardController.selectedCard;
    [self.wrapper sendPlayerEndOfPlayMessage:@"1234" selectedCardString:selectedCard.sentence];
}

-(void) sendJudgeEndOfPlayMessage;
{
    __weak MTViewController *weakSelf = self;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after( popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.wrapper sendJudgeEndOfPlayMessage:@"1234"];
    });
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
    [self.startNewGameButton setTitle:username forState:UIControlStateNormal];
    [self.wrapper joinGameWithCode:@"1234" username:username];
}

#pragma mark - Wrapper Delegate

-(void) didConnect;
{
    
}

-(void) didError:(NSError *)error;
{
    [[[UIAlertView alloc] initWithTitle:@"Oh, Sockets!" message:@"Your connection wouldn't open. Check the hoses and try again." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil] show];
}

-(void) didDisconnect;
{
    // TODO: resume
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Your connection disconnected. Press OK to try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
	if( buttonIndex == alertView.cancelButtonIndex ){
		[self.wrapper connect];
	}
}

-(void) changeToGamePhase:(NSString*) gamePhase data:(NSDictionary*) data;
{
    if( [@"waitingForPlayers" isEqualToString:gamePhase] ){
        
        NSString *role = [data objectForKey:@"role"];
		self.isJudge = [@"JUDGE" isEqualToString:role];
        self.waitingForPlayersController.canStartGame = self.isJudge;
		self.waitingForPlayersController.wrapper = self.wrapper;
        [self transitionToContainerView:self.waitingForPlayersContainer];
        
	}else if ([@"Playing" isEqualToString:gamePhase] ){
        
		NSArray *sentences = [data objectForKey:@"sentences"];
		NSString *tag = [data objectForKey:@"tag"];
		
		NSMutableArray *cards = [NSMutableArray array];
		for ( NSString *sentence in sentences ){
			MTCard *card = [[MTCard alloc] initWithSentence:sentence words:@[tag]];
			[cards addObject:card];
		}
		
		self.playerChooseCardController.cards = cards;
		self.playerChooseCardController.isJudge = self.isJudge;

        [self startPlayTimer];
		[self transitionToContainerView:self.playerChooseCardContainer];
        
    }else if( [@"Judging" isEqualToString:gamePhase] ){
        
        NSArray *sentences = [data objectForKey:@"sentences"];
		NSString *tag = [data objectForKey:@"tag"];
		
		NSMutableArray *cards = [NSMutableArray array];
		for ( NSString *sentence in sentences ){
			MTCard *card = [[MTCard alloc] initWithSentence:sentence words:@[tag]];
			[cards addObject:card];
		}
		
		self.judgeGameController.cards = cards;
		self.judgeGameController.isJudge = self.isJudge;
        [self transitionToContainerView:self.judgeGameContainer];

    }else if( [@"error" isEqualToString:gamePhase] ){
        
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:[data objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	
    }else{
        NSLog( @"Unknown game phase: %@", gamePhase );
    }
}

@end