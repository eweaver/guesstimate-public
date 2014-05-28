//
//  GuesttimateRegistrationViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"

@interface GuesttimateRegistrationViewController : GuesstimateBaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *idText;
@property (strong, nonatomic) UITextField *nameText;
@property (strong, nonatomic) UITextField *passwordText;

@end
