//
//  ContentNotAvailableViewController.h
//  Bestsongs.pk
//
//  Created by IMac on 28/04/2018.
//  Copyright © 2018 Bestsongs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentNotAvailableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lblOfContentNotAvailableDescription;

@property (weak, nonatomic) IBOutlet UILabel *lblContentNotAvailableContactDetail;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraintOfDescription;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraintOfContactDetail;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraintOfDescription;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraintOfContactDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bestSongsLogoTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bestSongsLogoLeadingConsraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bestSongsLogoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bestSongsLogoBottomConstraint;


@end
