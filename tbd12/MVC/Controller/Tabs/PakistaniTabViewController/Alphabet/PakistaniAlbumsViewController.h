//
//  PakistaniAlbumsViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Song.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SVPullToRefresh.h"
#import "PlayerViewController.h"
#import "SearchViewController.h"
#import "SingleAlbumViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScrollView+SVInfiniteScrolling.h"
@import LNPopupController;

@interface PakistaniAlbumsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString * selectedAlphabet;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@end
