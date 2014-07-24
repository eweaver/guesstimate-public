//
//  GuesstimateEndGameViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateEndGameViewController.h"
#import "GuesstimateGame.h"
#import "GuesstimateEndGamePlayerEntryTableViewCell.h"

@interface GuesstimateEndGameViewController ()

@property (strong, nonatomic) GuesstimateGame *game;
@property (strong, nonatomic) UITableView *playersTable;
@property (strong, nonatomic) NSMutableArray *players;

@end

@implementation GuesstimateEndGameViewController

static NSInteger offset = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _players = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO];
    
    //Bg gradient
    UIImageView *gradientBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 244)];
    gradientBg.contentMode = UIViewContentModeScaleAspectFill;
    gradientBg.image = [UIImage imageNamed:@"header_gradient.jpg"];
    [self.view addSubview:gradientBg];
    [self.view sendSubviewToBack:gradientBg];
    
    self.categoryBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 244, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 244)];
    self.categoryBgImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.categoryBgImage];
    
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    
    //[self addMenuItemsStackedRight:self.navigationController.navigationBar];
    [self setBackButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super viewDidLoad];
    
    NSInteger height = [UIScreen mainScreen].bounds.size.height - 246;
    self.playersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 246, self.view.frame.size.width, height)];
    self.playersTable.bounces = YES;
    self.playersTable.scrollEnabled = YES;
    self.playersTable.rowHeight = 40;
    self.playersTable.dataSource = self;
    self.playersTable.delegate = self;
    
    offset = 0;
    
    [self displayResults];
}

-(void)displayResults {
    [GuesstimateApplication displayWaiting:self.view withText:@"Game Over!"];
    [GuesstimateGame getGameData:self.gameId onCompleteBlock:^(GuesstimateGame *game, NSError *error) {
        if(game) {
            self.game = game;
            //Bg Image
            if(game.category.bgImage != nil) {
                UIImage * toImage = [UIImage imageNamed:game.category.bgImage];
                [UIView transitionWithView:self.categoryBgImage
                                  duration:0.3f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    self.categoryBgImage.image = toImage;
                                    [self.view sendSubviewToBack:self.categoryBgImage];
                                } completion:nil];
            }
            
            [self.game loadGameGuesses:^(BOOL succeeded, NSError *error) {
                [GuesstimateApplication hideWaiting:self.view];
                /*if([self.game scoreGame] == YES) {
                    [self displayAnswer];
                    [self displayPlayerGuesses];
                } else {
                    //error :(
                }*/
                
                [self orderPlayers];
                

                [GuesstimateApplication hideWaiting:self.view];
                [self.view addSubview:self.playersTable];
                [self displayAnswer];
            }];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
        
    }];
}

-(void)displayAnswer {
    NSInteger height = [UIScreen mainScreen].bounds.size.height - 242;
    UIView *answer = [self addInfoView:[NSString stringWithFormat:@"The answer is: %@!", self.game.answerFormatted] offset:height];
    [self.view addSubview:answer];
}

-(void)orderPlayers {
    [self.game scoreGame];
    NSArray *scores = [self.game getGameScoresInOrder];
    NSInteger numPlayers = scores.count;
    NSInteger counter = 0;
    for(NSDictionary *playerData in scores) {
        GuesstimateUser *user = [playerData objectForKey:@"user"];
        [self.players addObject:user];
        BOOL isWinner = counter == 0 ? YES : NO;
        
        if(isWinner == YES) {
            self.game.winnerId = user.objectId;
        }
        
        BOOL isLoser = (counter == (numPlayers - 1) ? YES : NO);
        
        if(isLoser == YES) {
            self.game.loserId = user.objectId;
        }
        
        counter++;
    }
    
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.players.count;
}

#pragma mark table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateEndGamePlayerEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerEntryCell"];
    
    if(cell == nil) {
        cell = [[GuesstimateEndGamePlayerEntryTableViewCell alloc] init];
    }
    
    GuesstimateUser *user = [self.players objectAtIndex:indexPath.row];
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    NSDictionary *guessData = [self.game.guesses objectForKey:user.objectId];
    
    NSString *guessString = [guessData objectForKey:@"guess"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:3];
    NSNumber *diff = [formatter numberFromString:[guessData objectForKey:@"diff"]];
    
    cell.playerGuess.text = guessString;
    cell.playerDiff.text = [NSString stringWithFormat:@"-%@", [formatter stringFromNumber:diff]];
    
    NSString *name;
    if([user.objectId isEqualToString:authUser.objectId]) {
        name = @"me";
    } else {
        name = user.name;
    }
    
    if([self.game.winnerId isEqualToString:user.objectId]) {
        //name = [NSString stringWithFormat:@"%@ (winner)", name];
    }
    
    if([self.game.loserId isEqualToString:user.objectId]) {
        //name = [NSString stringWithFormat:@"%@ (loser)", name];
    }
    
    cell.playerName.text = name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
