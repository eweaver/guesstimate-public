//
//  GuesstimateBaseInviteViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"

@interface GuesstimateInviteViewController : GuesstimateBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *gameId;

@end
