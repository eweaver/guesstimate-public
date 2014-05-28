//
//  GuesstimateEndGameViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateEndGameViewController.h"
#import "GuesstimateGame.h"

@interface GuesstimateEndGameViewController ()

@property (strong, nonatomic) GuesstimateGame *game;

@end

@implementation GuesstimateEndGameViewController

static NSInteger offset = 0;

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
    
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    
    [self addMenuItemsStackedRight:self.navigationController.navigationBar];
    [self setBackButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    offset = 0;
    
    [self displayResults];
}

-(void)displayResults {
    [self displayWaiting];
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
                [self hideWaiting];
                if([self.game scoreGame] == YES) {
                    [self displayAnswer];
                    [self displayPlayerGuesses];
                } else {
                    //error :(
                }
            }];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
        
    }];
}

-(void)displayAnswer {
    UIView *answer = [self addInfoView:[NSString stringWithFormat:@"The answer is: %@!", self.game.answer] offset:40];
    [self.view addSubview:answer];
}

-(void)displayPlayerGuesses {
    NSArray *scores = [self.game getGameScoresInOrder];
    NSInteger numPlayers = scores.count;
    NSInteger counter = 0;
    for(NSDictionary *playerData in scores) {
        BOOL isWinner = counter == 0 ? YES : NO;
        BOOL isLoser = (counter == (numPlayers - 1) ? YES : NO);
        
        [self displayPlayer:playerData isWinner:isWinner isLoser:isLoser];
        counter++;
    }
    
}

-(void)displayPlayer:(NSDictionary *)playerData isWinner:(BOOL)isWinner isLoser:(BOOL)isLoser {
    
    
    GuesstimateUser *user = [playerData objectForKey:@"user"];
    UIView *view = [[UIView alloc] init];
    
    CGRect boxFrame = view.frame;
    boxFrame.size.width = self.view.frame.size.width;
    boxFrame.size.height = 40;
    int boxOffset = (int) (offset * 42) + 66;
    view.frame = CGRectOffset(boxFrame, 0, boxOffset);
    [view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.6 blue:0.08 alpha:0.7]];
    
    UIImageView *contactPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
    contactPhoto.image = [GuesstimateUser getDefaultPhoto];
    [view addSubview:contactPhoto];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, view.frame.size.width - 110, view.frame.size.height)];
    nameLabel.text = user.name;
    [nameLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:nameLabel];
    
    NSString *guessString = [NSString stringWithFormat:@"%@", [playerData objectForKey:@"guess"]];
    
    UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 100, 0, 100, view.frame.size.height)];
    answerLabel.text = guessString;
    
    if(isWinner) {
        [answerLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f]];
        [answerLabel setTextColor:[UIColor yellowColor]];
    } else if(isLoser) {
        [answerLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 16.0f]];
        [answerLabel setTextColor:[UIColor redColor]];
    } else {
        [answerLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f]];
        [answerLabel setTextColor:[UIColor whiteColor]];
    }
    
    [answerLabel setBackgroundColor:[UIColor clearColor]];
    
    [view addSubview:answerLabel];
    [self.view addSubview:view];
    
    offset++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
