//
//  MTJudgeViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTJudgeViewController.h"
#import "MTCardViewContainer.h"

@interface MTJudgeViewController()<MTCardViewContainerDelegate>

@property (weak, nonatomic) IBOutlet MTCardViewContainer *cardViewContainer;

@end

@implementation MTJudgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isJudge = YES;
    
    if( isJudge ){
        self.cardViewContainer.isJudge = YES;
        self.cardViewContainer.buttonVisible = YES;
    }else{
        self.cardViewContainer.isJudge = NO;
        self.cardViewContainer.buttonVisible = NO;
    }
    self.cardViewContainer.delegate = self;
    self.cardViewContainer.cards = self.cards;
}

-(void) setCards:(NSArray*) cards;
{
    _cards = cards;
    self.cardViewContainer.cards = cards;
}


#pragma mark - MTCardViewContainerDelegate

-(void) didSelectCard:(MTCard*) card;
{
    NSLog( @"Done" );
}

@end