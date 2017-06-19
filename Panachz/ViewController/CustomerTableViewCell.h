//
//  CustomerTableViewCell.h
//  Panachz
//
//  Created by YinYin Chiu on 16/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerTelLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerEmailLabel;
@property (strong, nonatomic) IBOutlet UIView *checkView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *checkViewPosition;


@end
