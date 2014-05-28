//
//  GuesstimateBaseMenuController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/17/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateBaseMenuController.h"


@interface GuesstimateBaseMenuController ()

@end

@implementation GuesstimateBaseMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // TableView defaults
    
    self.menuTable.backgroundColor = [UIColor clearColor];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"test_bg.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)createMenuWithNumSections:(NSInteger)sections {
    self.menuOptions = nil;
    self.numSections = sections;
    self.menuOptions = [[NSMutableArray alloc] initWithCapacity:sections];
    self.menuHeaders = [[NSMutableArray alloc] initWithCapacity:sections];
    
    for(NSInteger i = 0; i < sections; i++) {
        [self.menuOptions addObject:[[NSMutableArray alloc] init]];
        [self.menuHeaders addObject:@""];
    }
}

-(void)addMenuItems:(NSArray *)items header:(NSString *)header inSection:(NSInteger)section {
    if(section >= 0 && section <= self.numSections) {
        [self.menuOptions setObject:items atIndexedSubscript:section];
        [self.menuHeaders setObject:header atIndexedSubscript:section];
    }
}

-(NSInteger)getHeight:(NSInteger)headerHeight rowHeight:(NSInteger)rowHeight {
    NSInteger rows = 0;
    
    for(NSArray *menuItems in self.menuOptions) {
        rows += menuItems.count;
    }
    
    return (self.menuHeaders.count * headerHeight) + (rows * rowHeight);
}

#pragma mark table header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    [view setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:128.0/255.0 blue:126.0/255.0 alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
    [label setFont:[UIFont fontWithName: @"HelveticaNeue" size: 18.0f]];
    label.textColor = [UIColor whiteColor];
    
    NSString *string = [self.menuHeaders objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    
    return view;
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.menuOptions objectAtIndex:section] count];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
