//
//  NSDictionary+GuesstimateAlertViewDataSource.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "NSDictionary+GuesstimateAlertViewDataSource.h"

@implementation NSDictionary (GuesstimateAlertViewDataSource)

- (NSString *)titleForAlert:(NSString *)alert {
    return [self objectForKey:@"title"];
}

- (NSString *)messageForAlert:(NSString *)alert {
    return [self objectForKey:@"message"];
}

- (NSString *)actionTextForAlert:(NSString *)alert {
    return [self objectForKey:@"action"];
}

- (NSString *)cancelTextForAlert:(NSString *)alert {
    return [self objectForKey:@"cancel"];
}

- (NSDictionary *)dataForAlert:(NSString *)alert {
    return [self objectForKey:@"data"];
}

@end
