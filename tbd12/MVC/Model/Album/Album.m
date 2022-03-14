//
//  Album.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/22/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id) initWithID:(NSNumber *)Id title:(NSString *)title poster:(NSString *)poster permalink:(NSString *)permalink{
    self = [super init];
    if(self){
        _ID = Id;
        _Title = title;
        _Poster = poster;
        _Permalink = permalink;
    }
    return self;
}

@end
