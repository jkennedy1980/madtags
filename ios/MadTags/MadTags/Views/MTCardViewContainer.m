//
//  MTCardViewContainer.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTCardViewContainer.h"
#import "MTCard.h"
#import "MTCardView.h"

@implementation MTCardViewContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) awakeFromNib;
{
    [self initialize];
}

-(void) initialize;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tap];
}

-(void) didTap:(UIGestureRecognizer*) recognizer;
{
    if( recognizer.state == UIGestureRecognizerStateEnded ){
        CGPoint point = [recognizer locationInView:self];
        MTCardView *tappedView = (MTCardView *) [self hitTest:point withEvent:nil];
        
        if( self.selectedCard ){
            self.selectedCard = nil;
        }else{
            self.selectedCard = tappedView.card;
        }

    }
}

-(void) setCards:(NSArray *)cards;
{
    for( UIView *cardView in self.subviews ){
        [cardView removeFromSuperview];
    }
    
    _cards = cards;
    
    for( MTCard *card in self.cards ){
        MTCardView *view = [[MTCardView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        view.card = card;
        view.backgroundColor = [UIColor greenColor];
        [self addSubview:view];
    }
    
    [self updateCardLayout];
}

-(void) setSelectedCard:(MTCard *)selectedCard;
{
    _selectedCard = selectedCard;
    [self updateCardLayoutAnimated:YES];
}

-(void) updateCardLayoutAnimated:(BOOL) animated;
{
    if( animated ){
        __weak MTCardViewContainer *weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf updateCardLayout];
        }];
    }else{
        [self updateCardLayout];
    }
}

-(void) updateCardLayout;
{
    if( self.selectedCard ){
        [self updateCardLayoutForSelectedCard];
        return;
    }
    
    CGFloat yOffset = 0;
    CGFloat visibleCardHeight = self.bounds.size.height / self.cards.count;
    
    for( MTCardView *cardView in self.subviews ){
        cardView.frame = CGRectMake( 0, yOffset, cardView.bounds.size.width, cardView.bounds.size.height );
        yOffset += visibleCardHeight;
    }
}

-(void) updateCardLayoutForSelectedCard;
{
    CGFloat visibleCardHeight = 20.0;
    
    BOOL hitSelectedCard = NO;
    NSInteger index = 0;
    
    for( MTCardView *cardView in self.subviews ){
        if( cardView.card == self.selectedCard ){
            hitSelectedCard = YES;
            cardView.frame = CGRectMake( 0, 0, cardView.bounds.size.width, cardView.bounds.size.height);
        }else{
            if( hitSelectedCard == YES ){
                CGFloat yOffset = (self.subviews.count - index) * visibleCardHeight;
                cardView.frame = CGRectMake( 0, self.bounds.size.height - yOffset, cardView.bounds.size.width, cardView.bounds.size.height );
                yOffset += visibleCardHeight;
            }
        }
        index++;
    }
}
@end
