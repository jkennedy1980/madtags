//
//  MTChooseCardViewController.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCard.h"

@interface MTPlayerChooseCardViewController : UIViewController

@property (nonatomic,strong) NSArray *cards;
@property (nonatomic,assign) BOOL isJudge;
@property (nonatomic,strong,readonly) MTCard *selectedCard;

@end
