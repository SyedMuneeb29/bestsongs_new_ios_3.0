//
//  Banner.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/28/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "Banner.h"

@implementation Banner

- (id)initWithID:(NSNumber *)Id albumId:(NSNumber *)albumId title:(NSString *)title poster:(NSString *)poster year:(NSString *)year type:(NSString *)type videoURL:(NSString *)videoURL permalink:(NSString *)permalink{
    self = [super init];
    if(self){
        _ID = Id;
        _AlbumID = albumId;
        _Title = title;
        _Poster = poster;
        _Year = year;
        _Type = type;
        _VideoURL = videoURL;
        _Permalink = permalink;
    }
    return self;
}

@end
