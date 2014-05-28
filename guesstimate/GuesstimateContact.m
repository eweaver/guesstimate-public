//
//  GuesstimateContact.m
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateContact.h"

@implementation GuesstimateContact

+(void)getMyContacts:(void (^)(NSArray *contacts, NSError *error))onComplete {
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    
    if(!user) {
        NSDictionary *errorDictionary = @{ @"error": @"No session user to load invites for."};
        NSError* error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:1 userInfo:errorDictionary];
        onComplete(nil, error);
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
        PFUser *userObject = [PFUser user];
        userObject.objectId = user.objectId;
        [query whereKey:@"myId" equalTo:userObject];
        [query includeKey:@"contactId"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *contactObjects, NSError *error) {
            NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:contactObjects.count];
            
            for(PFObject *contactObject in contactObjects) {
                PFUser *userObject = [contactObject objectForKey:@"contactId"];
                GuesstimateContact *contact = [GuesstimateContact initContact:contactObject.objectId userObject:userObject];
                [contacts addObject:contact];
            }
            
            onComplete(contacts, error);
        }];
    }
}

// Add - verifies contact exists before creating
+(void)addContact:(NSString *)username onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    [GuesstimateContact addContact:username withSource:ContactSourceInApp onCompletionBlock:onComplete];
}

+(void)addContact:(NSString *)username withSource:(NSInteger)source onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    
    if([authUser.name isEqual:username]) {
        NSDictionary *errorDictionary = @{ @"error": @"Cannot add yourself as a contact."};
        NSError *error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:2 userInfo:errorDictionary];
        onComplete(NO, error);
        return;
    }
    
    PFQuery *query= [PFUser query];
    [query whereKey:@"username" equalTo:username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count == 1) {
            // Check for existing contact
            PFUser *newContact = [objects objectAtIndex:0];
            GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
            
            PFQuery *contactQuery = [PFQuery queryWithClassName:@"Contact"];
            [contactQuery whereKey:@"myId" equalTo:[PFUser objectWithoutDataWithObjectId:authUser.objectId]];
            [contactQuery whereKey:@"contactId" equalTo:[PFUser objectWithoutDataWithObjectId:newContact.objectId]];
            
            [contactQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(objects.count > 0) {
                    NSDictionary *errorDictionary = @{ @"error": @"A contact relationship already exists!."};
                    NSError *existingContactError = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:4 userInfo:errorDictionary];
                    onComplete(NO, existingContactError);
                } else if(error) {
                    onComplete(NO, error);
                } else {
                    [self createContact:newContact.objectId withSource:source onCompletionBlock:onComplete];
                }
            }];
        } else {
            NSDictionary *errorDictionary = @{ @"error": @"User does not exist."};
            NSError *error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:3 userInfo:errorDictionary];
            onComplete(NO, error);
        }
    }];
}

// Create
+(void)createContact:(NSString *)contactId onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    [self createContact:contactId withSource:ContactSourceInApp onCompletionBlock:onComplete];
}

+(void)createContact:(NSString *)contactId withSource:(NSInteger)source onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    [self saveContact:contactId withSource:source onCompletionBlock:onComplete];
}

+(void)saveContact:(NSString *)contactId withSource:(NSInteger)source onCompletionBlock:(void (^)(BOOL succeeded, NSError *error))onComplete {
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    
    if(! authUser) {
        NSDictionary *errorDictionary = @{ @"error": @"No session user to create contact for."};
        NSError *error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.UserError" code:1 userInfo:errorDictionary];
        onComplete(NO, error);
        return;
    }
    
    PFObject *contactObject = [PFObject objectWithClassName:@"Contact"];
    PFUser *me = [PFUser user];
    me.objectId = authUser.objectId;
    contactObject[@"myId"] = [PFUser objectWithoutDataWithObjectId:authUser.objectId];
    contactObject[@"contactId"] = [PFUser objectWithoutDataWithObjectId:contactId];
    
    [contactObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        onComplete(succeeded, error);
    }];
}

+(GuesstimateContact *)initContact:(NSString *)objectId userObject:(PFUser *)userObject {
    GuesstimateContact *contact = [[GuesstimateContact alloc] init];
    contact.objectId = objectId;
    contact.user = [GuesstimateUser initWith:userObject];
    
    return contact;
}

@end
