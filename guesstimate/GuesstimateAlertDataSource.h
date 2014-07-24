//
//  GuesstimateAlertDataSource.h
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GuesstimateAlertDataSource <NSObject>

- (NSString *)titleForAlert:(NSString *)alert;
- (NSString *)messageForAlert:(NSString *)alert;
- (NSString *)actionTextForAlert:(NSString *)alert;
- (NSString *)cancelTextForAlert:(NSString *)alert;
- (NSDictionary *)dataForAlert:(NSString *)alert;

@end
