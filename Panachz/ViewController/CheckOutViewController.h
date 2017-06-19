//
//  CheckOutViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jeans.h"
#import "PayPalMobile.h"

@interface CheckOutViewController : UIViewController <PayPalPaymentDelegate>

@property (nonatomic, strong) NSString *jeansName;
@property (nonatomic, strong) NSString *detailDescription;
@property (nonatomic) NSUInteger qty;
@property (nonatomic, assign) NSInteger unitPrice;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (nonatomic, strong) UIImage *jeansPreview;
@property (nonatomic, strong) UIImage *jeansFrontPreview;
@property (nonatomic, strong) UIImage *jeansBackPreview;
@property (nonatomic, strong) Jeans *jeans;

@property (strong, nonatomic) IBOutlet UIImageView *jeansPreviewImage;
@property (strong, nonatomic) IBOutlet UITextView *jeansDescriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *waistLabel;
@property (strong, nonatomic) IBOutlet UILabel *hipsLabel;
@property (strong, nonatomic) IBOutlet UILabel *thighLabel;
@property (strong, nonatomic) IBOutlet UILabel *inseamLabel;
@property (strong, nonatomic) IBOutlet UILabel *outseamLabel;
@property (strong, nonatomic) IBOutlet UILabel *curveLabel;
@property (strong, nonatomic) IBOutlet UILabel *qtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) IBOutlet UIView *existingCustomerView;
@property (strong, nonatomic) IBOutlet UIView *addNewCustomerView;
@property (strong, nonatomic) IBOutlet UILabel *trackingNoLabel;
@property (strong, nonatomic) IBOutlet UIView *mailOutDateView;
@property (strong, nonatomic) IBOutlet UILabel *mailOutDateLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;

@property (strong, nonatomic) IBOutlet UIView *shippingDetailsView;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerTelNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerAddressLabel;

@property (strong, nonatomic) IBOutlet UIView *datePickerContainer;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)paypalCheckOut:(id)sender;
- (IBAction)openPickerView:(id)sender;
- (IBAction)didPickerADate:(id)sender;

@end
