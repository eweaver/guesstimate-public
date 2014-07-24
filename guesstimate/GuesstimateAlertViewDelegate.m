//
//  GuesstimateAlertViewDelegate.m
//  guesstimate
//
//  Created by Eric Weaver on 7/23/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateAlertViewDelegate.h"
#import "FSPSAppDelegate.h"
#import "MMDrawerController.h"
#import "GuesstimateApplication.h"
#import "GuesstimateGame.h"
#import "GuesstimatePlayGameViewController.h"
#import "GuesstimateInvite.h"
#import "GuesstimateAlertDataSource.h"

@interface GuesstimateAlertViewDelegate ()

@property (strong, nonatomic) NSString *currentType;
@property (strong, nonatomic) id<GuesstimateAlertDataSource> dataSource;

@end

@implementation GuesstimateAlertViewDelegate

- (instancetype)initWithType:(NSString *)type dataSource:(id<GuesstimateAlertDataSource>)dataSource {
    self = [super init];
    if(self) {
        _currentType = type;
        _dataSource = dataSource;
    }
    
    return self;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Update to use alert type to determine action
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    // Join Game
    if([title isEqualToString:@"Join Game"]) {
        
        FSPSAppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
        
        MMDrawerController *drawerController = (MMDrawerController *) myDelegate.window.rootViewController;
        UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
        [GuesstimateApplication displayWaiting:navController.view withText:@"Joining game..."];
        
        [GuesstimateGame getGameData:[[self.dataSource dataForAlert:self.currentType] objectForKey:@"gameId"] onCompleteBlock:^(GuesstimateGame *game, NSError *error) {
            if(error) {
                [GuesstimateApplication hideWaiting:navController.view];
                return;
            }
            
            GuesstimatePlayGameViewController *vc = [[GuesstimatePlayGameViewController alloc] init];
            vc.gameId = [[self.dataSource dataForAlert:self.currentType] objectForKey:@"gameId"];
            
            // Temp
            PFUser *userObject = [PFUser user];
            userObject.objectId = [[self.dataSource dataForAlert:self.currentType] objectForKey:@"creator"];
            userObject[@"username"] = @"tmp";
            GuesstimateUser *user = [GuesstimateUser initWith:userObject];
            
            [GuesstimateInvite initWithGameObject:game inviterObject:user onCompleteBlock:^(GuesstimateInvite *invite, NSError *error) {
                if(error) {
                    [GuesstimateApplication hideWaiting:navController.view];
                    return;
                }
                
                [invite acceptInvite:^(BOOL succeeded, NSError *error) {
                    [GuesstimateApplication hideWaiting:navController.view];
                    [navController pushViewController:vc animated:YES];
                }];
            }];
        }];
    }
    
    // Return to Game
    else if([title isEqualToString:@"Go to Game"]) {
        FSPSAppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
        
        MMDrawerController *drawerController = (MMDrawerController *) myDelegate.window.rootViewController;
        GuesstimatePlayGameViewController *vc = [[GuesstimatePlayGameViewController alloc] init];
        vc.gameId = [[self.dataSource dataForAlert:self.currentType] objectForKey:@"gameId"];
        
        UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
        [navController pushViewController:vc animated:YES];
    }
}


@end
