//
//  ManageUsersViewController.h
//  Panachz
//
//  Created by Peter Choi on 14/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageUsersViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *designTabButton;
@property (strong, nonatomic) IBOutlet UIButton *customerTabButton;
@property (strong, nonatomic) IBOutlet UIButton *orderTabButton;
@property (strong, nonatomic) IBOutlet UITableView *usersTableView;
@property (strong, nonatomic) IBOutlet UIButton *approveNewUsersButton;

- (IBAction)tabButtonPressed:(id)sender;

@end
