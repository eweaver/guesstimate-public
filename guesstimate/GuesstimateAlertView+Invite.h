//
//  GuesstimateAlertView+Invite.h
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView.h"

@interface GuesstimateAlertView (Invite)

- (void)showInvite;

+ (void)showInvite:(id<GuesstimateAlertDataSource>)dataSource;

@end
