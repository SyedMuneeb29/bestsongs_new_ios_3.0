//
//  DownloadViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMaterialDesignSpinner.h"
#import "UIView+Toast.h"
#import "Song.h"
#import "Album.h"
#import "ObjectiveCDM.h"
#import <GoogleMediaFramework/GoogleMediaFramework.h>
#import <ZFPlayer/ZFPlayerView.h>
#import "View+MASAdditions.h"
#import <objc/runtime.h>

@interface DownloadViewController : UIViewController <ZFPlayerDelegate , ZFPlayerControlViewDelagate>

@property (nonatomic, copy) void (^didDismiss)(NSString *data);

@property (nonatomic, strong) GMFPlayerViewController *videoPlayer;
@property(nonatomic, strong) Album *album;
@property(nonatomic, strong) Song * song;
@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *spinner;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *advertisementLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomBar;

@end

/* DownloadViewController_h */
