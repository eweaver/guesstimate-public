//
//  GuesstimateQuestion.h
//  guesstimate
//
//  Created by Eric Weaver on 5/12/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GuesstimateQuestion : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *text;

+(void)getQuestions:(NSString *)categoryId onCompleteBlock:(void (^)(NSArray *questions, NSError *error))onComplete;

-(id)initWithId:(NSString *)objectId withCategory:(NSString *)categoryId withText:(NSString *)text;

@end
