//
//  MTChooseCardViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTPlayerChooseCardViewController.h"
#import "MTCardViewContainer.h"

@interface MTPlayerChooseCardViewController ()<MTCardViewContainerDelegate>

@property (weak, nonatomic) IBOutlet MTCardViewContainer *cardContainerView;

@end

@implementation MTPlayerChooseCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.cardContainerView.buttonState = kMTButtonStateVoting;
    self.cardContainerView.delegate = self;
}

-(void) setCards:(NSArray*) cards;
{
    _cards = cards;
    self.cardContainerView.cards = cards;
}

-(void) setIsJudge:(BOOL)isJudge;
{
	_isJudge = isJudge;
	if( _isJudge ){
        self.cardContainerView.buttonState = kMTButtonStateWaitingForVotes;
    }
}



#pragma mark - MTCardViewContainerDelegate

-(void) didSelectCard:(MTCard*) card;
{
    _selectedCard = card;
}

@end
