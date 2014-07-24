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
#import "GuesstimateTicker.h"
#import "GuesstimateAlertView.h"
#import "GuesstimateAlertView+Invite.h"
#import "GuesstimateAlertView+PlayerJoin.h"
#import "GuesstimateAlertView+SubmitAnswer.h"
#import "GuesstimateAlertView+EndGame.h"
#import "NSDictionary+GuesstimateAlertViewDataSource.h"

@interface GuesstimatePushHandler ()

@property (strong, nonatomic) NSDictionary *pushData;
@property (strong, nonatomic) NSString *pushTitle;
@property (strong, nonatomic) NSString *pushMessage;
@property (strong, nonatomic) NSString *pushActionText;
@property (strong, nonatomic) NSString *pushCancelText;
@property (strong, nonatomic) GuesstimateAlertView *alertView;

@end

@implementation GuesstimatePushHandler

-(void)handlePushView:(GuesstimateAlertView *)alertView {
    [alertView showAlert];
}

-(void)handlePush:(NSDictionary *)userInfo {
    self.pushData = userInfo;
    NSString *type = [userInfo objectForKey:@"type"];
    NSDictionary *aps = [userInfo objectForKey:@"aps"];

    // Invites
    if([type isEqualToString:@"invite"]) {
        self.pushTitle = @"You have been invited to a game!";
        self.pushMessage = [aps objectForKey:@"alert"];
        self.pushActionText = @"Join Game";
        self.pushCancelText = @"Decline";
        
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            NSDictionary *pushDataSource = @{@"title":self.pushTitle, @"message":self.pushMessage, @"action":self.pushActionText, @"cancel":self.pushCancelText, @"data":self.pushData};
            app.pushView = [[GuesstimateAlertView alloc] initWithType:@"invite" dataSource:pushDataSource];
        } else {
            if(! [self.authUser.objectId isEqualToString:[userInfo objectForKey:@"creator"]]) {
                self.alertView = [[GuesstimateAlertView alloc] initWithType:@"invite" dataSource:self];
                [self.alertView showInvite];
            }
        }
    }
    
    // Player Join
    else if([type isEqualToString:@"newPlayer"]) {
        self.pushTitle = @"A player has joined the game!";
        self.pushMessage = [aps objectForKey:@"alert"];
        self.pushActionText = @"Go to Game";
        self.pushCancelText = @"Cancel";
        
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            NSDictionary *pushDataSource = @{@"title":self.pushTitle, @"message":self.pushMessage, @"action":self.pushActionText, @"cancel":self.pushCancelText, @"data":self.pushData};
            app.pushView = [[GuesstimateAlertView alloc] initWithType:@"playerJoin" dataSource:pushDataSource];
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
                        GuesstimateTicker *ticker = [[GuesstimateTicker alloc] initWithText:[[self.pushData objectForKey:@"aps"] objectForKey:@"alert"] duration:2.0f rootView:navController.view];
                        [ticker displayBottomTicker];
                        [gameController refreshGameAddPlayer];
                    }
                    break;
                }
            }
            
            // Not in the game, show the Alert to see if we should go there
            if(! gameController) {
                self.alertView = [[GuesstimateAlertView alloc] initWithType:@"playerJoin" dataSource:self];
                [self.alertView showPlayerJoin];
            }
        }
    }
    
    // Submit answer
    else if([type isEqualToString:@"submitAnswer"]) {
        self.pushTitle = @"An answer has been submitted!";
        self.pushMessage = [aps objectForKey:@"alert"];
        self.pushActionText = @"Go to Game";
        self.pushCancelText = @"Cancel";
        
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            NSDictionary *pushDataSource = @{@"title":self.pushTitle, @"message":self.pushMessage, @"action":self.pushActionText, @"cancel":self.pushCancelText, @"data":self.pushData};
            app.pushView = [[GuesstimateAlertView alloc] initWithType:@"submitAnswer" dataSource:pushDataSource];

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
                        GuesstimateTicker *ticker = [[GuesstimateTicker alloc] initWithText:[[self.pushData objectForKey:@"aps"] objectForKey:@"alert"] duration:2.0f rootView:navController.view];
                        [ticker displayBottomTicker];
                        [gameController silentRefreshGame:[self.pushData objectForKey:@"guessOwner"]];
                    }
                }
            }
            
            // Not in the game, show the Alert to see if we should go there
            if(! gameController) {
                self.alertView = [[GuesstimateAlertView alloc] initWithType:@"submitAnswer" dataSource:self];
                [self.alertView showSubmitAnswer];
            }
        }

    }
    
    // End Game
    else if([type isEqualToString:@"endGame"]) {
        self.pushTitle = @"A game has ended!";
        self.pushMessage = [aps objectForKey:@"alert"];
        self.pushActionText = @"Go to Game";
        self.pushCancelText = @"Cancel";
        
        if( ! self.authUser ) {
            GuesstimateApplication *app = [GuesstimateApplication sharedApp];
            app.hasDelayedPush = YES;
            NSDictionary *pushDataSource = @{@"title":self.pushTitle, @"message":self.pushMessage, @"action":self.pushActionText, @"cancel":self.pushCancelText, @"data":self.pushData};
            app.pushView = [[GuesstimateAlertView alloc] initWithType:@"endGame" dataSource:pushDataSource];

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
                [GuesstimateAlertView showEndGame:self];
                self.alertView = [[GuesstimateAlertView alloc] initWithType:@"endGame" dataSource:self];
                [self.alertView showEndGame];
            }
        }
        
    }

}

#pragma mark GuesstimateAlertDataSource

- (NSString *)titleForAlert:(NSString *)alert {
    return self.pushTitle;
}

- (NSString *)messageForAlert:(NSString *)alert {
    return self.pushMessage;
}

- (NSString *)actionTextForAlert:(NSString *)alert {
    return self.pushActionText;
}

- (NSString *)cancelTextForAlert:(NSString *)alert {
    return self.pushCancelText;
}

- (NSDictionary *)dataForAlert:(NSString *)alert {
    return self.pushData;
}

@end
