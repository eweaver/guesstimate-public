//
//  GuesstimateFacebookInviteSource.m
//  guesstimate
//
//  Created by Eric Weaver on 5/14/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateFacebookInviteSource.h"
#import "GuesstimateUser.h"

@implementation GuesstimateFacebookInviteSource

+(void) getContactsAndInvitees:(void (^)(NSArray *contacts, NSArray *invitees, NSError *error))onComplete {
    void ( ^requestBlock )( void );
    requestBlock = ^( void )
    {
        FBRequest *request = [FBRequest requestForMyFriends];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSArray *friendObjects = [result objectForKey:@"data"];
                NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
                NSMutableDictionary *friendDataMappings = [NSMutableDictionary dictionaryWithCapacity:friendObjects.count];
                
                // Create a list of friends' Facebook IDs
                for (NSDictionary *friendObject in friendObjects) {
                    NSString *facebookId = [friendObject objectForKey:@"id"];
                    [friendIds addObject:facebookId];
                    
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId]];
                    NSDictionary *friendData = @{@"name":[friendObject objectForKey:@"name"], @"picture":pictureURL};
                    
                    [friendDataMappings setObject:friendData forKey:facebookId];
                }
                
                PFQuery *friendQuery = [PFUser query];
                [friendQuery whereKey:@"contactFacebookId" containedIn:friendIds];
                
                // findObjects will return a list of PFUsers that are friends
                // with the current user
                [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *friendUsers, NSError *error) {
                    
                    NSMutableArray *returnFriends = [[NSMutableArray alloc] init];
                    for(PFUser *userObject in friendUsers) {
                        NSDictionary *friendData = [friendDataMappings objectForKey:[userObject objectForKey:@"contactFacebookId"]];
                        [friendDataMappings removeObjectForKey:[userObject objectForKey:@"contactFacebookId"]];
                        
                        GuesstimateUser *user = [[GuesstimateUser alloc] initWithId:userObject.objectId withName:[friendData objectForKey:@"name"]];
                        [user setPhoto:[friendData objectForKey:@"picture"]];
                        [returnFriends addObject:user];
                    }
                    
                    NSArray *invitees = [GuesstimateFacebookInviteSource getInvitees:friendObjects];
                    onComplete(returnFriends, invitees, error);
                }];
                
            } else {
                [[GuesstimateApplication getErrorAlert:@"FBError"] show];
            }
        }];
    };
    
    if(! FBSession.activeSession.isOpen) {
        [GuesstimateFacebookLibrary openSession:requestBlock];
    } else {
        requestBlock();
    }
    
}

+(NSArray *)getInvitees:(NSArray *)friendObjects {
    NSMutableArray *invitees = [[NSMutableArray alloc] initWithCapacity:friendObjects.count];
    
    for(NSDictionary *friendObject in friendObjects) {
        NSString *facebookId = [friendObject objectForKey:@"id"];
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId]];
        NSDictionary *friendData = @{@"id":facebookId, @"name":[friendObject objectForKey:@"name"], @"picture":pictureURL};
        [invitees addObject:friendData];
    }
    
    return [[NSArray alloc] initWithArray:invitees];
}

@end
