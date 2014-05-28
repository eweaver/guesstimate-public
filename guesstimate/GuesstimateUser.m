//
//  GuesstimateUser.m
//  guesstimate
//
//  Created by Eric Weaver on 4/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateUser.h"
#import "GuesstimatePushNotifications.h"

@interface GuesstimateUser ()


@end

@implementation GuesstimateUser

static GuesstimateUser *authUser = nil;

+ (UIImage *)getDefaultPhoto {
    return [UIImage imageNamed:@"default_user.jpg"];
}

+ (GuesstimateUser *)initWith:(PFUser *)userObject {
    // Temp, eventually use source info
    NSString *name;
    if([userObject objectForKey:@"contactFacebookName"]) {
        name = [userObject objectForKey:@"contactFacebookName"];
    } else {
        name = [userObject objectForKey:@"username"];
    }
    
    GuesstimateUser *user = [[GuesstimateUser alloc] initWithId:userObject.objectId withName:name];
    return user;
}

+ (GuesstimateUser *)getAuthUser {
    // Auth user is nil, attempt to load session user
    if(authUser == nil) {
        PFUser *currentUser = [PFUser currentUser];
    
        if (currentUser) {
            [self initAuthUser:currentUser];
        }
    }
    
    return authUser;
}

+ (void)logOutAuthUser {
    [PFUser logOut];
    authUser = nil;
}

+ (GuesstimateUser *)initAuthUser:(PFUser *)user {
    authUser = [[self alloc] initWithId:user.objectId withName:user.username withEmail:user.email withPassword:user.password];
    [GuesstimatePushNotifications setInstallationToCurrentUser:user.objectId];
    return authUser;
}

+ (void)registerWithName:(NSString *)name withEmail:(NSString *)email withPassword:(NSString *) password onCompletionBlock:(void (^)(GuesstimateUser *user, NSError *error))onComplete {
    PFUser *user = [PFUser user];
    user.username = name;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded == YES) {
            onComplete([GuesstimateUser initAuthUser:user], nil);
        } else {
            onComplete(nil, error);
        }
    }];
}

+ (void)loginWithName:(NSString *)name withPassword:(NSString *) password onCompletionBlock:(void (^)(GuesstimateUser *user, NSError *error))onComplete {
    [PFUser logInWithUsernameInBackground:name password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            onComplete([GuesstimateUser initAuthUser:user], nil);
                                        } else {
                                            onComplete(nil, error);
                                        }
                                    }];
}

-(id)initWithId:(NSString *)objectId withName:(NSString *)name {
    self = [super init];
    
    if(self) {
        _objectId = objectId;
        _name = name;
    }
    
    return self;
}

-(id)initWithId:(NSString *)objectId withName:(NSString *)name withEmail:(NSString *)email withPassword:(NSString *)password {
    self = [super init];
    
    if(self) {
        _objectId = objectId;
        _name = name;
        _email = email;
        _password = password;
    }
    
    return self;
}

-(void)setPicture:(NSURL *)photoUrl {
    self.photo = photoUrl;
}

-(void)setPictureUIImage:(UIImage *)photoImage {
    self.photoImage = photoImage;
}

@end
