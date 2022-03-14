//
//  LoginPopupViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/29/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNPPopupController.h"
#import <AFNetworking.h>
#import "BaseController.h"
#import "PlaylistDatabase.h"
#import "User.h"
#import "UITextField+Shake.h"
@import Firebase;
//@import FirebaseAuth;
//@import FirebaseDatabase;

@interface LoginPopupViewController : UIView <UITextFieldDelegate>

+ (instancetype)instantiateFromNib;

@property (nonatomic, copy) void (^didDismiss)(NSString *data);

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) User *user;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailForResetPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnSendResetPasswordEmail;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *resetView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *txtRegisterName;
@property (weak, nonatomic) IBOutlet UITextField *txtRegisterEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtRegisterPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtRegisterCellNo;
@property (weak, nonatomic) IBOutlet UITextField *txtRegisterBirthday;


@property (weak, nonatomic) IBOutlet UISegmentedControl *cmbGender;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *registerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *loginRegisterSegment;

-(void)loadData;

@end
