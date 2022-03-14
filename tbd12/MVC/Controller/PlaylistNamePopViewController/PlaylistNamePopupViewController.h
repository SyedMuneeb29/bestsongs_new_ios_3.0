//
//  PlaylistNamePopupViewController.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 4/22/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "BaseController.h"
#import "PlaylistDatabase.h"
#import "CNPPopupController.h"
#import "BestsongsAPI.h"

@interface PlaylistNamePopupViewController : UIView <UITextFieldDelegate>

+ (instancetype)instantiateFromNib;

@property (nonatomic, strong) CNPPopupController *popupController;

@property (weak, nonatomic) IBOutlet UITextField *playlistName;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (void)loadData;

@end
