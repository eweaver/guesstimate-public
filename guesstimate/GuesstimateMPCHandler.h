//
//  GuesstimateMPCHandler.h
//  guesstimate
//
//  Created by Eric Weaver on 7/24/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "GuesstimateAlertDataSource.h"

@interface GuesstimateMPCHandler : NSObject <MCSessionDelegate, GuesstimateAlertDataSource>

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCBrowserViewController *browser;

- (void) setupPeerWithDisplayName:(NSString *)displayName;
- (void) setupSession;
- (void) setupBrowser:(NSString *)serviceType;
- (void) advertiseSelf:(NSString *)alert advertise:(BOOL)advertise;

@end
