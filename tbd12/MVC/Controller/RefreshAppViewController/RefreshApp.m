//
//  RefreshApp.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 8/1/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "RefreshApp.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <Crashlytics/Crashlytics.h>


@interface RefreshApp ()
{
    
    
    
}
@end



@implementation RefreshApp

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[[BaseController sharedInstance] getDefaultColor]];
    
    self.navigationItem.title = @"Refresh App";
    
    
    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(20, 50, 100, 100);
//    [button setTitle:@"Crash" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

}

//- (IBAction)crashButtonTapped:(id)sender {
//    [[Crashlytics sharedInstance] crash];
//}



- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoplayback" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:path];
    
    self.player = [AVPlayer playerWithURL:theurl];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.player = self.player;
    controller.view.frame = self.centerView.bounds;
    
    controller.showsPlaybackControls = false;
    
    [[self centerView]addSubview:controller.view];
    [self.player play ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
    [self.view bringSubviewToFront:self.centerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    AVPlayerItem *player = [notification object];
    [player seekToTime:kCMTimeZero];
}
- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
    
    [self.player  pause];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    
     [self.player  pause
      ];
    
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
