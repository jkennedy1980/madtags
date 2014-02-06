//
//  MTSentenceUtils.h
//  MadTags
//
//  Created by Josh Kennedy on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSentenceUtils : NSObject

+(NSAttributedString*) attributedStringForSentence:(NSString*) sentence withWords:(NSArray*) words textColor:(UIColor*) textColor highlightColor:(UIColor*) highlightColor;

@end
