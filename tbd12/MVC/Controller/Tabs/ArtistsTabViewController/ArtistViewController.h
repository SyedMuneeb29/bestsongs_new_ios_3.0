//
//  ArtistViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/25/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "CollectionViewCell.h"
#import "SearchViewController.h"
#import "PlayerViewController.h"
#import "ArtistSongsViewController.h"
#import "AlphabetCollectionViewCell.h"
#import "ArtistAlbumsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentNotAvailableViewController.h"
@import LNPopupController;

@interface ArtistViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;

- (void)showNoInternetAlertMessag;
@property (weak, nonatomic) IBOutlet UICollectionView *alphabetCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UIView *connectionFailedMessage;


- (void)showShowOfflineAlert;

@end

/* ArtistViewController_h */
