//
//  SingleAlbumViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 12/5/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import "Song.h"
#import "Album.h"
#import "Video.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "BestsongsAPI.h"
#import "PlayerViewController.h"
#import "ParallaxViewController.h"
#import "PlayerTableViewCell.h"
#import "VideoViewController.h"
#import "DownloadViewController.h"
#import "HomeViewController.h"
#import "SingleAlbumViewController.h"
#import "AddToPlaylistViewController.h"
#import "CNPPopupController.h"
#import "LoginViewController.h"
#import "UIView+Toast.h"
#import "PlaylistDatabase.h"
#import "SearchViewController.h"

#import "ObjectiveCDM.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "PlaylistNamePopupViewController.h"
#import "ContentNotAvailableViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "AddToPlaylistViewControllerDelegate.h"




@import LNPopupController;
@import UIKit;

@interface SingleAlbumViewController : UIViewController <ObjectiveCDMUIDelegate, ObjectiveCDMDataDelegate, UITableViewDataSource, UITableViewDelegate , PlayerViewControllerDelegate , PlayerTableViewCellDelegate , AddToPlaylistViewControllerDelegate>


@property (nonatomic, strong) NSString *playlistImageFromServer;

@property (nonatomic, strong) Playlist *playlist;

@property (nonatomic, strong) NSURL *playlistCoverURLFromApiOfAds;

@property (nonatomic, strong) NSURL *uRLOfApiForCoverOfPlaylistImage ;

@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Song *selectedSong;

@property (weak, nonatomic) IBOutlet UITableView *songTableView;



@property (nonatomic, strong) PlaylistNamePopupViewController *addToPlayListPopupViewController;
@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;


- (void) playSharingSong;
- (void) retrieveData;
@end
