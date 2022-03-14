//
//  PlaylistTableViewCell.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/8/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PlaylistTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;


@end
