//
//  LoginViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/15/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CNPPopupController.h"
#import "BaseController.h"
#import "LoginPopupViewController.h"
#import "BaseController.h"
#import "SVProgressHUD.h"
#import "PlaylistDatabase.h"
#import "User.h"
#import "ContentNotAvailableViewController.h"
@import Firebase;
//@import FirebaseAuth;
//@import FirebaseStorage;
@import GoogleSignIn;
@import TwitterKit;

@interface LoginViewController : UIViewController <CNPPopupControllerDelegate , GIDSignInDelegate, GIDSignInUIDelegate>


@property (nonatomic, strong) ContentNotAvailableViewController *addToContentNotAvailablePopupViewController;

@property (nonatomic, copy) void (^didDismiss)(NSString *data);

@property (weak, nonatomic) IBOutlet UIView *skipButtonView;
@property (weak, nonatomic) IBOutlet UIStackView *sharingStackView;

@property (nonatomic, strong) FIRStorage *storage;
@property (nonatomic, strong) FIRStorageReference *storageRef;
@property (nonatomic, strong) User *user;

@property (nonatomic, assign) BOOL IsVideo , IsAlbum;
@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) Song *song;
@property (nonatomic, strong) UIViewController *rootViewController;

@property (weak, nonatomic) IBOutlet UIView *twitterView;

@property (weak, nonatomic) IBOutlet UIButton *facebookSigninButton;
@property (weak, nonatomic) IBOutlet UIButton *googleSigninButton;
@property (weak, nonatomic) IBOutlet UIButton *bestsongSigninButton;




@end
