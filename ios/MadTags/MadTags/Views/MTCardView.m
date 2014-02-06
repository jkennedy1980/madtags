//
//  MTCardView.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTCardView.h"
#import "MTViewController.h"

@interface MTCardView()

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIButton *selectButton;

@end

#define kPadding 20.0
#define kSelectButtonDimension 100.0
#define kSelectButtonBottomPadding 100.0

#define kGreen [UIColor colorWithRed:0.318 green:0.509 blue:0.166 alpha:1.000]
#define kBlue [UIColor colorWithRed:0.057 green:0.259 blue:0.782 alpha:1.000]

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
    self.selected = !self.selected;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectButton.transform = CGAffineTransformMakeScale( 1.1, 1.1 );
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.selectButton.transform = CGAffineTransformIdentity;
        }];
    }];
    
    [self.delegate didSelectCardView:self];
    
//    [self setupButton];

}

-(UIColor*) highlightColor;
{
    if( self.isJudge ){
        return kBlue;
    }else{
        return kGreen;
    }
}

-(void) setupButton;
{
    NSArray *sentenceParts = [self.card.sentence componentsSeparatedByString: @"<<WORD>>"];
    if( (sentenceParts.count - 1) > self.card.words.count ){
        NSLog( @"Invalid card" );
        return;
    }
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    
    int index = 0;
    
    for( NSString *part in sentenceParts ){
        [attText appendAttributedString:[self attributedStringForSentence:part]];
        
        NSString *word = nil;
        if( index < self.card.words.count ){
            word = [self.card.words objectAtIndex:index];
        }
        
        if( word ) [attText appendAttributedString:[self attributedStringForWord:word]];
        index++;
    }
    
    self.textLabel.attributedText = attText;
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake( self.bounds.size.width - kPadding*2, 100.0 )];
    self.textLabel.frame = CGRectMake( kPadding, kPadding, self.bounds.size.width - kPadding*2, size.height );
    
    if( self.selected ){
        self.selectButton.selected = YES;
        self.selectButton.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self.selectButton setTitleColor:[self highlightColor] forState:UIControlStateSelected];
    }else{
        self.selectButton.selected = NO;
        self.selectButton.layer.backgroundColor = [self highlightColor].CGColor;
        [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
         
-(void) playClockDidTick:(NSNotification*) notification;
{
    NSNumber *clockTime = [notification.userInfo objectForKey:MTPlayTimerTickTimeKey];
    [self.selectButton setTitle:[NSString stringWithFormat:@":%@", clockTime] forState:UIControlStateNormal];
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

-(void) setIsJudge:(BOOL)isJudge;
{
    _isJudge = isJudge;
    [self setupButton];
}

-(NSAttributedString*) attributedStringForSentence:(NSString*) sentence;
{
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:sentence];
    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.147 green:0.147 blue:0.147 alpha:1.000] range:NSMakeRange(0, attText.length)];
    [attText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30.0] range:NSMakeRange(0, attText.length)];
    return attText;
}

-(NSAttributedString*) attributedStringForWord:(NSString*) word;
{
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:word];
    [attText addAttribute:NSForegroundColorAttributeName value:[self highlightColor] range:NSMakeRange(0, attText.length)];
    [attText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(0, attText.length)];
    return attText;
}

@end
