//
//  GuesstimateInvitesViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 7/18/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateInvitesViewController.h"
#import "GuesstimateInvite.h"
#import "GuesstimateInviteTableViewCell.h"
#import "GuesstimatePlayGameViewController.h"

@interface GuesstimateInvitesViewController ()

@property (strong, nonatomic) NSArray *invites;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GuesstimateInvitesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 96;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [GuesstimateApplication displayWaiting:self.view withText:@"Loading invites..."];
    [GuesstimateInvite getMyInvites:^(NSArray *invites, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        if(!error && invites.count > 0) {
            self.invites = invites;
            [self.view addSubview:_tableView];
        } else {
            self.invites = [[NSArray alloc] init];
            UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            cover.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.7f];
            UILabel *noInvites = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height)];
            noInvites.textColor = [UIColor whiteColor];
            noInvites.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
            noInvites.numberOfLines = 2;
            noInvites.textAlignment = NSTextAlignmentCenter;
            noInvites.text = @"No invites, make some friends :|";
            
            [cover addSubview:noInvites];
            [self.view addSubview:cover];
        }
    }];
    
    self.title = NSLocalizedString(@"Invites", @"");
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.invites.count;
}

#pragma mark table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    if(cell == nil) {
        cell = [[GuesstimateInviteTableViewCell alloc] init];
    }
    
    
    GuesstimateInvite *invite = [self.invites objectAtIndex:indexPath.row];
    
    cell.categoryImage.image = [UIImage imageNamed:invite.game.category.bgImage];
    cell.nameLabel.text = invite.user.name;
    cell.questionLabel.text = invite.game.gameName;
    
    NSString *dateString = [NSString stringWithFormat:@"created at: %@",[NSDateFormatter localizedStringFromDate:invite.game.date
                                                                                           dateStyle:NSDateFormatterShortStyle
                                                                                           timeStyle:NSDateFormatterShortStyle]];
    cell.createdAtLabel.text = dateString;
    
    cell.otherPlayersLabel.text = @"players: placeholder";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self loadGameFromInvite:indexPath];
}

- (void)loadGameFromInvite:(NSIndexPath *)indexPath {
    [GuesstimateApplication displayWaiting:self.view withText:@"Accepting invite..."];
    GuesstimateInvite *invite = [self.invites objectAtIndex:indexPath.row];
    GuesstimateGame *game = invite.game;

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

@end
