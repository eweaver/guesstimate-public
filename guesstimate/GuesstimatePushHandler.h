//
//  GuesstimatePushHandler.h
//  guesstimate
//
//  Created by Eric Weaver on 5/26/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuesstimateUser.h"

@interface GuesstimatePushHandler : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) GuesstimateUser *authUser;

-(void)handlePush:(NSDictionary *)userInfo;

@end
