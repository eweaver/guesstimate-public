//
//  GuesstimateQuestionSelectViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 4/29/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateQuestionSelectViewController.h"
#import "GuesstimateWelcomeViewController.h"
#import "GuesstimateInviteViewController.h"
#import "GuesstimateUser.h"
#import "GuesstimateGame.h"
#import "GuesstimateCategory.h"
#import "GuesstimateQuestion.h"
#import "GuesstimateCategoryTableViewCell.h"

@interface GuesstimateQuestionSelectViewController ()

@property (assign, nonatomic) BOOL isCategoryListExpanded;

@end

@implementation GuesstimateQuestionSelectViewController

NSInteger categoryPosition = 0;
NSInteger questionPosition = 0;
NSInteger maxQuestionPosition = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.categoryBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 246, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 246)];
        self.categoryBgImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:self.categoryBgImage];
        
        self.categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 40, self.view.frame.size.width, 20)];
        self.categoryTitle.font = [UIFont fontWithName:@"HelveticaNueue-Light" size:11.0f];
        self.categoryTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:self.categoryTitle];
        
        self.categoriesTable = [[UITableView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, 26, 150, 28)];
        
        [self loadCategories];
        [self loadQuestions];
        
        //Hide logo
        [[self.view viewWithTag:101] removeFromSuperview];
        [[self.view viewWithTag:102] removeFromSuperview];
        
        //Question box
        UIView *boxView = [self addUIBox:182 offset:64 withColor:[UIColor colorWithWhite:1 alpha:0.2]];
        
        self.questionText = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, (boxView.frame.size.width - 100), boxView.frame.size.height - 20)];
        self.questionText.textAlignment = NSTextAlignmentCenter;
        [self.questionText setTextColor:[UIColor whiteColor]];
        [self.questionText setBackgroundColor:[UIColor clearColor]];
        [self.questionText setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 22.0f]];
        self.questionText.numberOfLines = 6;
        
        [boxView addSubview:self.questionText];
        
        //Bg gradient
        UIImageView *gradientBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 244)];
        gradientBg.contentMode = UIViewContentModeScaleAspectFill;
        gradientBg.image = [UIImage imageNamed:@"header_gradient.jpg"];
        [self.view addSubview:gradientBg];
        
        // Swipe Gestures
        UISwipeGestureRecognizer *previousSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousQuestion:)];
        [previousSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
        [boxView addGestureRecognizer:previousSwipe];
        
        UISwipeGestureRecognizer *nextSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextQuestion:)];
        [nextSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [boxView addGestureRecognizer:nextSwipe];
        
        // Decorate with arrows
        UITapGestureRecognizer *previousTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previousQuestion:)];
        UITapGestureRecognizer *nextTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextQuestion:)];
        boxView = [self addSwipeableArrowsToUIView:boxView leftArrowGesture:previousTap rightArrowGesture:nextTap];
        
        UIColor *playColor = [[UIColor alloc] initWithRed:248.0/255.0 green:156.0/255.0 blue:32.0/255.0 alpha:0.66];
        self.playButton = [self addUIBox:60 offset:246 withColor:playColor];
        
        UILabel *playLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.playButton.frame.size.width, self.playButton.frame.size.height)];
        playLabel.text = @"Play this question >>";
        playLabel.textAlignment = NSTextAlignmentCenter;
        [playLabel setTextColor:[UIColor whiteColor]];
        [playLabel setBackgroundColor:[UIColor clearColor]];
        [playLabel setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 30.0f]];
        [self.playButton addSubview:playLabel];
        
        UITapGestureRecognizer *selectCategoryRap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGame)];
        [self.playButton addGestureRecognizer:selectCategoryRap];
        
        [self.view addSubview:boxView];
        [self.view addSubview:self.playButton];
        [self addMenuItems];
    }
    return self;
}

#pragma mark viewLoad

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkForDelayedPush];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isCategoryListExpanded = NO;
    
    if(self.categoryId == nil) {
        //Default
        self.category = [GuesstimateCategory getDefaultCategory];
        self.categoryId = self.category.objectId;
        self.categories = @[[[GuesstimateCategory alloc] initWithId:self.categoryId withTitle:@"Alcohol" withBgImage:@"cat_alcohol.jpg" isLocked:NO]];
        categoryPosition = 0;
    }

}

#pragma mark push

-(void)checkForDelayedPush {
    GuesstimateApplication *app = [GuesstimateApplication sharedApp];
    if(app.hasDelayedPush == YES) {
        self.pushHandler = [[GuesstimatePushHandler alloc] init];
        self.pushHandler.authUser = [GuesstimateUser getAuthUser];
        [self.pushHandler handlePush:app.pushData];
        
        app.hasDelayedPush = NO;
        app.pushData = nil;
    }
}

#pragma mark categories

-(void)loadCategories {
    [GuesstimateCategory getCategories:^(NSArray *categories, NSError *error) {
        if(categories) {
            self.categories = categories;
            // Navbar questions
            NSInteger height = 28;
            if(self.isCategoryListExpanded == YES) {
                height = (height * (self.categories.count));
            }

            self.categoriesTable.tag = 902;
            self.categoriesTable.layer.cornerRadius = 10;
            self.categoriesTable.delegate = self;
            self.categoriesTable.dataSource = self;
            self.categoriesTable.bounces = NO;
            self.categoriesTable.rowHeight = 28;
            self.categoriesTable.tableHeaderView = nil;
            self.categoriesTable.layer.borderWidth = 0.66f;
            self.categoriesTable.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66].CGColor;
            self.categoriesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            [self.view addSubview:self.categoriesTable];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

#pragma mark questions

-(void)loadQuestions {
    self.questionText.text = @"loading...";
    [self displayWaiting];
    [GuesstimateQuestion getQuestions:self.categoryId onCompleteBlock:^(NSArray *questions, NSError *error) {
        [self hideWaiting];
        if(questions) {
            [self displayQuestions:questions];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

- (NSInteger)getPreviousIndex {
    if(questionPosition > 0) {
        questionPosition--;
    } else {
        questionPosition = maxQuestionPosition;
    }
    
    return questionPosition;
}

- (NSInteger)getNextIndex {
    if(questionPosition < maxQuestionPosition) {
        questionPosition++;
    } else {
        questionPosition = 0;
    }
    
    return questionPosition;
}

- (void)previousQuestion:(UISwipeGestureRecognizer *)gr {
    NSInteger newIndex = [self getPreviousIndex];
    [self displayQuestionAtIndex:newIndex];
}

- (void)nextQuestion:(UISwipeGestureRecognizer *)gr {
    NSInteger newIndex = [self getNextIndex];
    [self displayQuestionAtIndex:newIndex];
}

-(void)displayQuestions:(NSArray *)questions {
    maxQuestionPosition = (int) [questions count] - 1;
    self.questions = questions;
    [self displayQuestionAtIndex:0];
}

-(void)displayQuestionAtIndex:(NSInteger) index {
    GuesstimateQuestion *question = [self.questions objectAtIndex:index];
    self.questionText.text = question.text;
    self.category = [self.categories objectAtIndex:categoryPosition];
    
    //Bg Image
    if(self.category.bgImage != nil) {
         UIImage * toImage = [UIImage imageNamed:self.category.bgImage];
         [UIView transitionWithView:self.categoryBgImage
                           duration:0.3f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             self.categoryBgImage.image = toImage;
                         } completion:nil];
    }
    
    //Category title
    self.categoryTitle.text = [NSString stringWithFormat:@"Category: %@", self.category.title];
    [self.view sendSubviewToBack:self.categoryBgImage];
    [self.view bringSubviewToFront:self.playButton];

}

#pragma mark segue/transition

-(void)startGame {
    [self displayWaiting];
    
    GuesstimateQuestion *question = (GuesstimateQuestion *) [self.questions objectAtIndex:questionPosition];
    NSString *questionId = question.objectId;
    GuesstimateUser *user = [GuesstimateUser getAuthUser];
    NSString *preview = self.questionText.text;
    [GuesstimateGame createGame:self.categoryId withQuestion:questionId creator:user.objectId preview:preview onCompleteBlock:^(GuesstimateGame *game, NSError *error) {
        [self hideWaiting];
        if(game) {
            GuesstimateInviteViewController *viewController = [[GuesstimateInviteViewController alloc] init];
            viewController.gameId = game.objectId;
            [self pushSelectionViewController:viewController];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

#pragma mark table methods

-(void)shrinkCategoriesTable {
    NSInteger height = 28;
    
    CGRect newFrame = CGRectMake(self.categoriesTable.frame.origin.x, self.categoriesTable.frame.origin.y, 150, height);
    self.isCategoryListExpanded = NO;
    
    self.categoriesTable.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.categoriesTable.frame = newFrame;
    
    [self.categoriesTable reloadData];
    [self.categoriesTable setNeedsLayout];
    [self.categoriesTable setNeedsDisplayInRect:newFrame];
}

-(void)expandCategoriesTable {
    NSInteger height = self.categories.count * 28;
    CGRect newFrame = CGRectMake(self.categoriesTable.frame.origin.x, self.categoriesTable.frame.origin.y, 150, height);
    self.isCategoryListExpanded = YES;
    
    self.categoriesTable.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
    self.categoriesTable.frame = newFrame;
    [self.view bringSubviewToFront:self.categoriesTable];

    [self.categoriesTable reloadData];
    [self.categoriesTable setNeedsLayout];
    [self.categoriesTable setNeedsDisplayInRect:newFrame];
}

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isCategoryListExpanded == NO) {
        return 1;
    } else {
        return [self.categories count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    if(cell == nil) {
        cell = [[GuesstimateCategoryTableViewCell alloc] init];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if(self.isCategoryListExpanded == YES) {
        GuesstimateCategory* category = [self.categories objectAtIndex:indexPath.row];
        cell.titleLabel.text = category.title;
    
        CALayer *upperBorder = [CALayer layer];
        upperBorder.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66].CGColor;
        upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(cell.frame), 0.66f);
        [cell.layer addSublayer:upperBorder];
    
        if(category.isLocked == YES) {
            cell.rightImageView.image = [UIImage imageNamed:@"ic_lock.png"];
            cell.titleLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        }
    } else {
        GuesstimateCategory* category = [self.categories objectAtIndex:categoryPosition];
        cell.titleLabel.text = category.title;
        cell.leftArrowImageView.image = [UIImage imageNamed:@"arrow_dropdown.png"];
        cell.rightArrowImageView.image = [UIImage imageNamed:@"arrow_dropdown.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateCategory *category = [self.categories objectAtIndex:indexPath.row];
    if(category.isLocked == YES) {
        [[GuesstimateApplication getErrorAlert:@"This category is locked!"] show];
        return;
    }
    
    
    if(self.isCategoryListExpanded == YES) {
        if(categoryPosition != indexPath.row) {
            categoryPosition = indexPath.row;
            self.categoryId = category.objectId;
            [self loadQuestions];
        }
        
        [self shrinkCategoriesTable];
    } else {
        [self expandCategoriesTable];
    }
}

#pragma mark memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
