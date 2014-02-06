//
//  MTSentenceUtils.m
//  MadTags
//
//  Created by Josh Kennedy on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTSentenceUtils.h"

@implementation MTSentenceUtils

+(NSAttributedString*) attributedStringForSentence:(NSString*) sentence withWords:(NSArray*) words textColor:(UIColor*) textColor highlightColor:(UIColor*) highlightColor;
{
    if( !sentence ) return nil;
    if( !words ) return nil;
    
    NSArray *sentenceParts = [sentence componentsSeparatedByString: @"<<WORD>>"];
    if( (sentenceParts.count - 1) > words.count ){
        NSLog( @"Invalid card" );
        return nil;
    }
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] init];
    
    int index = 0;
    
    for( NSString *part in sentenceParts ){
        [attText appendAttributedString:[self attributedStringForSentence:part textColor:textColor]];
        
        NSString *word = nil;
        if( index < words.count ){
            word = [words objectAtIndex:index];
        }
        
        if( word ) [attText appendAttributedString:[self attributedStringForWord:word textColor:highlightColor]];
        index++;
    }
    
    return attText;
}

+(NSAttributedString*) attributedStringForSentence:(NSString*) sentence textColor:(UIColor*) textColor;
{
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:sentence];
    [attText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, sentence.length)];
    [attText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:30.0] range:NSMakeRange(0, attText.length)];
    return attText;
}

+(NSAttributedString*) attributedStringForWord:(NSString*) word textColor:(UIColor*) textColor;
{
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:word];
    [attText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, word.length)];
    [attText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(0, attText.length)];
    return attText;
}

@end