//
//  DiscoverTabViewController.m
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 11/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//

#import "DiscoverTabViewController.h"

@interface DiscoverTabViewController ()

@end

@implementation DiscoverTabViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"hideHomeAdd" object:nil];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"showHomeAdd" object:nil];
    
    
}

- (IBAction)bollywoodBtnClicked:(UIButton *)sender {
    
    
    DiscoverMoreViewController *discoverMoreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc]initWithID:[NSNumber numberWithInteger:16] title:@"Bollywood Gupshup" permalink:@"gupshups"];
    discoverMoreVC.discover = discover;
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
}



- (IBAction)weddingsBtnClikced:(UIButton *)sender {

    DiscoverMoreViewController *discoverMoreVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
    Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Wedding Songs" permalink:@"wedding"];
    
    
    discoverMoreVC.discover = discover;
    
    
    [self.navigationController pushViewController:discoverMoreVC animated:YES];

}


- (IBAction)kidsBtnClicked:(UIButton *)sender {

    
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
        DiscoverMoreViewController *discoverMoreVC = [storyBoard instantiateViewControllerWithIdentifier:@"discoverMoreViewController"];
        Discover *discover = [[Discover alloc] initWithID:[NSNumber numberWithInt:1] title:@"Kids" permalink:@"kids"];
        discoverMoreVC.discover = discover;
    
    
        [self.navigationController pushViewController:discoverMoreVC animated:YES];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.isTranslucent
    self.navigationController.navigationBar.barTintColor = UIColor.blackColor ;
    self.navigationItem.title = @"Discover" ;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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
