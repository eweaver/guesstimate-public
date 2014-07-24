//
//  GuesstimateMyGamesViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 7/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateMyGamesViewController.h"
#import "GuesstimateInviteTableViewCell.h"
#import "GuesstimateGame.h"
#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateEndGameViewController.h"

@interface GuesstimateMyGamesViewController ()

@property (strong, nonatomic) NSArray *games;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *gameFilter;
@property (assign, nonatomic) NSInteger mode;

@end

@implementation GuesstimateMyGamesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 110)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 96;
        _mode = 1;
        
        CGRect myFrame = CGRectMake(5, [UIScreen mainScreen].bounds.size.height - 41, self.view.frame.size.width - 10, 36);
        NSArray *mySegments = [[NSArray alloc] initWithObjects: @"Active Games", @"History", nil];
        
        _gameFilter = [[UISegmentedControl alloc] initWithItems:mySegments];
        _gameFilter.frame = myFrame;
        _gameFilter.tintColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.08 alpha:0.8];
        
        [_gameFilter setSelectedSegmentIndex:0];
        
        [_gameFilter addTarget:self
                                    action:@selector(sourceSwitch:)
                          forControlEvents:UIControlEventValueChanged];
        
        

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [GuesstimateApplication displayWaiting:self.view withText:@"" withSubtext:@"Loading my games..."];
    [GuesstimateGame getMyGames:^(NSArray *games, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        
        if(!error) {
            self.games = games;
            [self.view addSubview:self.tableView];
            [self.view addSubview:self.gameFilter];
        } else {
            self.games = [[NSArray alloc] init];
            /*UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            cover.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.7f];
            UILabel *noGames = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height)];
            noGames.textColor = [UIColor whiteColor];
            noGames.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
            noGames.numberOfLines = 2;
            noGames.textAlignment = NSTextAlignmentCenter;
            noGames.text = @"No games, make some friends :|";
            
            [cover addSubview:noGames];
            [self.view addSubview:cover];*/
        }
    }];
    
    self.title = NSLocalizedString(@"My Games", @"");
    [[self navigationController] setNavigationBarHidden:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadActiveGames {
    [GuesstimateApplication displayWaiting:self.view];
    [GuesstimateGame getMyGames:^(NSArray *games, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        
        if(!error) {
            self.games = games;
            //[self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            //[self.tableView setNeedsDisplay];
        } else {
            self.games = [[NSArray alloc] init];
            /*UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            cover.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.7f];
            UILabel *noGames = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height)];
            noGames.textColor = [UIColor whiteColor];
            noGames.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
            noGames.numberOfLines = 2;
            noGames.textAlignment = NSTextAlignmentCenter;
            noGames.text = @"No games, make some friends :|";
            
            [cover addSubview:noGames];
            [self.view addSubview:cover];*/
        }
    }];
}

- (void)loadInactiveGames {
    [GuesstimateApplication displayWaiting:self.view];
    [GuesstimateGame getMyExpiredGames:^(NSArray *games, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        
        if(!error) {
            self.games = games;
            //[self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
            //[self.tableView setNeedsDisplay];
        } else {
            self.games = [[NSArray alloc] init];
            /*UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
             cover.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.7f];
             UILabel *noGames = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height)];
             noGames.textColor = [UIColor whiteColor];
             noGames.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
             noGames.numberOfLines = 2;
             noGames.textAlignment = NSTextAlignmentCenter;
             noGames.text = @"No games, make some friends :|";
             
             [cover addSubview:noGames];
             [self.view addSubview:cover];*/
        }
    }];
}

-(void)sourceSwitch:(UISegmentedControl *)paramSender {
    NSInteger selectedIndex = [paramSender selectedSegmentIndex];

    if(selectedIndex == 0) {
        _mode = 1;
        [self loadActiveGames];
    }
    
    else {
        _mode = 2;
        [self loadInactiveGames];
    }
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.games.count;
}

#pragma mark table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    if(cell == nil) {
        cell = [[GuesstimateInviteTableViewCell alloc] init];
    }
    
    
    GuesstimateGame *game = [self.games objectAtIndex:indexPath.row];

    cell.categoryImage.image = [UIImage imageNamed:game.category.bgImage];
    //cell.nameLabel.text = invite.user.name;
    cell.questionLabel.text = game.gameName;
    
    NSString *dateString = [NSString stringWithFormat:@"created at: %@",[NSDateFormatter localizedStringFromDate:game.date
                                                                                                       dateStyle:NSDateFormatterShortStyle
                                                                                                       timeStyle:NSDateFormatterShortStyle]];
    cell.createdAtLabel.text = dateString;
    
    if(self.mode == 1) {
        //cell.otherPlayersLabel.text = @"players: placeholder";
        if(game.isComplete == YES) {
            // TODO: Update winner to be User pointer and add winner name!
            cell.statusLabel.text = @"status: complete";
        } else {
            cell.statusLabel.text = @"status: active";
        }
        cell.otherPlayersLabel.hidden = YES;
        cell.statusLabel.hidden = NO;
    } else {
        if(game.isComplete == YES) {
            // TODO: Update winner to be User pointer and add winner name!
            cell.statusLabel.text = @"status: complete";
            cell.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.1f];
        } else {
            cell.statusLabel.text = @"status: expired";
            cell.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f];
        }
        
        cell.otherPlayersLabel.hidden = YES;
        cell.statusLabel.hidden = NO;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateGame *game  = [self.games objectAtIndex:indexPath.row];
    
    if(self.mode == 2 && game.isComplete == NO) {
        // Allow no action on these games
        return;
    }
    
    [GuesstimateApplication displayWaiting:self.view withText:@"Loading game..."];
    UINavigationController *navController = (UINavigationController *) self.mm_drawerController.centerViewController;
    
    if(game.isComplete == YES) {
        GuesstimateEndGameViewController *viewController = [[GuesstimateEndGameViewController alloc] init];
        viewController.gameId = game.objectId;
        [navController pushViewController:viewController animated:YES];
    } else {
        GuesstimatePlayGameViewController *viewController = [[GuesstimatePlayGameViewController alloc] init];
        viewController.gameId = game.objectId;
        [navController pushViewController:viewController animated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
