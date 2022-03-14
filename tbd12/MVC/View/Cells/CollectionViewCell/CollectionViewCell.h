//
//  CollectionViewCell.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 10/20/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *Image;
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayIcon;

@end
