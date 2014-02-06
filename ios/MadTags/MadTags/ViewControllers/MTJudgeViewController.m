//
//  MTJudgeViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTJudgeViewController.h"
#import "MTCardViewContainer.h"

@interface MTJudgeViewController ()

@property (weak, nonatomic) IBOutlet MTCardViewContainer *cardViewContainer;

@end

@implementation MTJudgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cardViewContainer.isJudge = YES;
    self.cardViewContainer.cards = self.cards;
}

-(void) setCards:(NSArray*) cards;
{
    _cards = cards;
    self.cardViewContainer.cards = cards;
}


@end