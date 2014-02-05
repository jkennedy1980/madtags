//
//  MTUserJoinViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTUserJoinViewController.h"
#import "MTViewController.h"

@interface MTUserJoinViewController ()

@end

@implementation MTUserJoinViewController

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
}

- (IBAction)didClickJoinButton:(id)sender;
{
    MTViewController *vc = (MTViewController*) self.parentViewController;
    [vc didClickJoinWithGameCode:@"1234" username:@"Josh Kennedy"];
}


@end
