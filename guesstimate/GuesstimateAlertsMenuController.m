//
//  GuesstimateAlertsMenuController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/17/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertsMenuController.h"
#import "GuesstimateApplication.h"
#import "GuesstimateGame.h"
#import "GuesstimateInvite.h"
#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateInviteViewController.h"
#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateEndGameViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "GuesstimateUser.h"
#import "MBProgressHUD.h"

@interface GuesstimateAlertsMenuController ()

@end

@implementation GuesstimateAlertsMenuController

static BOOL gamesLoaded = NO;
static BOOL invitesLoaded = NO;

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
    [self createMenuWithNumSections:3];
    [self addMenuItems:@[] header:@"Invites" inSection:0];
    [self addMenuItems:@[] header:@"My Games" inSection:1];
    [self addMenuItems:@[@"Logout"] header:@"Settings" inSection:2];
    
    void ( ^completeBlock )( void );
    completeBlock = ^( void )
    {
        [GuesstimateApplication hideWaiting:self.view];
        
        NSInteger tableHeight = [self getHeight:44 rowHeight:44];
        NSInteger maxHeight = [UIScreen mainScreen].bounds.size.height - 20;
        tableHeight = MIN(tableHeight, maxHeight);
        
        self.menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, tableHeight)];
        self.menuTable.delegate = self;
        self.menuTable.dataSource = self;
        self.menuTable.rowHeight = 44;
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
    
    [GuesstimateGame getMyGames:^(NSArray *games, NSError *error) {
        if(games && games.count > 0) {
            [self addMenuItems:games header:@"My Games" inSection:1];
        } else {
            
            //[[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
        
        gamesLoaded = YES;
        if(gamesLoaded == YES && invitesLoaded == YES) {
            completeBlock();
        }
    }];
    
    [GuesstimateInvite getMyInvites:^(NSArray *invites, NSError *error) {
        if(invites && invites.count > 0) {
            [self addMenuItems:invites header:@"Invites" inSection:0];
        } else {
            
        }
        
        invitesLoaded = YES;
        if(gamesLoaded == YES && invitesLoaded == YES) {
            completeBlock();
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark custom cell handlers

-(GuesstimateGame *)getGameCell:(NSIndexPath *)indexPath {
    return [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(GuesstimateInvite *)getInviteCell:(NSIndexPath *)indexPath {
    return [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(void)startLogOut {
    [GuesstimateApplication displayWaiting:self.view];
    [GuesstimateUser logOutAuthUser];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:NO completion:^(BOOL finished) {
        [GuesstimateApplication hideWaiting:self.view];
    }];
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    GuesstimateWelcomeViewController *viewController = [[GuesstimateWelcomeViewController alloc] init];
    [navController pushViewController:viewController animated:YES];
}

-(void)loadGame:(NSIndexPath *)indexPath {
    [GuesstimateApplication displayWaiting:self.view];
    GuesstimateGame *game = [self getGameCell:indexPath];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:NO completion:^(BOOL finished) {
        [GuesstimateApplication hideWaiting:self.view];
    }];
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;

    if(game.isComplete == YES) {
        GuesstimateEndGameViewController *viewController = [[GuesstimateEndGameViewController alloc] init];
        viewController.gameId = game.objectId;
        [navController pushViewController:viewController animated:YES];
    }
    else if(game.hasStarted == YES) {
        GuesstimatePlayGameViewController *viewController = [[GuesstimatePlayGameViewController alloc] init];
        viewController.gameId = game.objectId;
        [navController pushViewController:viewController animated:YES];
    } else {
        GuesstimateInviteViewController *viewController = [[GuesstimateInviteViewController alloc] init];
        viewController.gameId = game.objectId;
        [navController pushViewController:viewController animated:YES];
    }
}

-(void)loadGameFromInvite:(NSIndexPath *)indexPath {
    [GuesstimateApplication displayWaiting:self.view];
    GuesstimateInvite *invite = [self getInviteCell:indexPath];
    GuesstimateGame *game = invite.game;
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:NO completion:^(BOOL finished) {
        [GuesstimateApplication hideWaiting:self.view];
    }];
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    
    [invite acceptInvite:^(BOOL succeeded, NSError *error) {
        if(succeeded == YES) {
            GuesstimatePlayGameViewController *viewController = [[GuesstimatePlayGameViewController alloc] init];
            viewController.gameId = game.objectId;
            [navController pushViewController:viewController animated:YES];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
    
}

#pragma mark table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if(cell == nil) {
        cell = [[GuesstimateMenuTableViewCell alloc] init];
    }
    
    switch(indexPath.section) {
        // Invites
        case 0:
            cell.smallOptionLabel.text = [NSString stringWithFormat:@"%@ asks", [[[self getInviteCell:indexPath] user] name]];
            cell.descriptionLabel.text = [[[self getInviteCell:indexPath] game] gameName];
            cell.iconView.image = [UIImage imageNamed:@"icon_invite.png"];
            break;
        // My Games
        case 1:
            //cell.optionLabel.text = [[self getGameCell:indexPath] objectId];
            cell.optionLabel.text = [[self getGameCell:indexPath] gameName];
            cell.iconView.image = [UIImage imageNamed:@"icon_game.png"];
            break;
        // Settings
        case 2:
            cell.optionLabel.text = [[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
 
            if([cell.optionLabel.text isEqualToString:@"Logout"]) {
                cell.optionLabel.textColor = [UIColor redColor];
                cell.iconView.image = [UIImage imageNamed:@"icon_logout.png"];
            }
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
        // Invites
        case 0:
            [self loadGameFromInvite:indexPath];
            break;
        // My Games
        case 1:
            [self loadGame:indexPath];
            break;
        // Settings
        case 2:
            if([[[self.menuOptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Logout"]) {
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
