//
//  SidebarViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/5/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "SidebarViewController.h"

@interface SidebarViewController ()
@end

@implementation SidebarViewController

@synthesize userImage, userName, userEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*self.menusArray = [[NSMutableArray alloc] initWithObjects:@"My Playlists",@"Show all my Downloads",@"My Reward Points",@"Gift Shop",@"How to Earn Points",@"Rate App",@"Share App",@"About Us",@"Contact Us",@"Terms and Conditions",@"Privacy Policy",@"Rewards Point Terms and Conditions",nil];
    */
    self.menusArray = [[NSMutableArray alloc] initWithObjects:@"My Playlists",@"My Offline Songs",@"My Reward Points",@"Gift Shop",@"How to Earn Points",@"Share App",@"Rate App",@"About Us",@"Contact Us",@"Terms and Conditions",@"Privacy Policy",@"Reward Points Terms and Conditions",nil];
    
    [self.TableView setSeparatorColor:[[UIColor alloc]initWithRed:35.0/255.0 green:35.0/255.0 blue:35.0/255.0 alpha:1.0]];
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.TableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    self.userImage.layer.cornerRadius = 96 / 2;
    self.userImage.clipsToBounds = YES;
    
    self.userImage.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.userImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userImage.layer.shadowRadius = 6.0;
    self.userImage.layer.shadowOpacity = 1.0;
    
    [self.loginBtn.layer setBorderWidth:1.0];
    [self.loginBtn.layer setCornerRadius:15.0];
    [self.loginBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    UIEdgeInsets btnPadding = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
    
    self.playlistBtn.titleEdgeInsets = btnPadding;
    self.showAllDownloadsBtn.titleEdgeInsets = btnPadding;
    self.rewardBtn.titleEdgeInsets = btnPadding;
    self.aboutBtn.titleEdgeInsets = btnPadding;
    self.settingBtn.titleEdgeInsets = btnPadding;
    self.shareThisAppBtn.titleEdgeInsets = btnPadding;
    self.logoutBtn.titleEdgeInsets = btnPadding;
    
    [self.TableView setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];
    
    [self setLoginData];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];

    
}

- (void)setLoginData{
    if(![[BaseController sharedInstance] checkIsUserLogin]){
        for (int i=0;i<[self.menusArray count]; i++) {
            NSString *item = [self.menusArray objectAtIndex:i];
            if ([item rangeOfString:@"Logout"].location != NSNotFound) {
                [self.menusArray removeObject:item];
                i--;
            }
        }
        [self.TableView reloadData];
        self.userImage.image = [UIImage imageNamed:@"profile.png"];
        [self.loginBtn setHidden:NO];
        [self.logoutBtn setHidden:YES];
        [self.userName setHidden:YES];
        [self.userEmail setHidden:YES];
        return;
    }
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        [self.menusArray addObject:@"Logout"];
        [self.TableView reloadData];
        
        [self.logoutBtn setHidden:NO];
        [self.loginBtn setHidden:YES];
        [self.userName setText: user.displayName];
        [self.userEmail setText:user.email];
        [self.userName setHidden:NO];
        [self.userEmail setHidden:NO];
        NSURL *photoUrl = user.photoURL;
        if(photoUrl == nil)
            self.userImage.image = [UIImage imageNamed:@"profile.png"];
        else{
            self.userImage.image = [UIImage imageNamed:@"profile.png"];
            NSURL *url = photoUrl;
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.userImage.image = image;
                        });
                    }
                }
            }];
            [task resume];
        }
    }
}

- (IBAction)loginBtn:(id)sender {
    if(![[BaseController sharedInstance] checkIsUserLogin]){
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginViewController.didDismiss = ^(NSString *data) {
            [self setLoginData];
        };
        loginViewController.modalInPopover = YES;
        loginViewController.hidesBottomBarWhenPushed = YES;
        loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginViewController animated:YES completion:nil];
    } else {
        [self setLoginData];
    }
}

- (IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Properties

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    [cell.textLabel setText:[self.menusArray objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:17]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.backgroundColor = cell.contentView.backgroundColor;
    return cell;
}

- (void)openPlaylist{
    if(![AFNetworkReachabilityManager sharedManager].isReachable){
        [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
        return;
    }
    PlaylistViewController *playlistController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistViewController"];
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navController = (UINavigationController *)tabBarController.selectedViewController;
    NSArray *viewControllers = navController.viewControllers;
    BOOL isFound = false;
    for (UIViewController *anVC in viewControllers) {
        if ([anVC isKindOfClass:[playlistController class]]) {
            isFound = true;
            break;
        }
    }
    if(!isFound)
        [navController pushViewController:playlistController animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedRow = [self.menusArray objectAtIndex:indexPath.row];
    if([selectedRow isEqualToString:@"My Playlists"]){
        if([[BaseController sharedInstance] checkIsUserLogin]){
            [self openPlaylist];
        } else {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            LoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginViewController.didDismiss = ^(NSString *data) {
                [self setLoginData];
                if([[BaseController sharedInstance] checkIsUserLogin]){
                    [self openPlaylist];
                }
            };
            loginViewController.modalInPopover = YES;
            loginViewController.hidesBottomBarWhenPushed = YES;
            loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            UINavigationController *navController = [[UINavigationController alloc] init];
            [navController setNavigationBarHidden:YES animated:NO];
            [navController pushViewController:loginViewController animated:NO];
            [self presentViewController:navController animated:YES completion:nil];
        }
    } else if([selectedRow isEqualToString:@"My Offline Songs"]){
        ShowDownloadsViewController *showDownloadsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDownloadsViewController"];
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navController = (UINavigationController *)tabBarController.selectedViewController;
        NSArray *viewControllers = navController.viewControllers;
        BOOL isFound = false;
        for (UIViewController *anVC in viewControllers) {
            if ([anVC isKindOfClass:[ShowDownloadsViewController class]]) {
                isFound = true;
                break;
            }
        }
        if(!isFound)
            [navController pushViewController:showDownloadsController animated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if([selectedRow isEqualToString:@"My Reward Points"]){
        [self openWebPage:@"My Reward Points" pageLink:@"https://bestsongs-a5062.firebaseapp.com/my-reward-points.html"];
    }
//    else if ([selectedRow isEqualToString:@"Refresh Your App"]){
//        RefreshApp *refreshAppController = [self.storyboard instantiateViewControllerWithIdentifier:@"refresh_app"];
//        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        UINavigationController *navController = (UINavigationController *)tabBarController.selectedViewController;
//        NSArray *viewControllers = navController.viewControllers;
//        BOOL isFound = false;
//        for (UIViewController *anVC in viewControllers) {
//            if ([anVC isKindOfClass:[RefreshApp class]]) {
//                isFound = true;
//                break;
//            }
//        }
//        if(!isFound)
//            [navController pushViewController:refreshAppController animated:NO];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    else if([selectedRow isEqualToString:@"Gift Shop"]){
        [self openWebPage:@"Gift Shop" pageLink:@"https://bestsongs-a5062.firebaseapp.com/gift-shop.html"];
    } else if([selectedRow isEqualToString:@"How to Earn Points"]){
        [self openWebPage:@"How to Earn Points" pageLink:@"https://bestsongs-a5062.firebaseapp.com/earn-reward-points.html"];
    } else if([selectedRow isEqualToString:@"Rate App"]){
        NSString *str = @"https://itunes.apple.com/pk/app/bestsongs-pk/id1145380246?mt=8";
//        str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
//        str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
//        str = [NSString stringWithFormat:@"%@1145380246", str];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:str];
        
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                NSLog(@"Open %@: %d",str, success);
            }];
        } else {
//            BOOL success = [application openURL:URL];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                NSLog(@"Open %@: %d",str,success);
            }];
        }
        
        
        
        
        
        
    } else if([selectedRow isEqualToString:@"Share App"]){
        
        NSString *sharingLink = @"https://itunes.apple.com/pk/app/bestsongs-pk/id1145380246?mt=8";
        NSString * message = [NSString stringWithFormat:@"Download Pakistan's No1 Music App bestsongs.pk: "];
        NSArray * shareItems = @[message, sharingLink];
        UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        activityViewControntroller.excludedActivityTypes = @[];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            activityViewControntroller.popoverPresentationController.sourceView = self.view;
            activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
        }
        [self presentViewController:activityViewControntroller animated:true completion:nil];
        /*
        if(![AFNetworkReachabilityManager sharedManager].isReachable){
            [[BaseController sharedInstance] showToastError:INTERNTERRORMESSAGE];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showWithStatus:@"Generating Share Link"];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
            [[BestsongsAPI sharedInstance] createShareLink:@""
                                                   message:@""
                                                 posterURL:@""
                                                      link:@""
                                                 onSuccess:^(id response) {
                                                     [SVProgressHUD dismiss];
                                                     NSDictionary *dataDictionary = (NSDictionary *) response;
                                                     //NSLog(@"Response");
                                                     //NSLog(@"%@",response);
                                                     NSString *sharingLink = dataDictionary[@"shortLink"];
                                                     NSString * message = [NSString stringWithFormat:@"Play and enjoy %@",@""];
                                                     NSArray * shareItems = @[message, sharingLink];
                                                     //NSLog(@"%@",shareItems);
                                                     UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                                                     activityViewControntroller.excludedActivityTypes = @[];
                                                     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                         activityViewControntroller.popoverPresentationController.sourceView = self.view;
                                                         activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
                                                     }
                                                     [self presentViewController:activityViewControntroller animated:true completion:nil];
                                                 } onFailure:^(NSError *error) {
                                                     [SVProgressHUD dismiss];
                                                     [[BaseController sharedInstance] showToastError:error.localizedDescription];
                                                 }];
            
        });*/
    } else if([selectedRow isEqualToString:@"About Us"]) {
        [self openWebPage:@"About Us" pageLink:@"https://bestsongs-a5062.firebaseapp.com/about-us.html"];
    } else if([selectedRow isEqualToString:@"Contact Us"]) {
        [self openWebPage:@"Contact Us" pageLink:@"https://bestsongs-a5062.firebaseapp.com/contact.html"];
    } else if([selectedRow isEqualToString:@"Privacy Policy"]){
        [self openWebPage:@"Privacy Policy" pageLink:@"https://bestsongs-a5062.firebaseapp.com/privacy.html"];
    } else if([selectedRow isEqualToString:@"Terms and Conditions"]) {
        [self openWebPage:@"Terms and Conditions" pageLink:@"https://bestsongs-a5062.firebaseapp.com/terms-condition.html"];
    } else if([selectedRow isEqualToString:@"Reward Points Terms and Conditions"]) {
        [self openWebPage:@"RPP Privacy Policy" pageLink:@"https://bestsongs-a5062.firebaseapp.com/rpp-terms-condition.html"];
    } else if([selectedRow isEqualToString:@"Logout"]){
        FIRUser *user = [FIRAuth auth].currentUser;
        if (user != nil) {
            NSError *error;
            [[FIRAuth auth] signOut:&error];
            if (!error) {
                [self setLoginData];
            }
        }
    }
}

- (void)openWebPage:(NSString *)pageTitle pageLink:(NSString *)pageLink{
    Pages *page = [[Pages alloc] initWithtitle:pageTitle pageURL:pageLink];
    OtherPagesViewController *otherPages = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherPagesViewController"];
    otherPages.page = page;
    [self.navigationController pushViewController:otherPages animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"sideBarViewed" object:nil];
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[PlayerViewController sharedInstance] updateControls];
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

@end
