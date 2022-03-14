//
//  MashupViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "Album.h"
#import "Song.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "CollectionViewCell.h"
#import "SearchViewController.h"
#import "PlayerViewController.h"
#import "SingleAlbumViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentNotAvailableViewController.h"

@import LNPopupController;

@interface MashupViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;


- (void)showNoInternetAlertMessag;



@property (weak, nonatomic) IBOutlet UIView *connectionFailedMessage;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

- (void)showShowOfflineAlert;
@end

/* MashupViewController_h */
