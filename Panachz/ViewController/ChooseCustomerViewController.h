//
//  ChooseCustomerViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHRotaryKnob.h"
#import "Customer.h"

@protocol ChooseCustomerDeleate <NSObject>

- (void)didChooseCustomer:(Customer *)customer;

@end

@interface ChooseCustomerViewController : UIViewController

@property (nonatomic, strong) id <ChooseCustomerDeleate> ccDelegate;

@property (strong, nonatomic) IBOutlet UILabel *designTab;
@property (strong, nonatomic) IBOutlet UILabel *customerTab;
@property (strong, nonatomic) IBOutlet UILabel *orderTab;

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UITableView *customerTableView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
- (IBAction)rightSegmentedControlDidChangeValue:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *saveProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelEditProfileButton;
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
@property (strong, nonatomic) IBOutlet UITextView *noteTextField;
@property (strong, nonatomic) IBOutlet UITextField *telNoTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *titlePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPickerView;

@property (strong, nonatomic) IBOutlet UIView *measurementView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *measurementSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *outseamLabel;
@property (strong, nonatomic) IBOutlet UILabel *InseamLabel;
@property (strong, nonatomic) IBOutlet UILabel *WaistLabel;
@property (strong, nonatomic) IBOutlet UILabel *HipLabel;
@property (strong, nonatomic) IBOutlet UILabel *thighLabel;
@property (strong, nonatomic) IBOutlet UILabel *curveMeasurementLabel;
@property (strong, nonatomic) IBOutlet UIButton *editMeasurementButton;
@property (strong, nonatomic) IBOutlet UILabel *measurementLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveMeasurementButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelEditMeasurementButton;
@property (strong, nonatomic) IBOutlet UIButton *cmButton;
@property (strong, nonatomic) IBOutlet UIButton *inchButton;
@property (strong, nonatomic) IBOutlet MHRotaryKnob *measurementRotateView;
@property (strong, nonatomic) IBOutlet UIScrollView *measurementInchScrollview;
@property (strong, nonatomic) IBOutlet UIScrollView *measurementCMScrollview;
- (IBAction)measurementSegmentedControlDidChangeValue:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *measurementSlider;

@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (strong, nonatomic) IBOutlet UITableView *orderTableView;

- (IBAction)cancelSearch:(id)sender;

@end
