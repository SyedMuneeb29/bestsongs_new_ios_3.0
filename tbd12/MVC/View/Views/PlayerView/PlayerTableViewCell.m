//
//  PlayerTableViewCell.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 7/28/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PlayerTableViewCell.h"
#import "ObjectiveCDMDownloadTask.h"

@implementation PlayerTableViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (NAKPlaybackIndicatorViewState)state {
    return self.musicIndicator.state;
}

- (void)setState:(NAKPlaybackIndicatorViewState)state {
    self.musicIndicator.state = state;
    self.sNo.hidden = (state != NAKPlaybackIndicatorViewStateStopped);
}

- (void)displayProgressForDownloadTask:(ObjectiveCDMDownloadTask *)downloadTaskInfo {
    //NSLog(@"Running Timer");
    if(self.timer == nil){
        self.currentTask = downloadTaskInfo;
        self.timer =  [NSTimer scheduledTimerWithTimeInterval: 1.0
                                         target: self
                                       selector:@selector(onTick)
                                       userInfo: nil repeats:YES];
    }
}

-(void)onTick{
    if(self.currentTask != nil){
        //NSLog(@"Timer ::");
//        [_progressView setProgress:self.currentTask.cachedProgress animated:YES];
        if(self.currentTask.completed){
            [self.timer invalidate];
            self.timer = nil;
            /*BaseController * baseController = [[BaseController alloc] init];
            [baseController showToastNotification:@"Song Successfully Downloaded.." andTextColor:baseController.getSuccessTextMessageColor andBackgroundColor:baseController.getSuccessMessageBackgroundColor];*/
//            [_progressView setHidden:YES];
            [_downloadIcon setHidden:NO];
        }
    } else{
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
