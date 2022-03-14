//
//  AppDelegate.m
//  tbd12
//
//  Created by Muneeb ur Rehman on 05/02/2022.
//

#import "AppDelegate.h"
#import "tbd12-Swift.h"
@import GoogleMobileAds ;

@interface AppDelegate ()
{
    AddsView *addsView ;
    NSString *isAddNeededToPlay ;
    UIWindow* window ;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [_window setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    
   
    [FIRApp configure];

    // Google Mobile Ads
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    
    //    [GADMobileAds configureWithApplicationID:@"ca-app-pub-5377163247466568~6296708013"] ;
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSError *error;
    
    BOOL isOtherAudioPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying];
    if(isOtherAudioPlaying){
        NSLog(@"Background Sound Already Played...!!");
        BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&error];
        if (!success) {
            NSLog(@"App Delegate Error :: %@", [error localizedDescription]);
        } else {
            NSLog(@"Successfully Stopped Background Sound...!!!");
        }
    }
    
        [Fabric with:@[[Crashlytics class]]];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];

//    [[AVAudioSession sharedInstance]
//     setCategory:AVAudioSessionCategoryPlayAndRecord
//     error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    Float32 bufferLength = 0.1;
//    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(bufferLength), &bufferLength);
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:bufferLength error:&error];
    
    [self updateMainTabbar];
    

    [self.window makeKeyAndVisible];

    
    return YES;
}




#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


//MARK: - TabBar

- (void)updateMainTabbar{


    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    UITabBarController *tabbarController = (UITabBarController *)self.window.rootViewController;



    int count = (int)tabbarController.viewControllers.count;
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:tabbarController.viewControllers];


//
//    DiscoverMoreViewController *discoverMoreVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
//    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Kids" permalink:@"kids"];
//    discoverMoreVC.discover = discover;
//    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:discoverMoreVC];
//    discoverMoreVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    discoverMoreVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Kids" image:nil tag:count];
//    [discoverMoreVC.tabBarItem setImage: [[UIImage imageNamed:@"kids"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//
//    discoverMoreVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Kids" image:[UIImage imageNamed:@"kids"] tag:count];
//    discoverMoreVC.tabBarItem.selectedImage = [UIImage imageNamed:@"kids-fill"];
//    [controllers addObject:navigationViewController];
//
//    count++;
//
        DiscoverTabViewController *myMusicVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverTabViewController"];
        //    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Kids" permalink:@"kids"];
        //    discoverMoreVC.discover = discover;
    
        UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:myMusicVC];
        myMusicVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        myMusicVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:nil tag:count];
        [myMusicVC.tabBarItem setImage: [[UIImage imageNamed:@"playlist"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
        myMusicVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Discover" image:[UIImage imageNamed:@"kids"] tag:count];
        myMusicVC.tabBarItem.selectedImage = [UIImage imageNamed:@"kids-fill"];
    
    
        [controllers addObject:navigationViewController];
    
        count++;

        //
//        DiscoverTabViewController *discoverTabVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverTabViewController"];
//        //    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Kids" permalink:@"kids"];
//        //    discoverMoreVC.discover = discover;
//        //
//        navigationViewController = [[UINavigationController alloc]initWithRootViewController:discoverTabVC];
//        discoverTabVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        discoverTabVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"clear-cache-fill"]  tag:count];
//        [discoverTabVC.tabBarItem setImage: [[UIImage imageNamed:@"clear-cache"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//
//        discoverTabVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Discover" image:[UIImage imageNamed:@"clear-cache-fill"] tag:count];
//        discoverTabVC.tabBarItem.selectedImage = [UIImage imageNamed:@"clear-cache-fill"];
//
//
//        [controllers addObject:navigationViewController];
//
//        count++;
//
//
    MyMusicViewController *downloadsVC = [storyBoard instantiateViewControllerWithIdentifier:@"myMusicViewController"];
    UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:downloadsVC];
    downloadsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    downloadsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Music" image:nil tag:count];
      downloadsVC.tabBarItem.selectedImage = [UIImage imageNamed:@"playlist-fill"];
    [downloadsVC.tabBarItem setImage: [[UIImage imageNamed:@"playlist"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //downloadsVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Show all my Downloads" image:[UIImage imageNamed:@"download-tabbar"] tag:count];
    [controllers addObject:nVC];
    
    [tabbarController setViewControllers:controllers];

    

    
    
//
//
//
//    //
//    //    DiscoverMoreViewController *discoverMoreVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
//    //    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Kids" permalink:@"kids"];
//    //    discoverMoreVC.discover = discover;
//    //
//    //    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:discoverMoreVC];
//    //    discoverMoreVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    //    discoverMoreVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Kids" image:nil tag:count];
//    //    [discoverMoreVC.tabBarItem setImage: [[UIImage imageNamed:@"kids"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    //
//    //    discoverMoreVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Kids" image:[UIImage imageNamed:@"kids"] tag:count];
//    //    discoverMoreVC.tabBarItem.selectedImage = [UIImage imageNamed:@"kids-fill"];
//    //
//    //    [controllers addObject:navigationViewController];
//    //
//    //    count++;
//    //

//
//    discoverMoreVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
//    discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Wedding Songs" permalink:@"wedding"];
//    discoverMoreVC.discover = discover;
//    navigationViewController = [[UINavigationController alloc]initWithRootViewController:discoverMoreVC];
//    discoverMoreVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    discoverMoreVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Wedding Songs" image:[UIImage imageNamed:@"wedding"] tag:count];
//    discoverMoreVC.tabBarItem.selectedImage = [UIImage imageNamed:@"wedding-fill"];
//    [controllers addObject:navigationViewController];
//
//    count++;

//    discoverMoreVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
//    discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Bollywood Gupshup" permalink:@"gupshups"];
//    discoverMoreVC.discover = discover;
//    navigationViewController = [[UINavigationController alloc]initWithRootViewController:discoverMoreVC];
//    discoverMoreVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    discoverMoreVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Bollywood Gupshup" image:[UIImage imageNamed:@"bollywood-gupshup"] tag:count];
//    discoverMoreVC.tabBarItem.selectedImage = [UIImage imageNamed:@"bollywood-gupshup-fill"];
//    [controllers addObject:navigationViewController];
//
//    count++;

//    discoverMoreVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
//    discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Today's Playlist" permalink:@"playlists"];
//    discoverMoreVC.discover = discover;
//    navigationViewController = [[UINavigationController alloc]initWithRootViewController:discoverMoreVC];
//    discoverMoreVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    discoverMoreVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Today's Playlist" image:[UIImage imageNamed:@"playlist"] tag:count];
//    discoverMoreVC.tabBarItem.selectedImage = [UIImage imageNamed:@"playlist-fill"];
//    [controllers addObject:navigationViewController];
//
//    count++;



    UINavigationController *moreController = tabbarController.moreNavigationController;
    if ([moreController.topViewController.view isKindOfClass:[UITableView class]]) {
        UIColor *colour = [[UIColor alloc]initWithRed:12.0/255.0 green:12.0/255.0 blue:14.0/255.0 alpha:1.0];
        moreController.navigationBar.barStyle = UIBarStyleBlack;
        moreController.navigationBar.translucent = YES;
        moreController.navigationBar.barTintColor = [UIColor blackColor];

        moreController.topViewController.view.backgroundColor = colour;
        UITableView *view = (UITableView *)moreController.topViewController.view;

        view.backgroundColor = colour;
        view.tableFooterView = [UIView new];
        [view setSeparatorColor:[[UIColor alloc]initWithRed:27.0/255.0 green:27.0/255.0 blue:29.0/255.0 alpha:1.0]];

        if ([[view subviews] count]) {
            for (UITableViewCell *cell in [view visibleCells]) {
                cell.backgroundColor = colour;
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imageView.image = [cell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                cell.imageView.tintColor = [UIColor whiteColor];
                [cell.imageView tintColorDidChange];
            }
        }

        [view setTableFooterView:[[BaseController sharedInstance] getTableViewFooterView]];
    }

    [UITabBarItem.appearance setTitleTextAttributes:

     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateNormal];

    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]}
                                           forState:UIControlStateSelected];

    [UITabBarItem.appearance setTitleTextAttributes: @{NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Semibold" size:9.5]} forState:UIControlStateSelected];
    [UITabBarItem.appearance setTitleTextAttributes: @{NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Semibold" size:9.5]} forState:UIControlStateNormal];

    for (UITabBarItem *tbi in tabbarController.tabBar.items)
        tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//MARK: - FirstResponder

-(BOOL) canBecomeFirstResponder {
    return YES;
}

//MARK: - Orientation

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.unBlockRotation) {
        return UIInterfaceOrientationMaskAll;
    }
   

    
   
   //  || [anVC isKindOfClass:[DownloadViewController class]]
    
    BOOL isFound = false;
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
        topRootViewController = topRootViewController.presentedViewController;
    if([topRootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navController = (UINavigationController *)topRootViewController;
        for (UIViewController *anVC in navController.viewControllers) {
            if ([anVC isKindOfClass:[VideoViewController class]]) {
                isFound = true;
                break;
            }
        }
    }
    if(isFound)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
    
    
}

//MARK: - Lifecycle

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
