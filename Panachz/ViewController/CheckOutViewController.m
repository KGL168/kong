//
//  CheckOutViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "CheckOutViewController.h"
#import "CheckOutJeansPreviewScreenViewController.h"
#import "AddCustomerViewController.h"
#import "ChooseCustomerViewController.h"
#import "MasterViewController.h"
#import "MBProgressHUD.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"

@interface CheckOutViewController () <AddCustomerviewControllerDelegate, ChooseCustomerDeleate, UITextViewDelegate> {
    /* keyboard auto go up */
    CGFloat currentKeyboardHeight;
    CGFloat deltaHeight;
    CGFloat moved;
    CGFloat textfield_y;
    bool animated;
}
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) Customer *orderCustomter;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic) BOOL customerAdded;
@end

@implementation CheckOutViewController

@synthesize orderCustomter;
@synthesize customerAdded;
@synthesize jeansName;
@synthesize detailDescription;
@synthesize qty;
@synthesize jeans;
@synthesize jeansPreview;
@synthesize jeansFrontPreview;
@synthesize jeansBackPreview;

@synthesize jeansPreviewImage;
@synthesize jeansDescriptionTextView;
@synthesize waistLabel;
@synthesize hipsLabel;
@synthesize thighLabel;
@synthesize inseamLabel;
@synthesize outseamLabel;
@synthesize curveLabel;
@synthesize qtyLabel;
@synthesize unitPriceLabel;
@synthesize totalPriceLabel;

@synthesize existingCustomerView;
@synthesize addNewCustomerView;

@synthesize shippingDetailsView;
@synthesize customerNameLabel;
@synthesize customerEmailLabel;
@synthesize customerTelNoLabel;
@synthesize customerAddressLabel;

@synthesize trackingNoLabel;

@synthesize mailOutDateView;
@synthesize mailOutDateLabel;

@synthesize noteTextView;
@synthesize datePickerContainer;
@synthesize datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup navigation bar
//    NSString *titleText = @"Order ID: FA1000";
//    UIFont* titleFont = [UIFont fontWithName:@"Roboto-Regular" size:18];
//    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
//    title.textColor = [UIColor blackColor];
//    title.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = titleText;
//    self.navigationItem.titleView = title;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [activityIndicatorView startAnimating];
    self.navigationItem.titleView = activityIndicatorView;

    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:@"orders/lastOrderId"
                       parameters:nil
                          success:^(NSURLSessionTask *task, id responseObject) {
                              if ([responseObject[@"response"][0][@"code"] intValue] == 100) {
                                  NSString *lastOrderId = responseObject[@"last_order_id"][@"order_id"];
                                  
                                  weakSelf.orderId = [NSString stringWithFormat:@"Order ID: FA%@", lastOrderId];
                                  NSString *titleText = [NSString stringWithFormat:@"Order ID: FA%@", lastOrderId];
                                  UIFont* titleFont = [UIFont fontWithName:@"Roboto-Regular" size:18];
                                  CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
                                  
                                  UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
                                  title.textColor = [UIColor blackColor];
                                  title.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
                                  title.textAlignment = NSTextAlignmentCenter;
                                  title.text = titleText;
                                  weakSelf.navigationItem.titleView = title;
                              }
                          }
                          failure:^(NSURLSessionTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] show];
                          }];
    
    // Setup Left navigation bar item
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 24, 24)];
    [menuImage setImage:[UIImage imageNamed:@"ic_keyboard_arrow_left_black_48dp"]];

    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addSubview:menuImage];
    menuButton.frame = CGRectMake(0, 0, 24, 24);
    [menuButton addTarget:self
                   action:@selector(backToDesign:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = navigationBarMenuButton;
    
    // Setup jeans preview image
    [self.jeansPreviewImage setImage:self.jeansPreview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(jeansPreview:)];
    [tap setNumberOfTapsRequired:1];
    [self.jeansPreviewImage setUserInteractionEnabled:YES];
    [self.jeansPreviewImage addGestureRecognizer:tap];
    
    // Setup existing customer view
    self.existingCustomerView.layer.borderWidth = 1.0;
    self.existingCustomerView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(chooseExistingCustomer:)];
    [tap setNumberOfTapsRequired:1];
    [self.existingCustomerView setUserInteractionEnabled:YES];
    [self.existingCustomerView addGestureRecognizer:tap];
    
    // Setup add new customer view
    self.addNewCustomerView.layer.borderWidth = 1.0;
    self.addNewCustomerView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(addCustomer:)];
    [tap setNumberOfTapsRequired:1];
    [self.addNewCustomerView setUserInteractionEnabled:YES];
    [self.addNewCustomerView addGestureRecognizer:tap];
    
    // Setup mail out date view
    self.mailOutDateView.layer.borderWidth = 1.0;
    self.mailOutDateView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup shipping detail view
    self.shippingDetailsView.layer.borderWidth = 1.0;
    self.shippingDetailsView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup the note text view
    self.noteTextView.layer.borderWidth = 1.0;
    self.noteTextView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup date picker
    self.datePickerContainer.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.datePickerContainer.layer.borderWidth = 1.0;
    
    // Setup summary
    [self.jeansDescriptionTextView setText:self.detailDescription];
    UIFont *font = [UIFont fontWithName:@"Roboto-Thin" size:14.0f];
    [self.jeansDescriptionTextView setFont:font];
    [self.jeansDescriptionTextView setTextColor:[UIColor colorWithRBGValue:0x444444]];
    
    self.waistLabel.text = self.jeans.jeanWaistSize == nil ? @"0.0" : self.jeans.jeanWaistSize;
    self.hipsLabel.text = self.jeans.jeanHipsSize == nil ? @"0.0" : self.jeans.jeanHipsSize;
    self.thighLabel.text = self.jeans.jeanThighSize == nil ? @"0.0" : self.jeans.jeanThighSize;
    self.inseamLabel.text = self.jeans.jeanInseamSize == nil ? @"0.0" : self.jeans.jeanInseamSize;
    self.outseamLabel.text = self.jeans.jeanOutseamSize == nil ? @"0.0" : self.jeans.jeanOutseamSize;
    self.curveLabel.text = self.jeans.jeanCurveSize == nil ? @"0.0" : self.jeans.jeanCurveSize;
    
    [self.qtyLabel setText:[NSString stringWithFormat:@"%li", self.qty]];
    NSInteger uPrice =  self.unitPrice;
    self.unitLabel.text = [NSString stringWithFormat: @"$%li.0", uPrice];
    
    [self.unitPriceLabel setText:[NSString stringWithFormat:@"%li", uPrice]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"%li", uPrice * self.qty]];
    
    NSTimeInterval trackingNo = [[NSDate date] timeIntervalSince1970];
    [trackingNoLabel setText:[NSString stringWithFormat:@"%0.0f", trackingNo]];
    
    // Setup note textview
    self.noteTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Setup for paypal
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    
    // See PayPalConfiguration.h for details and default values.
    // Should you wish to change any of the values, you can do so here.
    // For example, if you wish to accept PayPal but not payment card payments, then add:
    _payPalConfiguration.acceptCreditCards = YES;
    // Or if you wish to have the user choose a Shipping Address from those already
    // associated with the user's PayPal account, then add:
    //_payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    _payPalConfiguration.merchantName = @"Panachz";
    _payPalConfiguration.rememberUser = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)a {
    [super viewWillAppear:a];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

#pragma mark - Tap Gesture

- (void) jeansPreview:(UIGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"PreviewJeans"
                              sender:nil];
}

- (void)addCustomer:(id)sender {
    [self performSegueWithIdentifier:@"AddCustomer"
                              sender:nil];
}

- (IBAction)chooseExistingCustomer:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot connect to Internet"
                                    message:@"Please check your Internet Connection"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/customers", [Panachz getInstance].user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                              
                              if ([[response objectForKey:@"code"] intValue] == 300) {
                                  [weakSelf performSegueWithIdentifier:@"ChooseExistCustomer"
                                                            sender:nil];
                              } else {
                                  [[[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"You don't have a existing customer"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil] show];
                              }
                              
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                          }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddCustomer"]) {
        AddCustomerViewController *vc = (AddCustomerViewController *)segue.destinationViewController;
        vc.acDelegate = self;
    } else if ([segue.identifier isEqualToString:@"ChooseExistCustomer"]) {
        ChooseCustomerViewController *vc = (ChooseCustomerViewController *)segue.destinationViewController;
        vc.ccDelegate = self;
    } else if ([segue.identifier isEqualToString:@"PreviewJeans"]) {
        CheckOutJeansPreviewScreenViewController *vc = (CheckOutJeansPreviewScreenViewController *)segue.destinationViewController;
        vc.frontPreview = self.jeansFrontPreview;
        vc.backPreiview = self.jeansBackPreview;
    }
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    deltaHeight = kbSize.height - moved;
    currentKeyboardHeight = kbSize.height;
    [self animateTextField: YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self animateTextField: NO];
    currentKeyboardHeight = 0.0f;
}

- (void)animateTextField:(BOOL)up {
    if (textfield_y > [[UIScreen mainScreen] bounds].size.height - currentKeyboardHeight && !animated && up) {
        animated = YES;
    }
    
    if (animated) {
        const float movementDuration = 0.3f;
        
        int movement = (up ? -deltaHeight : moved);
        
        moved = (up ? moved + deltaHeight : 0.0f);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        
        if (!up) {
            animated = NO;
        }
    }
    
    textfield_y = 0.0f;
}

#pragma mark - Textview Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    CGRect newFrame = [textView convertRect:textView.bounds
                                     toView:nil];
    textfield_y = newFrame.origin.y;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect newFrame = [textView convertRect:textView.bounds
                                      toView:nil];
    textfield_y = newFrame.origin.y;
}

- (void)didAddUser:(Customer *)userInfo {
    self.orderCustomter = userInfo;
    
    self.shippingDetailsView.hidden = NO;
    [self.customerNameLabel setText:userInfo.name];
    [self.customerEmailLabel setText:userInfo.email];
    [self.customerTelNoLabel setText:userInfo.telNo];
    [self.customerAddressLabel setText:userInfo.address];
    
    self.customerAdded = YES;
}

- (void)didChooseCustomer:(Customer *)customer {
    self.orderCustomter = customer;
    
    self.shippingDetailsView.hidden = NO;
    [self.customerNameLabel setText:customer.name];
    [self.customerEmailLabel setText:customer.email];
    [self.customerTelNoLabel setText:customer.telNo];
    [self.customerAddressLabel setText:customer.address];
    
    // Update the size
    [self.waistLabel setText:customer.waist];
    [self.hipsLabel setText:customer.hips];
    [self.thighLabel setText:customer.thigh];
    [self.inseamLabel setText:customer.inseam];
    [self.outseamLabel setText:customer.outseam];
    [self.curveLabel setText:customer.curve];
    
    self.customerAdded = NO;
}

#pragma mark - Navigation Bar Button

- (void)backToDesign:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Date Picker

- (IBAction)openPickerView:(id)sender {
    if (self.datePickerContainer.hidden) {
        self.datePickerContainer.alpha = 0.0;
        self.datePickerContainer.hidden = NO;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.datePickerContainer.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.datePickerContainer becomeFirstResponder];
                             }
                         }];
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.datePickerContainer.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.datePickerContainer resignFirstResponder];
                                 self.datePickerContainer.hidden = YES;
                             }
                         }];
    }
}

- (IBAction)didPickerADate:(id)sender {
    UIDatePicker *dPicker = (UIDatePicker *)sender;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM / dd / yyyy"];
    [self.mailOutDateLabel setText:[dateFormatter stringFromDate:dPicker.date]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePickerContainer.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.datePickerContainer resignFirstResponder];
                             self.datePickerContainer.hidden = YES;
                         }
                     }];
}

#pragma mark - Check Out

//TODO: Check Out
- (IBAction)paypalCheckOut:(id)sender {
    if (self.orderCustomter == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please select a customer!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    // Create PayPalItem
    PayPalItem *item1 = [PayPalItem itemWithName:self.jeansName
                                    withQuantity:self.qty
                                       withPrice:[NSDecimalNumber decimalNumberWithString:self.unitPriceLabel.text]
                                    withCurrency:@"USD"
                                         withSku:@"Jeans-00001"];
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Panachz Jeans";
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    NSString *countryCode = nil;
    if ([self.orderCustomter.country isEqualToString:@"Hong Kong"]) {
        countryCode = @"HK";
    } else if ([self.orderCustomter.country isEqualToString:@"China"]) {
        countryCode = @"CN";
    } else if ([self.orderCustomter.country isEqualToString:@"Japan"]) {
        countryCode = @"JP";
    } else if ([self.orderCustomter.country isEqualToString:@"United States"]) {
        countryCode = @"US";
    } else {
        countryCode = @"GB";
    }
  
    // Shipping address
    PayPalShippingAddress *shippingAddress = [PayPalShippingAddress shippingAddressWithRecipientName:self.orderCustomter.name
                                                                                           withLine1:self.orderCustomter.street
                                                                                           withLine2:@""
                                                                                            withCity:self.orderCustomter.city
                                                                                           withState:self.orderCustomter.state
                                                                                      withPostalCode:self.orderCustomter.zipCode
                                                                                     withCountryCode:countryCode];
    payment.shippingAddress = shippingAddress;
    
    // Invoice number
    payment.invoiceNumber = [NSString stringWithFormat:@"%@-%@", self.orderId, self.trackingNoLabel.text];
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
        
        return;
    }
    
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (UIImage *)compressImage:(UIImage *)image {
    UIGraphicsBeginImageContext(CGSizeMake(1024, 1340));
    [image drawInRect:CGRectMake(0, 0, 1024, 1340)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment);
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
    
    if ([[[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"state"] isEqualToString:@"approved"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM / dd / yyyy"];
        NSDate *mailOutDate = [dateFormatter dateFromString:self.mailOutDateLabel.text];
        
        NSData *imageData = UIImagePNGRepresentation([self compressImage:self.jeansPreview]);
        NSData *frontPreview = UIImagePNGRepresentation([self compressImage:self.jeansFrontPreview]);
        NSData *backPreview = UIImagePNGRepresentation([self compressImage:self.jeansBackPreview]);
        
        NSDictionary *para = @{@"user_id" : [NSString stringWithFormat:@"%lu", [Panachz getInstance].user.userId],
                               @"customer_id" : [NSString stringWithFormat:@"%lu", self.orderCustomter.customerId],
                               @"state" : @"Not Submitted",
                               @"quantity" : [NSString stringWithFormat:@"%lu", self.qty],
                               @"unit_price" : self.unitPriceLabel.text,
                               @"tracking_no" : self.trackingNoLabel.text,
                               @"measurement_waist" : self.waistLabel.text,
                               @"measurement_hips" : self.hipsLabel.text,
                               @"measurement_thigh" : self.thighLabel.text,
                               @"measurement_inseam" : self.inseamLabel.text,
                               @"measurement_outseam" : self.outseamLabel.text,
                               @"measurement_curve" : self.curveLabel.text,
                               @"address_street" : self.orderCustomter.street,
                               @"address_city" : self.orderCustomter.city,
                               @"address_state" : self.orderCustomter.state,
                               @"address_country" : self.orderCustomter.country,
                               @"address_zipcode" : self.orderCustomter.zipCode,
                               @"item_title" : self.jeansName,
                               @"item_detail" : self.jeansDescriptionTextView.text,
                               @"mail_out_date" : [NSString stringWithFormat:@"%0.0f", [mailOutDate timeIntervalSince1970]],
                               @"notes" : self.noteTextView.text,
                               @"paypal_confirmation" : completedPayment};
        
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        __weak typeof (self) weakSelf = self;
        [[PanachzApi getInstance] POST:@"customer/set/measurement"
                            parameters:@{@"customer_id" : [NSString stringWithFormat:@"%lu", self.orderCustomter.customerId],
                                         @"measurement_waist" : self.waistLabel.text,
                                         @"measurement_hips" : self.hipsLabel.text,
                                         @"measurement_thigh" : self.thighLabel.text,
                                         @"measurement_inseam" : self.inseamLabel.text,
                                         @"measurement_outseam" : self.outseamLabel.text,
                                         @"measurement_curve" : self.curveLabel.text}
                               success:nil
                               failure:nil];
        [[PanachzApi getInstance] POST:@"orders/create"
                            parameters:para
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                 [formData appendPartWithFileData:imageData
                                             name:@"image"
                                         fileName:@"image.png"
                                         mimeType:@"image/png"];
                 
                 [formData appendPartWithFileData:frontPreview
                                             name:@"front_preview"
                                         fileName:@"front_preview.png"
                                         mimeType:@"image/png"];
                 
                 [formData appendPartWithFileData:backPreview
                                             name:@"back_preview"
                                         fileName:@"back_preview.png"
                                         mimeType:@"image/png"];
             }
                               success:^(NSURLSessionTask *task, id responseObject) {
                                   NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                   
                                   if ([[response objectForKey:@"code"] intValue] == 101) {
                                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                      message:@"Order Created"
                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction *action) {
                                                                                          UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                          MasterViewController *vc = (MasterViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"MasterViewController"];
                                                                                          vc.tab = DESIGN_VIEW;
                                                                                          [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                                                                                                          withCompletion:nil];
                                                                                      }];
                                       [alert addAction:action];
                                       [weakSelf presentViewController:alert
                                                              animated:YES
                                                            completion:nil];
                                   } else {
                                       [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:[response objectForKey:@"message"]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil] show];
                                   }
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                               }
                               failure:^(NSURLSessionTask *task, NSError *error) {
                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:[NSString stringWithFormat:@"%@", error]
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] show];
                               }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Somthing wrong"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
