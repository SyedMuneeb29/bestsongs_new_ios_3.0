//
//  MyMusicViewController.m
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 11/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//

#import "MyMusicViewController.h"

@interface MyMusicViewController ()

@end

@implementation MyMusicViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated] ;
    
   
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _playlistBtn.layer.cornerRadius = 50 ;
    _playlistBtn.layer.borderColor =  UIColor.lightGrayColor.CGColor ;
    _playlistBtn.layer.borderWidth = 2 ;
    
    
    _downloadsBtn.layer.cornerRadius = 50 ;
    _downloadsBtn.layer.borderColor =  UIColor.lightGrayColor.CGColor ; //UIColor.redColor.CGColor ;
    _downloadsBtn.layer.borderWidth = 2 ;
    
    
    
    self.navigationController.navigationBar.barTintColor = UIColor.blackColor ;
    self.navigationItem.title = @"My Music" ;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
}


- (IBAction)playlistBtnClicked:(id)sender {
    
    
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    
    PlaylistViewController *playlistController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistViewController"];
    
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
   
       
        if([[BaseController sharedInstance] checkIsUserLogin]){
          
            [self.navigationController pushViewController:playlistController animated:YES];
            
            
            
        }else {
            
            loginViewController.modalInPopover = YES;
            loginViewController.hidesBottomBarWhenPushed = YES;
            loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            UINavigationController *navController = [[UINavigationController alloc] init];
            [navController setNavigationBarHidden:YES animated:NO];
            [navController pushViewController:loginViewController animated:NO];
            [self presentViewController:navController animated:YES completion:nil];
            
        }

    
  
    

   
    
}
- (IBAction)downloadBtnClicked:(id)sender {
//
//    if(![AFNetworkReachabilityManager sharedManager].isReachable){
//        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
//        return;
//    }
    
    ShowDownloadsViewController *showDownloadsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];

        [self.navigationController pushViewController:showDownloadsController animated:NO];
  
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
