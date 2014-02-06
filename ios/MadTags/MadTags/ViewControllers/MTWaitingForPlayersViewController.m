//
//  MTWaitingForPlayersViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTWaitingForPlayersViewController.h"
#import "MTTaggers.h"

@interface MTWaitingForPlayersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) NSMutableArray *discoveredTags;

@end


@implementation MTWaitingForPlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.discoveredTags = [NSMutableArray array];
}

- (IBAction)didClickStartButton:(id)sender;
{
	[self.wrapper startGameWithCode:@"1234"];
}

-(void) setCanStartGame:(BOOL)canStartGame;
{
    _canStartGame = canStartGame;
    
//    if( _canStartGame ){
//        self.startButton.alpha = 1.0;
//    }else{
//        self.startButton.alpha = 0.0;
//    }

}

-(void) discoveredTag:(NSDictionary*) tag;
{
    [self.discoveredTags addObject:tag];
    [self.tableView reloadData];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.discoveredTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *tag = [self.discoveredTags objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
    cell.textLabel.text = [tag objectForKey:MTTaggerWordKey];
    
    NSString *tagEngine = [tag objectForKey:MTTaggerSourceNameKey];
    
    if( [@"gracenote" isEqualToString:tagEngine] ){
        cell.imageView.image = [UIImage imageNamed:@"gracenotetag_48x48"];
    }else if( [@"alphonso" isEqualToString:tagEngine] ){
        cell.imageView.image = [UIImage imageNamed:@"alphonsotag_48x48"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
