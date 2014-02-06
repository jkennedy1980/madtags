//
//  MTSocketWrapper.h
//  MadTags
//
//  Created by Josh Kennedy on 2/5/14.
//  Copyright (c) 2014 Scott Eklund. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTSocketWrapperDelegate <NSObject>

-(void) didError:(NSError*) error;

-(void) didConnect;

-(void) didDisconnect;

-(void) changeToGamePhase:(NSString*) gamePhase data:(NSDictionary*) dictionary;

-(void) clientsDidDiscoverTag:(NSDictionary*)tagDict;

@end


@interface MTSocketWrapper : NSObject

@property (nonatomic,weak) id<MTSocketWrapperDelegate> delegate;

-(void) connect;

-(void) disconnect;

-(void) joinGameWithCode:(NSString*) gameCode username:(NSString*) username;

-(void) startGameWithCode:(NSString*) gameCode;

-(void) sendJudgeEndOfPlayMessage:(NSString*) gameCode;

-(void) sendPlayerEndOfPlayMessage:(NSString*) gameCode selectedCardString:(NSString*) cardString;

-(void) restartGame:(NSString*)gameCode;

-(void) sendToGameCode:(NSString*) gameCode tag:(NSDictionary*)tagDict;

-(void) sendJudgementSentence:(NSString*) sentence;

@end