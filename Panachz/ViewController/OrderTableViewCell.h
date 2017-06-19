//
//  OrderTableViewCell.h
//  Panachz
//
//  Created by YinYin Chiu on 20/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailOutDateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *checkPosition;

@end
