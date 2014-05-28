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
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
    });
}

+ (void)hideWaiting:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
    
}
@end
