//
//  GuesstimateBaseMenuController.h
//  guesstimate
//
//  Created by Eric Weaver on 5/17/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuesstimateMenuTableViewCell.h"

@interface GuesstimateBaseMenuController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *menuOptions;
@property (strong, nonatomic) NSMutableArray *menuHeaders;
@property (assign, nonatomic) NSInteger numSections;
@property (strong, nonatomic) UITableView *menuTable;

-(void)createMenuWithNumSections:(NSInteger)sections;
-(void)addMenuItems:(NSArray *)items header:(NSString *)header inSection:(NSInteger)section;
-(NSInteger)getHeight:(NSInteger)headerHeight rowHeight:(NSInteger)rowHeight;

@end
