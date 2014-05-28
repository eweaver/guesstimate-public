//
//  GuesstimatePushNotifications.m
//  guesstimate
//
//  Created by Eric Weaver on 5/25/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimatePushNotifications.h"
#import "GuesstimateUser.h"

@implementation GuesstimatePushNotifications

+(void)saveDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

+(void)setInstallationToCurrentUser:(NSString *)userId {
    PFUser *user = [PFUser user];
    user.objectId = userId;
    PFInstallation *installation = [PFInstallation currentInstallation];
    user[@"currentInstallation"] = installation;
    [user saveInBackground];
}

+(void)joinPushChannel:(NSString *)channelName withUsers:(NSArray *)userIds onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" containedIn:userIds];
    [userQuery includeKey:@"currentInstallation"];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(NSDictionary *userData in objects) {
            if([userData objectForKey:@"currentInstallation"]) {
                [GuesstimatePushNotifications joinPushChannel:channelName installation:[userData objectForKey:@"currentInstallation"]];
            }
        }
        
        if(error) {
            onComplete(NO, error);
        } else {
            onComplete(YES, error);
        }
    }];
}

+(void)leavePushChannel:(NSString *)channelName withUsers:(NSArray *)userIds onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" containedIn:userIds];
    [userQuery includeKey:@"currentInstallation"];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(NSDictionary *userData in objects) {
            if([userData objectForKey:@"currentInstallation"]) {
                [GuesstimatePushNotifications leavePushChannel:channelName installation:[userData objectForKey:@"currentInstallation"]];
            }
        }
        
        if(error) {
            onComplete(NO, error);
        } else {
            onComplete(YES, error);
        }
    }];
}

+(void)joinPushChannel:(NSString *)channelName installation:(PFInstallation *)installation {
    [installation addUniqueObject:[NSString stringWithFormat:@"C%@", channelName] forKey:@"channels"];
    [installation saveInBackground];
}

+(void)leavePushChannel:(NSString *)channelName installation:(PFInstallation *)installation {
    [installation removeObject:[NSString stringWithFormat:@"C%@", channelName] forKey:@"channels"];
    [installation saveInBackground];
}

+(void)sendPushToChannel:(NSString *)channelName type:(NSString *)type message:(NSString *)message pushData:(NSDictionary *)pushData expiresAt:(NSDate *)expiresAt {
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:pushData];
    [tmp setObject:message forKey:@"alert"];
    //[tmp setObject:@"Increment" forKey:@"badge"];
    [tmp setObject:type forKey:@"type"];
    NSDictionary *data = [[NSDictionary alloc] initWithDictionary:tmp];
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannels:[NSArray arrayWithObjects:[NSString stringWithFormat:@"C%@", channelName], nil]];
    [push setData:data];
    [push expireAtDate:expiresAt];
    [push sendPushInBackground];
}

@end