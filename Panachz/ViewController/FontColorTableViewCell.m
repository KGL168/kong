//
//  FontColorTableViewCell.m
//  Panachz
//
//  Created by Peter Choi on 28/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "FontColorTableViewCell.h"

@implementation FontColorTableViewCell

@synthesize colorLabel;
@synthesize checkIcon;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.checkIcon.hidden = NO;
    } else {
        self.checkIcon.hidden = YES;
    }
}

@end
