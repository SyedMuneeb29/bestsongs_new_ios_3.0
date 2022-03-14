//
//  PlaylistNamePopupViewController.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 4/22/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "PlaylistNamePopupViewController.h"

@interface PlaylistNamePopupViewController (){
    PlaylistDatabase *playlistDB;
}

@end

@implementation PlaylistNamePopupViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

- (void)loadData {
    [self.saveBtn.layer setBorderWidth:1.0];
    [self.saveBtn.layer setCornerRadius:20.0];
    [self.saveBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.playlistName.layer setBorderWidth:1.0];
    [self.playlistName.layer setCornerRadius:20.0];
    [self.playlistName.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.cancelBtn.layer setBorderWidth:1.0];
    [self.cancelBtn.layer setCornerRadius:20.0];
    [self.cancelBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    self.playlistName.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tap];
    
    playlistDB = [[PlaylistDatabase alloc]init];
    [playlistDB loadDatabase];

}

- (void)dismissKeyboard {
    [self.playlistName resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveBtnClick:(id)sender {
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    [self dismissKeyboard];
    NSString *title = self.playlistName.text;
    [[BaseController sharedInstance] setupLoading];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    int screenSize =(int)[[UIScreen mainScreen] nativeBounds].size.height / 36 ;
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, (CGFloat)screenSize )];
    [SVProgressHUD show];
    playlistDB = [[PlaylistDatabase alloc] init];
    [playlistDB loadDatabase];
    Playlist *playlist = [[Playlist alloc] initWithID:0 bestsongID:0 totalTracks:0 currentRevision:0 title:title];
    [playlistDB createPlaylist:playlist onSuccess:^(id response) {
        [SVProgressHUD dismiss];
        [[BaseController sharedInstance] showToastSuccess:@"Playlist Successfully Created."];
        [self.popupController dismissPopupControllerAnimated:YES];
    } onFailure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[BaseController sharedInstance] showToastError:error.localizedDescription];
    }];
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissKeyboard];
    [self.popupController dismissPopupControllerAnimated:YES];
    
}

- (IBAction)popupCloseButton:(id)sender {
    [self dismissKeyboard];
    [self.popupController dismissPopupControllerAnimated:YES];
}


@end
