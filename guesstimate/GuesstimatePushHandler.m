//
//  GuesstimatePushHandler.m
//  guesstimate
//
//  Created by Eric Weaver on 5/26/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimatePushHandler.h"
#import "GuesstimateUser.h"
#import "MMDrawerController.h"
#import "GuesstimateInvite.h"
#import "GuesstimateApplication.h"
#import "GuesstimatePlayGameViewController.h"
#import "FSPSAppDelegate.h"
#import "GuesstimateApplication.h"

@interface GuesstimatePushHandler ()

@property (strong, nonatomic) NSDictionary *pushData;

@end

@implementation GuesstimatePushHandler

-(void)handlePush:(NSDictionary *)userInfo {
    self.pushData = userInfo;
    NSString *type = [userInfo objectForKey:@"type"];
    NSDictionary *aps = [userInfo objectForKey:@"aps"];

    // Invites
    if([type isEqualToString:@"invite"]) {
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            app.pushData = userInfo;
        } else {
            if(! [self.authUser.objectId isEqualToString:[userInfo objectForKey:@"creator"]]) {
                UIAlertView *pushView = [[UIAlertView alloc] initWithTitle:@"Game Invite Placeholder" message:[aps objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Join Game", nil];
                [pushView show];
            }
        }
    }
    
    // Player Join
    else if([type isEqualToString:@"newPlayer"]) {
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            app.pushData = userInfo;
        } else {
            FSPSAppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
            MMDrawerController *drawerController = (MMDrawerController *) myDelegate.window.rootViewController;
            UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
            GuesstimatePlayGameViewController *gameController;
            
            // Check if the user is currently in the game, if not show an alert to push to the new game or not
            for(UIViewController *vc in navController.viewControllers) {
                if([vc isKindOfClass:[GuesstimatePlayGameViewController class]]) {
                    gameController = (GuesstimatePlayGameViewController *) vc;
                    if([gameController.gameId isEqualToString:[self.pushData objectForKey:@"gameId"]]) {
                        [gameController silentRefreshGame];
                    }
                    break;
                }
            }
            
            // Not in the game, show the Alert to see if we should go there
            if(! gameController) {
                UIAlertView *pushView = [[UIAlertView alloc] initWithTitle:@"Player Joined Placeholder" message:[aps objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go to Game", nil];
                [pushView show];
            }
        }
    }
    
    // Submit answer
    else if([type isEqualToString:@"submitAnswer"]) {
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            app.pushData = userInfo;
        } else {
            FSPSAppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
            MMDrawerController *drawerController = (MMDrawerController *) myDelegate.window.rootViewController;
            UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
            GuesstimatePlayGameViewController *gameController;
            
            // Check if the user is currently in the game, if not show an alert to push to the new game or not
            for(UIViewController *vc in navController.viewControllers) {
                if([vc isKindOfClass:[GuesstimatePlayGameViewController class]]) {
                    gameController = (GuesstimatePlayGameViewController *) vc;
                    if([gameController.gameId isEqualToString:[self.pushData objectForKey:@"gameId"]]) {
                        [gameController silentRefreshGame];
                    }
                    break;
                }
            }
            
            // Not in the game, show the Alert to see if we should go there
            if(! gameController) {
                UIAlertView *pushView = [[UIAlertView alloc] initWithTitle:@"Answer Submitted Placeholder" message:[aps objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go to Game", nil];
                [pushView show];
            }
        }

    }
    
    // End Game
    else if([type isEqualToString:@"endGame"]) {
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            app.pushData = userInfo;
        } else {
            FSPSAppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
            MMDrawerController *drawerController = (MMDrawerController *) myDelegate.window.rootViewController;
            UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
            GuesstimatePlayGameViewController *gameController;
            
            // Check if the user is currently in the game, if not show an alert to push to the new game or not
            for(UIViewController *vc in navController.viewControllers) {
                if([vc isKindOfClass:[GuesstimatePlayGameViewController class]]) {
                    gameController = (GuesstimatePlayGameViewController *) vc;
                    if([gameController.gameId isEqualToString:[self.pushData objectForKey:@"gameId"]]) {
                        [gameController silentRefreshGame];
                    }
                    break;
                }
            }
            
            // Not in the game, show the Alert to see if we should go there
            if(! gameController) {
                UIAlertView *pushView = [[UIAlertView alloc] initWithTitle:@"End Game Placeholder" message:[aps objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go to Game", nil];
                [pushView show];
            }
        }
        
    }

}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    // Join Game
    if([title isEqualToString:@"Join Game"]) {
        FSPSAppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
        
        MMDrawerController *drawerController = (MMDrawerController *) myDelegate.window.rootViewController;
        UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
        [GuesstimateApplication displayWaiting:navController.view withText:@"Joining game..."];
        
        [GuesstimateGame getGameData:[self.pushData objectForKey:@"gameId"] onCompleteBlock:^(GuesstimateGame *game, NSError *error) {
            
            GuesstimatePlayGameViewController *vc = [[GuesstimatePlayGameViewController alloc] init];
            vc.gameId = [self.pushData objectForKey:@"gameId"];
            
            // Temp
            PFUser *userObject = [PFUser user];
            userObject.objectId = [self.pushData objectForKey:@"creator"];
            userObject[@"username"] = @"tmp";
            GuesstimateUser *user = [GuesstimateUser initWith:userObject];

            [GuesstimateInvite initWithGameObject:game inviterObject:user onCompleteBlock:^(GuesstimateInvite *invite, NSError *error) {
                NSLog(@"%@", invite);
                NSLog(@"%@", error);
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
        vc.gameId = [self.pushData objectForKey:@"gameId"];

        UINavigationController *navController = (UINavigationController *) drawerController.centerViewController;
        [navController pushViewController:vc animated:YES];
    }
}

@end
