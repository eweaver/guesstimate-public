//
//  GuesstimateAlertView+EndGame.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView+EndGame.h"

@implementation GuesstimateAlertView (EndGame)

- (void)showEndGame {
    [self showAlert:@"endGame"];
}

+ (void)showEndGame:(id<GuesstimateAlertDataSource>)dataSource {
    [GuesstimateAlertView showAlert:@"endGame" dataSource:dataSource];
}

@end
