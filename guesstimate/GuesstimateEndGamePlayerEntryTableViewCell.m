//
//  GuesstimateEndGamePlayerEntryTableViewCell.m
//  guesstimate
//
//  Created by Eric Weaver on 7/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateEndGamePlayerEntryTableViewCell.h"

@implementation GuesstimateEndGamePlayerEntryTableViewCell

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
        
        _playerGuess = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 2, 100, 20)];
        _playerGuess.textColor = [UIColor blackColor];
        _playerGuess.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f];
        [self addSubview:_playerGuess];
        
        _playerDiff = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 18, 100, 20)];
        _playerDiff.textColor = [UIColor redColor];
        _playerDiff.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 12.0f];
        [self addSubview:_playerDiff];

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
