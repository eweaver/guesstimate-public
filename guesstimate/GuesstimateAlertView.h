//
//  GuesstimateAlertView.h
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuesstimateAlertDataSource.h"
#import "GuesstimateAlertViewDelegate.h"

@interface GuesstimateAlertView : UIAlertView

- (instancetype)initWithType:(NSString *)type dataSource:(id<GuesstimateAlertDataSource>)dataSource;
- (instancetype)initWithDataSource:(id<GuesstimateAlertDataSource>)dataSource;
- (void)showAlert:(NSString *)alert;
- (void)showAlert;

- (GuesstimateAlertViewDelegate *)createDelegate;
- (void)setAlertTypeDelegate:(GuesstimateAlertViewDelegate *)alertDelegate;

+ (void)showAlert:(NSString *)alert dataSource:(id<GuesstimateAlertDataSource>)dataSource;

@end
