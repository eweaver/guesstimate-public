//
//  FSPSAppDelegate.h
//  guesstimate
//
//  Created by Eric Weaver on 4/21/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
