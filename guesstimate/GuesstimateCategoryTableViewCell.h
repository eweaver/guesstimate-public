//
//  GuesstimateCategoryTableViewCell.h
//  guesstimate
//
//  Created by Eric Weaver on 4/28/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuesstimateCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *leftArrowImageView;
@property (strong, nonatomic) UIImageView *rightArrowImageView;

@property (strong, nonatomic) UIImageView *rightImageView;

@end
