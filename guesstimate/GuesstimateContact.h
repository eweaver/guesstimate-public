//
//  GuesstimateContact.h
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GuesstimateUser.h"

@interface GuesstimateContact : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) GuesstimateUser *user;

typedef NS_ENUM(NSInteger, ContactSource) {
    ContactSourceInApp,
    ContactSourceFacebook,
    ContactSourceContacts
};

+(void)getMyContacts:(void (^)(NSArray *contacts, NSError *error))onComplete;

+(void)addContact:(NSString *)username onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
+(void)addContact:(NSString *)username withSource:(NSInteger)source onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;

+(void)createContact:(NSString *)contactId onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
+(void)createContact:(NSString *)contactId withSource:(NSInteger)source onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete;
+(GuesstimateContact *)initContact:(NSString *)objectId userObject:(PFUser *)userObject;

@end
