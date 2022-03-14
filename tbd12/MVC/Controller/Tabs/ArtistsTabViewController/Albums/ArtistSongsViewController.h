//
//  ArtistSongsViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 9/7/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "SearchViewController.h"
#import "PlayerViewController.h"
#import "ParallaxViewController.h"
#import "SingleAlbumViewController.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import LNPopupController;
@import UIKit;

@interface ArtistSongsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Artist *artist;
@property (weak, nonatomic) IBOutlet UITableView *TableView;

@end
/* ArtistSongsViewController_h */
