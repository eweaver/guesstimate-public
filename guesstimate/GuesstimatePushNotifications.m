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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"pushToken"];
    [defaults synchronize];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

+(void)syncDeviceTokenFromUserDefaults:(void (^)(BOOL succeeded, NSError *error))onComplete {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if(!currentInstallation.deviceToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"pushToken"]) {
            NSData *deviceToken = [defaults objectForKey:@"pushToken"];

            [currentInstallation setDeviceTokenFromData:deviceToken];
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                onComplete(succeeded, error);
                return;
            }];
        }
    }
    
    onComplete(YES, nil);
}

+(void)setInstallationToCurrentUser:(NSString *)userId {
    PFInstallation *installation = [PFInstallation currentInstallation];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"pushToken"]) {
        NSData *deviceToken = [defaults objectForKey:@"pushToken"];
        [installation setDeviceTokenFromData:deviceToken];
    }
    [installation setObject:[PFUser currentUser] forKey:@"user"];
    [installation saveInBackground];
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
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

+(void)sendPushToUsers:(NSArray *)users type:(NSString *)type message:(NSString *)message pushData:(NSDictionary *)pushData expiresAt:(NSDate *)expiresAt {
    PFQuery *innerQuery = [PFUser query];
    [innerQuery whereKey:@"objectId" containedIn:users];
    
    // Build the actual push notification target query
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    [query whereKey:@"user" matchesQuery:innerQuery];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:pushData];
    [tmp setObject:message forKey:@"alert"];
    //[tmp setObject:@"Increment" forKey:@"badge"];
    [tmp setObject:type forKey:@"type"];
    NSDictionary *data = [[NSDictionary alloc] initWithDictionary:tmp];
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    //[push setMessage:message];
    [push setData:data];
    [push expireAtDate:expiresAt];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
}

@end