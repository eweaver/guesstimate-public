//
//  FacebookLibrary.h
//  guesstimate
//
//  Created by Eric Weaver on 5/15/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GuesstimateApplication.h"

@interface GuesstimateFacebookLibrary : NSObject

+(void) openSession:(void (^)(void))onSessionComplete;
+(void) meWithBlock:(void (^)(NSDictionary *userData, NSError *error))onComplete;

@end
