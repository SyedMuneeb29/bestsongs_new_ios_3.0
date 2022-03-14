//
//  ParallaxViewController.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 9/7/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "ParallaxViewController.h"

@implementation ParallaxViewController

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

@end
