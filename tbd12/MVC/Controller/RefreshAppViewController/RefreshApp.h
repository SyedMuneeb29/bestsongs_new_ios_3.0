//
//  RefreshApp.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 8/1/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import <AVFoundation/AVFoundation.h>

@interface RefreshApp : UIViewController

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (nonatomic) AVPlayer *player;

@end
