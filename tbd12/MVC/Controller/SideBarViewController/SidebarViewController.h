//
//  SidebarViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/5/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pages.h"
#import "PlaylistViewController.h"
#import "ShowDownloadsViewController.h"
#import "RefreshApp.h"
#import "BaseController.h"
#import "LoginViewController.h"
#import "OtherPagesViewController.h"
@import Firebase;
//@import FirebaseAuth;

@interface SidebarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;

// Menu Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (nonatomic, strong) NSMutableArray * menusArray;
@property (weak, nonatomic) IBOutlet UITableView *TableView;


@property (weak, nonatomic) IBOutlet UIButton *playlistBtn;
@property (weak, nonatomic) IBOutlet UIButton *showAllDownloadsBtn;
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareThisAppBtn;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


@end

/* SidebarViewController_h */
