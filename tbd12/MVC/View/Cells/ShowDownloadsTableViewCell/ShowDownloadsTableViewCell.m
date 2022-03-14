//
//  ShowDownloadsTableViewCell.m
//  Bestsongs.pk
//
//  Created by Apnaweb on 3/11/17.
//  Copyright © 2017 Bestsongs. All rights reserved.
//

#import "ShowDownloadsTableViewCell.h"

@implementation ShowDownloadsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected){
        _sNo.textColor = [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
        _trackTitle.textColor = [[UIColor alloc]initWithRed:255.0/255.0 green:64.0/255.0 blue:129.0/255.0 alpha:1.0];
       
    }else{
        _sNo.textColor = [UIColor whiteColor];
        _trackTitle.textColor = [UIColor whiteColor];
        
        
    }
    
    
    // Configure the view for the selected state
}

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

@end
