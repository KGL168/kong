//
//  OrderViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 20/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTeextView;
@property (strong, nonatomic) IBOutlet UILabel *waistSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hipsSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *thighSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *inseamSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *outseamLabel;
@property (strong, nonatomic) IBOutlet UILabel *curvSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPersonNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPersonEmailLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactPersonTelNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *shippingAddresLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackingNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailOutDateLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;

- (IBAction)deleteCustomer:(id)sender;
- (IBAction)cancelSearch:(id)sender;
- (IBAction)addOrder:(id)sender;
- (IBAction)viewProfile:(id)sender;

@end
