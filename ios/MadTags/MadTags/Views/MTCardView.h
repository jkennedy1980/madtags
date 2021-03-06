//
//  MTCardView.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCard.h"
#import "MTCardViewContainer.h"

@class MTCardView;

@protocol MTCardViewDelegate <NSObject>

-(void) didSelectCardView:(MTCardView*) cardView;

-(void) didDeselectCardView:(MTCardView*) cardView;

@end


@interface MTCardView : UIView

@property (nonatomic,strong) MTCard *card;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,weak) id<MTCardViewDelegate> delegate;
@property (nonatomic,assign) MTButtonState buttonState;

@end
