//
//  GuesstimateUser.h
//  guesstimate
//
//  Created by Eric Weaver on 4/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GuesstimateUser : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSURL *photo;
@property (strong, nonatomic) UIImage *photoImage;

+ (UIImage *)getDefaultPhoto;
+ (GuesstimateUser *)initWith:(PFUser *)userObject;
+ (GuesstimateUser *)getAuthUser;
+ (void)logOutAuthUser;
+ (GuesstimateUser *)initAuthUser:(PFUser *)user;
+ (void)registerWithName:(NSString *)name withEmail:(NSString *)email withPassword:(NSString *) password onCompletionBlock:(void (^)(GuesstimateUser *user, NSError *error))onComplete;
+ (void)loginWithName:(NSString *)name withPassword:(NSString *) password onCompletionBlock:(void (^)(GuesstimateUser *user, NSError *error))onComplete;

-(id)initWithId:(NSString *)objectId withName:(NSString *)name;
-(id)initWithId:(NSString *)objectId withName:(NSString *)name withEmail:(NSString *)email withPassword:(NSString *)password;
-(void)setPicture:(NSURL *)photoUrl;
-(void)setPictureUIImage:(UIImage *)photoImage;

@end