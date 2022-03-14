//
//  TabbarViewController.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/25/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "TabbarViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateMainTabbar];
}

- (void)updateMainTabbar{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    int count = (int)self.viewControllers.count;
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.viewControllers];

    DiscoverTabViewController *myMusicVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverTabViewController"];
    UINavigationController *navigationViewController = [[UINavigationController alloc]initWithRootViewController:myMusicVC];
    myMusicVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    myMusicVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:nil tag:count];
    [myMusicVC.tabBarItem setImage: [[UIImage imageNamed:@"playlist"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    myMusicVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Discover" image:[UIImage imageNamed:@"kids"] tag:count];
    myMusicVC.tabBarItem.selectedImage = [UIImage imageNamed:@"kids-fill"];
    [controllers addObject:navigationViewController];
    count++;

    MyMusicViewController *downloadsVC = [storyBoard instantiateViewControllerWithIdentifier:@"myMusicViewController"];
    UINavigationController *nVC = [[UINavigationController alloc]initWithRootViewController:downloadsVC];
    downloadsVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    downloadsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Music" image:nil tag:count];
    downloadsVC.tabBarItem.selectedImage = [UIImage imageNamed:@"playlist-fill"];
    [downloadsVC.tabBarItem setImage: [[UIImage imageNamed:@"playlist"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [controllers addObject:nVC];
    
    [self setViewControllers:controllers];
    [self setupTabBarMoreTheme];
    [self setupTabBarItem];
}

- (void) setupTabBarMoreTheme {
    UINavigationController* more = self.tabBarController.moreNavigationController;
    more.navigationBar.barStyle = UIBarStyleDefault;
    if ([more.topViewController.view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)more.topViewController.view;
        [tableView setBackgroundColor:[UIColor blackColor]];
        more.topViewController.view = tableView;
    }
    
    UINavigationController *moreController = self.moreNavigationController;
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
}

- (void) setupTabBarItem {
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    [UITabBarItem.appearance setTitleTextAttributes: @{NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Semibold" size:9.5]} forState:UIControlStateSelected];
    [UITabBarItem.appearance setTitleTextAttributes: @{NSFontAttributeName : [UIFont fontWithName:@"ProximaNova-Semibold" size:9.5]} forState:UIControlStateNormal];
    for (UITabBarItem *tbi in self.tabBar.items)
        tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
