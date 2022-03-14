//
//  PlaylistViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/4/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPPopupController.h"
#import "Album.h"
#import "Song.h"
#import "BaseController.h"
#import "PlaylistDatabase.h"
#import "PlayerViewController.h"
#import "ParallaxViewController.h"
#import "VideoViewController.h"
#import "DownloadViewController.h"
#import "LoginViewController.h"
#import "ShowDownloadsViewController.h"
#import "TabbarViewController.h"
#import "AddToPlaylistPopupViewController.h"
#import "AddToPlaylistViewControllerDelegate.h"
// For Toast Notification
#import "UIView+Toast.h"
@import LNPopupController;

@interface AddToPlaylistViewController : UIView <UITableViewDataSource, UITableViewDelegate>
+ (instancetype)instantiateFromNib;

@property (nonatomic, weak) id<AddToPlaylistViewControllerDelegate> delegate;
    
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property(nonatomic, strong) Album *album;
@property(nonatomic, strong) Song * song;

@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundPoster;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *movieName;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong, readwrite) Playlist *playlist;
    
-(void)loadView;
@end

/* PlaylistViewController_h */
