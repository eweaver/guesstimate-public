//
//  GuesstimateApplication.m
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateApplication.h"

@implementation GuesstimateApplication

+ (id)sharedApp {
    static GuesstimateApplication *shareApp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareApp = [[self alloc] init];
    });
    return shareApp;
}

+ (UIAlertView *)getErrorAlert:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An error has occurred!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    return alert;
}

+ (void)displayWaiting:(UIView *)view {
    [GuesstimateApplication getHUD:view];
    /*dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
    });*/
}

+ (void)displayWaiting:(UIView *)view withText:(NSString *)text {
    MBProgressHUD *hud = [GuesstimateApplication getHUD:view];
    hud.labelText = text;
}

+ (void)displayWaiting:(UIView *)view withText:(NSString *)text withSubtext:(NSString *)subtext {
    MBProgressHUD *hud = [GuesstimateApplication getHUD:view];
    hud.labelText = text;
    hud.detailsLabelText = subtext;
}

+ (void)hideWaiting:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
    
}

+ (MBProgressHUD *)getHUD:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.layer.zPosition = 100.0f;
    
    hud.labelColor = [UIColor whiteColor];
    hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f];
    
    hud.detailsLabelColor = [UIColor whiteColor];
    hud.detailsLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    
    return hud;
}

@end
