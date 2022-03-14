//
//  Album.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/22/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Album : NSObject

@property (nonatomic, copy, readonly) NSNumber * ID;
@property (nonatomic, copy, readonly) NSString *Title, *Poster, *Permalink;


- (id) initWithID: (NSNumber *)Id title: (NSString *) title poster: (NSString *) poster permalink: (NSString *) permalink;

@end
 /* Album_h */
