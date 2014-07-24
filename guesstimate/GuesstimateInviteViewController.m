//
//  GuesstimateBaseInviteViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateInviteViewController.h"
#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateGameInviteTableViewCell.h"
#import "GuesstimateGame.h"
#import "GuesstimateContact.h"

@interface GuesstimateInviteViewController ()

@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSMutableDictionary *invites;

@end

@implementation GuesstimateInviteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [[self.view viewWithTag:901] removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Assume Facebook contacts only for now
    /*[GuesstimateFacebookInviteSource getContacts:^(NSArray *contacts, NSError *error) {
            }];*/
    
    [GuesstimateContact getMyContacts:^(NSArray *contacts, NSError *error) {
        self.contacts = contacts;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 189)];
        tableView.tag = 901;
        tableView.allowsMultipleSelection = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        [tableView setBackgroundColor:[[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.3]];
        
        [self.view addSubview:tableView];

    }];
    
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    
    self.invites = [[NSMutableDictionary alloc] init];
    
    // Start Game
    UIView *startGameView = [self addPositiveButton:@"Start Game >>" offset:40];
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGame)];
    [startGameView addGestureRecognizer:startTap];
    [self.view addSubview:startGameView];
}

#pragma mark gestures

-(void)startGame {
    if([self.invites count] < 1) {
        [[GuesstimateApplication getErrorAlert:@"At least one other player must be invited to start!"] show];
        return;
    }
    
    NSArray *invites = [self.invites allValues];
    [GuesstimateGame startGame:self.gameId invites:invites onCompleteBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded == YES) {
            GuesstimatePlayGameViewController *viewController = [[GuesstimatePlayGameViewController alloc] init];
            viewController.gameId = self.gameId;
            [self pushSelectionViewController:viewController];
        } else {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        }
    }];
}

#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
    [label setFont:[UIFont fontWithName: @"HelveticaNeue" size: 18.0f]];
    label.textColor = [UIColor whiteColor];
    NSString *string = @"Contact List";
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:0.8]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contacts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateGameInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameInviteCell"];
    
    if(cell == nil) {
        cell = [[GuesstimateGameInviteTableViewCell alloc] init];
    }

    [cell setBackgroundColor:[UIColor clearColor]];
    GuesstimateContact *contact = (GuesstimateContact *) [self.contacts objectAtIndex:indexPath.row];
    if(contact.user.photo != nil) {
        cell.photoView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:contact.user.photo]];
    } else {
        cell.photoView.image = [GuesstimateUser getDefaultPhoto];
    }
    cell.nameLabel.text = contact.user.name;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateContact *contact = [self.contacts objectAtIndex:indexPath.row];
    [self.invites setObject:contact.user forKey:contact.user.objectId];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateContact *contact = [self.contacts objectAtIndex:indexPath.row];
    [self.invites removeObjectForKey:contact.user.objectId];
}

#pragma mark memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
