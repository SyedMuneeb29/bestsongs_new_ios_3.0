//
//  AristAlbumsViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "Song.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "ArtistSongsViewController.h"
#import "PlayerViewController.h"
#import "SearchViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import LNPopupController;

@interface ArtistAlbumsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString * selectedAlphabet;
@property (strong, nonatomic) IBOutlet UITableView *TableView;

@end
