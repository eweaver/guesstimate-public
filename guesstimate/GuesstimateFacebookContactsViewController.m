//
//  GuesstimateFacebookContactsViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/18/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateFacebookContactsViewController.h"
#import "GuesstimateFacebookContactTableViewCell.h"
#import "GuesstimateFacebookInviteSource.h"

@interface GuesstimateFacebookContactsViewController ()

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSArray *invitees;
@property (nonatomic, strong) UISegmentedControl *mySegmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger visibleTable;

@end

@implementation GuesstimateFacebookContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect tableViewFrame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 124);
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GuesstimateApplication displayWaiting:self.view withText:@"" withSubtext:@"Loading Facebook contacts..."];
    [GuesstimateFacebookInviteSource getContactsAndInvitees:^(NSArray *contacts, NSArray *invitees, NSError *error) {
        [GuesstimateApplication hideWaiting:self.view];
        if(error) {
            [[GuesstimateApplication getErrorAlert:[error userInfo][@"error"]] show];
        } else {
            self.contacts = contacts;
            self.invitees = invitees;
            self.visibleTable = 0;
            [self displayContactsTable];
            [self addTabs];
        }
    }];
}

-(void)displayContactsTable {
    self.tableView.frame = self.tableView.frame;
    
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView setNeedsDisplayInRect:self.tableView.frame];

}

-(GuesstimateFacebookContactTableViewCell *)displayContactsTableCell:(NSIndexPath *)indexPath cell:(GuesstimateFacebookContactTableViewCell *)cell  {
    GuesstimateUser *user = [self.contacts objectAtIndex:indexPath.row];
    cell.nameLabel.text = user.name;
    cell.photoView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:user.photo]];
    return cell;
}

-(void)displayInviteesTable {
    self.tableView.frame = self.tableView.frame;
    
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView setNeedsDisplayInRect:self.tableView.frame];
}

-(GuesstimateFacebookContactTableViewCell *)displayInviteesTableCell:(NSIndexPath *)indexPath cell:(GuesstimateFacebookContactTableViewCell *)cell  {
    NSDictionary *facebookData = [self.invitees objectAtIndex:indexPath.row];
    cell.nameLabel.text = [facebookData objectForKey:@"name"];
    //TODO: Make this lazy loading
    //cell.photoView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[facebookData objectForKey:@"picture"]]];
    cell.photoView.image = [GuesstimateUser getDefaultPhoto];
    return cell;
}

-(void) addTabs {
    CGRect myFrame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 50, self.view.frame.size.width - 20, 40);
    NSArray *mySegments = [[NSArray alloc] initWithObjects: @"Available Contacts", @"Invite to App", nil];
    self.mySegmentedControl = [[UISegmentedControl alloc] initWithItems:mySegments];
    self.mySegmentedControl.frame = myFrame;
    self.mySegmentedControl.tintColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.08 alpha:0.8];

    [self.mySegmentedControl setSelectedSegmentIndex:0];
    
    [self.mySegmentedControl addTarget:self
                                action:@selector(sourceSwitch:)
                      forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.mySegmentedControl];
}

-(void)sourceSwitch:(UISegmentedControl *)paramSender {
    NSInteger selectedIndex = [paramSender selectedSegmentIndex];
    self.visibleTable = selectedIndex;
    
    // Available Contacts
    if(selectedIndex == 0) {
        [self displayContactsTable];
    }
    
    // Users who can be invited
    else {
        [self displayContactsTable];
    }
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.visibleTable == 0) {
        return self.contacts.count;
    } else {
        return self.invitees.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateFacebookContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FacebookContactCell"];
    if(cell == nil) {
        cell = [[GuesstimateFacebookContactTableViewCell alloc] init];
    }
    
    if(self.visibleTable == 0) {
        cell = [self displayContactsTableCell:indexPath cell:cell];
    } else {
        cell = [self displayInviteesTableCell:indexPath cell:cell];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuesstimateFacebookContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FacebookContactCell"];
    if(cell == nil) {
        cell = [[GuesstimateFacebookContactTableViewCell alloc] init];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
