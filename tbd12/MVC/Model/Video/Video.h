//
//  Video.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 9/9/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, copy, readonly) NSNumber * ID;
@property (nonatomic, copy, readonly) NSString *Title, *VideoURL , *AlbumName, *Poster, *Permalink;
- (id)initWithID: (NSNumber *)Id title: (NSString *)title videoURL:(NSString *)videoURL albumName:(NSString *)albumName poster: (NSString *)poster permalink: (NSString *) permalink;

@end

/* Video_h */
