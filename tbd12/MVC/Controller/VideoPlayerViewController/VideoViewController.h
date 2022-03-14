//
//  VideoViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/26/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

//#import <GoogleAds-IMA-iOS-SDK/GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>
@import GoogleInteractiveMediaAds;
#import <UIKit/UIKit.h>
#import "MMMaterialDesignSpinner.h"
#import "UIView+Toast.h"
#import "BaseController.h"
#import "BestsongsAPI.h"
#import <AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ZFPlayer/ZFPlayerView.h>
#import "PlayerViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "ContentNotAvailableViewController.h"
#import "tbd12-Swift.h"
@class SwiftClass;


@interface VideoViewController : UIViewController <VideoCollectionViewDelegate,ZFPlayerDelegate , ZFPlayerControlViewDelagate>

@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;


@property(nonatomic,strong) Video *video;


@property(nonatomic,strong) NSString *type;

@property (nonatomic, assign) BOOL isAlreadyPlay;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *spinner;

@property (weak, nonatomic) IBOutlet UILabel *trailerName;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPoster;
@property (strong, nonatomic) IBOutlet ZFPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *dislikes;
@property (weak, nonatomic) IBOutlet UIView *videoCollectionsView;



@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@property (weak, nonatomic) IBOutlet UIView *adsView;

@property (weak, nonatomic) IBOutlet UIView *adsContainerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailerNameTopConstraint;


- (void)retrieveData;
- (void)dismissController;
@end

/* VideoViewController_h */
