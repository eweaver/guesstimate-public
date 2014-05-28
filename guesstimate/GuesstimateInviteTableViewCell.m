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
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 36, 36)];
        [self addSubview:self.photoView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, self.frame.size.width - 60, 36)];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
        
        [self addSubview:self.nameLabel];
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
