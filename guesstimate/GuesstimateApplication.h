//
//  GuesstimateApplication.h
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "GuesstimateAlertView.h"

@interface GuesstimateApplication : NSObject

@property (assign, nonatomic) BOOL hasDelayedPush;
@property (strong, nonatomic) GuesstimateAlertView *pushView;

+ (id)sharedApp;
+ (UIAlertView *)getErrorAlert:(NSString *)msg;


+ (void)displayWaiting:(UIView *)view;
+ (void)displayWaiting:(UIView *)view withText:(NSString *)text;
+ (void)displayWaiting:(UIView *)view withText:(NSString *)text withSubtext:(NSString *)subtext;

+ (void)hideWaiting:(UIView *)view;

@end
