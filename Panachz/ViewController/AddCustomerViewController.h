//
//  AddCustomerViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 16/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@protocol AddCustomerviewControllerDelegate <NSObject>

- (void)didAddUser:(Customer *)userInfo;

@end

@interface AddCustomerViewController : UIViewController

@property (nonatomic, strong) id <AddCustomerviewControllerDelegate> acDelegate;

@property (strong, nonatomic) IBOutlet UIView *customerNavigationBar;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *titleLeftArrowImageView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *streetTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *stateTextField;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *countryLeftArrowImageView;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *telNoTextField;
@property (strong, nonatomic) IBOutlet UITextView *noteTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *titlePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPickerView;

- (IBAction)addNewCustomer:(id)sender;
- (IBAction)cancel:(id)sender;
@end
