//
//  ChooseCustomerTableViewCell.m
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ChooseCustomerTableViewCell.h"

@implementation ChooseCustomerTableViewCell

@synthesize nameLabel;
@synthesize telLabel;
@synthesize emailLabel;
@synthesize checkPosition;
@synthesize createOrderPosition;
@synthesize createButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
