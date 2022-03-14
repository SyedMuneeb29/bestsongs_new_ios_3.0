//
//  Playlist.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 3/6/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property (nonatomic, copy, readonly) NSNumber * ID , * BestsongID , *TotalTracks , *CurrentRevision;
@property (nonatomic, copy, readonly) NSString *Title;

- (id) initWithID: (NSNumber *)Id bestsongID:(NSNumber *)bestsongID totalTracks: (NSNumber *)totalTracks currentRevision: (NSNumber *)currentRevision title: (NSString *) title;

@end
