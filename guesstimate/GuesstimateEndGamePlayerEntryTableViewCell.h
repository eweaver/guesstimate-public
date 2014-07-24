//
//  GuesstimateEndGamePlayerEntryTableViewCell.h
//  guesstimate
//
//  Created by Eric Weaver on 7/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuesstimateEndGamePlayerEntryTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *playerImage;
@property (strong, nonatomic) UILabel *playerName;
@property (strong, nonatomic) UILabel *playerGuess;
@property (strong, nonatomic) UILabel *playerDiff;

@end
