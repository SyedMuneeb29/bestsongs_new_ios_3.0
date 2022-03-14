//
//  LoginPopupViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/29/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "LoginPopupViewController.h"

@implementation LoginPopupViewController

UIDatePicker *datePicker;

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

- (void)loadData{
    datePicker = [[UIDatePicker alloc]init];
    
    [datePicker setDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate date]];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    // update the textfield with the date everytime it changes with selector defined below
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.txtRegisterBirthday setInputView:datePicker];
    
    [self.txtEmail setDelegate:self];
    [self.txtEmail.layer setBorderWidth:1.0];
    [self.txtEmail.layer setCornerRadius:20.0];
    [self.txtEmail.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.txtEmailForResetPassword setDelegate:self];
    [self.txtEmailForResetPassword.layer setBorderWidth:1.0];
    [self.txtEmailForResetPassword.layer setCornerRadius:20.0];
    [self.txtEmailForResetPassword.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    
    [self.txtPassword setDelegate:self];
    [self.txtPassword.layer setBorderWidth:1.0];
    [self.txtPassword.layer setCornerRadius:20.0];
    [self.txtPassword.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.resetPasswordBtn.layer setBorderWidth:1.0];
    [self.resetPasswordBtn.layer setCornerRadius:20.0];
    [self.resetPasswordBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.btnSendResetPasswordEmail.layer setBorderWidth:1.0];
    [self.btnSendResetPasswordEmail.layer setCornerRadius:20.0];
    [self.btnSendResetPasswordEmail.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.loginBtn.layer setBorderWidth:1.0];
    [self.loginBtn.layer setCornerRadius:20.0];
    [self.loginBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    
    [self.txtRegisterName setDelegate:self];
    [self.txtRegisterName.layer setBorderWidth:1.0];
    [self.txtRegisterName.layer setCornerRadius:20.0];
    [self.txtRegisterName.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.txtRegisterEmail setDelegate:self];
    [self.txtRegisterEmail.layer setBorderWidth:1.0];
    [self.txtRegisterEmail.layer setCornerRadius:20.0];
    [self.txtRegisterEmail.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.txtRegisterPassword setDelegate:self];
    [self.txtRegisterPassword.layer setBorderWidth:1.0];
    [self.txtRegisterPassword.layer setCornerRadius:20.0];
    [self.txtRegisterPassword.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.txtRegisterCellNo setDelegate:self];
    [self.txtRegisterCellNo.layer setBorderWidth:1.0];
    [self.txtRegisterCellNo.layer setCornerRadius:20.0];
    [self.txtRegisterCellNo.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.txtRegisterBirthday setDelegate:self];
    [self.txtRegisterBirthday.layer setBorderWidth:1.0];
    [self.txtRegisterBirthday.layer setCornerRadius:20.0];
    [self.txtRegisterBirthday.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.registerBtn.layer setBorderWidth:1.0];
    [self.registerBtn.layer setCornerRadius:20.0];
    [self.registerBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.loginView setHidden:NO];
    [self.registerView setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tap];
    
    self.ref = [[FIRDatabase database] reference];
}

- (void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.txtRegisterBirthday.inputView;
    self.txtRegisterBirthday.text = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}



- (void)dismissKeyboard {
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtRegisterName resignFirstResponder];
    [self.txtRegisterEmail resignFirstResponder];
    [self.txtRegisterPassword resignFirstResponder];
    [self.txtRegisterCellNo resignFirstResponder];
    [self.txtRegisterBirthday resignFirstResponder];
    [self.txtEmailForResetPassword resignFirstResponder];
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginRegisterSegment:(id)sender {
    [self dismissKeyboard];
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [self.loginView setHidden:NO];
        [self.registerView setHidden:YES];
        [self.resetView setHidden:YES];
    } else {
        [self.loginView setHidden:YES];
        [self.registerView setHidden:NO];
        [self.resetView setHidden:YES];
        [self.scrollView flashScrollIndicators];
    }
}

- (BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)loginBtn:(id)sender {
    [self dismissKeyboard];
    if(![self NSStringIsValidEmail:self.txtEmail.text]){
        [self.txtEmail shake:15
                   withDelta:15
                       speed:0.04
              shakeDirection:ShakeDirectionHorizontal completion:^{
                  [self.txtEmail.layer setBorderColor:[[UIColor redColor] CGColor]];
                  [[BaseController sharedInstance] showToastError:@"Enter valid email."];
              }];
        return;
    }
    [self.txtEmail.layer setBorderColor:[[UIColor greenColor] CGColor]];
    if([NSString stringWithFormat:@"%@",self.txtPassword.text].length <= 5){
        [self.txtPassword shake:15
                      withDelta:15
                          speed:0.04
                 shakeDirection:ShakeDirectionHorizontal completion:^{
                     [self.txtPassword.layer setBorderColor:[[UIColor redColor] CGColor]];
                     [[BaseController sharedInstance] showToastError:@"Password must be 6 character long."];
                 }];
        return;
    }
    [self.txtPassword.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    
    [self ShowLoading];
    
    [[FIRAuth auth]
     signInWithEmail:self.txtEmail.text
     password:self.txtPassword.text
     completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
         
         if(error){
             
             [self HideLoading];
             [[BaseController sharedInstance] showToastError:error.localizedDescription];
             
         } else {
             [[BaseController sharedInstance] getUserPlaylists:^(NSError *error, BOOL success) {
                 if(success){
                     [self HideLoading];
                     
                     
                     [[BestsongsAPI sharedInstance] fetchPlaylists:^(id response) {
                         
                         NSDictionary *dataDictionary = (NSDictionary *) response ;
                         NSMutableArray *playlistArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getPlaylistsArrayFromJSON:[dataDictionary objectForKey:@"playlists"]]];
                         
                         NSUInteger arrayLength = [playlistArray count];
                         
                         printf("%lu", (unsigned long)arrayLength);
                         
                         if (arrayLength > 0)
                         {
                             [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Imported"];
                         }
                         //                        else
                         //                        {
                         //
                         //                        }
                         
                     }
                                                         onFailure:^(NSError *error) {
                                                             
                                                             [self HideLoading];
                                                            // [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                             
                                                             
                                                         }];
                     
                     
                     [self.popupController dismissPopupControllerAnimated:YES];
                     if (self.didDismiss)
                         self.didDismiss(@"some extra data");
                 } else {
                     [self HideLoading];
                 //    [[BaseController sharedInstance] showToastError:@"Error Occured While Importing Playlists"];
                     [self.popupController dismissPopupControllerAnimated:YES];
                     if (self.didDismiss)
                         self.didDismiss(@"some extra data");
                 }
             }];
         }
         
         
     }] ;
    
    //
    //    [[FIRAuth auth]
    //     signInWithEmail:self.txtEmail.text
    //    password:self.txtPassword.text
    //    completion:^(FIRUser *user, NSError *error) {
    //        if(error){
    //            [self HideLoading];
    //
    //            [[BaseController sharedInstance] showToastError:error.localizedDescription];
    //        } else {
    //            [[BaseController sharedInstance] getUserPlaylists:^(NSError *error, BOOL success) {
    //                if(success){
    //                    [self HideLoading];
    //
    //
    //
    //                    [[BestsongsAPI sharedInstance] fetchPlaylists:^(id response) {
    //
    //                        NSDictionary *dataDictionary = (NSDictionary *) response;
    //                        NSMutableArray *playlistArray = [[NSMutableArray alloc] initWithArray:[[BestsongsAPI sharedInstance] getPlaylistsArrayFromJSON:[dataDictionary objectForKey:@"playlists"]]];
    //
    //                        NSUInteger arrayLength = [playlistArray count];
    //
    //
    //                        printf("%lu", (unsigned long)arrayLength);
    //
    //                        if (arrayLength > 0)
    //                        {
    //                                [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Imported"];
    //                        }
    ////                        else
    ////                        {
    ////
    ////                        }
    //
    //                    }
    //                    onFailure:^(NSError *error) {
    //                    }];
    //
    //
    //                    [self.popupController dismissPopupControllerAnimated:YES];
    //                    if (self.didDismiss)
    //                        self.didDismiss(@"some extra data");
    //                } else {
    //                    [self HideLoading];
    //                    [[BaseController sharedInstance] showToastError:@"Error Occured While Importing Playlists"];
    //                    [self.popupController dismissPopupControllerAnimated:YES];
    //                    if (self.didDismiss)
    //                        self.didDismiss(@"some extra data");
    //                }
    //            }];
    //        }
    //    }];
    //
    //
    
    
    
}

- (IBAction)registerBtn:(id)sender {
    [self dismissKeyboard];
    
    if([NSString stringWithFormat:@"%@",self.txtRegisterName.text].length <= 0){
        [self.txtRegisterName shake:15
                          withDelta:15
                              speed:0.04
                     shakeDirection:ShakeDirectionHorizontal completion:^{
                         [self.txtRegisterName.layer setBorderColor:[[UIColor redColor] CGColor]];
                         [[BaseController sharedInstance] showToastError:@"Enter your Name"];
                     }];
        return;
    }
    [self.txtRegisterName.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    if([NSString stringWithFormat:@"%@",self.txtRegisterEmail.text].length <= 0){
        [self.txtRegisterEmail shake:15
                           withDelta:15
                               speed:0.04
                      shakeDirection:ShakeDirectionHorizontal completion:^{
                          [self.txtRegisterEmail.layer setBorderColor:[[UIColor redColor] CGColor]];
                          [[BaseController sharedInstance] showToastError:@"Enter your email address"];
                      }];
        return;
    }
    
    if(![self NSStringIsValidEmail:self.txtRegisterEmail.text]){
        [self.txtRegisterEmail shake:15
                           withDelta:15
                               speed:0.04
                      shakeDirection:ShakeDirectionHorizontal completion:^{
                          [self.txtRegisterEmail.layer setBorderColor:[[UIColor redColor] CGColor]];
                          [[BaseController sharedInstance] showToastError:@"Enter valid email."];
                      }];
        return;
    }
    [self.txtRegisterEmail.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    if([NSString stringWithFormat:@"%@",self.txtRegisterPassword.text].length <= 5){
        [self.txtRegisterPassword shake:15
                              withDelta:15
                                  speed:0.04
                         shakeDirection:ShakeDirectionHorizontal completion:^{
                             [self.txtRegisterPassword.layer setBorderColor:[[UIColor redColor] CGColor]];
                             [[BaseController sharedInstance] showToastError:@"Password must be 6 character long."];
                         }];
        return;
    }
    [self.txtRegisterPassword.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    if([NSString stringWithFormat:@"%@",self.txtRegisterCellNo.text].length <= 0){
        [self.txtRegisterCellNo shake:15
                            withDelta:15
                                speed:0.04
                       shakeDirection:ShakeDirectionHorizontal completion:^{
                           [self.txtRegisterCellNo.layer setBorderColor:[[UIColor redColor] CGColor]];
                           [[BaseController sharedInstance] showToastError:@"Enter Your Cell No."];
                       }];
        return;
    }
    [self.txtRegisterCellNo.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    if([NSString stringWithFormat:@"%@",self.txtRegisterBirthday.text].length <= 0){
        [self.txtRegisterBirthday shake:15
                              withDelta:15
                                  speed:0.04
                         shakeDirection:ShakeDirectionHorizontal completion:^{
                             [self.txtRegisterBirthday.layer setBorderColor:[[UIColor redColor] CGColor]];
                             [[BaseController sharedInstance] showToastError:@"Provide Your Birthday."];
                         }];
        return;
    }
    [self.txtRegisterBirthday.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
    [self ShowLoading];
    
    
    [[FIRAuth auth]
     createUserWithEmail:self.txtRegisterEmail.text
     password:self.txtRegisterPassword.text
     completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
         
         if(error){
             [self HideLoading];
             if([error.localizedDescription isEqualToString:@"The email address is already in use by another account."]){
                 [[BaseController sharedInstance] showToastError:@"This email is already in use. Please try different email."];
             } else {
                 [[BaseController sharedInstance] showToastError:error.localizedDescription];
             }
         } else {
             
             FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
             changeRequest.displayName = self.txtRegisterName.text;
             [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                 NSString *gender = self.cmbGender.selectedSegmentIndex == 0 ? @"M" : @"F";
                 
                 NSString *dateString = self.txtRegisterBirthday.text;
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"dd MMMM yyyy"];
                 NSDate *date = [dateFormatter dateFromString:dateString];
                 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                 NSString *formattedDate = [dateFormatter stringFromDate:date];
                 
                 self.user = [[User alloc] initWithID:authResult.user.uid name:self.txtRegisterName.text email:authResult.user.email gender:gender dob:formattedDate phoneNo:self.txtRegisterCellNo.text phoneType:@"mobile" photoURL:[NSURL URLWithString:@""]];
                 
                 [[BestsongsAPI sharedInstance] createUser:self.user onSuccess:^(id response) {
                     [self HideLoading];
                     [[BaseController sharedInstance] showToastSuccess:@"Your Account Successfully Created"];
                     [self.popupController dismissPopupControllerAnimated:YES];
                     if (self.didDismiss)
                         self.didDismiss(@"some extra data");
                 } onFailure:^(NSError *error) {
                     [self HideLoading];
                     [[BaseController sharedInstance] showToastError:@"Error Occured While Creating Account.. Try Again"];
                 }];
             }];
         }
         
     }] ;
    
    
    //    [[FIRAuth auth]
    //     createUserWithEmail:self.txtRegisterEmail.text
    //     password:self.txtRegisterPassword.text
    //     completion:^(FIRUser *_Nullable user,
    //                  NSError *_Nullable error) {
    //         if(error){
    //             [self HideLoading];
    //             if([error.localizedDescription isEqualToString:@"The email address is already in use by another account."]){
    //                 [[BaseController sharedInstance] showToastError:@"This email is already in use. Please try different email."];
    //             } else {
    //                 [[BaseController sharedInstance] showToastError:error.localizedDescription];
    //             }
    //         } else {
    //
    //             FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
    //             changeRequest.displayName = self.txtRegisterName.text;
    //             [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
    //                 NSString *gender = self.cmbGender.selectedSegmentIndex == 0 ? @"M" : @"F";
    //
    //                 NSString *dateString = self.txtRegisterBirthday.text;
    //                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //                 [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    //                 NSDate *date = [dateFormatter dateFromString:dateString];
    //                 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //                 NSString *formattedDate = [dateFormatter stringFromDate:date];
    //
    //                 self.user = [[User alloc] initWithID:user.uid name:self.txtRegisterName.text email:user.email gender:gender dob:formattedDate phoneNo:self.txtRegisterCellNo.text phoneType:@"mobile" photoURL:[NSURL URLWithString:@""]];
    //
    //                 [[BestsongsAPI sharedInstance] createUser:self.user onSuccess:^(id response) {
    //                     [self HideLoading];
    //                     [[BaseController sharedInstance] showToastSuccess:@"Your Account Successfully Created"];
    //                     [self.popupController dismissPopupControllerAnimated:YES];
    //                     if (self.didDismiss)
    //                         self.didDismiss(@"some extra data");
    //                 } onFailure:^(NSError *error) {
    //                     [self HideLoading];
    //                     [[BaseController sharedInstance] showToastError:@"Error Occured While Creating Account.. Try Again"];
    //                 }];
    //             }];
    //         }
    //     }];
}

- (IBAction)closeBtn:(id)sender {
    [self dismissKeyboard];
    [self.popupController dismissPopupControllerAnimated:YES];
}

- (void)ShowLoading {
    [[BaseController sharedInstance] setupLoading];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD setRingThickness:7.0f];
    [SVProgressHUD setRingRadius:20];
    [SVProgressHUD setForegroundColor:[[UIColor alloc]initWithRed:182.0/255.0 green:0.0/255.0 blue:61.0/255.0 alpha:1.0]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
    [SVProgressHUD show];
}

- (void)HideLoading {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [SVProgressHUD dismiss];
}





- (IBAction)sendResetPasswordAtEmailId:(id)sender {
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    BOOL networkPresent = [AFNetworkReachabilityManager sharedManager].isReachable;
    
    if(networkPresent){
        
        
        
        if([self NSStringIsValidEmail:self.txtEmailForResetPassword.text]){
            
            NSString *emailTxtBoxText = self.txtEmailForResetPassword.text;
            
            
            [[FIRAuth auth] sendPasswordResetWithEmail:emailTxtBoxText completion:^(NSError * _Nullable error) {
                if (error == NULL){
                    
                    [[BaseController sharedInstance] showToastSuccess:@"Please check your inbox to reset password"];
                    
                }
                
            }];
            
            
            
        }
        else{
            
            
            [[BaseController sharedInstance] showToastError:@"Enter valid email."];
            
        }
        
        
        
        
    }
    
    else {
        
        [[BaseController sharedInstance] showToastError:@"You must connect ot Wi-fi or a Cellular Network to get online again."];
        
        
    }
    
    
}


- (IBAction)resetPassword:(id)sender {
    
    self.loginRegisterSegment.selectedSegmentIndex = -1;
    
    
    [self.loginView setHidden:YES];
    [self.registerView setHidden:YES];
    [self.resetView setHidden:NO];
    
    
    
    //    [[FIRAuth auth] sendPasswordResetWithEmail:@"muneeburrehman103@gmail.com" completion:nil];
    //
    
}
@end
