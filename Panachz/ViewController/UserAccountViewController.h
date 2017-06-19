//
//  UserAccountViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *designTabButton;
@property (strong, nonatomic) IBOutlet UIButton *customerTabButton;
@property (strong, nonatomic) IBOutlet UIButton *orderTabButton;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UITextField *loginEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *titleLeftArrowImageView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *streetTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *telNoTextField;
@property (strong, nonatomic) IBOutlet UITextView *noteTextField;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *countryLeftArrowImageView;
@property (strong, nonatomic) IBOutlet UIPickerView *titlePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPickerView;

- (IBAction)startEdit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)tabButtonPressed:(id)sender;
- (IBAction)changePassword:(id)sender;


@end
