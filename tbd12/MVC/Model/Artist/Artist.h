//
//  Artist.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/23/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject

@property (nonatomic, copy, readonly) NSNumber * ID;
@property (nonatomic, copy, readonly) NSString *Name, *Poster;

- (id) initWithID: (NSNumber *)Id name: (NSString *) name poster: (NSString *) poster;

@end
