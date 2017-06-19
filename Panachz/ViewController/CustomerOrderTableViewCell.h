//
//  CustomerOrderTableViewCell.h
//  Panachz
//
//  Created by YinYin Chiu on 20/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerOrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtotalLabel;

@end
