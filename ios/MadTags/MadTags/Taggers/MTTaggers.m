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
#import "MTTaggerSimulator.h"

@interface MTTaggers ()
@property (nonatomic, strong) id<MTTagger> tagger;
@property (nonatomic, strong) NSArray *taggerClasses;
@end

@implementation MTTaggers

- (id)initWithSeed:(NSUInteger)seed delegate:(id<MTTaggerDelegate>)delegate;
{
    self = [super init];
    if (self) {
#if TARGET_IPHONE_SIMULATOR
		self.taggerClasses = @[[MTGracenoteEntourage class], [MTTaggerSimulator class]]; //, [MTAlphonso class]];
#else
		self.taggerClasses = @[[MTGracenoteEntourage class], [MTAlphonso class]];
#endif
		self.tagger = [self taggerForSeed:seed];
		self.tagger.delegate = delegate;
    }
    return self;
}

-(id<MTTagger>) taggerForSeed:(NSUInteger)seed;
{
	NSUInteger numTaggers = [self.taggerClasses count];
	NSUInteger index = seed % numTaggers;
	Class taggerClass = [self.taggerClasses objectAtIndex:index];
	return [[taggerClass alloc] init];
}
@end
