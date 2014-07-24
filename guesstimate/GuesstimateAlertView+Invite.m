//
//  GuesstimateAlertView+Invite.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView+Invite.h"

@implementation GuesstimateAlertView (Invite)

- (void)showInvite {
    [self showAlert:@"invite"];
}

+ (void)showInvite:(id<GuesstimateAlertDataSource>)dataSource {
    [GuesstimateAlertView showAlert:@"invite" dataSource:dataSource];
}

@end
