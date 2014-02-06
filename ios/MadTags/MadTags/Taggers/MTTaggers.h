//
//  MTTaggers.h
//  MadTags
//
//  Created by Scott Eklund on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MTTaggerWordKey			@"MTTaggerWordKey"
#define MTTaggerIsProductKey	@"MTTaggerIsProductKey"
#define MTTaggerIsTVShowKey		@"MTTaggerIsTVShowKey"
#define MTTaggerTMSIdKey		@"MTTaggerTMSIdKey"
#define MTTaggerSourceNameKey	@"MTTaggerSourceNameKey"

@protocol MTTaggerDelegate <NSObject>

-(void) didTagContent:(NSDictionary*)tagDict;

@end

@protocol MTTagger <NSObject>
@property (nonatomic, weak) id<MTTaggerDelegate> delegate;
@end

@interface MTTaggers : NSObject

- (id)initWithSeed:(NSUInteger)seed delegate:(id<MTTaggerDelegate>)delegate;

@end
