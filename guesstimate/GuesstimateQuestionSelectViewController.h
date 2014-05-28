//
//  GuesstimateQuestionSelectViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 4/29/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"
#import "GuesstimateCategory.h"

@interface GuesstimateQuestionSelectViewController : GuesstimateBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) GuesstimateCategory *category;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *questions;

@property (strong, nonatomic) UILabel *questionText;
@property (strong, nonatomic) UIView *playButton;

@property (strong, nonatomic) UILabel *categoryTitle;
@property (strong, nonatomic) UIImageView *categoryBgImage;

@property (strong, nonatomic) UITableView *categoriesTable;

@end
