//
//  GuesstimatePlayerEntryTableViewCell.m
//  guesstimate
//
//  Created by Eric Weaver on 7/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimatePlayerEntryTableViewCell.h"

@implementation GuesstimatePlayerEntryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _playerImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
        _playerImage.image = [UIImage imageNamed:@"default_user.jpg"];
        [self addSubview:_playerImage];
        
        _playerName = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, self.frame.size.width - 136, 40)];
        _playerName.textColor = [UIColor blackColor];
        _playerName.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f];
        [self addSubview:_playerName];
        
        _playerGuess = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 100, 40)];
        _playerGuess.textColor = [UIColor blackColor];
        _playerGuess.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f];
        [self addSubview:_playerGuess];
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
