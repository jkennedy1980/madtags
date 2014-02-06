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
    self.cardContainerView.delegate = self;
    self.cardContainerView.cards = self.cards;
}

-(void) setCards:(NSArray*) cards;
{
    _cards = cards;
    self.cardContainerView.cards = cards;
}


#pragma mark - MTCardViewContainerDelegate

-(void) didSelectCard:(MTCard*) card;
{
    
}

@end
