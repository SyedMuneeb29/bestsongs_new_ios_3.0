//
//  AddToPlaylistPopupViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/7/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Song.h"
#import "DBManager.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "PlaylistDatabase.h"
#import "CNPPopupController.h"
#import "BestsongsAPI.h"

@interface AddToPlaylistPopupViewController : UIView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

+ (instancetype)instantiateFromNib;

@property(nonatomic, strong) Album *album;
@property(nonatomic, strong) Song * song;

@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet UIView *createPlaylistButtonView;
@property (weak, nonatomic) IBOutlet UIView *showPlaylistView;
@property (weak, nonatomic) IBOutlet UIView *createPlaylistView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


-(void)loadData;

@end

/* AddToPlaylistPopupViewController_h */
