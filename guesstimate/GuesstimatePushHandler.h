//
//  GuesstimatePushHandler.h
//  guesstimate
//
//  Created by Eric Weaver on 5/26/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuesstimateUser.h"
#import "GuesstimateAlertDataSource.h"
#import "GuesstimateAlertView.h"

@interface GuesstimatePushHandler : NSObject <GuesstimateAlertDataSource>

@property (strong, nonatomic) GuesstimateUser *authUser;

-(void)handlePushView:(GuesstimateAlertView *)alertView;
-(void)handlePush:(NSDictionary *)userInfo;

@end
