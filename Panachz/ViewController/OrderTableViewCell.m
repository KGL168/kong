//
//  OrderTableViewCell.m
//  Panachz
//
//  Created by YinYin Chiu on 20/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

@synthesize orderIDLabel;
@synthesize customerNameLabel;
@synthesize descriptionLabel;
@synthesize statusLabel;
@synthesize mailOutDateLabel;
@synthesize checkPosition;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
