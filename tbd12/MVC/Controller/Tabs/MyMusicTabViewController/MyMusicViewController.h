//
//  MyMusicViewController.h
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 11/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistViewController.h"
#import "ShowDownloadsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMusicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *playlistBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadsBtn;

@end

NS_ASSUME_NONNULL_END
