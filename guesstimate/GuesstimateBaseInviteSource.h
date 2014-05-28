//
//  GuesstimateBaseInviteMethod.h
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GuesstimateApplication.h"

@interface GuesstimateBaseInviteSource : NSObject

+(void) getContacts:(void (^)(NSArray *contacts, NSError *error))onComplete;
+(void) getContactsAndInvitees:(void (^)(NSArray *contacts, NSArray *invitees, NSError *error))onComplete;

@end
