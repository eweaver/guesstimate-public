//
//  GuesstimateGame.m
//  guesstimate
//
//  Created by Eric Weaver on 4/30/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateGame.h"
#import "GuesstimateInvite.h"
#import "GuesstimatePushNotifications.h"

@interface GuesstimateGame ()

@property (strong, nonatomic) NSArray *gameScores;

@end

@implementation GuesstimateGame

+(GuesstimateGame *)initGame:(NSString *)objectId withCategory:(NSString *)categoryId withQuestion:(NSString *)questionId {
    GuesstimateGame *game = [[GuesstimateGame alloc] init];
    
    game.objectId = objectId;
    game.categoryId = categoryId;
    game.category = nil;
    game.questionId = questionId;
    game.gameName = objectId;
    
    game.questionText = @"";
    
    game.isComplete = NO;
    game.hasStarted = NO;
    
    game.guesses = [[NSMutableDictionary alloc] init];
    
    return game;
}

+(GuesstimateGame *)initGame:(PFObject *)gameObject hasQuestion:(BOOL)hasQuestion {
    GuesstimateGame *game = [[GuesstimateGame alloc] init];
    
    PFObject *category = [gameObject objectForKey:@"categoryId"];
    PFObject *question = [gameObject objectForKey:@"questionId"];
    
    game.objectId = gameObject.objectId;
    game.categoryId = category.objectId;
    game.questionId = question.objectId;
    game.gameName = [gameObject objectForKey:@"name"];
    
    if(hasQuestion) {
        game.questionText = [question objectForKey:@"text"];
        game.answer = [question objectForKey:@"answer"];
        game.category = [[GuesstimateCategory alloc] initWithId:category.objectId withTitle:[category objectForKey:@"title"] withBgImage:[category objectForKey:@"bg_image"] isLocked:[[category objectForKey:@"isLocked"] boolValue]];
    } else {
        game.questionText = @"";
        game.answer = nil;
        game.category= nil;
    }
    
    game.date = [gameObject objectForKey:@"expiresAt"];
    game.isComplete = [[gameObject objectForKey:@"isComplete"] boolValue];
    game.hasStarted = [[gameObject objectForKey:@"hasStarted"] boolValue];
    game.winnerId = [gameObject objectForKey:@"winner"];
    
    // TODO
    game.guesses = [[NSMutableDictionary alloc] init];
    
    return game;
}

+(void)getMyGames:(void (^)(NSArray *games, NSError *error))onComplete {
    GuesstimateUser *user = [GuesstimateUser getAuthUser];

    if(!user) {
        NSDictionary *errorDictionary = @{ @"error": @"No session user to load games for."};
        NSError* error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:1 userInfo:errorDictionary];
        onComplete(nil, error);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Guess"];
        PFUser *userObject = [PFUser user];
        userObject.objectId = user.objectId;
        
        NSDate *now = [NSDate date];
        
        [query whereKey:@"userId" equalTo:userObject];
        [query whereKey:@"expiresAt" greaterThan:now];
        [query includeKey:@"gameId"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *guessObjects, NSError *error) {
            NSMutableArray *games = [NSMutableArray arrayWithCapacity:guessObjects.count];
            
            for(PFObject *guessObject in guessObjects) {
                [games addObject:[self initGame:[guessObject objectForKey:@"gameId"] hasQuestion:NO]];
            }
            
            onComplete(games, error);
        }];
    }
}

+(void)createGame:(NSString *)categoryId withQuestion:(NSString *)questionId creator:(NSString *)creatorId preview:(NSString *)preview onCompleteBlock:(void (^)(GuesstimateGame *game, NSError *error))onComplete {
    
    PFObject *category = [PFObject objectWithClassName:@"Category"];
    category.objectId = categoryId;
    
    PFObject *question = [PFObject objectWithClassName:@"Question"];
    question.objectId = questionId;
    
    // Set expire for one hour for now
    NSDate *date = [NSDate date];
    NSDate *expiresAt = [date dateByAddingTimeInterval:60*60*1];

    PFObject *gameObject = [PFObject objectWithClassName:@"Game"];
    gameObject[@"categoryId"] = category;
    gameObject[@"questionId"] = question;
    gameObject[@"name"] = preview;
    gameObject[@"hasStarted"] = [NSNumber numberWithBool:NO];
    gameObject[@"isComplete"] = [NSNumber numberWithBool:NO];
    gameObject[@"expiresAt"] = expiresAt;
    
    [gameObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded == YES) {
            GuesstimateGame *game = [GuesstimateGame initGame:gameObject.objectId withCategory:categoryId withQuestion:questionId];
            onComplete(game, error);
            [game addUser:creatorId expiresAt:expiresAt];
            NSArray *pushMapping = @[creatorId];
            [GuesstimatePushNotifications joinPushChannel:[NSString stringWithFormat:@"%@-game", gameObject.objectId] withUsers:pushMapping onCompleteBlock:^(BOOL succeeded, NSError *error) {
                //noop
            }];
        } else {
            onComplete(nil, error);
        }
    }];
}

+(void)startGame:(NSString *)gameId invites:(NSArray *)invites onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    PFObject *gameObject = [PFObject objectWithClassName:@"Game"];
    gameObject.objectId = gameId;
    gameObject[@"hasStarted"] = [NSNumber numberWithBool:YES];
    
    [gameObject saveInBackground];
    
    [GuesstimateInvite sendInvites:gameId users:invites onCompleteBlock:^(BOOL succeeded, NSError *error) {
         onComplete(succeeded, error);
    }];
}

+(void)getGameData:(NSString *)gameId onCompleteBlock:(void (^)(GuesstimateGame *game, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"objectId" equalTo:gameId];
    [query includeKey:@"questionId"];
    [query includeKey:@"categoryId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && [objects count] == 1) {
            GuesstimateGame *game = [self initGame:[objects objectAtIndex:0] hasQuestion:YES];
            onComplete(game, nil);
        } else {
            onComplete(nil, error);
        }
    }];
}

-(void)getGameData:(void (^)(GuesstimateGame *game, NSError *error))onComplete {
    [GuesstimateGame getGameData:self.objectId onCompleteBlock:onComplete];
}

-(void)loadGameGuesses:(void (^)(BOOL succeeded, NSError *error))onComplete {
    PFQuery *quessQuery = [PFQuery queryWithClassName:@"Guess"];
    PFObject *gameObject = [PFObject objectWithClassName:@"Game"];
    gameObject.objectId = self.objectId;
    
    [quessQuery whereKey:@"gameId" equalTo:gameObject];
    [quessQuery includeKey:@"userId"];
    
    [quessQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for(PFObject *guess in objects) {
                GuesstimateUser *user = [GuesstimateUser initWith:[guess objectForKey:@"userId"]];
                
                NSString *guessString = [[guess objectForKey:@"guess"] stringValue];
                NSString *diffString = [[guess objectForKey:@"diff"] stringValue];
                if(guessString == nil) {
                    guessString = @"N/A";
                }
                
                if(diffString == nil) {
                    diffString = @"-1";
                }

                NSDictionary *guessData = @{@"guessId":guess.objectId,
                                            @"gameId":[[guess objectForKey:@"gameId"] objectId],
                                            @"userId":user,
                                            @"guess":guessString,
                                            @"diff":diffString};
            
                [self.guesses setObject:[[guess objectForKey:@"userId"] objectId] forKey:guessData];
            }
            
            onComplete(YES, error);
        }
        else {
            onComplete(NO, error);
        }
    }];
}

-(void)submitGuess:(NSString *)guessId guess:(NSNumber *)guess onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    PFObject *guessObject = [PFObject objectWithClassName:@"Guess"];
    guessObject.objectId = guessId;
    guessObject[@"guess"] = guess;
    guessObject[@"diff"] = [GuesstimateGame getAnswerDiff:guess answer:self.answer];
    
    [guessObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        onComplete(succeeded, error);
    }];
}

-(void)completeGame:(NSString *)winnerId {
    PFObject *gameObject = [PFObject objectWithClassName:@"Game"];
    
    gameObject.objectId = self.objectId;
    gameObject[@"isComplete"] = @YES;
    gameObject[@"winner"] = winnerId;
    
    [gameObject saveInBackground];
}


-(BOOL)scoreGame {
    //if(self.isComplete == NO) {
    //    return NO;
    //}
    
    NSString *winnerId;
    NSString *loserId;
    double smallestDiff = -1;
    double largestDiff = -1;
    
    NSMutableArray *tmpScores = [[NSMutableArray alloc] initWithCapacity:self.guesses.count];
    
    for(NSDictionary *guessData in self.guesses) {
        GuesstimateUser *user = [guessData objectForKey:@"userId"];
        NSNumber *diff = nil;
        
        NSString *guessString = [guessData objectForKey:@"guess"];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *guess = [f numberFromString:guessString];
        diff = [NSNumber numberWithDouble:[[guessData objectForKey:@"diff"] doubleValue]];
        
        if(smallestDiff == -1 || smallestDiff > [diff doubleValue]) {
            smallestDiff = [diff doubleValue];
            winnerId = user.objectId;
        }
        
        if(largestDiff == -1 || largestDiff < [diff doubleValue]) {
            largestDiff = [diff doubleValue];
            loserId = user.objectId;
        }
        
        NSDictionary *scoresData = @{@"user":user, @"guess":guess, @"diff":diff};
        [tmpScores addObject:scoresData];
    }
    
    self.gameScores = [[NSArray alloc] initWithArray:tmpScores];

    return YES;
}

-(GuesstimateUser *)getGameWinner {
    GuesstimateUser *user;
    
    return user;
}

-(GuesstimateUser *)getGameLoser {
    GuesstimateUser *user;
    
    return user;
}

-(NSArray *)getGameScoresInOrder {
    NSArray *sortedArray;
    sortedArray = [self.gameScores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDictionary *aData = (NSDictionary *)a;
        NSNumber *aNumber = [aData objectForKey:@"diff"];
        NSDictionary *bData = (NSDictionary *)b;
        NSNumber *bNumber = [bData objectForKey:@"diff"];
        
        return [aNumber compare:bNumber];
    }];
    return sortedArray;
}


// EEEEEEP

-(GuesstimateGame *)loadGameWithId:(NSString *)gameId {
    // TODO
    GuesstimateGame *game = [[GuesstimateGame alloc] init];
    return game;
}

-(GuesstimateGame *)loadGameWithGame:(GuesstimateGame *)game {
    // TODO
    return game;
}

-(void)addUser:(NSString *)userId expiresAt:(NSDate *)expiresAt {
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    game.objectId = self.objectId;
    
    PFUser *user = [PFUser user];
    user.objectId = userId;
    
    PFObject *guess = [PFObject objectWithClassName:@"Guess"];
    guess[@"gameId"] = game;
    guess[@"userId"] = user;
    guess[@"expiresAt"] = expiresAt;
    
    [guess saveInBackground];
}

// Helpers

+(NSNumber *)getAnswerDiff:(NSNumber *)guess answer:(NSNumber *)answer {
    double diff = fabs([guess doubleValue] - [answer doubleValue]);
    return [NSNumber numberWithDouble:diff];
}

@end
