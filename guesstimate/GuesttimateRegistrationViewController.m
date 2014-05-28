//
//  GuesttimateRegistrationViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesttimateRegistrationViewController.h"
#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateQuestionSelectViewController.h"
#import "GuesstimateFacebookLibrary.h"

@interface GuesttimateRegistrationViewController ()

@end

@implementation GuesttimateRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    
    // Reg Fields
    
    self.nameText = [self addTextField:@"name" placeholder:@"Username" offset:251 secure:NO];
    self.nameText.returnKeyType = UIReturnKeyNext;
    self.nameText.tag = 1;
    [self.view addSubview:self.nameText];
    
    self.passwordText = [self addTextField:@"password" placeholder:@"Password" offset:189 secure:YES];
    self.passwordText.returnKeyType = UIReturnKeyNext;
    self.passwordText.tag = 2;
    [self.view addSubview:self.passwordText];
    
    self.idText = [self addTextField:@"identifier" placeholder:@"Email" offset:127 secure:NO];
    self.idText.keyboardType = UIKeyboardTypeEmailAddress;
    self.idText.tag = 3;
    [self.view addSubview:self.idText];
    
    // Store tags associated with text fields
    self.textFields = @{@1:@251, @2:@189, @3:@127};

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardWithTap:)];
    [self.view addGestureRecognizer:tap];

    // Complete
    UIView *registerView = [self addPositiveButton:@"Get Started >>" offset:40];
    UITapGestureRecognizer *registerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeRegistration:)];
    [registerView addGestureRecognizer:registerTap];
    [self.view addSubview:registerView];
    
    UIView *fbLoginView = [self addFacebookButton:[UIScreen mainScreen].bounds.size.height - 160];
    UITapGestureRecognizer *fbRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginButtonTouchHandler:)];
    [fbLoginView addGestureRecognizer:fbRegister];
    [self.view addSubview:fbLoginView];

    if([UIScreen mainScreen].bounds.size.height > 480) {
        UIView *logoSubtext = [[UIView alloc] init];
        CGRect newFrame = logoSubtext.frame;
        newFrame.size.width = self.view.frame.size.width;
        newFrame.size.height = 40;
        logoSubtext.frame = CGRectOffset(newFrame, 0, 188);
    
        UILabel *logoText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, logoSubtext.frame.size.width, logoSubtext.frame.size.height)];
        logoText.text = @"- or use email -";
        logoText.textAlignment = NSTextAlignmentCenter;
        [logoText setTextColor:[UIColor whiteColor]];
        [logoText setBackgroundColor:[UIColor clearColor]];
        [logoText setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 17.0f]];
        [logoSubtext addSubview:logoText];
        [self.view addSubview:logoSubtext];
    }
}

-(void)loadMenu {
    GuesstimateWelcomeViewController *viewController = [[GuesstimateWelcomeViewController alloc] init];
    [self pushSelectionViewController:viewController];
}


-(UITextField *)addTextField:(NSString *)text placeholder:(NSString *)placeholder offset:(NSInteger) offset secure:(BOOL)secure {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - offset - 60, 320, 60)];
    [textField setBackgroundColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.7]];
    textField.borderStyle = UITextBorderStyleNone;
    [textField setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f]];
    
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.6];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if(secure == YES) {
        textField.secureTextEntry = YES;
    }
    textField.delegate = self;
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

- (void)completeRegistration:(UITapGestureRecognizer *)gr {
    NSString* identifier = self.idText.text;
    NSString* name = self.nameText.text;
    NSString* password = self.passwordText.text;
    
    [self displayWaiting];
    [GuesstimateUser registerWithName:name withEmail:identifier withPassword:password onCompletionBlock:^(GuesstimateUser *user, NSError *error) {
        [self hideWaiting];
        
        if(error == nil) {
            GuesstimateQuestionSelectViewController *viewController = [[GuesstimateQuestionSelectViewController alloc] init];
            [self pushSelectionViewController:viewController];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
        
    }];
}

- (void)backToMainView:(UITapGestureRecognizer *)gr {
    GuesstimateWelcomeViewController *viewController = [[GuesstimateWelcomeViewController alloc] init];
    [self pushSelectionViewController:viewController];
}

#pragma mark textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.text isEqualToString:@""]) {
        textField.placeholder = @"please enter a value!";
        return NO;
    }
    
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.shouldEndEditing == NO) {
        self.shouldEndEditing = YES;
        return;
    }
    
    if(textField.returnKeyType == UIReturnKeyNext) {
        int nextTag = (int) textField.tag + 1;
        [[self.view viewWithTag:nextTag] becomeFirstResponder];
    } else {
        [self textFieldsDidBecomeInactive];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    self.shouldEndEditing = YES;
    [self textFieldDidBecomeActive:textField.tag];
    return YES;
}

#pragma Facebook

- (void)loginButtonTouchHandler:(UITapGestureRecognizer *)gr {
    [self displayWaiting];
    
    // TODO: Move to GuesstimateFacebookLibrary
    [PFFacebookUtils initializeFacebook];
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self hideWaiting];
        
        if (!user) {
            if (!error) {
                [[GuesstimateApplication getErrorAlert:@"An unknown error occurred during the Facebook request, please try again later."] show];
            } else {
                [[GuesstimateApplication getErrorAlert:@"FBError"] show];
            }
        } else {
            GuesstimateUser *authUser = [GuesstimateUser initAuthUser:user];
            
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

#pragma memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
