//
//  GuesstimateCategory.h
//  guesstimate
//
//  Created by Eric Weaver on 5/12/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GuesstimateCategory : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *bgImage;
@property (assign, nonatomic) BOOL isLocked;

+(void)getCategory:(NSString *)categoryId onCompletion:(void (^)(GuesstimateCategory *category, NSError *error))onComplete;
+(void)getCategories:(void (^)(NSArray *categories, NSError *error))onComplete;
+(GuesstimateCategory *)getDefaultCategory;

-(id)initWithId:(NSString *)objectId withTitle:(NSString *)title withBgImage:(NSString *)bgImage isLocked:(BOOL)isLocked;

@end
