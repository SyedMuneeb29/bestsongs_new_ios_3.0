//
//  PlayerTableViewCell.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/28/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveCDMDownloadTask.h"
#import "NAKPlaybackIndicatorView.h"
//#import "M13ProgressViewImage.h"
#import "BaseController.h"

@protocol PlayerTableViewCellDelegate <NSObject>
@optional
- (void)jumpToMusicListVCWithCurrentIndex:(NSInteger)index;
@end

@interface PlayerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sNo;
//@property (weak, nonatomic) IBOutlet M13ProgressViewImage *progressView;
@property (weak, nonatomic) IBOutlet NAKPlaybackIndicatorView *musicIndicator;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UIButton *videoIcon;
@property (weak, nonatomic) IBOutlet UIButton *downloadIcon;
@property (weak, nonatomic) IBOutlet UIButton *playlistIcon;
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (nonatomic, weak) id<PlayerTableViewCellDelegate> delegate;
@property (nonatomic, assign) NAKPlaybackIndicatorViewState state;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ObjectiveCDMDownloadTask *currentTask;

- (void) displayProgressForDownloadTask:(ObjectiveCDMDownloadTask *)downloadTaskInfo;

@end

/* PlayerTableViewCell_h */
