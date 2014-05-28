//
//  GuesstimateInvite.h
//  guesstimate
//
//  Created by Eric Weaver on 5/15/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GuesstimateGame.h"
#import "GuesstimateUser.h"

@interface GuesstimateInvite : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) GuesstimateGame *game;
@property (strong, nonatomic) GuesstimateUser *user;

+(GuesstimateInvite *)initInvite:(NSString *)objectId game:(GuesstimateGame *)game inviter:(GuesstimateUser *)inviter;
+(GuesstimateInvite *)initInvite:(NSString *)objectId gameObject:(PFObject *)gameObject inviterObject:(PFUser *)inviterObject;

+(void)sendInvite:(NSString *)gameId user:(NSString *)invitedId onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
+(void)sendInvites:(NSString *)gameId userIds:(NSArray *)invitedUserIds onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
+(void)sendInvites:(NSString *)gameId users:(NSArray *)invitedUsers onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;

+(void)getMyInvites:(void (^)(NSArray *invites, NSError *error))onComplete;

-(void)acceptInvite:(void (^)(BOOL succeeded, NSError *error))onComplete;

@end
