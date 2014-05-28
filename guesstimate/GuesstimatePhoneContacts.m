//
//  GuesstimatePhoneContacts.m
//  guesstimate
//
//  Created by Eric Weaver on 5/20/14.
//  Copyright (c) 2014 First Step Dev. All rights reserved.
//

#import "GuesstimatePhoneContacts.h"
#import <AddressBook/AddressBook.h>
#import "GUesstimateUser.h"

@implementation GuesstimatePhoneContacts

+(NSArray *)getAllContacts {
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
        
        for (int i = 0; i < nPeople; i++)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name and Last Name
            
            NSString *name;
            NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            if(firstName == nil) {
                firstName = @"";
            }
            
            if(lastName == nil) {
                lastName = @"";
                name = firstName;
            } else {
                name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            }

            // get contacts picture, if pic doesn't exists, show standart one
            
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
            UIImage *contactImage = [UIImage imageWithData:imgData];
            
            if(contactImage == nil) {
                contactImage = [GuesstimateUser getDefaultPhoto];
            }
            
            NSDictionary *contactData = @{@"name":name, @"photoImage":contactImage};
            [items addObject:contactData];
            
            //get Phone Numbers
            
            /*NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
                
                //NSLog(@"All numbers %@", phoneNumbers);
                
            }
            
            
            //get Contact email
            
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                
                [contactEmails addObject:contactEmail];
                // NSLog(@"All emails are:%@", contactEmails);
                
            }*/
        }
        
        return items;
    } else {
        return @[];
    }
}


@end
