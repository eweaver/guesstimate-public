//
//  GuesstimateAlertView+PlayerJoin.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView+PlayerJoin.h"

@implementation GuesstimateAlertView (PlayerJoin)

- (void)showPlayerJoin {
    [self showAlert:@"playerJoin"];
}

+ (void)showPlayerJoin:(id<GuesstimateAlertDataSource>)dataSource {
    [GuesstimateAlertView showAlert:@"playerJoin" dataSource:dataSource];
}

@end
