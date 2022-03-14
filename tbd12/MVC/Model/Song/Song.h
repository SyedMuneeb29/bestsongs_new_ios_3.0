//
//  Song.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/29/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, copy, readonly) NSNumber * ID , *AlbumID , *Likes;
@property (nonatomic, copy, readonly) NSString *Title, *AlbumTitle, *Poster, *Permalink, *AudioURL, *VideoURL, *VideoPermalink;
@property (nonatomic, assign, readonly) BOOL IsDownload , IsVideo , IsLiked;

- (id)initWithID:(NSNumber *)Id albumId: (NSNumber *)albumId likes:(NSNumber *)likes title:(NSString *)title albumTitle:(NSString *)albumTitle poster:(NSString *)poster permalink:(NSString *)permalink audioURL:(NSString *)audioURL videoURL:(NSString *)videoURL videoPermalink:(NSString *)videoPermalink isDowload:(BOOL)isDownload isVideo:(BOOL)isVideo isLikes:(BOOL)isLiked;

@end

/* Song_h */
