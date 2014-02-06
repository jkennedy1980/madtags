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


@interface MTCardViewContainer()<MTCardViewDelegate>

@end


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
        
        if( [tappedView isEqual:self] ) return;
        
        if( self.displayedCard ){
            self.displayedCard = nil;
        }else{
            self.displayedCard = tappedView.card;
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
        view.delegate = self;
        view.isJudge = self.isJudge;
        [self addSubview:view];
    }
    
    [self updateCardLayout];
}

-(void) setDisplayedCard:(MTCard *)displayedCard;
{
    _displayedCard = displayedCard;
    [self updateCardLayoutAnimated:YES];
}

-(void) didSelectCardView:(MTCardView*) cardView;
{
    for( MTCardView *card in self.subviews ){
        if( cardView != card ){
            card.selected = NO;
        }
    }
    
    self.selectedCard = cardView.card;
    [self.delegate didSelectCard:self.selectedCard];
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
    if( self.displayedCard ){
        [self updateCardLayoutForSelectedCard];
        return;
    }
    
    CGFloat yOffset = 0;
    CGFloat visibleCardHeight = self.bounds.size.height / self.cards.count;
    
    for( MTCardView *cardView in self.subviews ){
        cardView.buttonVisible = self.buttonVisible;
        cardView.isJudge = self.isJudge;
        cardView.frame = CGRectMake( 0, yOffset, cardView.bounds.size.width, cardView.bounds.size.height );
        yOffset += visibleCardHeight;
    }
}

-(void) setIsJudge:(BOOL)isJudge;
{
    _isJudge = isJudge;
    for( MTCardView *cardView in self.subviews ){
        cardView.isJudge = self.isJudge;
    }
}

-(void) setButtonVisible:(BOOL)buttonVisible;
{
    _buttonVisible = buttonVisible;
    for( MTCardView *cardView in self.subviews ){
        cardView.buttonVisible = self.buttonVisible;
    }
}

-(void) updateCardLayoutForSelectedCard;
{
    CGFloat visibleCardHeight = 20.0;
    
    BOOL hitSelectedCard = NO;
    NSInteger index = 0;
    
    for( MTCardView *cardView in self.subviews ){
        if( cardView.card == self.displayedCard ){
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
