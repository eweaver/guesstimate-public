//
//  GuesstimateTicker.m
//  guesstimate
//
//  Created by Eric Weaver on 7/15/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateTicker.h"

@interface GuesstimateTicker ()

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIView *tickerView;

@end

@implementation GuesstimateTicker

-(instancetype) initWithText:(NSString *)text duration:(CGFloat)duration rootView:(UIView *)rootView {
    self = [super init];
    
    if(self) {
        _text = text;
        _duration = duration;
        _rootView = rootView;
    }
    
    return self;
}

- (void) displayBottomTicker {
    CGRect finalFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.tickerView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ([UIScreen mainScreen].bounds.size.height / 4), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 4)];
    self.tickerView.alpha = 0.0f;
    self.tickerView.layer.zPosition = 40.0f;
    self.tickerView.backgroundColor = [UIColor colorWithRed:11.0f/255.0f green:119.0f/255.0f blue:112.0f/255.0f alpha:0.9f];
    
    UILabel *tickerText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tickerView.frame.size.width, [UIScreen mainScreen].bounds.size.height / 4)];
    tickerText.textAlignment = NSTextAlignmentCenter;
    tickerText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    tickerText.text = self.text;
    tickerText.textColor = [UIColor whiteColor];
    [self.tickerView addSubview:tickerText];
    
    [self.rootView addSubview:self.tickerView];
    
    [UIView animateWithDuration:0.4f animations:^{
        self.tickerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.tickerView.frame = finalFrame;
            tickerText.frame = CGRectMake(0, 0, self.tickerView.frame.size.width, 40);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7f delay:self.duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.tickerView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.tickerView removeFromSuperview];
            }];
        }];
        
        
    }];

}

@end
