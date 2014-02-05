//
//  MTUserJoinViewController.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTUserJoinViewControllerDelegate <NSObject>

-(void) didClickJoinWithGameCode:(NSString*) gameCode username:(NSString*) username;

@end


@interface MTUserJoinViewController : UIViewController

@property (nonatomic,weak) id<MTUserJoinViewControllerDelegate> delegate;

@end
