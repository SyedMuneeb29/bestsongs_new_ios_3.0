//
//  MusicIndicator.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 1/25/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "MusicIndicator.h"

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width

@implementation MusicIndicator

+ (instancetype)sharedInstance {
    static MusicIndicator *_sharedMusicIndicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicIndicator = [[MusicIndicator alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 44)];
    });
    return _sharedMusicIndicator;
}

@end
