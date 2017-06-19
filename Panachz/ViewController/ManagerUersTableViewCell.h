//
//  ManagerUersTableViewCell.h
//  Panachz
//
//  Created by Peter Choi on 14/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerUersTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *positionLabel;
@property (strong, nonatomic) IBOutlet UILabel *revenueLabel;
@property (strong, nonatomic) IBOutlet UILabel *commissionLabel;

@end
