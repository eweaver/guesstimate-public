//
//  GuesstimatePlayGameViewController.h
//  guesstimate
//
//  Created by Eric Weaver on 5/3/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseViewController.h"

@interface GuesstimatePlayGameViewController : GuesstimateBaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *gameId;
@property (strong, nonatomic) NSDictionary *gameData;
@property (strong, nonatomic) NSMutableDictionary *answers;

@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIView *submitAnswerView;
@property (strong, nonatomic) UIView *playersList;
@property (strong, nonatomic) UIView *endGame;

@property (strong, nonatomic) UIImageView *categoryBgImage;

-(void)refreshGame;

@end
