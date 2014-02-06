//
//  MTUserJoinViewController.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTUserJoinViewController.h"
#import "MTViewController.h"

@interface MTUserJoinViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *userNameTextFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (strong, nonatomic) NSMutableArray *names;

@end

@implementation MTUserJoinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userNameTextFieldContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userNameTextFieldContainer.layer.borderWidth = 1.0;
    
    self.joinButton.layer.cornerRadius = floor( self.joinButton.bounds.size.width / 2.0 );
    
    self.names = [NSMutableArray array];
    [self.names addObject:@"Marilyn"];
    [self.names addObject:@"Frank"];
    [self.names addObject:@"Jimmy"];
    [self.names addObject:@"George"];
    [self.names addObject:@"Sarah"];
    [self.names addObject:@"Heather"];
    
    self.userNameTextField.text = self.names[arc4random_uniform(self.names.count)];
}

- (IBAction)didClickJoinButton:(id)sender;
{
    if( self.userNameTextField.text.length == 0 ) return;
    
    [self.userNameTextField resignFirstResponder];
    [self.delegate didClickJoinWithGameCode:@"1234" username:self.userNameTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if( self.userNameTextField.text.length == 0 ) return NO;

    [self.userNameTextField resignFirstResponder];
    [self.delegate didClickJoinWithGameCode:@"1234" username:self.userNameTextField.text];
    return YES;
}

- (IBAction)didTouchMyTV:(id)sender {
	[self.delegate didClickRestartGame];
}

@end
