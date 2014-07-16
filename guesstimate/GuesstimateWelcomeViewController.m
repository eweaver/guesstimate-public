//
//  GuesstimateWelcomeViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 4/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateUser.h"
#import "GuesttimateRegistrationViewController.h"
#import "GuesstimateQuestionSelectViewController.h"
#import "GuesstimateLoginViewController.h"
#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateApplication.h"
#import "GuesstimateFacebookLibrary.h"

@interface GuesstimateWelcomeViewController ()

@end

@implementation GuesstimateWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Register
    UIView *registerView = [self addPositiveButton:@"Register" offset:230];
    UITapGestureRecognizer *registerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerViewTapped:)];
    [registerView addGestureRecognizer:registerTap];
    [self.view addSubview:registerView];
    
    // Login
    UIView *loginView = [self addNegativeButton:@"Login" offset:135];
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginViewTapped:)];
    [loginView addGestureRecognizer:loginTap];
    [self.view addSubview:loginView];
    
    // Facebook
    UIView *fbLoginView = [self addFacebookButton:40];
    UITapGestureRecognizer *fbRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginButtonTouchHandler:)];
    [fbLoginView addGestureRecognizer:fbRegister];
    [self.view addSubview:fbLoginView];
}

- (void)viewDidAppear:(BOOL)animated{
    [self checkStoredAuthentication];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma load tokens
- (void)checkStoredAuthentication {
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    
    if(user) {
        GuesstimateQuestionSelectViewController *viewController = [[GuesstimateQuestionSelectViewController alloc] init];
        [self pushSelectionViewController:viewController];

    } else {
        [GuesstimateApplication hideWaiting:self.view];
    }
}

# pragma mark touch events

- (void)registerViewTapped:(UITapGestureRecognizer *)gr {
    GuesttimateRegistrationViewController *viewController = [[GuesttimateRegistrationViewController alloc] init];
    [self pushSelectionViewController:viewController];
}

- (void)loginViewTapped:(UITapGestureRecognizer *)gr {
    GuesstimateLoginViewController *viewController = [[GuesstimateLoginViewController alloc] init];
    [self pushSelectionViewController:viewController];
}

# pragma mark facebook

- (void)loginButtonTouchHandler:(UITapGestureRecognizer *)gr {
    [GuesstimateApplication displayWaiting:self.view withText:@"" withSubtext:@"Logging in with Facebook..."];
    [PFFacebookUtils initializeFacebook];
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];

        if (!user) {
            if (!error) {
                [[GuesstimateApplication getErrorAlert:@"An unknown error occurred during the Facebook request, please try again later."] show];
            } else {
                [[GuesstimateApplication getErrorAlert:@"FBError"] show];
            }
        } else {
            //GuesstimateUser *authUser = [GuesstimateUser initAuthUser:user];
            
            if(user.isNew) {
                [GuesstimateFacebookLibrary meWithBlock:^(NSDictionary *userData, NSError *error) {
                    if(!error) {
                        user[@"contactFacebookId"] = [userData objectForKey:@"id"];
                        [user saveInBackground];
                    } else {
                        
                        // what to do here?
                    }
                }];
            }
            
            GuesstimateQuestionSelectViewController *viewController = [[GuesstimateQuestionSelectViewController alloc] init];
            [self pushSelectionViewController:viewController];
        }
    }];
}

@end
