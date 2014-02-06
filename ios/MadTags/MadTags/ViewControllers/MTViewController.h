//
//  MTViewController.h
//  MadTags
//
//  Created by Scott Eklund on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTUserJoinViewController.h"

static NSString *MTPlayTimerTickNotification = @"MTPlayTimerTickNotification";
static NSString *MTPlayTimerTickTimeKey = @"MTPlayTimerTickTimeKey";

@interface MTViewController : UIViewController<MTUserJoinViewControllerDelegate>

@end
