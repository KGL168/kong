//
//  ManagerUersTableViewCell.m
//  Panachz
//
//  Created by Peter Choi on 14/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ManagerUersTableViewCell.h"

@implementation ManagerUersTableViewCell

@synthesize nameLabel;
@synthesize telephoneLabel;
@synthesize emailLabel;
@synthesize positionLabel;
@synthesize revenueLabel;
@synthesize commissionLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
