//
//  AddToPlaylistViewControllerDelegate.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 3/7/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddToPlaylistViewControllerDelegate <NSObject>
@optional
- (void)updateTableview;
- (void)deleteTrackFromPlaylist: (NSNumber *)trackID;
- (void)likeTrack:(NSNumber *)trackID;
- (void)unLikeTrack:(NSNumber *)trackID;
@end
