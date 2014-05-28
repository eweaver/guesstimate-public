//
//  GuesstimateMenuTableViewCell.h
//  guesstimate
//
//  Created by Eric Weaver on 5/17/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuesstimateMenuTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *optionLabel;
@property (strong, nonatomic) UILabel *smallOptionLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end
