//
//  ApproveUsersTableViewCell.m
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ApproveUsersTableViewCell.h"

@implementation ApproveUsersTableViewCell

@synthesize nameLabel;
@synthesize emailLabel;
@synthesize telephoneName;
@synthesize approveButton;
@synthesize deleteButton;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
