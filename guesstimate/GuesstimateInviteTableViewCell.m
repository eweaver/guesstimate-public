//
//  GuesstimateInviteTableViewCell.m
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateInviteTableViewCell.h"

@implementation GuesstimateInviteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        self.categoryImage.layer.masksToBounds = YES;
        self.categoryImage.layer.cornerRadius = 5.0f;
        [self addSubview:self.categoryImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 75, 70, 21)];
        self.nameLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.0f];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:10.0f];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.nameLabel];
        
        self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, self.frame.size.width - 85, 58)];
        self.questionLabel.textColor = [UIColor blackColor];
        self.questionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
        self.questionLabel.numberOfLines = 3;
        
        [self addSubview:self.questionLabel];
        
        self.createdAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 58, self.frame.size.width - 85, 17)];
        self.createdAtLabel.textColor = [UIColor colorWithWhite:0.55f alpha:1.0f];
        self.createdAtLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0f];
        
        [self addSubview:self.createdAtLabel];
        
        self.otherPlayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 74, self.frame.size.width - 85, 17)];
        self.otherPlayersLabel.textColor = [UIColor colorWithWhite:0.55f alpha:1.0f];
        self.otherPlayersLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0f];
        
        [self addSubview:self.otherPlayersLabel];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 74, self.frame.size.width - 85, 17)];
        self.statusLabel.textColor = [UIColor colorWithWhite:0.55f alpha:1.0f];
        self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0f];
        
        [self addSubview:self.statusLabel];
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
