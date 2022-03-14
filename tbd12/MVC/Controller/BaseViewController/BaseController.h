//
//  BaseController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/27/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CRToast/CRToast.h>
#import <FFToast/FFToast.h>
#import <Foundation/Foundation.h>
#import "Banner.h"
#import "User.h"
#import "Album.h"
#import "Artist.h"
#import "Song.h"
#import "Video.h"
#import "Discover.h"
#import "Constants.h"
#import "CNPPopupController.h"
#import "PlaylistDatabase.h"
#import "SVProgressHUD.h"
#import "DownloadViewController.h"
#import "PlayerViewControllerDelegate.h"
@import Firebase;
//@import FirebaseAuth;
//@import FirebaseCrash;

@interface BaseController : NSObject

+ (BaseController *)sharedInstance;

- (BOOL)checkIsUserLogin;
- (BOOL)checkIsUserDownloadAnySong;
- (User *)getLoginUserDetail;
- (void)registerNewUser:(User *)user andFirebaseUser:(FIRUser *)firebaseUser callback:(void (^)(NSError *error, BOOL success))callback;
- (void)getUserPlaylists:(void (^)(NSError *error, BOOL success))callback;
- (UIView *)getNavigationbar:(NSString *)title;
- (UIView *)getNavigationbar:(UINavigationController *)navController andTitle:(NSString *)title andTotalButtons:(int)totalButtons;
- (UIView *)getTableViewFooterView;
- (CALayer *)setViewBottomBorder:(CGFloat)height;



- (void)openAudioPlayer:(UIStoryboard *)storyboard tabbarController:(UITabBarController *)tabbarController album:(Album *)album selectedTrack:(Song *)selectedTrack tracks:(NSMutableArray *)tracks playlist:(Playlist *)playlist isRunFromDownload:(BOOL)isRunFromDownload delegate:(id<PlayerViewControllerDelegate>) delegate;

- (DownloadViewController *)downloadMP3:(UIStoryboard *)storyboard song:(Song *)song rootViewController:(UIViewController *)rootViewController;
- (void)openVideoPlayer:(UIStoryboard *)storyboard andVideo:(Video *)video andRootViewController:(UIViewController *)rootViewController;
- (void)openVideoPlayerWithType:(UIStoryboard *)storyboard andVideo:(Video *)video andRootViewController:(UIViewController *)rootViewController andType:(NSString *)type;

- (NSMutableArray *)getSongsArrayFromJSON: (NSDictionary *)songsArray;

- (void)showToastSuccess:(NSString *)text;
- (void)showToastError:(NSString *)text;
- (void)popup_open:(UIStoryboard *)storyboard tabbarController:(UITabBarController *)tabbarController;

- (CNPPopupTheme *)cnPopupDefaultTheme;
- (void)setupLoading;
- (UIColor *)getDefaultColor;
- (UIColor *)getDefaultBackgroundColor;
- (NSString *)getCurrentFormattedDateTime;
- (NSString *)getCurrentTimeUniqueID;
- (CGFloat)getLabelHeight:(UILabel*)label;

// Event Received For Audio
- (UITabBarController *)getCurrentTabbarController;
- (void) remoteControlReceivedWithEvent: (UIEvent *) event;

- (UIColor *)getErrorTextMessageColor;
- (UIColor *)getSuccessTextMessageColor;

- (UIColor *)getErrorMessageBackgroundColor;
- (UIColor *)getSuccessMessageBackgroundColor;


@end
