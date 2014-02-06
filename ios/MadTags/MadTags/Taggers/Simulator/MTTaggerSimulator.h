//
//  MTTaggerSimulator.h
//  MadTags
//
//  Created by Scott Eklund on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTTaggers.h"

@interface MTTaggerSimulator : NSObject<MTTagger>
@property (nonatomic, weak) id<MTTaggerDelegate>delegate;
@property (nonatomic, strong) NSString *sourceName;
@end
