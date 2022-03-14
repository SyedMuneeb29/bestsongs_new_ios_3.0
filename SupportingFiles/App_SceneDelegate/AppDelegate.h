//
//  AppDelegate.h
//  tbd12
//
//  Created by Muneeb ur Rehman on 05/02/2022.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"
#import "Discover.h"
#import "DiscoverTabViewController.h"
#import "MyMusicViewController.h"

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic , assign) bool unBlockRotation;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AddToPlaylistViewController *addToPlVC;
@property (strong, nonatomic) UINavigationController *navC;
@end

