//
//  MTTaggerSimulator.m
//  MadTags
//
//  Created by Scott Eklund on 2/6/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import "MTTaggerSimulator.h"

@interface MTTaggerSimulator ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *tagDB;
@property (nonatomic, assign) NSUInteger nextTagIndex;
@end

@implementation MTTaggerSimulator

- (id)init
{
    self = [super init];
    if (self) {
		self.sourceName = @"";
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(giveUpATag) userInfo:nil repeats:YES];
		[self makeTagDB];
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
}

-(void) giveUpATag;
{
	NSArray *tag = [self.tagDB objectAtIndex:self.nextTagIndex++];
	NSDictionary *tagDict = @{MTTaggerWordKey : [tag objectAtIndex:0], MTTaggerSourceNameKey : [tag objectAtIndex:1]};
	[self.delegate didTagContent:tagDict];
}

-(void) makeTagDB;
{
	self.tagDB = @[
		@[@"So You Think You Can Dance",@"ZeeBox"],
		@[@"Modern Family",@"Gracenote"],
		@[@"Cadillac",@"Alphonso"],
		@[@"Cadillac ATS",@"Alphonso"],
		@[@"Game of Thrones",@"Gracenote"],
		@[@"Yeah Yeah Yeahs",@"Gracenote"],
		@[@"Phenomena",@"Gracenote"],
		@[@"Vanity Fair",@"ZeeBox"],
		@[@"Car and Driver",@"ZeeBox"],
		@[@"Esquire",@"ZeeBox"],
		@[@"BMW",@"Alphonso"],
		@[@"BMW X1",@"Alphonso"],
		@[@"The Ultimate Driving Machine",@"ZeeBox"],
		@[@"Ford",@"Alphonso"],
		@[@"Ford Focus",@"Alphonso"],
		@[@"Girls Night Out",@"ZeeBox"],
		@[@"Road Trips",@"ZeeBox"],
		@[@"Speed Dating",@"ZeeBox"],
		@[@"Eco-Boost",@"ZeeBox"],
		@[@"Toyota RAV-4",@"Alphonso"],
		@[@"Toyota",@"Alphonso"],
		@[@"Spare Tire",@"ZeeBox"],
		@[@"Skee-Lo",@"Gracenote"],
		@[@"I Wish",@"Gracenote"],
		@[@"Lexus",@"Alphonso"],
		@[@"Lexus RX",@"Alphonso"],
		@[@"First Sight",@"Gracenote"],
		@[@"The Figgs",@"Gracenote"],
		@[@"Chevy",@"Alphonso"],
		@[@"Cruze",@"Alphonso"],
		@[@"FOX",@"Alphonso"],
		@[@"Cat Deeley",@"ZeeBox"],
		@[@"Nigel Lythgoe",@"ZeeBox"],
		@[@"Mary Murphy",@"ZeeBox"],
		@[@"Adam Shankman",@"ZeeBox"],
		@[@"Best Buy",@"Alphonso"],
		@[@"AT&T",@"Alphonso"],
		@[@"Amy Poehler",@"ZeeBox"],
		@[@"T-Mobile",@"Alphonso"],
		@[@"Sprint",@"Alphonso"],
		@[@"Verizon",@"Alphonso"],
		@[@"Samsung",@"Alphonso"],
		@[@"Kevin Connolly",@"ZeeBox"],
		@[@"Motorola",@"Alphonso"],
		@[@"HTC",@"Alphonso"],
		@[@"Dole",@"Alphonso"],
		@[@"Gatorade",@"Alphonso"],
		@[@"RG3",@"ZeeBox"],
		@[@"Gatorade Frost",@"Alphonso"],
		@[@"Kellogg’s",@"Alphonso"],
		@[@"Special K Multi-Grain",@"Alphonso"],
		@[@"Jennifer Anniston",@"ZeeBox"],
		@[@"Aveeno Active Naturals",@"Alphonso"],
		@[@"Tropical Storm Sandy",@"ZeeBox"],
		@[@"The Ad Council",@"Alphonso"],
		@[@"Heinrich Hertz",@"ZeeBox"],
		@[@"Mazda",@"Alphonso"],
		@[@"The Who",@"Gracenote"],
		@[@"Baba O’Riley",@"Gracenote"],
		@[@"Mazda 6",@"Alphonso"],
		@[@"ActiveSense",@"Alphonso"],
		@[@"Zoom Zoom",@"Alphonso"],
		@[@"Bill Rancic",@"ZeeBox"],
		@[@"Rogaine",@"Alphonso"],
		@[@"Samsung",@"Alphonso"],
		@[@"Depeche Mode",@"Gracenote"],
		@[@"Coctail Song",@"Gracenote"],
		@[@"Tampax Pearl",@"Alphonso"],
		@[@"The Call",@"Alphonso"],
		@[@"Halle Berry",@"Alphonso"],
		@[@"Vicks ZzzQuil",@"Alphonso"],
		@[@"Fountain of Youth",@"Alphonso"],
		@[@"Hollywood",@"Alphonso"],
		@[@"Inner Beauty",@"Alphonso"],
		@[@"Sisterhood",@"Alphonso"],
		@[@"Girl Power",@"Alphonso"],
		@[@"Lana Del Rey",@"Gracenote"],
		@[@"Young and Beautiful",@"Gracenote"],
	];
}
@end
