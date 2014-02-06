//
//  MTCardView.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTCardView.h"


@interface MTCardView()

@property (nonatomic,strong) UILabel *textLabel;

@end

#define kPadding 20.0

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
    }
    return self;
}

-(void) setCard:(MTCard *)card;
{
    _card = card;
    
    NSArray *sentenceParts = [card.sentence componentsSeparatedByString: @"<<WORD>>"];
    if( (sentenceParts.count - 1) > card.words.count ){
        NSLog( @"Invalid card" );
        return;
    }
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    
    int index = 0;
    
    for( NSString *part in sentenceParts ){
        [attText appendAttributedString:[self attributedStringForSentence:part]];
        
        NSString *word = nil;
        if( index < card.words.count ){
            word = [card.words objectAtIndex:index];
        }
        
        if( word ) [attText appendAttributedString:[self attributedStringForWord:word]];
        index++;
    }

    self.textLabel.attributedText = attText;
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake( self.bounds.size.width - kPadding*2, 100.0 )];
    self.textLabel.frame = CGRectMake( kPadding, kPadding, self.bounds.size.width - kPadding*2, size.height );
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
    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.318 green:0.509 blue:0.166 alpha:1.000] range:NSMakeRange(0, attText.length)];
    [attText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(0, attText.length)];
    return attText;
}

@end
