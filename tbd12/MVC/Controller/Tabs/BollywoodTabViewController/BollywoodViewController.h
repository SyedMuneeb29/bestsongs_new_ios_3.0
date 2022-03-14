//
//  BollywoodViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/25/16.
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
#import "BollywoodAlbumsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentNotAvailableViewController.h"
@import LNPopupController;

@interface BollywoodViewController : UIViewController

@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;


- (void)showNoInternetAlertMessag;
@property (weak, nonatomic) IBOutlet UICollectionView *alphabetCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UIView *connectionFailedMessage;


- (void)showShowOfflineAlert;
@end
/* BollywoodViewController_h */
