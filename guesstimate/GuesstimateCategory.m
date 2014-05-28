//
//  GuesstimateCategory.m
//  guesstimate
//
//  Created by Eric Weaver on 5/12/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimateCategory.h"

@implementation GuesstimateCategory

+(void)getCategory:(NSString *)categoryId onCompletion:(void (^)(GuesstimateCategory *category, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query whereKey:@"objectId" equalTo:categoryId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(error) {
            onComplete(nil, error);
        } else {
            if([objects count] == 1) {
                PFObject *object = [objects objectAtIndex:0];
                GuesstimateCategory *category = [[GuesstimateCategory alloc] initWithId:object.objectId withTitle:[object objectForKey:@"title"] withBgImage:[object objectForKey:@"bg_image"] isLocked:[[object objectForKey:@"isLocked"] boolValue]];
                onComplete(category, nil);
            } else {
                NSDictionary *errorDictionary = @{ @"error": @"Unable to load specified category."};
                NSError *error = [[NSError alloc] initWithDomain:@"com.firststep.guesstimate.CategoryError" code:1 userInfo:errorDictionary];
                onComplete(nil, error);
            }
        }
    }];
}

+(void)getCategories:(void (^)(NSArray *categories, NSError *error))onComplete {
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query orderByAscending:@"title"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *categories, NSError *error) {
        NSMutableArray *gCategories = [[NSMutableArray alloc] initWithCapacity:[categories count]];
        
        for (PFObject *object in categories) {
            GuesstimateCategory *category = [[GuesstimateCategory alloc] initWithId:object.objectId withTitle:[object objectForKey:@"title"] withBgImage:[object objectForKey:@"bg_image"] isLocked:[[object objectForKey:@"isLocked"] boolValue]];
            [gCategories addObject:category];
        }
        
        onComplete([[NSArray alloc] initWithArray:gCategories], error);
    }];
}

+(GuesstimateCategory *)getDefaultCategory {
    return [[GuesstimateCategory alloc] initWithId:@"zB78Vnq0JK" withTitle:@"Alcohol" withBgImage:@"cat_alcohol.jpg" isLocked:NO];
}

-(id)initWithId:(NSString *)objectId withTitle:(NSString *)title withBgImage:(NSString *)bgImage isLocked:(BOOL)isLocked {
    self = [super init];
    
    if(self) {
        _objectId = objectId;
        _title = title;
        _bgImage = bgImage;
        _isLocked = isLocked;
    }
    
    return self;
}

@end
