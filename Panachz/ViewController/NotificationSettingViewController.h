//
//  NotificationSettingViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *designTabButton;
@property (strong, nonatomic) IBOutlet UIButton *customerTabButton;
@property (strong, nonatomic) IBOutlet UIButton *orderTabButton;

@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UISwitch *enableNotifiactionSwitch;
@property (strong, nonatomic) IBOutlet UITextField *revenueTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)startEdit:(id)sender;
- (IBAction)saveUpdate:(id)sender;
- (IBAction)canel:(id)sender;
- (IBAction)tabButtonPressed:(id)sender;


@end
