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

@interface GuesstimatePlayGameViewController ()

@property (strong, nonatomic) GuesstimateGame *game;

@end

@implementation GuesstimatePlayGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    [self addMenuItemsStackedRight:self.navigationController.navigationBar];
    UITapGestureRecognizer *refreshGame = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshGame)];
    [self pushMenuItemToRightStack:self.navigationController.navigationBar imageName:@"ic_refresh.png" gestureRecognizer:refreshGame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self startGame];
}

-(void)submitAnswer {
    [self displayWaiting];
    // TODO: stop using tags :/
    UITextField *answerField = (UITextField *) [self.view viewWithTag:1];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *guess = [f numberFromString:answerField.text];
    
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    NSDictionary *playerMetadata = [self.answers objectForKey:authUser.objectId];
    
    [self.game submitGuess:[playerMetadata objectForKey:@"guessId"] guess:guess onCompleteBlock:^(BOOL succeeded, NSError *error) {
        [self hideWaiting];
        if(succeeded) {
            NSInteger tag = [[playerMetadata objectForKey:@"tag"] integerValue];
            UILabel *playerAnswer = (UILabel *) [self.view viewWithTag:tag];
            playerAnswer.text = [guess stringValue];
            
            [self endGameForLocalPlayer];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

-(void)refreshGame {
    // Put more logic in to reduce reloading the entire game.
    // Really only need to reload players list & guesses
    self.questionLabel.text = @"loading...";
    [self removePlayers];
    [self startGame];
}

-(void)startGame {
    [self displayWaiting];
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
                [self hideWaiting];
                [self displayPlayers];
            }];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
        
    }];
}

-(void)removePlayers {
    [self.playersList removeFromSuperview];
    self.playersList = nil;
}

-(void)displayPlayers {
    
    self.playersList = [[UIView alloc] init];
    int counter = 1;
    self.answers = [[NSMutableDictionary alloc] initWithCapacity:[self.game.guesses count]];
    GuesstimateUser *authUser = [GuesstimateUser getAuthUser];
    BOOL gameIsComplete = YES;
    double smallestDiff = -1;
    NSString *winnerId;
    
    for(NSDictionary *guessData in self.game.guesses) {
        GuesstimateUser *user = [guessData objectForKey:@"userId"];
        NSNumber *diff = nil;
        
        NSString *guessString = [guessData objectForKey:@"guess"];
        NSString *revealedGuess = guessString;
        NSString *name;
        if([authUser.objectId isEqual:user.objectId]) {
            name = @"me";
            if(! [guessString isEqualToString:@"N/A"]) {
                [self endGameForLocalPlayer];
                
                 diff = [NSNumber numberWithDouble:[[guessData objectForKey:@"diff"] doubleValue]];
            } else {
                gameIsComplete = NO;
            }
        } else {
            name = user.name;
            if(! [guessString isEqualToString:@"N/A"]) {
                guessString = @"???";
                diff = [NSNumber numberWithDouble:[[guessData objectForKey:@"diff"] doubleValue]];
            } else {
                gameIsComplete = NO;
            }
        }
        
        if(smallestDiff == -1 || smallestDiff > [diff doubleValue]) {
            smallestDiff = [diff doubleValue];
            winnerId = user.objectId;
        }
        
        UIView *playerView = [self createPlayerView:counter name:name guess:guessString];
        NSInteger tag = 400 + counter;
        NSString *tagId = [NSString stringWithFormat: @"%d", (int)tag];
        [self.playersList addSubview:playerView];
        
        NSDictionary *playerMetadata = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tagId, @"tag",
                                        guessString, @"answer",
                                        revealedGuess, @"revealed",
                                        [guessData objectForKey:@"guessId"], @"guessId",
                                        nil];
        
        [self.answers setObject:playerMetadata forKey:user.objectId];
        
        counter++;
    }
    
    if(gameIsComplete == YES) {
        [self displayEndGame:winnerId];
    }
    
    [self.view addSubview:self.playersList];
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

-(UIView *)createPlayerView:(NSInteger) offset name:(NSString *)name guess:(NSString *)guess {
    UIView *view = [[UIView alloc] init];
    
    CGRect boxFrame = view.frame;
    boxFrame.size.width = self.view.frame.size.width;
    boxFrame.size.height = 40;
    int boxOffset = (int) (offset * 42) + 94;
    view.frame = CGRectOffset(boxFrame, 0, boxOffset);
    [view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.6 blue:0.08 alpha:0.7]];
    
    UIImageView *contactPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    contactPhoto.image = [GuesstimateUser getDefaultPhoto];
    [view addSubview:contactPhoto];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, view.frame.size.width - 110, view.frame.size.height)];
    nameLabel.text = name;
    [nameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:nameLabel];
    
    UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 100, 0, 100, view.frame.size.height)];
    answerLabel.text = guess;
    [answerLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f]];
    [answerLabel setTextColor:[UIColor whiteColor]];
    [answerLabel setBackgroundColor:[UIColor clearColor]];
    answerLabel.tag = 400 + offset;
    
    [view addSubview:answerLabel];
    
    return view;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
