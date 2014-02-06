//
//  MTWaitingForPlayersViewController.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSocketWrapper.h"

@interface MTWaitingForPlayersViewController : UIViewController

@property (nonatomic,assign) BOOL canStartGame;
@property (strong, nonatomic) MTSocketWrapper *wrapper;

-(void) discoveredTag:(NSDictionary*) tag;

@end
