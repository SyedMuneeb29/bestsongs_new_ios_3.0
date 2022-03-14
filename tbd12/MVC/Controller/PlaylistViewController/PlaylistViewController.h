//
//  PlaylistViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/6/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SWTableViewCell.h"
#import "PlaylistDatabase.h"
#import "PlaylistTableViewCell.h"
#import "SingleAlbumViewController.h"
#import "PlaylistNamePopupViewController.h"

@interface PlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate , SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *playlistTableView;
@property (weak, nonatomic) IBOutlet UIButton *createPlaylistButton;

@end
/* PlaylistViewController_h */
