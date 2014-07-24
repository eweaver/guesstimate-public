//
//  GuesstimateAlertView+SubmitAnswer.h
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertView.h"

@interface GuesstimateAlertView (SubmitAnswer)

- (void)showSubmitAnswer;

+ (void)showSubmitAnswer:(id<GuesstimateAlertDataSource>)dataSource;

@end
