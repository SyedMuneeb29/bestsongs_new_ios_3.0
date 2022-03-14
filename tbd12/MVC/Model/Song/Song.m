//
//  Song.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/29/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "Song.h"

@implementation Song

- (id)initWithID:(NSNumber *)Id albumId:(NSNumber *)albumId likes:(NSNumber *)likes title:(NSString *)title albumTitle:(NSString *)albumTitle poster:(NSString *)poster permalink:(NSString *)permalink audioURL:(NSString *)audioURL videoURL:(NSString *)videoURL videoPermalink:(NSString *)videoPermalink isDowload:(BOOL)isDownload isVideo:(BOOL)isVideo isLikes:(BOOL)isLiked{
    self = [super init];
    if(self){
        _ID = Id;
        _AlbumID = albumId;
        _Likes = likes;
        _Title = title;
        _AlbumTitle = albumTitle;
        _Poster = poster;
        _Permalink = permalink;
        _AudioURL = audioURL;
        _VideoURL = videoURL;
        _VideoPermalink = videoPermalink;
        _IsDownload = isDownload;
        _IsVideo = isVideo;
        _IsLiked = isLiked;
    }
    return self;
}

@end
