//
//  ShowDownloadsTableViewCell.h
//  Bestsongs.pk
//
//  Created by Apnaweb on 3/11/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAKPlaybackIndicatorView.h"
#import "SWTableViewCell.h"

@interface ShowDownloadsTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIView *border;

@property (weak, nonatomic) IBOutlet UILabel *sNo;
@property (weak, nonatomic) IBOutlet NAKPlaybackIndicatorView *musicIndicator;
@property (weak, nonatomic) IBOutlet UILabel *trackTitle;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UIImageView *poster;

@property (nonatomic, assign) NAKPlaybackIndicatorViewState state;

@end
