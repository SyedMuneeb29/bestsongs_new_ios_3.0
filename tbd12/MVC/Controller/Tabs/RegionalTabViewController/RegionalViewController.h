//
//  RegionalViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 8/30/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Song.h"
#import "BaseController.h"
#import "SearchViewController.h"
#import "PlayerViewController.h"
#import "RegionalTableViewCell.h"
#import "DiscoverMoreViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import LNPopupController;

@interface RegionalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)openDownload;
- (void)showNoInternetAlertMessag;
- (void)showShowOfflineAlert;

@end

/* RegionalViewController_h */
