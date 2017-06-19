//
//  SalesRecordTableViewCell.m
//  Panachz
//
//  Created by YinYin Chiu on 21/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "SalesRecordTableViewCell.h"

@implementation SalesRecordTableViewCell

@synthesize clientNameLabel;
@synthesize telephoneLabel;
@synthesize statusLabel;
@synthesize ordersLabel;
@synthesize purchaseLabel;
@synthesize lastPurchaseLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
