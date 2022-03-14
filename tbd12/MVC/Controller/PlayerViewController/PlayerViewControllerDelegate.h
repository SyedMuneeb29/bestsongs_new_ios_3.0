//
//  PlayerViewControllerDelegate.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/10/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

@protocol PlayerViewControllerDelegate <NSObject>
@optional
- (void)updatePlaybackIndicatorOfVisisbleCells;
- (void)likeTrackFromPlayer:(NSNumber *)trackID;
- (void)unLikeTrackFromPlayer:(NSNumber *)trackID;
@end

/* PlayerViewControllerDelegate_h */
