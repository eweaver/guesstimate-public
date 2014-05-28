//
//  GuesstimateApplication.h
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface GuesstimateApplication : NSObject

@property (assign, nonatomic) BOOL hasDelayedPush;
@property (strong, nonatomic) NSDictionary *pushData;

+ (id)sharedApp;
+ (UIAlertView *)getErrorAlert:(NSString *)msg;
+ (void)displayWaiting:(UIView *)view ;
+ (void)hideWaiting:(UIView *)view;

@end
