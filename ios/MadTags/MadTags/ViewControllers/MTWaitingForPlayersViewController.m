//
//  MTWaitingForPlayersViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTWaitingForPlayersViewController.h"

@interface MTWaitingForPlayersViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation MTWaitingForPlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)didClickStartButton:(id)sender;
{
	[self.wrapper startGameWithCode:@"1234"];
}

-(void) setCanStartGame:(BOOL)canStartGame;
{
    _canStartGame = canStartGame;
    
    if( _canStartGame ){
        self.startButton.alpha = 1.0;
    }else{
        self.startButton.alpha = 0.0;
    }

}

@end
