//
//  PlayListViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/28/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "Album.h"
#import "Video.h"
#import "BaseController.h"
#import "MMMaterialDesignSpinner.h"
#import "NAKPlaybackIndicatorView.h"
#import "PlayerTableViewCell.h"
#import "MusicIndicator.h"
#import "MusicSlider.h"
#import "PlayerViewControllerDelegate.h"
#import "AddToPlaylistViewController.h"
#import "AddToPlaylistViewControllerDelegate.h"
#import "STKAudioPlayer.h"
#import "QueueId.h"
#import "SingleAlbumViewController.h"
#import "ContentNotAvailableViewController.h"
#import <Crashlytics/Crashlytics.h>

@interface PlayerViewController : UIViewController <ObjectiveCDMUIDelegate, ObjectiveCDMDataDelegate, UITableViewDataSource, UITableViewDelegate , AddToPlaylistViewControllerDelegate>

//Poster Constraints

@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posterHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posterWidth;
@property (nonatomic, weak) id<PlayerViewControllerDelegate> delegate;

@property (nonatomic, strong) Playlist  *playlist;
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Song *selectedSong;

@property (nonatomic, strong) NSMutableArray * tracks;
@property (nonatomic) BOOL isRunFromDownload;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundPoster;
@property (weak, nonatomic) IBOutlet UITableView *songTableView;

// Views
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIView *groupView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;


// Poster Layer
@property (weak, nonatomic) IBOutlet UIView *posterLayer;

// -- Top Labels
@property (weak, nonatomic) IBOutlet UILabel *topSongName;
@property (weak, nonatomic) IBOutlet UILabel *topMovieName;

@property (nonatomic, strong) NSString *open_popup;


// -- Center
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;

@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *albumYear;

// Loader
@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *spinnerView;

// -- Player
@property (weak, nonatomic) IBOutlet UILabel *playHeadTime;
@property (weak, nonatomic) IBOutlet UILabel *playHeadDuration;
@property (weak, nonatomic) IBOutlet UIProgressView *bufferingBar;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;

// -- Previous , Play and Next Button
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *earPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;

// -- Watch Video , Share and Download Button
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watchShareDownloadHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *watchShareDownloadView;
@property (weak, nonatomic) IBOutlet UIButton *watchVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadMP3Btn;

@property (readwrite, retain) STKAudioPlayer* audioPlayer;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *posterView;
@property (weak, nonatomic) IBOutlet UIView *seekView;
@property (weak, nonatomic) IBOutlet UIView *playerButtonView;


+ (instancetype)sharedInstance;

- (void) retrieveData;
- (void) downPlayer;
- (void) playSelectedSong:(Song *)song;
- (void) next;
- (void) previous;
- (void) play;
- (void) pause;
- (void) stop;
- (void) updateControls;
@end

/* PlayListViewController_h */
