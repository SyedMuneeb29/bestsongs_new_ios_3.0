//
//  User.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/27/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//@property (nonatomic, copy, readonly) NSNumber * ID;
@property (nonatomic, copy, readonly) NSString *UserID, *Name, *Email, *Gender, *DOB, *PhoneNo, *PhoneType;
@property (nonatomic, copy, readonly) NSURL *PhotoURL;


- (id) initWithID: (NSString *) userID andName: (NSString *) name andEmail: (NSString *) email andGender: (NSString *)gender andPhotoURL: (NSURL *) photoURL;

- (id) initWithID: (NSString *)userID name: (NSString *) name email: (NSString *) email gender: (NSString *) gender dob : (NSString *)dob phoneNo : (NSString *)phoneNo phoneType : (NSString *)phoneType photoURL : (NSURL *)photoURL;

@end
