//
//  GuesstimateEndGameViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 5/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"

@interface GuesstimateEndGameViewController : GuesstimateBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *gameId;
@property (strong, nonatomic) UIImageView *categoryBgImage;

@end
