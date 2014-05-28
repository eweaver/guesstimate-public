//
//  GuesstimateMenuTableViewCell.m
//  guesstimate
//
//  Created by Eric Weaver on 5/17/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateMenuTableViewCell.h"

@implementation GuesstimateMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 36, 36)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.iconView];
        
        // Options
        self.optionLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 2, 220, 40)];
        self.optionLabel.textColor = [UIColor blackColor];
        self.optionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        self.optionLabel.numberOfLines = 2;

        [self addSubview:self.optionLabel];
        
        self.smallOptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 4, 220, 20)];
        self.smallOptionLabel.textColor = [UIColor blackColor];
        self.smallOptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        
        [self addSubview:self.smallOptionLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 20, 220, 20)];
        self.descriptionLabel.textColor = [UIColor grayColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        
        [self addSubview:self.descriptionLabel];
        
        // Background
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        
        CALayer *upperBorder = [CALayer layer];
        upperBorder.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66].CGColor;
        upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.66f);
        [self.layer addSublayer:upperBorder];
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
