//
//  GuesstimateInviteTableViewCell.h
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuesstimateInviteTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *categoryImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UILabel *createdAtLabel;
@property (strong, nonatomic) UILabel *otherPlayersLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end
