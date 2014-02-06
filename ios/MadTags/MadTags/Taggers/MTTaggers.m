//
//  MTTaggers.m
//  MadTags
//
//  Created by Scott Eklund on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTTaggers.h"
#import "MTGracenoteEntourage.h"
#import "MTAlphonso.h"

@interface MTTaggers ()
@property (nonatomic, strong) id<MTTagger> tagger;
@property (nonatomic, strong) NSArray *taggerClasses;
@end

@implementation MTTaggers

- (id)initWithSeed:(int)seed delegate:(id<MTTaggerDelegate>)delegate;
{
    self = [super init];
    if (self) {
		self.taggerClasses = @[[MTGracenoteEntourage class]]; //, [MTAlphonso class]];
		self.tagger = [self taggerForSeed:seed];
		self.tagger.delegate = delegate;
    }
    return self;
}

-(id<MTTagger>) taggerForSeed:(int)seed;
{
	NSUInteger numTaggers = [self.taggerClasses count];
	NSUInteger index = seed % numTaggers;
	Class taggerClass = [self.taggerClasses objectAtIndex:index];
	return [[taggerClass alloc] init];
}
@end
