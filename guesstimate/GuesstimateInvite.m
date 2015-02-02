//
//  GuesstimateInvite.m
//  guesstimate
//
//  Created by Eric Weaver on 5/15/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateInvite.h"
#import "GuesstimateUser.h"
#import "GuesstimatePushNotifications.h"

@implementation GuesstimateInvite

+(GuesstimateInvite *)initInvite:(NSString *)objectId game:(GuesstimateGame *)game inviter:(GuesstimateUser *)inviter {
    GuesstimateInvite *invite = [[GuesstimateInvite alloc] init];
    invite.game = game;
    invite.user = inviter;
    invite.objectId = objectId;
    
    return invite;
}

+(GuesstimateInvite *)initInvite:(NSString *)objectId gameObject:(PFObject *)gameObject inviterObject:(PFUser *)inviterObject {
    GuesstimateGame *game = [GuesstimateGame initGame:gameObject hasQuestion:NO];
    GuesstimateUser *user = [GuesstimateUser initWith:inviterObject];
    GuesstimateInvite *invite = [[GuesstimateInvite alloc] init];
    invite.game = game;
    invite.user = user;
    invite.objectId = objectId;
    
    return invite;
}

+(void)initWithGameObject:(GuesstimateGame *)gameObject inviterObject:(GuesstimateUser *)inviterObject onCompleteBlock:(void (^)(GuesstimateInvite *invite, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    game.objectId = gameObject.objectId;
    
    [query whereKey:@"gameId" equalTo:game];
    [query findObjectsInBackgroundWithBlock:^(NSArray *inviteObjects, NSError *error) {
        GuesstimateInvite *invite = [[GuesstimateInvite alloc] init];
        invite.game = gameObject;
        invite.user = inviterObject;
        if(!error) {
            GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
            
            for(PFObject *inviteObject in inviteObjects) {
                if([[inviteObject objectForKey:@"inviteId"] isEqualToString:authUser.objectId]) {
                    invite.objectId = inviteObject.objectId;
                    onComplete(invite, nil);
                    return;
                }
            }
        } else {
            onComplete(nil, error);
        }
    }];
}

+(void)sendInvite:(NSString *)gameId user:(NSString *)invitedId onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    NSArray *pushMapping = @[invitedId];
    [[self createInvite:gameId user:invitedId] saveInBackgroundWithBlock:onComplete];
    [GuesstimateInvite sendInvitePushNotifications:gameId users:pushMapping];
}

+(void)sendInvites:(NSString *)gameId userIds:(NSArray *)invitedUserIds onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    NSMutableArray *invites = [NSMutableArray arrayWithCapacity:[invitedUserIds count]];
    NSMutableArray *pushMapping = [NSMutableArray arrayWithCapacity:[invitedUserIds count]];
    
    for(NSString *userId in invitedUserIds) {
        [invites addObject:[self createInvite:gameId user:userId]];
        [pushMapping addObject:userId];
    }
    
    [PFObject saveAllInBackground:invites block:onComplete];
    [GuesstimateInvite sendInvitePushNotifications:gameId users:pushMapping];
}

+(void)sendInvites:(NSString *)gameId users:(NSArray *)invitedUsers onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    NSMutableArray *invites = [NSMutableArray arrayWithCapacity:[invitedUsers count]];
    NSMutableArray *pushMapping = [NSMutableArray arrayWithCapacity:[invitedUsers count]];
    
    for(GuesstimateUser *user in invitedUsers) {
        [invites addObject:[self createInvite:gameId user:user.objectId]];
        [pushMapping addObject:user.objectId];
    }
    
    [PFObject saveAllInBackground:invites block:onComplete];
    [GuesstimateInvite sendInvitePushNotifications:gameId users:pushMapping];
}

+(void)sendInvitePushNotifications:(NSString *)gameId users:(NSArray *)users {
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    NSDictionary *pushData = @{@"gameId":gameId, @"creator":user.objectId};
    NSDate *date = [NSDate date];
    NSDate *expiresAt = [date dateByAddingTimeInterval:60*60*1];

    [GuesstimatePushNotifications sendPushToUsers:users type:@"invite" message:@"You have been invited to a game!" pushData:pushData expiresAt:expiresAt];
}

+(void)getMyInvites:(void (^)(NSArray *invites, NSError *error))onComplete {
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    
    if(!user) {
        NSDictionary *errorDictionary = @{ @"error": @"No session user to load invites for."};
        NSError* error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:1 userInfo:errorDictionary];
        onComplete(nil, error);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
        [query whereKey:@"inviteId" equalTo:user.objectId];
        [query includeKey:@"gameId"];
        [query includeKey:@"gameId.categoryId"];
        [query includeKey:@"inviter"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *inviteObjects, NSError *error) {
            NSMutableArray *invites = [NSMutableArray arrayWithCapacity:inviteObjects.count];
            
            for(PFObject *inviteObject in inviteObjects) {
                GuesstimateInvite *invite = [GuesstimateInvite initInvite:inviteObject.objectId gameObject:[inviteObject objectForKey:@"gameId"] inviterObject:[inviteObject objectForKey:@"inviter"]];
                [invites addObject:invite];
            }
            
            onComplete(invites, error);
        }];
    }
}

+(void)getMyInvitesCount:(void (^)(NSInteger count, NSError *error))onComplete {
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    
    if(!user) {
        NSDictionary *errorDictionary = @{ @"error": @"No session user to load invites for."};
        NSError* error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:1 userInfo:errorDictionary];
        onComplete(0, error);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Invite"];
        [query whereKey:@"inviteId" equalTo:user.objectId];
        [query includeKey:@"gameId"];
        [query includeKey:@"gameId.categoryId"];
        [query includeKey:@"inviter"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *inviteObjects, NSError *error) {
            onComplete([inviteObjects count], error);
        }];
    }

}

-(void)acceptInvite:(void (^)(BOOL succeeded, NSError *error))onComplete {
    // Delete invite
    PFObject *invite = [PFObject objectWithClassName:@"Invite"];
    invite.objectId = self.objectId;
    [invite deleteInBackground];
    
    // Update game to hasStarted (if not already)
    if(self.game.hasStarted == NO) {
        PFObject *game = [PFObject objectWithClassName:@"Game"];
        game.objectId = self.game.objectId;
        game[@"hasStarted"] = @YES;
        [game saveInBackground];
    }
    
    // Create game guess entry
    PFObject *guess = [PFObject objectWithClassName:@"Guess"];
    
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    game.objectId = self.game.objectId;
    guess[@"gameId"] = game;
    guess[@"expiresAt"] = self.game.date;
    
    //PFUser *user = [PFUser user];
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    
    if(authUser) {
        PFUser *user = [PFUser user];
        user.objectId = authUser.objectId;
        guess[@"userId"] = user;
        
        [guess saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded == YES) {
                [self.game loadGameGuesses:^(BOOL succeeded, NSError *error) {
                    GuesstimateUser *user = [GuesstimateUser getAuthUser];
                    NSDictionary *pushData = @{@"gameId":self.game.objectId, @"newPlayer":user.objectId};
                    NSDate *date = [NSDate date];
                    NSDate *expiresAt = [date dateByAddingTimeInterval:60*60*1];
                    NSArray *users = [self.game getOtherGamePlayers];
                    [GuesstimatePushNotifications sendPushToUsers:users type:@"newPlayer" message:[NSString stringWithFormat:@"%@ has joined the game!", user.name] pushData:pushData expiresAt:expiresAt];
                }];
            }
            onComplete(succeeded, error);
        }];
    } else {
        //error?
    }
}

// Helpers

+(PFObject *)createInvite:(NSString *)gameId user:(NSString *)invitedId {
    PFObject *game = [PFObject objectWithClassName:@"Game"];
    game.objectId = gameId;
    
    PFObject *invite = [PFObject objectWithClassName:@"Invite"];
    invite[@"gameId"] = game;
    invite[@"inviteId"] = invitedId;
    
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    if(user != nil) {
        PFUser *inviter = [PFUser user];
        inviter.objectId = user.objectId;
        invite[@"inviter"] = inviter;
    } else {
        // error?
    }
    
    return invite;
}

@end
