//
//  Video.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 9/9/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "Video.h"

@implementation Video

- (id)initWithID:(NSNumber *)Id title:(NSString *)title videoURL:(NSString *)videoURL albumName:(NSString *)albumName poster:(NSString *)poster permalink:(NSString *)permalink{
    self = [super init];
    if(self){
        _ID = Id;
        _Title = title;
        _VideoURL = videoURL;
        _AlbumName = albumName;
        _Poster = poster;
        _Permalink = permalink;
    }
    return self;
}
@end
