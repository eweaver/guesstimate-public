//
//  GuesstimateFacebookContactTableViewCell.m
//  guesstimate
//
//  Created by Eric Weaver on 5/19/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateFacebookContactTableViewCell.h"

@implementation GuesstimateFacebookContactTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 36, 36)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.photoView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, self.frame.size.width - 60, 36)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont fontWithName:@"HelveticaNueue-Thin" size:14.0f];
        
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
