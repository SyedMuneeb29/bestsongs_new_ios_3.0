//
//  Banner.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/28/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject

@property (nonatomic, copy, readonly) NSNumber *ID , *AlbumID;
@property (nonatomic, copy, readonly) NSString *Title, *Poster, *Year, *Type, *VideoURL, *Permalink;

- (id)initWithID:(NSNumber *)Id albumId:(NSNumber *)albumId title:(NSString *)title poster:(NSString *)poster year:(NSString *)year type:(NSString *)type videoURL:(NSString *)videoURL permalink:(NSString *)permalink;

@end
