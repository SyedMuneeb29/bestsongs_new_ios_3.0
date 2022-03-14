//
//  DiscoverMoreViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/29/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Song.h"
#import "Discover.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "CollectionViewCell.h"
#import "VideoViewController.h"
#import "PlayerViewController.h"
#import "SearchViewController.h"
#import "SingleAlbumViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ContentNotAvailableViewController.h"

@import LNPopupController;

@interface DiscoverMoreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)showNoInternetAlertMessag;



@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;
@property (weak, nonatomic) IBOutlet UIView *connectionFailedMessage;
@property (nonatomic, strong) Discover *discover;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

- (void)showShowOfflineAlert;
@end
