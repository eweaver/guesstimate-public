//
//  GuesstimateBaseInviteMethod.m
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseInviteSource.h"

@implementation GuesstimateBaseInviteSource

+(void) getContacts:(void (^)(NSArray *games, NSError *error))onComplete {
    onComplete(@[],nil);
}

@end
