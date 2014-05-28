//
//  GuesstimatePhoneContactsViewController.m
//  guesstimate
//
//  Created by Eric Weaver on 5/18/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimatePhoneContactsViewController.h"
#import "GuesstimatePhoneContacts.h"
#import "GuesstimateFacebookContactTableViewCell.h"

@interface GuesstimatePhoneContactsViewController ()

@property (strong, nonatomic) NSArray *contacts;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GuesstimatePhoneContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect tableViewFrame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
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
    
    self.contacts = [GuesstimatePhoneContacts getAllContacts];
}

#pragma mark table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GuesstimateFacebookContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FacebookContactCell"];
    if(cell == nil) {
        cell = [[GuesstimateFacebookContactTableViewCell alloc] init];
    }
    
    NSDictionary *contactData = [self.contacts objectAtIndex:indexPath.row];
    cell.nameLabel.text = [contactData objectForKey:@"name"];
    cell.photoView.image = [contactData objectForKey:@"photoImage"];
    
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
