//
//  MTWaitingForPlayersViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTWaitingForPlayersViewController.h"

@interface MTWaitingForPlayersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) NSMutableArray *discoveredTags;

@end


@implementation MTWaitingForPlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.discoveredTags = [NSMutableArray array];
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

#pragma mark - TableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

@end
