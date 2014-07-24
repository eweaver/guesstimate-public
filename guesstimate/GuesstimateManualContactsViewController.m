//
//  GuesstimateManualContactsViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/18/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateManualContactsViewController.h"
#import "GuesstimateContact.h"

@interface GuesstimateManualContactsViewController ()

@end

@implementation GuesstimateManualContactsViewController

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
    
    // Answer
    UIView *addContact = [self addPositiveButton:@"Add Contact" offset:40];
    UITapGestureRecognizer *submitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addContact)];
    [addContact addGestureRecognizer:submitTap];
    [self.view addSubview:addContact];
    
    self.contactName = [self addTextField:@"contact" placeholder:@"Contact Name" offset:127 secure:NO];
    self.contactName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.contactName.tag = 1;
    [self.view addSubview:self.contactName];
    
    self.textFields = @{@1:@127};
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardWithTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)addContact {
    NSString *contactName = self.contactName.text;
    [GuesstimateContact addContact:contactName onCompletionBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"%@ added as a contact.", contactName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(UITextField *)addTextField:(NSString *)text placeholder:(NSString *)placeholder offset:(NSInteger) offset secure:(BOOL)secure {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - offset - 60, 320, 60)];
    [textField setBackgroundColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.7]];
    textField.borderStyle = UITextBorderStyleNone;
    [textField setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f]];
    
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.6];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.keyboardType = UIKeyboardTypeAlphabet;
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

#pragma textfield

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    self.shouldEndEditing = YES;
    [self textFieldDidBecomeActive:textField.tag];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.shouldEndEditing == NO) {
        self.shouldEndEditing = YES;
        return;
    }
    
    [self textFieldsDidBecomeInactive];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
