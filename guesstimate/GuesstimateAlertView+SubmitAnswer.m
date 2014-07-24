//
//  GuesstimateAlertView+SubmitAnswer.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView+SubmitAnswer.h"

@implementation GuesstimateAlertView (SubmitAnswer)

- (void)showSubmitAnswer {
    [self showAlert:@"submitAnswer"];
}

+ (void)showSubmitAnswer:(id<GuesstimateAlertDataSource>)dataSource {
    [GuesstimateAlertView showAlert:@"submitAnswer" dataSource:dataSource];
}


@end
