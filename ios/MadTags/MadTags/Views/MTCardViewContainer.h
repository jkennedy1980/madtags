//
//  MTCardViewContainer.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCard.h"

typedef enum {
	MTCardActionVoting,
	MTCardActionJudging
} MTCardActionType;

@protocol MTCardViewContainerDelegate <NSObject>

-(void) didSelectCard:(MTCard*) card;

@end

@interface MTCardViewContainer : UIView

@property (nonatomic,weak) id<MTCardViewContainerDelegate> delegate;

@property (nonatomic,strong) NSArray *cards;
@property (nonatomic,assign) BOOL isJudge;
@property (nonatomic,assign) MTCardActionType buttonAction;
@property (nonatomic,strong) MTCard *displayedCard;
@property (nonatomic,strong) MTCard *selectedCard;

@end
