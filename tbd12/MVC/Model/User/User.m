//
//  User.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/27/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithID:(NSString *)userID andName:(NSString *)name andEmail:(NSString *)email andGender:(NSString *)gender andPhotoURL:(NSURL *)photoURL {
    self = [super init];
    if(self){
        _UserID = userID;
        _Name = name;
        _Email = email;
        _Gender = gender;
        _PhotoURL = photoURL;
    }
    return self;
}

- (id)initWithID:(NSString *)userID name:(NSString *)name email:(NSString *)email gender:(NSString *)gender dob:(NSString *)dob phoneNo:(NSString *)phoneNo phoneType:(NSString *)phoneType photoURL:(NSURL *)photoURL{
    self = [super init];
    if(self){
        _UserID = userID;
        _Name = name;
        _Email = email;
        _Gender = gender;
        _DOB = dob;
        _PhoneNo = phoneNo;
        _PhoneType = phoneType;
        _PhotoURL = photoURL;
    }
    return self;
}

@end
