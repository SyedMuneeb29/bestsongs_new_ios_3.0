//
//  PlaylistTableViewCell.m
//  Bestsongs.pk
//
//  Created by Baqar Mehdi on 11/8/16.
//  Copyright © 2016 Bestsongs. All rights reserved.
//

#import "PlaylistTableViewCell.h"

@implementation PlaylistTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
