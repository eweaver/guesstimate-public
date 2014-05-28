//
//  GuesstimateGame.h
//  guesstimate
//
//  Created by Eric Weaver on 4/30/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GuesstimateUser.h"
#import "GuesstimateCategory.h"

@interface GuesstimateGame : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *gameName;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) GuesstimateCategory *category;
@property (strong, nonatomic) NSString *questionId;
@property (strong, nonatomic) NSString *questionText;
@property (strong, nonatomic) NSNumber *answer;
@property (strong, nonatomic) NSString *winnerId;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableDictionary *guesses;
@property (assign, nonatomic) BOOL isComplete;
@property (assign, nonatomic) BOOL hasStarted;

#pragma mark collections
+(void)getMyGames:(void (^)(NSArray *games, NSError *error))onComplete;

#pragma mark create
+(void)createGame:(NSString *)categoryId withQuestion:(NSString *)questionId creator:(NSString *)creatorId preview:(NSString *)preview onCompleteBlock:(void (^)(GuesstimateGame *game, NSError *error))onComplete;
+(void)startGame:(NSString *)gameId invites:(NSArray *)invites onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;

#pragma mark init
+(GuesstimateGame *)initGame:(NSString *)objectId withCategory:(NSString *)categoryId withQuestion:(NSString *)questionId;
+(GuesstimateGame *)initGame:(PFObject *)gameObject hasQuestion:(BOOL)hasQuestion;

#pragma mark load
+(void)getGameData:(NSString *)gameId onCompleteBlock:(void (^)(GuesstimateGame *game, NSError *error))onComplete;
-(void)getGameData:(void (^)(GuesstimateGame *game, NSError *error))onComplete;

-(void)loadGameGuesses:(void (^)(BOOL succeeded, NSError *error))onComplete;
-(void)submitGuess:(NSString *)guessId guess:(NSNumber *)guess onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
-(void)completeGame:(NSString *)winnerId;
-(void)setQuestionText:(NSString *)questionText;

-(BOOL)scoreGame;
-(GuesstimateUser *)getGameWinner;
-(GuesstimateUser *)getGameLoser;
-(NSArray *)getGameScoresInOrder;

-(GuesstimateGame *)loadGameWithId:(NSString *)gameId;
-(GuesstimateGame *)loadGameWithGame:(GuesstimateGame *)game;

#pragma mark users
-(void)addUser:(NSString *)userId expiresAt:(NSDate *)expiresAt;

@end