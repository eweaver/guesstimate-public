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

@interface GuesstimateContactsMenuController ()

@end

@implementation GuesstimateContactsMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.menuTable removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [GuesstimateApplication displayWaiting:self.view];
    
    // Create static sections of table view
    [self createMenuWithNumSections:2];
    [self addMenuItems:@[] header:@"All Contacts" inSection:0];
    [self addMenuItems:@[@"Facebook", @"Phone Contacts", @"Manually"] header:@"Add Contacts" inSection:1];
    
    void ( ^completeBlock )( void );
    completeBlock = ^( void )
    {
        [GuesstimateApplication hideWaiting:self.view];
        
        NSInteger tableHeight = [self getHeight:44 rowHeight:36];
        NSInteger maxHeight = [UIScreen mainScreen].bounds.size.height - 20;
        tableHeight = MIN(tableHeight, maxHeight);
        
        self.menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, tableHeight)];
        self.menuTable.delegate = self;
        self.menuTable.dataSource = self;
        self.menuTable.rowHeight = 36;
        self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTable.backgroundColor = [UIColor clearColor];
        
        if(tableHeight > maxHeight) {
            self.menuTable.scrollEnabled = YES;
            self.menuTable.bounces = YES;
        } else {
            self.menuTable.scrollEnabled = NO;
            self.menuTable.bounces = NO;
        }
        
        [self.view addSubview:self.menuTable];
    };
    
    [GuesstimateContact getMyContacts:^(NSArray *contacts, NSError *error) {
        if(contacts && contacts.count > 0) {
            [self addMenuItems:contacts header:@"All Contacts" inSection:0];
        } else {
            
            //[[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
        
        completeBlock();
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark content

-(NSString *)getContactName:(NSIndexPath *)indexPath {
    GuesstimateContact *contact = [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return contact.user.name;
}

-(UIImage *)getContactTypeImage:(NSIndexPath *)indexPath {
    UIImage *image;
    switch(indexPath.row) {
        case 0:
            image = [UIImage imageNamed:@"icon_fb.png"];
            break;
        case 1:
            image = [UIImage imageNamed:@"icon_phone.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"icon_manual.png"];
            break;
    }
    
    return image;
}

-(void)loadInviteViewController:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    
    switch(indexPath.row) {
        // Facebook
        case 0:
            viewController = [[GuesstimateFacebookContactsViewController alloc] init];
            break;
        // Phone Contacts
        case 1:
            viewController = [[GuesstimatePhoneContactsViewController alloc] init];
            break;
        // Manually
        case 2:
            viewController = [[GuesstimateManualContactsViewController alloc] init];
            break;
    }
    
    [GuesstimateApplication displayWaiting:self.view];
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
            cell.optionLabel.text = [self getContactName:indexPath];
            cell.iconView.image = [UIImage imageNamed:@"default_user.jpg"];
            break;
        case 1:
            cell.optionLabel.text = [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.iconView.image = [self getContactTypeImage:indexPath];
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if(cell == nil) {
        cell = [[GuesstimateMenuTableViewCell alloc] init];
    }
    
    switch(indexPath.section) {
        case 0:
            // What to do here? -- pre-invite to current game
            break;
        case 1:
            [self loadInviteViewController:indexPath];
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
