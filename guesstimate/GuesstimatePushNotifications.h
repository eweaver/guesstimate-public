//
//  GuesstimatePushNotifications.h
//  guesstimate
//
//  Created by Eric Weaver on 5/25/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GuesstimatePushNotifications : NSObject

+(void)saveDeviceToken:(NSData *)deviceToken;
+(void)setInstallationToCurrentUser:(NSString *)userId;
+(void)joinPushChannel:(NSString *)channelName withUsers:(NSArray *)userIds onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
+(void)leavePushChannel:(NSString *)channelName withUsers:(NSArray *)userIds onCompleteBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;

+(void)sendPushToChannel:(NSString *)channelName type:(NSString *)type message:(NSString *)message pushData:(NSDictionary *)pushData expiresAt:(NSDate *)expiresAt;

@end
