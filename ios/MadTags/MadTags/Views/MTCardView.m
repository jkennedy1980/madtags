//
//  MTCardView.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTCardView.h"
#import "MTViewController.h"
#import "MTSentenceUtils.h"

@interface MTCardView()

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIView *selectedMarker;

@end

#define kPadding 20.0
#define kSelectButtonDimension 100.0
#define kSelectButtonBottomPadding 100.0

#define kGreen [UIColor colorWithRed:0.318 green:0.509 blue:0.166 alpha:1.000]
#define kBlue [UIColor colorWithRed:0.057 green:0.259 blue:0.782 alpha:1.000]
#define kDarkGray [UIColor colorWithRed:0.147 green:0.147 blue:0.147 alpha:1.000]


@implementation MTCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 30.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 5.0;
                
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake( kPadding, kPadding, self.bounds.size.width - kPadding*2, 100.0 )];
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.textLabel.numberOfLines = 999;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.textLabel];
        
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake( floor((self.bounds.size.width - kSelectButtonDimension) / 2.0), self.bounds.size.height - kSelectButtonDimension - kSelectButtonBottomPadding, kSelectButtonDimension, kSelectButtonDimension);
        self.selectButton.layer.cornerRadius = floor( kSelectButtonDimension / 2.0 );
        self.selectButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0];
        [self.selectButton addTarget:self action:@selector(didClickSelectButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectButton];
        [self setupButton];
        
        
        self.selectedMarker = [[UIView alloc] initWithFrame:CGRectMake( self.bounds.size.width - 30.0, 10.0, 14, 14)];
        self.selectedMarker.layer.cornerRadius = 7;
        self.selectedMarker.backgroundColor = [self highlightColor];
        self.selectedMarker.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.selectedMarker];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playClockDidTick:) name:MTPlayTimerTickNotification object:nil];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) didClickSelectButton;
{

//    self.selected = !self.selected;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectButton.transform = CGAffineTransformMakeScale( 1.1, 1.1 );
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.selectButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    if( self.selected ){
        [self.delegate didDeselectCardView:self];
    }else{
        [self.delegate didSelectCardView:self];
    }
}

-(UIColor*) highlightColor;
{
    if( self.buttonState == kMTButtonStateJudging || self.buttonState == kMTButtonStateWaitingForJudging ){
        return kBlue;
    }else{
        return kGreen;
    }
}

-(void) setupButton;
{
    self.textLabel.attributedText = [MTSentenceUtils attributedStringForSentence:self.card.sentence withWords:self.card.words textColor:kDarkGray highlightColor:[self highlightColor]];
    
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake( self.bounds.size.width - kPadding*2, 100.0 )];
    self.textLabel.frame = CGRectMake( kPadding, kPadding, self.bounds.size.width - kPadding*2, size.height );
    
    
    if( self.buttonState == kMTButtonStateVoting ){
        
        [self.selectButton setTitle:@":30" forState:UIControlStateNormal];
        self.selectButton.enabled = YES;

    }else if( self.buttonState == kMTButtonStateJudging ){
        
        [self.selectButton setTitle:@"Fav" forState:UIControlStateNormal];
        self.selectButton.enabled = YES;

    }else if( self.buttonState == kMTButtonStateWaitingForJudging ){
        
        [self.selectButton setTitle:@"Wait" forState:UIControlStateNormal];
        self.selectButton.enabled = NO;

    }else if( self.buttonState == kMTButtonStateWaitingForVotes ){
        
        [self.selectButton setTitle:@"Wait" forState:UIControlStateNormal];
        self.selectButton.enabled = NO;

    }else if( self.buttonState == kMTButtonStateWinner ){
        
        [self.selectButton setTitle:@"Start" forState:UIControlStateNormal];
        self.selectButton.enabled = YES;
        
    }
 
    
    self.selectedMarker.backgroundColor = [self highlightColor];

    if( self.selected ){
        self.selectButton.selected = YES;
        self.selectButton.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self.selectButton setTitleColor:[self highlightColor] forState:UIControlStateSelected];
        self.selectedMarker.alpha = 1.0;
    }else{
        self.selectButton.selected = NO;
        self.selectButton.layer.backgroundColor = [self highlightColor].CGColor;
        [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectedMarker.alpha = 0.0;
    }
    
    NSLog( @"Button: %d", self.buttonState );
}

-(void) playClockDidTick:(NSNotification*) notification;
{
    if( self.buttonState == kMTButtonStateVoting ){
        NSNumber *clockTime = [notification.userInfo objectForKey:MTPlayTimerTickTimeKey];
        [self.selectButton setTitle:[NSString stringWithFormat:@":%@", clockTime] forState:UIControlStateNormal];
    }
}

-(void) setButtonState:(MTButtonState)buttonState;
{
    _buttonState = buttonState;
    [self setupButton];
}

-(void) setSelected:(BOOL)selected;
{
    _selected = selected;
    self.selectButton.selected = selected;
    [self setupButton];
}

-(void) setCard:(MTCard *)card;
{
    _card = card;
    [self setupButton];
}

@end
