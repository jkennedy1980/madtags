//
//  MTRoundWinnerViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTRoundWinnerViewController.h"
#import "MTCardView.h"

@interface MTRoundWinnerViewController ()<MTCardViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardViewContainer;
@property (weak, nonatomic) IBOutlet MTCardView *cardView;

@end

@implementation MTRoundWinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MTCardView *cardView = [[MTCardView alloc] initWithFrame:CGRectMake(0, 0, self.cardViewContainer.bounds.size.width, self.cardViewContainer.bounds.size.height + 40)];
    self.cardView = cardView;
    self.cardView.delegate = self;
    self.cardView.buttonState = kMTButtonStateWinner;
    self.cardView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.cardViewContainer addSubview:self.cardView];
    self.cardViewContainer.backgroundColor = [UIColor clearColor];
}

-(void) viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}

-(void) setCard:(MTCard *)card;
{
    _card = card;
    self.cardView.card = card;
}

-(void) didSelectCardView:(MTCardView*) cardView;
{
    [self.delegate didClickStart];
}

-(void) didDeselectCardView:(MTCardView*) cardView;
{
    [self.delegate didClickStart];
}

@end
