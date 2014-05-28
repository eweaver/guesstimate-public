//
//  FacebookLibrary.m
//  guesstimate
//
//  Created by Eric Weaver on 5/15/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateFacebookLibrary.h"

@implementation GuesstimateFacebookLibrary

+(void) openSession:(void (^)(void))onSessionComplete {
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      onSessionComplete();
                                  }];
}

+(void) meWithBlock:(void (^)(NSDictionary *userData, NSError *error))onComplete {
    void ( ^requestBlock )( void );
    requestBlock = ^( void )
    {
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSDictionary *userData = (NSDictionary *) result;
                onComplete(userData, error);
                
            } else {
                onComplete(nil, error);
            }
        }];
    };
    
    if(! FBSession.activeSession.isOpen) {
        [self openSession:requestBlock];
    } else {
        requestBlock();
    }
}

@end
