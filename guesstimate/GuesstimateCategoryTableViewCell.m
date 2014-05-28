//
//  GuesstimateCategoryTableViewCell.m
//  guesstimate
//
//  Created by Eric Weaver on 4/28/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateCategoryTableViewCell.h"

@implementation GuesstimateCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 11, 10, 7)];
        [self addSubview:self.leftArrowImageView];
        
        self.rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(131, 11, 10, 7)];
        [self addSubview:self.rightArrowImageView];
        
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(131, 7, 11, 15)];
        [self addSubview:self.rightImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 29)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
