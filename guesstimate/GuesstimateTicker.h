//
//  GuesstimateTicker.h
//  guesstimate
//
//  Created by Eric Weaver on 7/15/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuesstimateTicker : NSObject

- (instancetype) initWithText:(NSString *)text duration:(CGFloat)duration rootView:(UIView *)rootView;
- (void) displayBottomTicker;

@end
