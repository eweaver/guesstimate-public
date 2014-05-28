//
//  GuesstimateBaseViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 4/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "GuesstimateConstants.h"
#import "GuesstimateUser.h"
#import "GuesstimateTransitionAnimator.h"
#import "GuesstimateApplication.h"
#import "GuesstimatePushHandler.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"

@interface GuesstimateBaseViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UITextField *activeTextField;
@property (assign, nonatomic) BOOL shouldEndEditing;
@property (strong, nonatomic) NSDictionary *textFields;
@property (strong, nonatomic) GuesstimatePushHandler *pushHandler;

- (UIView *)addInfoView:(NSString *)text offset:(NSInteger)offset;
- (UIView *)addNegativeButton:(NSString *)text offset:(NSInteger)offset;
- (UIView *)addPositiveButton:(NSString *)text offset:(NSInteger)offset;
- (UIView *)addFacebookButton:(NSInteger)offset;

- (UIView *)addUIBox:(NSInteger)height offset:(NSInteger)offset withColor:(UIColor *)color;
- (UIView *)addSwipeableArrowsToUIView:(UIView *)view leftArrowGesture:(UIGestureRecognizer *)leftArrowGesture rightArrowGesture:(UIGestureRecognizer *)rightArrowGesture;

- (void)hideKeyboardWithTap:(UITapGestureRecognizer *)gr;
- (void)hideKeyboard:(UISwipeGestureRecognizer *)gr;

- (void)textFieldDidBecomeActive:(NSInteger) tag;
- (void)textFieldsDidBecomeInactive;

- (void)displayWaiting;
- (void)hideWaiting;

- (void)addMenuItems;
- (void)addMenuItemsStackedRight:(UIView *)view;
- (void)setBackButton;
- (void)pushMenuItemToRightStack:(UIView *)view imageName:(NSString *)imageName gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;

-(void)logoutAuthUser;

- (void)pushSelectionViewController:(GuesstimateBaseViewController *)viewController;

@end
