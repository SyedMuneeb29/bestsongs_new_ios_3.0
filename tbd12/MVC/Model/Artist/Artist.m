//
//  Artist.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/23/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "Artist.h"

@implementation Artist

- (id) initWithID:(NSNumber *)Id name:(NSString *)name poster:(NSString *)poster{
    self = [super init];
    if(self){
        _ID = Id;
        _Name = name;
        _Poster = poster;
    }
    return self;
}

@end
