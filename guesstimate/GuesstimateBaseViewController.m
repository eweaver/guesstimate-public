//
//  GuesstimateBaseViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 4/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"
#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateQuestionSelectViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"

@interface GuesstimateBaseViewController ()

@property (strong, nonatomic) UIView *leftButtonView;
@property (strong, nonatomic) UIView *rightButtonView;
@property (strong, nonatomic) NSMutableArray *additionalViews;

@end

@implementation GuesstimateBaseViewController

static NSInteger offset = 70;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.additionalViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [[self navigationController] setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.leftButtonView removeFromSuperview];
    [self.rightButtonView removeFromSuperview];
    
    for(UIView *view in self.additionalViews) {
        [view removeFromSuperview];
    }
    
    self.additionalViews = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    offset = 70;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"test_bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    // Logo

    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    UIImage *logoOriginal = [[UIImage alloc] initWithContentsOfFile:thePath];
    UIImage *logo = [self resizeImage:logoOriginal newSize:CGSizeMake(284, 69)];
    
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(16, 70, 284, 69);
    logoView.tag = 101;
    [self.view addSubview:logoView];
    
    
    UIView *logoSubtext = [self addLogoSubtext:@"Are you willing to bet on that?" offset:130];
    logoSubtext.tag = 102;
    [self.view addSubview:logoSubtext];
}

#pragma mark menu items

-(void)addMenuItems {
    // Menu items
    UIView *leftContainerView = [[UIView alloc] initWithFrame:CGRectMake(10, 27, 25, 25)];
    UIButton *contactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactsButton.frame = CGRectMake(0, 0, 25, 25);
    UIImage *btnContacts = [UIImage imageNamed:@"ic_friends.png"];
    UIImageView *btnContactsView = [[UIImageView alloc] initWithImage:btnContacts];
    [contactsButton addSubview:btnContactsView];
    [leftContainerView addSubview:contactsButton];
    
    [self.view addSubview:leftContainerView];
    [self.view bringSubviewToFront:leftContainerView];
    
    // Left Drawer
    UITapGestureRecognizer *tapForContacts = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLeftDrawer)];
    [contactsButton addGestureRecognizer:tapForContacts];
    
    UIView *rightContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 27, 25, 25)];
    UIButton *alertsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alertsButton.frame = CGRectMake(0, 0, 25, 25);
    UIImage *btnImgDone = [UIImage imageNamed:@"ic_alerts.png"];
    UIImageView *btnImageView = [[UIImageView alloc] initWithImage:btnImgDone];
    [alertsButton addSubview:btnImageView];
    [rightContainerView addSubview:alertsButton];
    [self.view addSubview:rightContainerView];
    [self.view bringSubviewToFront:rightContainerView];
    
    // Right Drawer
    UITapGestureRecognizer *tapForAlerts = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRightDrawer)];
    [alertsButton addGestureRecognizer:tapForAlerts];
}

-(void)addMenuItemsStackedRight:(UIView *)view {
    // Menu items
    
    // Left Drawer
    /*[view addSubview:self.leftButtonView];
    [view bringSubviewToFront:self.leftButtonView];
    
    self.leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 7, 25, 25)];
    UIButton *contactsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    contactsButton.frame = CGRectMake(0, 0, 25, 25);
    contactsButton.tintColor = [UIColor whiteColor];
    [contactsButton setImage:[UIImage imageNamed:@"ic_friends.png"] forState:UIControlStateNormal];
    [self.leftButtonView addSubview:contactsButton];
    
    [view addSubview:self.leftButtonView];
    [view bringSubviewToFront:self.leftButtonView];
    
    
    UITapGestureRecognizer *tapForContacts = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLeftDrawer)];
    [contactsButton addGestureRecognizer:tapForContacts];*/
    
    
    self.rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 35, 7, 25, 25)];
    UIButton *alertsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    alertsButton.frame = CGRectMake(0, 0, 25, 25);
    alertsButton.tintColor = [UIColor whiteColor];
    [alertsButton setImage:[UIImage imageNamed:@"ic_alerts.png"] forState:UIControlStateNormal];
    [self.rightButtonView addSubview:alertsButton];
    
    [view addSubview:self.rightButtonView];
    [view bringSubviewToFront:self.rightButtonView];
    
    
    UITapGestureRecognizer *tapForAlerts = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRightDrawer)];
    [alertsButton addGestureRecognizer:tapForAlerts];
}

-(void)backToCategories {
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;

    GuesstimateQuestionSelectViewController *popController = nil;
    for(UIViewController *vc in navController.viewControllers) {
        if([vc isKindOfClass:[GuesstimateQuestionSelectViewController class]]) {
            popController = (GuesstimateQuestionSelectViewController *) vc;
            break;
        }
    }
    
    if(popController == nil) {
        popController = [[GuesstimateQuestionSelectViewController alloc] init];
        [self pushSelectionViewController:popController];
    } else {
        [navController popToViewController:popController animated:YES];
    }
}

-(void)setBackButton {
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(-20.0f, 0, 60.0f, 30.0f)];
    [backButton setTitle:@"Menu" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToCategories) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)pushMenuItemToRightStack:(UIView *)view imageName:(NSString *)imageName gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    // TODO: Update all buttons to this!
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - offset, 7, 25, 25)];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuButton.frame = CGRectMake(0, 0, 25, 25);
    menuButton.tintColor = [UIColor whiteColor];
    [menuButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [containerView addSubview:menuButton];
    
    [view addSubview:containerView];
    [view bringSubviewToFront:containerView];

    [menuButton addGestureRecognizer:gestureRecognizer];
    [self.additionalViews addObject:containerView];
    
    offset += 45;
}

-(void)openLeftDrawer {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)openRightDrawer {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark textfield-shift

-(void)textFieldDidBecomeActive:(NSInteger) tag {
    for (id textFieldTag in self.textFields) {
        int textFieldTagInt = [textFieldTag intValue];
        
        if(textFieldTagInt != tag) {
            [[self.view viewWithTag:textFieldTagInt] setHidden:YES];
        } else {
            UIView *textView = [self.view viewWithTag:textFieldTagInt];
            [textView setHidden:NO];
            [self.view bringSubviewToFront:textView];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                textView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ActiveTextFieldOffset - 60, 320, 60);
                [UIView commitAnimations];
            });
        }
    }
}

-(void)textFieldsDidBecomeInactive {
    for (id textFieldTag in self.textFields) {
        int textFieldTagInt = [textFieldTag intValue];
        int offset = [[self.textFields objectForKey:textFieldTag] intValue];

        UIView *textView = [self.view viewWithTag:textFieldTagInt];
        [textView setHidden:NO];
        //textView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - offset - 60, 320, 60);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            textView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - offset - 60, 320, 60);
            [UIView commitAnimations];
        });

    }
}

#pragma keyboard

-(void)hideKeyboardWithTap:(UITapGestureRecognizer *)gr {
    if([gr view].tag == 0) {
        self.shouldEndEditing = NO;
        if([self.activeTextField canResignFirstResponder]) {
            [self.activeTextField resignFirstResponder];
            [self textFieldsDidBecomeInactive];
        }
    }
}

-(void)hideKeyboard:(UISwipeGestureRecognizer *)gr {
    if([gr view].tag == 0) {
        self.shouldEndEditing = NO;
        if([self.activeTextField canResignFirstResponder]) {
            [self.activeTextField resignFirstResponder];
        }
    }
}

#pragma UI

- (UIView *)addUIBox:(NSInteger)height offset:(NSInteger)offset withColor:(UIColor *)color {
    UIView *box = [[UIView alloc] init];
    CGRect boxFrame = box.frame;
    boxFrame.size.width = self.view.frame.size.width;
    boxFrame.size.height = height;
    box.frame = CGRectOffset(boxFrame, 0, offset);
    [box setBackgroundColor:color];
    
    return box;
}

- (UIView *)addLogoSubtext:(NSString *)text offset:(NSInteger)offset {
    UIView *logoSubtext = [[UIView alloc] init];
    CGRect newFrame = logoSubtext.frame;
    newFrame.size.width = self.view.frame.size.width;
    newFrame.size.height = 40;
    logoSubtext.frame = CGRectOffset(newFrame, 0, offset);

    UILabel *logoText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, logoSubtext.frame.size.width, logoSubtext.frame.size.height)];
    logoText.text = text;
    logoText.textAlignment = NSTextAlignmentCenter;
    [logoText setTextColor:[UIColor whiteColor]];
    [logoText setBackgroundColor:[UIColor clearColor]];
    [logoText setFont:[UIFont fontWithName: @"HelveticaNeue-ThinItalic" size: 17.0f]];
    [logoSubtext addSubview:logoText];
    
    return logoSubtext;

}

- (UIView *)addInfoView:(NSString *)text offset:(NSInteger)offset {
    UIView *positiveView = [[UIView alloc] init];
    CGRect newFrame = positiveView.frame;
    newFrame.size.width = self.view.frame.size.width;
    newFrame.size.height = 65;
    positiveView.frame = CGRectOffset(newFrame, 0, [UIScreen mainScreen].bounds.size.height - offset - newFrame.size.height);
    
    [positiveView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.4 blue:0.8 alpha:0.8]];
    
    UILabel *positiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, positiveView.frame.size.width, positiveView.frame.size.height)];
    positiveLabel.text = text;
    positiveLabel.textAlignment = NSTextAlignmentCenter;
    [positiveLabel setTextColor:[UIColor whiteColor]];
    [positiveLabel setBackgroundColor:[UIColor clearColor]];
    [positiveLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size: 22.0f]];
    [positiveView addSubview:positiveLabel];
    
    return positiveView;
}

- (UIView *)addNegativeButton:(NSString *)text offset:(NSInteger)offset {
    UIView *negativeView = [[UIView alloc] init];
    CGRect newFrame = negativeView.frame;
    newFrame.size.width = self.view.frame.size.width;
    newFrame.size.height = 85;
    negativeView.frame = CGRectOffset(newFrame, 0, [UIScreen mainScreen].bounds.size.height - offset - newFrame.size.height);
    
    [negativeView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.6 blue:0.08 alpha:0.8]];
    
    UILabel *negativeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, negativeView.frame.size.width, negativeView.frame.size.height)];
    negativeLabel.text = text;
    negativeLabel.textAlignment = NSTextAlignmentCenter;
    [negativeLabel setTextColor:[UIColor whiteColor]];
    [negativeLabel setBackgroundColor:[UIColor clearColor]];
    [negativeLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size: 36.0f]];
    [negativeView addSubview:negativeLabel];
    
    return negativeView;
}

- (UIView *)addPositiveButton:(NSString *)text offset:(NSInteger)offset {
    UIView *positiveView = [[UIView alloc] init];
    CGRect newFrame = positiveView.frame;
    newFrame.size.width = self.view.frame.size.width;
    newFrame.size.height = 85;
    positiveView.frame = CGRectOffset(newFrame, 0, [UIScreen mainScreen].bounds.size.height - offset - newFrame.size.height);
    
    [positiveView setBackgroundColor:[UIColor colorWithRed:0.65 green:0.69 blue:0.0 alpha:0.8]];
    
    UILabel *positiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, positiveView.frame.size.width, positiveView.frame.size.height)];
    positiveLabel.text = text;
    positiveLabel.textAlignment = NSTextAlignmentCenter;
    [positiveLabel setTextColor:[UIColor whiteColor]];
    [positiveLabel setBackgroundColor:[UIColor clearColor]];
    [positiveLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Thin" size: 36.0f]];
    [positiveView addSubview:positiveLabel];
    
    return positiveView;
}

- (UIView *)addFacebookButton:(NSInteger)offset {
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"btn_facebook" ofType:@"png"];
    UIImage *logoOriginal = [[UIImage alloc] initWithContentsOfFile:thePath];
    UIImage *logo = [self resizeImage:logoOriginal newSize:CGSizeMake(320, 85)];
    
    UIView *facebookView = [[UIView alloc] init];
    CGRect newFrame = facebookView.frame;
    newFrame.size.width = self.view.frame.size.width;
    newFrame.size.height = 85;
    facebookView.frame = CGRectOffset(newFrame, 0, [UIScreen mainScreen].bounds.size.height - offset - newFrame.size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logo];
    imageView.frame = CGRectOffset(newFrame, 0, 0);
    
    [facebookView addSubview:imageView];
    return facebookView;
}

- (UIView *)addSwipeableArrowsToUIView:(UIView *)view leftArrowGesture:(UIGestureRecognizer *)leftArrowGesture rightArrowGesture:(UIGestureRecognizer *)rightArrowGesture {
    UIImageView *leftArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, view.frame.size.height)];
    leftArrowView.image = [UIImage imageNamed:@"btn_arrowleft.png"];
    UIView *leftContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, view.frame.size.height)];
    [leftContainer addGestureRecognizer:leftArrowGesture];
    [leftContainer addSubview:leftArrowView];
    
    UIImageView *rightArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, view.frame.size.height)];
    rightArrowView.image = [UIImage imageNamed:@"btn_arrowright.png"];
    UIView *rightContainer = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 0, 40, view.frame.size.height)];
    [rightContainer addGestureRecognizer:rightArrowGesture];
    [rightContainer addSubview:rightArrowView];

    [view addSubview:leftContainer];
    [view addSubview:rightContainer];
    
    return view;
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

# pragma waiting

- (void)displayWaiting {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
    });
}

- (void)hideWaiting {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

}

#pragma mark auth

-(void)logoutAuthUser {
    [GuesstimateUser logOutAuthUser];
    GuesstimateWelcomeViewController *vc = [[GuesstimateWelcomeViewController alloc] init];
    [self pushSelectionViewController:vc];
}

# pragma mark push view

- (void)pushSelectionViewController:(GuesstimateBaseViewController *)viewController
{
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    [navController pushViewController:viewController animated:YES];
}

#pragma transition

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    GuesstimateTransitionAnimator *animator = [GuesstimateTransitionAnimator new];
    //animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    GuesstimateTransitionAnimator *animator = [GuesstimateTransitionAnimator new];
    return animator;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
