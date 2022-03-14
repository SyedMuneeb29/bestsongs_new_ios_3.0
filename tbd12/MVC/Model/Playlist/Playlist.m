//
//  Playlist.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 3/6/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

- (id)initWithID:(NSNumber *)Id bestsongID:(NSNumber *)bestsongID totalTracks:(NSNumber *)totalTracks currentRevision:(NSNumber *)currentRevision title:(NSString *)title{
    self = [super init];
    if(self){
        _ID = Id;
        _BestsongID = bestsongID;
        _TotalTracks = totalTracks;
        _CurrentRevision = currentRevision;
        _Title = title;
    }
    return self;
}

@end
