//
//  PakistaniViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Song.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "CollectionViewCell.h"
#import "SearchViewController.h"
#import "PlayerViewController.h"
#import "SingleAlbumViewController.h"
#import "AlphabetCollectionViewCell.h"
#import "PakistaniAlbumsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentNotAvailableViewController.h"
@import LNPopupController;

@interface PakistaniViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)showNoInternetAlertMessag;


@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;

@property (weak, nonatomic) IBOutlet UIView *connectionFailedMessage;
@property (weak, nonatomic) IBOutlet UICollectionView *alphabetCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

- (void)showShowOfflineAlert;

@end

/* PakistaniViewController_h */
