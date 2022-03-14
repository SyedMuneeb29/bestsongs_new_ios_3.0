//
//  ParallaxViewController.h
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 9/7/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParallaxViewController : UIView

+ (instancetype)instantiateFromNib;

@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;


@end

/* ParallaxViewController_h */
