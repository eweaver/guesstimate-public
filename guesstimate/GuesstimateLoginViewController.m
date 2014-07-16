//
//  GuesstimateLoginViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateLoginViewController.h"
#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateQuestionSelectViewController.h"
#import "GuesstimateApplication.h"

@interface GuesstimateLoginViewController ()

@end

@implementation GuesstimateLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Login Fields
    self.idText = [self addTextField:@"identifier" placeholder:@"Username" offset:189 secure:NO];
    self.idText.returnKeyType = UIReturnKeyNext;
    self.idText.keyboardType = UIKeyboardTypeEmailAddress;
    self.idText.tag = 1;
    //[self.idText becomeFirstResponder];
    [self.view addSubview:self.idText];
    
    self.passwordText = [self addTextField:@"password" placeholder:@"Password" offset:127 secure:YES];
    self.passwordText.tag = 2;
    [self.view addSubview:self.passwordText];
    
    self.textFields = @{@1:@189, @2:@127};

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardWithTap:)];
    [self.view addGestureRecognizer:tap];
    
    // Complete
    UIView *registerView = [self addPositiveButton:@"Get Started >>" offset:40];
    UITapGestureRecognizer *registerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeLogin:)];
    [registerView addGestureRecognizer:registerTap];
    [self.view addSubview:registerView];
}

-(void)loadMenu {
    GuesstimateWelcomeViewController *viewController = [[GuesstimateWelcomeViewController alloc] init];
    [self pushSelectionViewController:viewController];
}

-(UITextField *)addTextField:(NSString *)text placeholder:(NSString *)placeholder offset:(NSInteger) offset secure:(BOOL)secure {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - offset - 60, 320, 60)];
    [textField setBackgroundColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.7]];
    textField.borderStyle = UITextBorderStyleNone;
    //textField.font = [UIFont systemFontOfSize:22];
    [textField setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f]];
    //textField.placeholder = placeholder;
    
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.6];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if(secure == YES) {
        textField.secureTextEntry = YES;
    }
    textField.delegate = self;
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}


- (void)completeLogin:(UITapGestureRecognizer *)gr {
    NSString* identifier = self.idText.text;
    NSString* password = self.passwordText.text;
    
    [GuesstimateApplication displayWaiting:self.view withText:@"Logging in..."];
    [GuesstimateUser loginWithName:identifier withPassword:password onCompletionBlock:^(GuesstimateUser *user, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        if(error == nil) {
            GuesstimateQuestionSelectViewController *vc = [[GuesstimateQuestionSelectViewController alloc] init];
            [self pushSelectionViewController:vc];
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
        // TODO: split out so this can call without a gesture recognizer
        //[self completeRegistration:[[UITapGestureRecognizer alloc] init]];
        [self textFieldsDidBecomeInactive];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    self.shouldEndEditing = YES;
    [self textFieldDidBecomeActive:textField.tag];
    return YES;
}

#pragma memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
