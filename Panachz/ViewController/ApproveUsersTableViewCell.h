//
//  ApproveUsersTableViewCell.h
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApproveUsersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *telephoneName;
@property (strong, nonatomic) IBOutlet UIButton *approveButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@end
