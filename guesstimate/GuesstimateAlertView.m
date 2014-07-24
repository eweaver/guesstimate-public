//
//  GuesstimateAlertView.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView.h"
#import "FSPSAppDelegate.h"
#import "MMDrawerController.h"
#import "GuesstimateApplication.h"
#import "GuesstimateGame.h"
#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateInvite.h"

@interface GuesstimateAlertView ()

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *currentType;
@property (strong, nonatomic) id<GuesstimateAlertDataSource> dataSource;
@property (strong, nonatomic) GuesstimateAlertViewDelegate *alertDelegate;

@end

@implementation GuesstimateAlertView

- (instancetype)initWithType:(NSString *)type dataSource:(id<GuesstimateAlertDataSource>)dataSource {
    self = [super init];
    if(self) {
        _type = type;
        _dataSource = dataSource;
    }
    
    return self;
}

- (instancetype)initWithDataSource:(id<GuesstimateAlertDataSource>)dataSource {
    self = [super init];
    if(self) {
        _type = @"default";
        _dataSource = dataSource;
    }
    
    return self;
}

- (GuesstimateAlertViewDelegate *)createDelegate {
    return [[GuesstimateAlertViewDelegate alloc] initWithType:self.type dataSource:self.dataSource];
}

- (void)setAlertTypeDelegate:(GuesstimateAlertViewDelegate *)alertDelegate {
    self.alertDelegate = alertDelegate;
}

- (void)showAlert:(NSString *)alert {
    [GuesstimateAlertView dismissAlertViews];
    self.currentType = alert;
    if(self.alertDelegate == nil) {
        self.alertDelegate = [[GuesstimateAlertViewDelegate alloc] initWithType:self.type dataSource:self.dataSource];
    }
    UIAlertView *pushView = [[UIAlertView alloc] initWithTitle:[self.dataSource titleForAlert:alert] message:[self.dataSource messageForAlert:alert] delegate:self.alertDelegate cancelButtonTitle:[self.dataSource cancelTextForAlert:alert] otherButtonTitles:[self.dataSource actionTextForAlert:alert], nil];
    [pushView show];
}

- (void)showAlert {
    [self showAlert:self.type];
}

+ (void)showAlert:(NSString *)alert dataSource:(id<GuesstimateAlertDataSource>)dataSource {
    GuesstimateAlertView *alertView = [[GuesstimateAlertView alloc] initWithType:alert dataSource:dataSource];
    [alertView showAlert:alert];
}

#pragma mark utility

+ (void)dismissAlertViews {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0)
            if ([[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]])
                [(UIAlertView *)[subviews objectAtIndex:0] dismissWithClickedButtonIndex:[(UIAlertView *)[subviews objectAtIndex:0] cancelButtonIndex] animated:NO];
    }
}

@end
