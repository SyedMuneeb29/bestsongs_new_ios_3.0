//
//  Discover.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/25/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "Discover.h"

@implementation Discover

- (id)initWithID:(NSNumber *)Id title:(NSString *)title permalink:(NSString *)permalink{
    self = [super init];
    if(self){
        _ID = Id;
        _Title = title;
        _Permalink = permalink;
    }
    return self;
}

@end
