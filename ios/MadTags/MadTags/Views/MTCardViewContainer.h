//
//  MTCardViewContainer.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCard.h"

@interface MTCardViewContainer : UIView

@property (nonatomic,strong) NSArray *cards;
@property (nonatomic,strong) MTCard *selectedCard;

@end
