//
//  SalesRecordTableViewCell.h
//  Panachz
//
//  Created by YinYin Chiu on 21/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesRecordTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *ordersLabel;
@property (strong, nonatomic) IBOutlet UILabel *purchaseLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastPurchaseLabel;

@end
