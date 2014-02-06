//
//  MTRoundWinnerViewController.h
//  MadTags
//
//  Created by Josh Kennedy on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCard.h"


@protocol MTRoundWinnerViewControllerDelegate <NSObject>

-(void) didClickStart;

@end


@interface MTRoundWinnerViewController : UIViewController

@property (nonatomic,strong) MTCard *card;
@property (nonatomic,weak) id<MTRoundWinnerViewControllerDelegate> delegate;

@end
