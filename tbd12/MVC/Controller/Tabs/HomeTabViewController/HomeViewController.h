//
//  HomeViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/22/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BestsongsAPI.h"
#import <AFNetworking.h>
#import <CRToast/CRToast.h>
#import "KIImagePager.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "CollectionViewCell.h"
#import "LoginViewController.h"
#import "VideoViewController.h"
#import "PlayerViewController.h"
#import "SearchViewController.h"
#import "SidebarViewController.h"
#import "MMMaterialDesignSpinner.h"
#import "SingleAlbumViewController.h"
#import "ShowDownloadsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentNotAvailableViewController.h"
#import <WebKit/WebKit.h>


@import LNPopupController;
@import Firebase;
//@import FirebaseMessaging;

@interface HomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;




@property (weak, nonatomic) IBOutlet UIView *couldNotConnectView;
@property (weak, nonatomic) IBOutlet UIButton *mainShowOfflineSongsBtn;
@property (weak, nonatomic) IBOutlet UIView *banners;


// Views
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *bollywoodView;
@property (weak, nonatomic) IBOutlet UIView *trailersView;
@property (weak, nonatomic) IBOutlet UIView *topVideosView;
@property (weak, nonatomic) IBOutlet UIView *artistView;
@property (weak, nonatomic) IBOutlet UIView *mashupView;
@property (weak, nonatomic) IBOutlet UIView *pakistaniView;
@property (weak, nonatomic) IBOutlet UIView *gupshupView;
@property (weak, nonatomic) IBOutlet UIView *regionalView;
@property (weak, nonatomic) IBOutlet UIView *weddingView;
@property (weak, nonatomic) IBOutlet UIView *evergreenView;

@property (weak, nonatomic) IBOutlet UIView *playlistView;
@property (weak, nonatomic) IBOutlet UIView *connectionFailedMessage;


// Views Height Constants
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bollywoodViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pakistaniViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailersViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVideosViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artistViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mashupViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weddingViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gupshupViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regionalViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evergreenViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playlistViewHeight;

// Collection View Controller
@property (weak, nonatomic) IBOutlet UICollectionView *bollywoodCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *pakistaniCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *trailersCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *topVideosCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *artistCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *mashupCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *weddingCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *gupshupCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *regionalCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *evergreenCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *playlistCollectionView;

// Collection View Height Constans
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bollywoodCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pakistaniCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailersCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topVideosCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artistCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mashupCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weddingCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gupshupCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regionalCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evergreenCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playlistCollectionViewHeight;



//  Score and video Ads View


@property (weak, nonatomic) IBOutlet WKWebView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *videoAdsView;
@property (weak, nonatomic) IBOutlet UIImageView *videoAdsVolumeImageButton;

@property (weak, nonatomic) IBOutlet UIView *videoAdsControlView;



// View more

@property (weak, nonatomic) IBOutlet UILabel *bollywoodViewMore;

@property (weak, nonatomic) IBOutlet UILabel *trailersViewMore;
@property (weak, nonatomic) IBOutlet UILabel *topVideosViewMore;

@property (weak, nonatomic) IBOutlet UILabel *artistsViewMore;
@property (weak, nonatomic) IBOutlet UILabel *mashupsViewMore;

@property (weak, nonatomic) IBOutlet UILabel *pakistaniViewMore;
@property (weak, nonatomic) IBOutlet UILabel *gupshupsViewMore;


@property (weak, nonatomic) IBOutlet UILabel *regionalViewMore;
@property (weak, nonatomic) IBOutlet UILabel *weddingViewMore;

@property (weak, nonatomic) IBOutlet UILabel *evergreenViewMore;
@property (weak, nonatomic) IBOutlet UILabel *playlistsViewMore;




- (void)showShowOfflineAlert;
- (void)showNoInternetAlertMessag;
- (BOOL)connected;

@end
