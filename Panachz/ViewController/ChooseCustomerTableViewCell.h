//
//  ChooseCustomerTableViewCell.h
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCustomerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIView *createOrderView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *checkPosition;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *createOrderPosition;
@property (strong, nonatomic) IBOutlet UIButton *createButton;

@end
