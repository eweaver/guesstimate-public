//
//  GuesstimateAlertViewDelegate.h
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuesstimateAlertDataSource.h"

@interface GuesstimateAlertViewDelegate : NSObject <UIAlertViewDelegate>

- (instancetype)initWithType:(NSString *)type dataSource:(id<GuesstimateAlertDataSource>)dataSource;

@end
