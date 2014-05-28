//
//  GuesstimateLoginViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 4/27/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"

@interface GuesstimateLoginViewController : GuesstimateBaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *idText;
@property (strong, nonatomic) UITextField *passwordText;

@end
