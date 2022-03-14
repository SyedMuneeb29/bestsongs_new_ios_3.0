//
//  SearchViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/27/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Album.h"
#import "Song.h"
#import "BaseController.h"
#import "SearchTableViewCell.h"
#import "PlayerViewController.h"
#import "ArtistSongsViewController.h"
#import "SingleAlbumViewController.h"
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
@import LNPopupController;

@interface SearchViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (retain, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@end
