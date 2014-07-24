//
//  GuesstimatePlayerEntryTableViewCell.h
//  guesstimate
//
//  Created by Eric Weaver on 7/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuesstimatePlayerEntryTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *playerImage;
@property (strong, nonatomic) UILabel *playerName;
@property (strong, nonatomic) UILabel *playerGuess;

@end
