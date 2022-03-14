//
//  MusicSlider.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 2/3/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "MusicSlider.h"

@implementation MusicSlider

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect rect = CGRectMake(0, 8, bounds.size.width, 3);
    return rect;
}

- (void)setup {
    UIImage *thumbImage = [UIImage imageNamed:@"music_slider_circle"];
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width + 5;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}

@end
