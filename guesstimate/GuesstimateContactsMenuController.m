//
//  GuesstimateMainMenuController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/17/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateContactsMenuController.h"
#import "GuesstimateFacebookContactsViewController.h"
#import "GuesstimatePhoneContactsViewController.h"
#import "GuesstimateManualContactsViewController.h"
#import "GuesstimateApplication.h"
#import "GuesstimateContact.h"
#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateMyGamesViewController.h"

@interface GuesstimateContactsMenuController ()

@end

@implementation GuesstimateContactsMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create static sections of table view
        [self createMenuWithNumSections:2];
        GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
        [self addMenuItems:@[@"Manually"] header:@"Add Contacts" inSection:0];
        [self addMenuItems:@[@"My Games", @"All Contacts", [NSString stringWithFormat:@"Logout (%@)", authUser.name]] header:@"Settings" inSection:1];
        
        NSInteger tableHeight = [UIScreen mainScreen].bounds.size.height;
        NSInteger maxHeight = [UIScreen mainScreen].bounds.size.height - 20;
        tableHeight = MIN(tableHeight, maxHeight);
        
        self.menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, tableHeight)];
        self.menuTable.delegate = self;
        self.menuTable.dataSource = self;
        self.menuTable.rowHeight = 44;
        self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTable.backgroundColor = [UIColor clearColor];
        
        self.menuTable.scrollEnabled = YES;
        self.menuTable.bounces = YES;
        
        [self.view addSubview:self.menuTable];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark content

-(void)startLogOut {
    [GuesstimateApplication displayWaiting:self.view withText:@"Logging out..."];
    [GuesstimateUser logOutAuthUser];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:^(BOOL finished) {
        [GuesstimateApplication hideWaiting:self.view];
    }];
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    GuesstimateWelcomeViewController *viewController = [[GuesstimateWelcomeViewController alloc] init];
    [navController pushViewController:viewController animated:YES];
}

-(UIImage *)getContactTypeImage:(NSIndexPath *)indexPath {
    UIImage *image;
    switch(indexPath.row) {
        /*case 0:
            image = [UIImage imageNamed:@"icon_fb.png"];
            break;
        case 1:
            image = [UIImage imageNamed:@"icon_phone.png"];
            break;*/
        case 0:
            image = [UIImage imageNamed:@"icon_manual.png"];
            break;
    }
    
    return image;
}

-(void)loadInviteViewController:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    
    switch(indexPath.row) {
        // Facebook
        /*case 0:
            viewController = [[GuesstimateFacebookContactsViewController alloc] init];
            break;
        // Phone Contacts
        case 1:
            viewController = [[GuesstimatePhoneContactsViewController alloc] init];
            break;*/
        // Manually
        case 0:
            viewController = [[GuesstimateManualContactsViewController alloc] init];
            break;
    }
    
    [GuesstimateApplication displayWaiting:self.view withText:@"Loading..."];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:^(BOOL finished) {
        [GuesstimateApplication hideWaiting:self.view];
    }];
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    [navController pushViewController:viewController animated:YES];

}

#pragma mark table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if(cell == nil) {
        cell = [[GuesstimateMenuTableViewCell alloc] init];
    }

    switch(indexPath.section) {
        case 0:
            cell.optionLabel.text = [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.iconView.image = [self getContactTypeImage:indexPath];
            break;
            // Settings
        case 1:
            cell.optionLabel.text = [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if([cell.optionLabel.text isEqualToString:@"All Contacts"]) {
                cell.iconView.image = [UIImage imageNamed:@"icon_manual.png"];
            }
            
            else if([cell.optionLabel.text isEqualToString:@"My Games"]) {
                cell.iconView.image = [UIImage imageNamed:@"icon_game.png"];
            }
            
            else {
                cell.optionLabel.textColor = [UIColor redColor];
                cell.iconView.image = [UIImage imageNamed:@"icon_logout.png"];
            }
            
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if(cell == nil) {
        cell = [[GuesstimateMenuTableViewCell alloc] init];
    }
    
    switch(indexPath.section) {
        case 0:
            [self loadInviteViewController:indexPath];
            break;
            // Settings
        case 1:
            if([[[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"My Games"]) {
                [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:^(BOOL finished) {
                    [GuesstimateApplication hideWaiting:self.view];
                }];
                UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
                GuesstimateMyGamesViewController *viewController = [[GuesstimateMyGamesViewController alloc] init];
                [navController pushViewController:viewController animated:YES];
            }
            else if([[[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"All Contacts"]) {
            }
            else {
                [self startLogOut];
            }
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
