//
//  MTTaggers.h
//  MadTags
//
//  Created by Scott Eklund on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTTaggerDelegate <NSObject>

-(void) didTagContent:(NSDictionary*)tagDict;

@end

@protocol MTTagger <NSObject>
@property (nonatomic, weak) id<MTTaggerDelegate> delegate;
@end

@interface MTTaggers : NSObject

- (id)initWithSeed:(int)seed andTaggerClasses:(NSArray*)classes delegate:(id<MTTaggerDelegate>)delegate;

@end
