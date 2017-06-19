//
//  CustomerTableViewCell.m
//  Panachz
//
//  Created by YinYin Chiu on 16/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "CustomerTableViewCell.h"

@implementation CustomerTableViewCell

@synthesize customerNameLabel;
@synthesize customerEmailLabel;
@synthesize customerTelLabel;
@synthesize checkView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
