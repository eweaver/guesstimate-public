//
//  GuesstimateQuestion.m
//  guesstimate
//
//  Created by Eric Weaver on 5/12/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateQuestion.h"

@implementation GuesstimateQuestion

+(void)getQuestions:(NSString *)categoryId onCompleteBlock:(void (^)(NSArray *questions, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query whereKey:@"categoryId" equalTo:[PFObject objectWithoutDataWithClassName:@"Category" objectId:categoryId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *questions, NSError *error) {
        NSMutableArray *gQuestions = [[NSMutableArray alloc] initWithCapacity:[questions count]];
        for (PFObject *object in questions) {
            [gQuestions addObject:[[GuesstimateQuestion alloc] initWithId:object.objectId withCategory:[object objectForKey:@"categoryId"] withText:[object objectForKey:@"text"]]];
        }
        
        onComplete([[NSArray alloc] initWithArray:gQuestions], error);
    }];
}

-(id)initWithId:(NSString *)objectId withCategory:(NSString *)categoryId withText:(NSString *)text {
    self = [super init];
    
    if(self) {
        _objectId = objectId;
        _categoryId = categoryId;
        _text = text;
    }
    
    return self;
}


@end
