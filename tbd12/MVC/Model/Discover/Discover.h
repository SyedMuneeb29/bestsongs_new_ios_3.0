//
//  Discover.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/25/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discover : NSObject

@property (nonatomic, copy, readonly) NSNumber * ID;
@property (nonatomic, copy, readonly) NSString *Title, *Permalink;

- (id) initWithID: (NSNumber *) Id title: (NSString *) title permalink: (NSString *)permalink;
@end

/* Discover_h */
