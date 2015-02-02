//
//  GuesstimatePlayGameViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/3/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateQuestionSelectViewController.h"
#import "GuesstimateEndGameViewController.h"
#import "GuesstimateGame.h"
#import "GuesstimatePlayerEntryTableViewCell.h"
#import "FSPSAppDelegate.h"

@interface GuesstimatePlayGameViewController ()

@property (strong, nonatomic) GuesstimateGame *game;
@property (strong, nonatomic) UITableView *playersTable;
@property (strong, nonatomic) NSMutableArray *players;
@property (assign, nonatomic) NSInteger authUserCellIndex;
@property (assign, nonatomic) BOOL gameIsComplete;
@property (strong, nonatomic) FSPSAppDelegate *appDelegate;

@end

@implementation GuesstimatePlayGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _players = [[NSMutableArray alloc] init];
        _gameIsComplete = NO;
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
    
    [self setBackButton];
    
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    
    UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 70)];
    boxView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (boxView.frame.size.width - 20), boxView.frame.size.height)];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    [self.questionLabel setTextColor:[UIColor whiteColor]];
    [self.questionLabel setBackgroundColor:[UIColor clearColor]];
    [self.questionLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 17.0f]];
    self.questionLabel.numberOfLines = 3;
    [boxView addSubview:self.questionLabel];
    
    [self.view addSubview:boxView];
    [self.view bringSubviewToFront:boxView];
    
    // Answer
    self.submitAnswerView = [self addPositiveButton:@"Submit Answer" offset:40];
    UITapGestureRecognizer *submitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAnswer)];
    [self.submitAnswerView addGestureRecognizer:submitTap];
    [self.view addSubview:self.submitAnswerView];
    
    UITextField *answer = [self addTextField:@"answer" placeholder:@"Answer" offset:127 secure:NO];
    answer.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    answer.tag = 1;
    [self.view addSubview:answer];
    
    self.textFields = @{@1:@127};
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardWithTap:)];
    [self.view addGestureRecognizer:tap];

    //[self addMenuItemsStackedRight:self.navigationController.navigationBar];
    UITapGestureRecognizer *refreshGame = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshGame)];
    [self pushMenuItemToRightStack:self.navigationController.navigationBar imageName:@"ic_refresh.png" gestureRecognizer:refreshGame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger height = [UIScreen mainScreen].bounds.size.height - 137 - 186;
    self.playersTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 134, self.view.frame.size.width, height)];
    self.playersTable.bounces = YES;
    self.playersTable.scrollEnabled = YES;
    self.playersTable.rowHeight = 40;
    self.playersTable.dataSource = self;
    self.playersTable.delegate = self;
    
    [self startGame];
}

-(void)submitAnswer {
    // TODO: stop using tags :/
    UITextField *answerField = (UITextField *) [self.view viewWithTag:1];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *guess = [f numberFromString:answerField.text];
    
    if(!guess) {
        answerField.placeholder = @"Answer must be a number!";
        return;
    }
    
    [GuesstimateApplication displayWaiting:self.view withText:@"" withSubtext:@"Submitting answer..."];
    
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    NSDictionary *guessData = [self.game.guesses objectForKey:authUser.objectId];
    
    [self.game submitGuess:[guessData objectForKey:@"guessId"] guess:guess onCompleteBlock:^(BOOL succeeded, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        if(succeeded) {
            // [guess stringValue]
            NSMutableDictionary *guesses = [self.game.guesses mutableCopy];
            NSMutableDictionary *guessData = [[guesses objectForKey:authUser.objectId] mutableCopy];
            [guessData setObject:[guess stringValue] forKey:@"guess"];
            [guesses setObject:guessData forKey:authUser.objectId];
            self.game.guesses = [guesses copy];

            [self.playersTable reloadData];
            [self.playersTable setNeedsDisplay];
            
            [self endGameForLocalPlayer];
            if([self hasGameEnded] == YES) {
                [self displayEndGame];
            }
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

-(BOOL)hasGameEnded {
    BOOL hasEnded = YES;
    for(NSString *userId in self.game.guesses) {
        NSDictionary *guessData = [self.game.guesses objectForKey:userId];
        NSString *guessString = [guessData objectForKey:@"guess"];

        if([guessString isEqualToString:@"N/A"]) {
            hasEnded = NO;
            break;
        }
    }

    return hasEnded;
}

-(void)silentRefreshGame {
    [GuesstimateGame getGameData:self.gameId onCompleteBlock:^(GuesstimateGame *game, NSError *error) {
        if(game) {
            [self.game loadGameGuesses:^(BOOL succeeded, NSError *error) {
                self.players = [[NSMutableArray alloc] init];
                for(NSString *userId in self.game.guesses) {
                    [self.players addObject:userId];
                }
                
                [self.playersTable reloadData];
                [self.playersTable setNeedsDisplay];
                
                if([self hasGameEnded] == YES) {
                    [self displayEndGame];
                }
            }];
            
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];

}

-(void)refreshGameAddPlayer {
    [self silentRefreshGame];
}

-(void)silentRefreshGame:(NSString *)guessOwner {
    [self silentRefreshGame];
}

-(void)refreshGame {
    [self silentRefreshGame];
}

-(void)startGame {
    [self startGame:YES];
}

-(void)startGame:(BOOL)initialLoad {
    [GuesstimateApplication displayWaiting:self.view withText:@"Loading game..."];
    [GuesstimateGame getGameData:self.gameId onCompleteBlock:^(GuesstimateGame *game, NSError *error) {
        if(game) {
            
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
            
            
            self.game = game;
            self.questionLabel.text = game.questionText;
            
            [self.game loadGameGuesses:^(BOOL succeeded, NSError *error) {
                self.players = [[NSMutableArray alloc] init];
                for(NSString *userId in self.game.guesses) {
                    [self.players addObject:userId];
                }
                
                [GuesstimateApplication hideWaiting:self.view];
                
                if(initialLoad == YES) {
                    //GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
                    self.appDelegate = (FSPSAppDelegate *) [[UIApplication sharedApplication] delegate];
                    [self.appDelegate.mpcHandler advertiseSelf:[NSString stringWithFormat:@"gt-%@", self.game.objectId] advertise:YES];
                    
                    [self.view addSubview:self.playersTable];
                } else {
                    [self.playersTable reloadData];
                    [self.playersTable setNeedsDisplay];
                    if([self hasGameEnded] == YES) {
                        [self displayEndGame];
                    }
                }
            }];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

-(void)endGameForLocalPlayer {
    UITextField *answerField = (UITextField *) [self.view viewWithTag:1];
    [answerField removeFromSuperview];
    [self.submitAnswerView removeFromSuperview];
    
    [[self.view viewWithTag:1001] removeFromSuperview];
    
    self.endGame = [self addInfoView:@"waiting for other players..." offset:40];
    self.endGame.tag = 1001;
    [self.view addSubview:self.endGame];
}

-(void)displayEndGame {
    GuesstimateUser *user;
    [self.game scoreGame];
    NSArray *scores = [self.game getGameScoresInOrder];

    for(NSDictionary *playerData in scores) {
        user = [playerData objectForKey:@"user"];
        break;
    }

    [self displayEndGame:user.objectId];
}

-(void)displayEndGame:(NSString *)winner {
    if(self.game.isComplete == NO) {
        self.game.isComplete = YES;
        [self.game completeGame:winner];
    }
    
    GuesstimateEndGameViewController *viewController = [[GuesstimateEndGameViewController alloc] init];
    viewController.gameId = self.gameId;
    [self pushSelectionViewController:viewController];
}

#pragma UI/display

-(UITextField *)addTextField:(NSString *)text placeholder:(NSString *)placeholder offset:(NSInteger) offset secure:(BOOL)secure {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - offset - 60, 320, 60)];
    [textField setBackgroundColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.7]];
    textField.borderStyle = UITextBorderStyleNone;
    [textField setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f]];
    
    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.6];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if(secure == YES) {
        textField.secureTextEntry = YES;
    }
    textField.delegate = self;
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

#pragma textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.text isEqualToString:@""]) {
        textField.placeholder = @"please enter a value!";
        return NO;
    }
    
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    self.shouldEndEditing = YES;
    [self textFieldDidBecomeActive:textField.tag];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.shouldEndEditing == NO) {
        self.shouldEndEditing = YES;
        return;
    }
    
    [self textFieldsDidBecomeInactive];
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
    GuesstimatePlayerEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerEntryCell"];
    
    if(cell == nil) {
        cell = [[GuesstimatePlayerEntryTableViewCell alloc] init];
    }
    
    NSString *userId = [self.players objectAtIndex:indexPath.row];
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    NSDictionary *guessData = [self.game.guesses objectForKey:userId];
    GuesstimateUser *user = [guessData objectForKey:@"userId"];

    NSString *guessString = [guessData objectForKey:@"guess"];
    
    if([user.objectId isEqualToString:authUser.objectId]) {
        self.authUserCellIndex = indexPath.row;
        cell.playerName.text = @"me";
        if([guessString isEqualToString:@"N/A"]) {
            cell.playerGuess.text = @"N/A";
        } else {
            cell.playerGuess.text = guessString;
        }
    } else {
        cell.playerName.text = user.name;
        if([guessString isEqualToString:@"N/A"]) {
            cell.playerGuess.text = @"N/A";
        } else {
            cell.playerGuess.text = @"???";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
