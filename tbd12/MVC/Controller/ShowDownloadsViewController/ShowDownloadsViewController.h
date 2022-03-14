//
//  ShowDownloadsViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/3/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveCDM.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "SWTableViewCell.h"
#import "PlayerViewController.h"
@import AVFoundation;
@import MediaPlayer;

@interface ShowDownloadsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate ,PlayerViewControllerDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *downloadTableView;
@end
