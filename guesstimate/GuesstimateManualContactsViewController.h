//
//  GuesstimateManualContactsViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 5/18/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"

@interface GuesstimateManualContactsViewController : GuesstimateBaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *contactName;

@end
