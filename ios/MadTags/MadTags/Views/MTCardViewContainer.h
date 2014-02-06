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
    kMTButtonStateVoting,
    kMTButtonStateWaitingForVotes,
    kMTButtonStateJudging,
    kMTButtonStateWaitingForJudging
} MTButtonState;


@protocol MTCardViewContainerDelegate <NSObject>

-(void) didSelectCard:(MTCard*) card;

@end

@interface MTCardViewContainer : UIView

@property (nonatomic,weak) id<MTCardViewContainerDelegate> delegate;

@property (nonatomic,strong) NSArray *cards;
@property (nonatomic,assign) MTButtonState buttonState;
@property (nonatomic,strong) MTCard *displayedCard;
@property (nonatomic,strong) MTCard *selectedCard;

@end
