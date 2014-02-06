//
//  MTChooseCardViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTPlayerChooseCardViewController.h"
#import "MTCardViewContainer.h"

@interface MTPlayerChooseCardViewController ()

@property (weak, nonatomic) IBOutlet MTCardViewContainer *cardContainerView;

@end

@implementation MTPlayerChooseCardViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setCards:(NSArray*) cards;
{
    _cards = cards;
    self.cardContainerView.cards = cards;
}

@end
