//
//  MTCard.m
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTCard.h"

@implementation MTCard

- (id)initWithSentence:(NSString*)sentence words:(NSArray*)words;
{
    self = [super init];
    if (self) {
        self.sentence = sentence;
		self.words = words;
    }
    return self;
}
@end
