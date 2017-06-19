//
//  CustomerViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 16/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "CustomerViewController.h"
#import "CustomerTableViewCell.h"
#import "CustomerOrderTableViewCell.h"
#import "Customer.h"
#import "AddCustomerViewController.h"
#import "MBProgressHUD.h"
#import "NSString+ValidEmail.h"
#import "Order.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "UIColor+HexColor.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 320;

@interface CustomerViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, AddCustomerviewControllerDelegate> {
    NSString *tempTitle;
    NSString *tempName;
    NSString *tempStreet;
    NSString *tempCity;
    NSString *tempState;
    NSString *tempCountry;
    NSString *tempZipCode;
    NSString *tempTelNo;
    NSString *tempNotes;
    NSString *tempOutseam;
    NSString *tempInseam;
    NSString *tempWaist;
    NSString *tempHips;
    NSString *tempThigh;
    NSString *tempCurve;
}

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSMutableArray *customers;
@property (nonatomic) BOOL measurementInInch;

@end

@implementation CustomerViewController

@synthesize customers;

@synthesize searchView;
@synthesize searchTextField;
@synthesize customerTableView;
@synthesize selectedIndexPath;
@synthesize rightSegmentedControl;

CGFloat animatedDistance3;

@synthesize editProfileButton;
@synthesize saveProfileButton;
@synthesize cancelEditProfileButton;
@synthesize titlePickerView;
@synthesize countryPickerView;
@synthesize profileView;
@synthesize titleLabel;
@synthesize titleLeftArrowImageView;
@synthesize nameTextField;
@synthesize streetTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize countryLabel;
@synthesize countryLeftArrowImageView;
@synthesize zipCodeTextField;
@synthesize telNoTextField;
@synthesize noteTextField;

@synthesize measurementInInch;
@synthesize measurementView;
@synthesize measurementSegmentedControl;
@synthesize outseamLabel;
@synthesize InseamLabel;
@synthesize WaistLabel;
@synthesize HipLabel;
@synthesize thighLabel;
@synthesize editMeasurementButton;
@synthesize measurementLabel;
@synthesize saveMeasurementButton;
@synthesize cancelEditMeasurementButton;
@synthesize cmButton;
@synthesize inchButton;
@synthesize measurementRotateView;
@synthesize measurementInchScrollview;
@synthesize measurementCMScrollview;
@synthesize measurementSlider;

@synthesize orderView;
@synthesize orderTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewCustomerProfile:)
                                                 name:@"ViewProfile"
                                               object:nil];
    
    self.searchView.layer.borderWidth = 1.0;
    self.searchView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.searchTextField.delegate = self;
    
    // Setup tableview
    self.customerTableView.dataSource = self;
    self.customerTableView.delegate = self;
    self.customerTableView.layer.borderWidth = 1.0;
    self.customerTableView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;

    self.customerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Setup segmented control in the right view
    NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                             size:12.0f],
                                       NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0x444444]};
    [self.rightSegmentedControl setTitleTextAttributes:normalAttributes
                                              forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                               size:12.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0xffffff]};
    [self.rightSegmentedControl setTitleTextAttributes:selectedAttributes
                                              forState:UIControlStateSelected];
    
    /* Setup profile view */
    
    // Setup wtf data
    self.titles = @[@"Mr.", @"Ms.", @"Mrs."];
    self.countries = @[@"China", @"Hong Kong", @"Japan", @"United States", @"United Kingdom"];
    
    // Tap on title label
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(openTitlePicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleLabel addGestureRecognizer:tap];
    
    // Tap on title arrow icon
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openTitlePicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.titleLeftArrowImageView.userInteractionEnabled = YES;
    [self.titleLeftArrowImageView addGestureRecognizer:tap];
    
    // Tap on title picker
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(closeTitlePicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    self.titlePickerView.userInteractionEnabled = YES;
    [self.titlePickerView addGestureRecognizer:tap];
    
    self.titlePickerView.showsSelectionIndicator = YES;
    self.titlePickerView.dataSource = self;
    self.titlePickerView.delegate = self;
    self.titlePickerView.layer.borderWidth = 1.0;
    self.titlePickerView.layer.cornerRadius = 4.0;
    self.titlePickerView.layer.borderColor = [UIColor colorWithRBGValue:0x444444
                                                                  alpha:0.3].CGColor;
    /* End the wtf Title and Title PickerView setup */
    
    self.nameTextField.delegate = self;
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.nameTextField.leftView = leftPadding;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.streetTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.streetTextField.leftView = leftPadding;
    self.streetTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.cityTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.cityTextField.leftView = leftPadding;
    self.cityTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.stateTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.stateTextField.leftView = leftPadding;
    self.stateTextField.leftViewMode = UITextFieldViewModeAlways;
    
    /* Setup the wtf Country and Country PickerView */
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openCountryPicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.countryLabel.userInteractionEnabled = YES;
    [self.countryLabel addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openCountryPicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.countryLeftArrowImageView addGestureRecognizer:tap];
    self.countryLeftArrowImageView.userInteractionEnabled = YES;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(closeCountryPicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    self.countryPickerView.userInteractionEnabled = YES;
    [self.countryPickerView addGestureRecognizer:tap];
    self.countryPickerView.showsSelectionIndicator = YES;
    self.countryPickerView.dataSource = self;
    self.countryPickerView.delegate = self;
    self.countryPickerView.layer.borderWidth = 1.0;
    self.countryPickerView.layer.cornerRadius = 4.0;
    self.countryPickerView.layer.borderColor = [UIColor colorWithRBGValue:0x444444
                                                                    alpha:0.3].CGColor;
    
    self.zipCodeTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.zipCodeTextField.leftView = leftPadding;
    self.zipCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.emailTextField.leftView = leftPadding;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.telNoTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.telNoTextField.leftView = leftPadding;
    self.telNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.noteTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.noteTextField.textContainerInset = UIEdgeInsetsMake(5, 3.5, 5, 3.5);
    
    self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
    /* End Setup profile view */
    
    /* Setup for measurement view*/
    self.measurementRotateView.interactionStyle = MHRotaryKnobInteractionStyleRotating;
    self.measurementRotateView.scalingFactor = 1.5;
    self.measurementRotateView.minRequiredDistanceFromKnobCenter = 100.0;
    self.measurementRotateView.minimumValue = 0;
    self.measurementRotateView.maximumValue = 254;
    self.measurementRotateView.defaultValue = 30;
    self.measurementRotateView.value = 30.4;
    self.measurementRotateView.maxAngle = 177.5;
//    self.measurementRotateView.enabled = NO;
    self.measurementRotateView.backgroundImage = [UIImage imageNamed:@"size_big_circle_customer"];
    self.measurementRotateView.backgroundColor = [UIColor clearColor];
    [self.measurementRotateView setKnobImage:[UIImage imageNamed:@"knob3"]
                                    forState:UIControlStateNormal];
    self.measurementRotateView.knobImageCenter = CGPointMake(163.0, 163.0);
    [self.measurementRotateView addTarget:self
                                   action:@selector(rotaryKnobDidChange)
                         forControlEvents:UIControlEventValueChanged];
    self.measurementRotateView.enabled = NO;
    self.measurementInInch = YES;
    [self setupInchScrollview];
    [self setupCMScrollview];
    self.measurementInchScrollview.userInteractionEnabled = NO;
    self.measurementCMScrollview.userInteractionEnabled = NO;
    [self.measurementSlider setBackgroundColor:[UIColor clearColor]];
    [self.measurementSlider setThumbImage:[UIImage imageNamed:@"size_pointer_customer"]
                                 forState:UIControlStateNormal];
    [self.measurementSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [self.measurementSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [self.measurementSlider addTarget:self
                               action:@selector(sliderChanged:)
                     forControlEvents:UIControlEventValueChanged];
    /* End setup for measurement view*/
    
    /* Setup for order view */
    self.orderTableView.dataSource = self;
    self.orderTableView.delegate = self;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    /* End Setup for order view */
    
    self.customers = [[NSMutableArray alloc] init];
    [self getCustomers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddCustomer"]) {
        AddCustomerViewController *vc = (AddCustomerViewController *)segue.destinationViewController;
        vc.acDelegate = self;
    }
}

#pragma mark - Notification

- (void)viewCustomerProfile:(NSNotification *)notification {
    if (self.customers != nil && self.customers.count > 0) {
        NSDictionary *userInfo = notification.userInfo;
        
        for (int i = 0; i < self.customers.count; i++) {
            Customer *c = [self.customers objectAtIndex:i];
            
            if ([c.name isEqualToString:[userInfo objectForKey:@"name"]] && [c.email isEqualToString:[userInfo objectForKey:@"email"]] && [c.telNo isEqualToString:[userInfo objectForKey:@"tel"]]) {
                self.selectedIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.customerTableView reloadData];
                [self tableView:self.customerTableView didSelectRowAtIndexPath:self.selectedIndexPath];
                [self.customerTableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                break;
            }
        }
    }
}

#pragma mark - Customer

- (void)didAddUser:(Customer *)userInfo {
    [self.customers addObject:userInfo];
    
    [self.customerTableView reloadData];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.customerTableView didSelectRowAtIndexPath:self.selectedIndexPath];
    [self.customerTableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Customer Added"
                               delegate:nil
                      cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)deleteCustomer:(id)sender {
    if (self.customers.count) {
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
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Are you sure to delete this customer?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
        __weak typeof (self) weakSelf = self;
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction *action) {
                                                        [MBProgressHUD showHUDAddedTo:weakSelf.view
                                                                             animated:YES];
                                                        
                                                        Customer *selectedCustomer = [weakSelf.customers objectAtIndex:weakSelf.selectedIndexPath.row];
                                                        [[PanachzApi getInstance] POST:@"customer/delete"
                                                                            parameters:@{@"customer_id" : [NSString stringWithFormat:@"%lu", selectedCustomer.customerId]}
                                                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                   NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                                                                   
                                                                                   if ([[response objectForKey:@"code"] intValue] == 304) {
                                                                                       [weakSelf.customers removeObject:selectedCustomer];
                                                                                       [weakSelf.customerTableView reloadData];
                                                                                       weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                                                                       [weakSelf tableView:weakSelf.customerTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                                                                       [weakSelf.customerTableView selectRowAtIndexPath:weakSelf.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                                                                                       
                                                                                       [[[UIAlertView alloc] initWithTitle:@""
                                                                                                                   message:@"Customer Deleted"
                                                                                                                  delegate:nil
                                                                                                         cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles:nil] show];
                                                                                   } else {
                                                                                       [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                  message:[response objectForKey:@"message"]
                                                                                                                  delegate:nil
                                                                                                        cancelButtonTitle:@"OK"
                                                                                                         otherButtonTitles:nil] show];
                                                                                   }
                                                                                   
                                                                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                                                                            animated:YES];
                                                                               }
                                                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                               message:@"Something Wrong. Please contact your developer"
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"OK"
                                                                                                     otherButtonTitles:nil] show];
                                                                               }];
                                                    }];
        [alert addAction:no];
        [alert addAction:yes];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

- (void)getCustomers {
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
    
    if ([[Panachz getInstance] userIsLoggedIn]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof (self) weakSelf = self;
        [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/customers", [Panachz getInstance].user.userId]
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                  
                                  if ([[response objectForKey:@"code"] intValue] == 300) {
                                      NSArray *customersArray = [responseObject objectForKey:@"customers"];
                                      [weakSelf.customers removeAllObjects];
                                      
                                      for (int i = 0; i < customersArray.count; i++) {
                                          NSDictionary *customerJson = [customersArray objectAtIndex:i];
                                          
                                          Customer *c = [[Customer alloc] initWithCustomerId:[[customerJson objectForKey:@"customer_id"] intValue]
                                                                                       email:[customerJson objectForKey:@"email"]
                                                                                       title:[customerJson objectForKey:@"title"]
                                                                                        name:[customerJson objectForKey:@"name"]
                                                                                      street:[customerJson objectForKey:@"address_street"]
                                                                                        city:[customerJson objectForKey:@"address_city"]
                                                                                       state:[customerJson objectForKey:@"address_state"]
                                                                                     country:[customerJson objectForKey:@"address_country"]
                                                                                     zipCode:[customerJson objectForKey:@"address_zipcode"]
                                                                                       telNo:[customerJson objectForKey:@"phone_no"]
                                                                                       notes:[customerJson objectForKey:@"notes"]];
                                          c.outseam = [customerJson objectForKey:@"measurement_outseam"];
                                          c.inseam = [customerJson objectForKey:@"measurement_inseam"];
                                          c.waist = [customerJson objectForKey:@"measurement_waist"];
                                          c.hips = [customerJson objectForKey:@"measurement_hips"];
                                          c.thigh = [customerJson objectForKey:@"measurement_thigh"];
                                          c.curve = [customerJson objectForKey:@"measurement_curve"];
                                          
                                          [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"customer/%lu/orders", c.customerId]
                                                             parameters:nil
                                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                    NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                                                    
                                                                    if ([[response objectForKey:@"code"] intValue] == 100) {
                                                                        NSArray *ordersJson = [responseObject objectForKey:@"orders"];
                                                                        
                                                                        for (NSDictionary *orderJson in ordersJson) {
                                                                            Order *o = [[Order alloc] initWithOrderId:[[orderJson objectForKey:@"order_id"] intValue]
                                                                                                               status:[orderJson objectForKey:@"state"]
                                                                                                             quantity:[[orderJson objectForKey:@"quantity"] intValue] createdDate:[[[orderJson objectForKey:@"timestamp"] componentsSeparatedByString:@" "] firstObject ]
                                                                                                            unitPrice:[[orderJson objectForKey:@"unit_price"] floatValue]];
                                                                            [c.orders addObject:o];
                                                                            [weakSelf.orderTableView reloadData];
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                    
                                                                }];
                                          
                                          [weakSelf.customers addObject:c];
                                      }
                                      
                                      [weakSelf.customerTableView reloadData];
                                      weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                                                      inSection:0];
                                      [weakSelf tableView:weakSelf.customerTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                      [weakSelf.customerTableView selectRowAtIndexPath:selectedIndexPath
                                                                              animated:YES
                                                                        scrollPosition:UITableViewScrollPositionNone];
                                  }
                                  [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                              }];
    } else {
        // TODO: Delete temp data
//        for (int i = 0; i < 40; i++) {
//            NSArray *t = @[@"Mr.", @"Ms.", @"Mrs."];
//            NSArray *c = @[@"China", @"Hong Kong", @"Japan", @"United States", @"United Kingdom"];
//            NSDictionary *client = @{@"Title" : [t objectAtIndex:i % 3],
//                                     @"Name" : [NSString stringWithFormat:@"Client %i", i],
//                                     @"Street" : [NSString stringWithFormat:@"Street %i", i],
//                                     @"City" : [NSString stringWithFormat:@"City %i", i],
//                                     @"State" : [NSString stringWithFormat:@"State %i", i],
//                                     @"Country" :[c objectAtIndex:arc4random() % 5],
//                                     @"ZipCode" : [NSString stringWithFormat:@"12345"],
//                                     @"Email" : [NSString stringWithFormat:@"client-%i-@email.com", i],
//                                     @"Tel" : [NSString stringWithFormat:@"%i", arc4random() % 100000000],
//                                     @"Note" : @"He loves blue",
//                                     @"Outseam" : [NSString stringWithFormat:@"%i.%i", arc4random() % 99 + 1, arc4random() % 8],
//                                     @"Inseam" : [NSString stringWithFormat:@"%i.%i", arc4random() % 99 + 1, arc4random() % 8],
//                                     @"Waist" : [NSString stringWithFormat:@"%i.%i", arc4random() % 99 + 1, arc4random() % 8],
//                                     @"Hips" : [NSString stringWithFormat:@"%i.%i", arc4random() % 99 + 1, arc4random() % 8],
//                                     @"Thigh" : [NSString stringWithFormat:@"%i.%i", arc4random() % 99 + 1, arc4random() % 8],
//                                     @"Orders" : @[@{@"OrderId" : @"LA001", @"Items" : @"3", @"OrderStatus" : @"Shipped", @"CreatedDate" : @"05/06/2014", @"Subtotal" : @"$300"},
//                                                   @{@"OrderId" : @"LA002", @"Items" : @"3", @"OrderStatus" : @"Shipped", @"CreatedDate" : @"05/06/2014", @"Subtotal" : @"$300"},
//                                                   @{@"OrderId" : @"LA003", @"Items" : @"3", @"OrderStatus" : @"Shipped", @"CreatedDate" : @"05/06/2014", @"Subtotal" : @"$300"},
//                                                   @{@"OrderId" : @"LA004", @"Items" : @"3", @"OrderStatus" : @"Shipped", @"CreatedDate" : @"05/06/2014", @"Subtotal" : @"$300"},
//                                                   @{@"OrderId" : @"LA005", @"Items" : @"3", @"OrderStatus" : @"Shipped", @"CreatedDate" : @"05/06/2014", @"Subtotal" : @"$300"},
//                                                   @{@"OrderId" : @"LA006", @"Items" : @"3", @"OrderStatus" : @"Shipped", @"CreatedDate" : @"05/06/2014", @"Subtotal" : @"$300"}]};
//            [self.customers addObject:client];
//        }

    }
}

#pragma mark - Search

- (void)searchCustomer {
    if (self.searchTextField.text.length == 0) {
        [self getCustomers];
        return;
    }
    
    NSString *keyword = self.searchTextField.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"customer/search"
                        parameters:@{@"user_id" : [NSString stringWithFormat:@"%lu", [Panachz getInstance].user.userId],
                                     @"keyword" : keyword}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                               
                               if ([[response objectForKey:@"code"] intValue] == 300 || [[response objectForKey:@"code"] intValue] == 405) {
                                   NSArray *customersArray = [responseObject objectForKey:@"customers"];
                                   [weakSelf.customers removeAllObjects];
                                   
                                   for (int i = 0; i < customersArray.count; i++) {
                                       NSDictionary *customerJson = [customersArray objectAtIndex:i];
                                       
                                       Customer *c = [[Customer alloc] initWithCustomerId:[[customerJson objectForKey:@"customer_id"] intValue]
                                                                                    email:[customerJson objectForKey:@"email"]
                                                                                    title:[customerJson objectForKey:@"title"]
                                                                                     name:[customerJson objectForKey:@"name"]
                                                                                   street:[customerJson objectForKey:@"address_street"]
                                                                                     city:[customerJson objectForKey:@"address_city"]
                                                                                    state:[customerJson objectForKey:@"address_state"]
                                                                                  country:[customerJson objectForKey:@"address_country"]
                                                                                  zipCode:[customerJson objectForKey:@"address_zipcode"]
                                                                                    telNo:[customerJson objectForKey:@"phone_no"]
                                                                                    notes:[customerJson objectForKey:@"notes"]];
                                       c.outseam = [customerJson objectForKey:@"measurement_outseam"];
                                       c.inseam = [customerJson objectForKey:@"measurement_inseam"];
                                       c.waist = [customerJson objectForKey:@"measurement_waist"];
                                       c.hips = [customerJson objectForKey:@"measurement_hips"];
                                       c.thigh = [customerJson objectForKey:@"measurement_thigh"];
                                       c.curve = [customerJson objectForKey:@"measurement_curve"];
                                       
                                       [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"customer/%lu/orders", c.customerId]
                                                          parameters:nil
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                                                 
                                                                 if ([[response objectForKey:@"code"] intValue] == 100) {
                                                                     NSArray *ordersJson = [responseObject objectForKey:@"orders"];
                                                                     
                                                                     for (NSDictionary *orderJson in ordersJson) {
                                                                         Order *o = [[Order alloc] initWithOrderId:[[orderJson objectForKey:@"order_id"] intValue]
                                                                                                            status:[orderJson objectForKey:@"state"]
                                                                                                          quantity:[[orderJson objectForKey:@"quantity"] intValue] createdDate:[[[orderJson objectForKey:@"timestamp"] componentsSeparatedByString:@" "] firstObject ]
                                                                                                         unitPrice:[[orderJson objectForKey:@"unit_price"] floatValue]];
                                                                         [c.orders addObject:o];
                                                                         [weakSelf.orderTableView reloadData];
                                                                     }
                                                                     
                                                                 }
                                                             }
                                                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 
                                                             }];
                                       
                                       [weakSelf.customers addObject:c];
                                   }
                                   
                                   [weakSelf.customerTableView reloadData];
                                   weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                                                   inSection:0];
                                   [weakSelf tableView:weakSelf.customerTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                   [weakSelf.customerTableView selectRowAtIndexPath:selectedIndexPath
                                                                           animated:YES
                                                                     scrollPosition:UITableViewScrollPositionNone];
                               } else {
                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:[response objectForKey:@"message"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] show];
                               }
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"Something Wrong!"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                           }];
}

- (IBAction)cancelSearch:(id)sender {
    [self.searchTextField setText:@""];
    [self.view endEditing:YES];
    [self getCustomers];
}

#pragma mark - Customer Tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView) {
        if (self.customers.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCustomerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        CustomerTableViewCell *cell = (CustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerTableViewCell"];
       
        Customer *client = [self.customers objectAtIndex:indexPath.row];
        [cell.customerNameLabel setText:[NSString stringWithFormat:@"%@ %@", client.title, client.name]];
        [cell.customerTelLabel setText:[NSString stringWithFormat:@"%@", client.telNo]];
        [cell.customerEmailLabel setText:[NSString stringWithFormat:@"%@", client.email]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == self.selectedIndexPath.row) {
            cell.checkViewPosition.constant = 0;
            [cell setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.0
                             animations:^(void){
                                 [cell setBackgroundColor:[UIColor colorWithRBGValue:0xf7f8f8]];
                                 [cell layoutIfNeeded];
                             }];
        } else {
            [cell setUserInteractionEnabled:YES];
            [cell setBackgroundColor:[UIColor colorWithRBGValue:0xffffff]];
        
            cell.checkViewPosition.constant = -40;
            [cell setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.0
                             animations:^(void){
                                 [cell setBackgroundColor:[UIColor colorWithRBGValue:0xffffff]];
                                 [cell layoutIfNeeded];
                             }];
        }
        
        
        return cell;
    } else {
        CustomerOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerOrderTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        Customer *client = [self.customers objectAtIndex:self.selectedIndexPath.row];
        Order *order = [client.orders objectAtIndex:indexPath.row];
        [cell.orderIDLabel setText:[NSString stringWithFormat:@"FA%lu", order.orderId]];
        [cell.itemsLabel setText:[NSString stringWithFormat:@"%lu", order.quantity]];
        [cell.orderStatusLabel setText:order.orderStatus];
        [cell.createdDateLabel setText:order.createdDate];
        [cell.subtotalLabel setText:[NSString stringWithFormat:@"%lu", order.totalPrice]];
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.customerTableView) {
        return self.customers.count == 0 ? 1 : self.customers.count;
    } else {
        if (self.customers != nil && self.customers.count) {
            Customer *client = [self.customers objectAtIndex:self.selectedIndexPath.row];
            return client.orders.count;
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView) {
        return 84.0;
    } else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView && self.customers != nil && self.customers.count > 0) {
        CustomerTableViewCell * cell = (CustomerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setUserInteractionEnabled:NO];
        
        cell.checkViewPosition.constant = 0;
        [cell setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [cell setBackgroundColor:[UIColor colorWithRBGValue:0xf7f8f8]];
                             [cell layoutIfNeeded];
                         }];
        
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        [self.rightSegmentedControl setSelectedSegmentIndex:0];
        self.profileView.hidden = NO;
        self.measurementView.hidden = YES;
        self.orderView.hidden = YES;
        
        [self cancelEditProfile];
        [self cancelEditMeasurement:nil];
        
        Customer *client = [customers objectAtIndex:indexPath.row];
        
        // Profile view
        [self.titleLabel setText:client.title];
        [self.nameTextField setText:client.name];
        [self.streetTextField setText:client.street];
        [self.cityTextField setText:client.city];
        [self.stateTextField setText:client.state];
        [self.countryLabel setText:client.country];
        [self.zipCodeTextField setText:client.zipCode];
        [self.emailTextField setText:client.email];
        [self.telNoTextField setText:client.telNo];
        if ([client.notes isKindOfClass: [NSString class]] && client.notes.length > 0)
        {
            [self.noteTextField setText:client.notes];
        }
        
        // Measuremnet view
        [self.measurementSegmentedControl setSelectedSegmentIndex:0];
        [self.outseamLabel setText:client.outseam];
        [self.InseamLabel setText:client.inseam];
        [self.WaistLabel setText:client.waist];
        [self.HipLabel setText:client.hips];
        [self.thighLabel setText:client.thigh];
        [self.curveMeasurementLabel setText:client.curve];
        self.measurementRotateView.value = [client.outseam floatValue];
        [self.measurementLabel setText:client.outseam];
        
        self.measurementInInch = YES;
        
        self.measurementCMScrollview.hidden = YES;
        self.measurementInchScrollview.hidden = NO;
        
        [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                            forState:UIControlStateNormal];
        [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                              forState:UIControlStateNormal];
        
        NSArray *mArray = [client.outseam componentsSeparatedByString:@"."];
        
        if ([mArray count] == 2)
        {
            self.measurementRotateView.value = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
        }
        else
        {
            self.measurementRotateView.value = [[mArray objectAtIndex:0] doubleValue];
        }
        
        [self updateScrollview];
        CGFloat cm = self.measurementRotateView.value; // in cm
        NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
        cm = [theString floatValue];
        CGFloat measurementValue = cm / 2.54f;
        theString = [NSString stringWithFormat:@"%.4f", measurementValue];
        measurementValue = [theString floatValue];
        int inchNumber = floor(measurementValue);
        int a = (int)((measurementValue - inchNumber) * 8.0f);
        NSString *value = nil;
        if (self.measurementInInch) {
            value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else {
            value = [NSString stringWithFormat:@"%.1f", cm];
        }
        [self.measurementLabel setText:value];
        
        // Order view
        [self.orderTableView reloadData];
    } else if (tableView == self.customerTableView && self.customers.count == 0) {
        [self.rightSegmentedControl setSelectedSegmentIndex:0];
        self.profileView.hidden = NO;
        self.measurementView.hidden = YES;
        self.orderView.hidden = YES;
        
        // Profile view
        [self.titleLabel setText:@"Mr."];
        [self.nameTextField setText:nil];
        [self.streetTextField setText:nil];
        [self.cityTextField setText:nil];
        [self.stateTextField setText:nil];
        [self.countryLabel setText:@"Country"];
        [self.zipCodeTextField setText:nil];
        [self.emailTextField setText:nil];
        [self.telNoTextField setText:nil];
        [self.noteTextField setText:nil];
        
        // Measuremnet view
        [self.measurementSegmentedControl setSelectedSegmentIndex:0];
        [self.outseamLabel setText:@"28.0"];
        [self.InseamLabel setText:@"28.0"];
        [self.WaistLabel setText:@"28.0"];
        [self.HipLabel setText:@"28.0"];
        [self.thighLabel setText:@"28.0"];
        [self.curveMeasurementLabel setText:@"28.0"];
        self.measurementRotateView.value = [@"28.0" floatValue];
        [self.measurementLabel setText:@"28.0"];
        
        self.measurementInInch = YES;
        
        self.measurementCMScrollview.hidden = YES;
        self.measurementInchScrollview.hidden = NO;
        
        [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                            forState:UIControlStateNormal];
        [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                              forState:UIControlStateNormal];
        
        NSArray *mArray = [@"28.0" componentsSeparatedByString:@"."];
        self.measurementRotateView.value = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
        
        [self updateScrollview];
        CGFloat cm = self.measurementRotateView.value; // in cm
        NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
        cm = [theString floatValue];
        CGFloat measurementValue = cm / 2.54f;
        theString = [NSString stringWithFormat:@"%.4f", measurementValue];
        measurementValue = [theString floatValue];
        int inchNumber = floor(measurementValue);
        int a = (int)((measurementValue - inchNumber) * 8.0f);
        NSString *value = nil;
        if (self.measurementInInch) {
            value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else {
            value = [NSString stringWithFormat:@"%.1f", cm];
        }
        [self.measurementLabel setText:value];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView) {
        CustomerTableViewCell * cell = (CustomerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setUserInteractionEnabled:YES];
        
        cell.checkViewPosition.constant = -40;
        [cell setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [cell setBackgroundColor:[UIColor colorWithRBGValue:0xffffff]];
                             [cell layoutIfNeeded];
                         }];
    }
    
    return indexPath;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.streetTextField becomeFirstResponder];
    } else if (textField == self.streetTextField) {
        [self.cityTextField becomeFirstResponder];
    } else if (textField == self.cityTextField) {
        [self.stateTextField becomeFirstResponder];
    } else if (textField == self.stateTextField) {
        [self.stateTextField resignFirstResponder];
        [self openCountryPicker];
    } else if (textField == self.zipCodeTextField) {
        [self.telNoTextField becomeFirstResponder];
    } else if (textField == self.telNoTextField) {
        [self.noteTextField becomeFirstResponder];
    }
    
    if (textField == self.searchTextField) {
        [self searchCustomer];
        [self.searchTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self closeTitlePicker];
    [self closeCountryPicker];
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds
                                                fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds
                                           fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance3 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance3 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance3;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    if (textField == self.searchTextField) {
        textField.placeholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance3;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    if (textField == self.searchTextField) {
        [textField setPlaceholder:@"Search"];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self closeTitlePicker];
    [self closeCountryPicker];
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds
                                                fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds
                                           fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance3 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance3 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance3;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance3;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self closeTitlePicker];
    [self closeCountryPicker];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Tap Action

- (void)openTitlePicker {
    self.titlePickerView.alpha = 0.0;
    self.titlePickerView.hidden = NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.titlePickerView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.titlePickerView becomeFirstResponder];
                         }
                     }];
}

- (void)closeTitlePicker {
    if (!self.titlePickerView.hidden) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.titlePickerView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.titlePickerView resignFirstResponder];
                                 self.titlePickerView.hidden = YES;
                             }
                         }];
    }
}

- (void)openCountryPicker {
    self.countryPickerView.alpha = 0.0;
    self.countryPickerView.hidden = NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.countryPickerView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.countryPickerView becomeFirstResponder];
                         }
                     }];
}

- (void)closeCountryPicker {
    if (!self.countryPickerView.hidden) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.countryPickerView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.countryPickerView resignFirstResponder];
                                 self.countryPickerView.hidden = YES;
                             }
                         }];
    }
}

#pragma mark - UIPickerView Delegate and Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.titlePickerView) {
        return self.titles.count;
    } else if (pickerView == self.countryPickerView) {
        return self.countries.count;
    } else {
        return 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.titlePickerView) {
        return [self.titles objectAtIndex:row];
    } else if (pickerView == self.countryPickerView) {
        return [self.countries objectAtIndex:row];
    } else {
        return @"HI";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.titlePickerView) {
        self.titleLabel.text = [self.titles objectAtIndex:row];
    } else if (pickerView == self.countryPickerView) {
        self.countryLabel.text = [self.countries objectAtIndex:row];
    }
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (IBAction)rightSegmentedControlDidChangeValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.profileView.hidden = NO;
        self.measurementView.hidden = YES;
        self.orderView.hidden = YES;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.profileView.hidden = YES;
        self.measurementView.hidden = NO;
        self.orderView.hidden = YES;
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        self.profileView.hidden = YES;
        self.measurementView.hidden = YES;
        self.orderView.hidden = NO;
    }
}

- (IBAction)startEditProfile:(id)sender {
    if (self.customers.count) {
        self.editProfileButton.hidden = YES;
        self.saveProfileButton.hidden = self.cancelEditProfileButton.hidden = NO;
        
        self.titleLabel.userInteractionEnabled =
        self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = YES;
        
        tempTitle = self.titleLabel.text;
        tempName = self.nameTextField.text;
        tempStreet = self.streetTextField.text;
        tempCity = self.cityTextField.text;
        tempState = self.stateTextField.text;
        tempCountry = self.countryLabel.text;
        tempZipCode = self.zipCodeTextField.text;
        tempTelNo = self.telNoTextField.text;
        tempNotes = self.noteTextField.text;
    }
}

- (IBAction)saveProfile:(id)sender {
    if (self.nameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Name cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.streetTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Street cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.cityTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"City cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.stateTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"State cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if ([self.countryLabel.text isEqualToString:@"Country"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please select a country"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.zipCodeTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Zip Code cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.emailTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Email cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (![self.emailTextField.text isAValidEmail]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter a valid email"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.telNoTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Telephone number cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    self.editProfileButton.hidden = NO;
    self.saveProfileButton.hidden = self.cancelEditProfileButton.hidden = YES;
    
    self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
    [self closeCountryPicker];
    [self closeTitlePicker];
    
    Customer *selectedCustomer = [self.customers objectAtIndex:self.selectedIndexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"customer/set/info"
                        parameters:@{@"customer_id" : [NSString stringWithFormat:@"%lu", selectedCustomer.customerId],
                                     @"email" : self.emailTextField.text,
                                     @"title" : self.titleLabel.text,
                                     @"name" : self.nameTextField.text,
                                     @"phone_no" : self.telNoTextField.text,
                                     @"address_street" : self.streetTextField.text,
                                     @"address_city" : self.cityTextField.text,
                                     @"address_state" : self.stateTextField.text,
                                     @"address_country" : self.countryLabel.text,
                                     @"address_zipcode" : self.zipCodeTextField.text,
                                     @"notes" : self.noteTextField.text}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                               if ([[response objectForKey:@"code"] intValue] == 302) {
                                   selectedCustomer.email = weakSelf.emailTextField.text;
                                   selectedCustomer.title = weakSelf.titleLabel.text;
                                   selectedCustomer.name = weakSelf.nameTextField.text;
                                   selectedCustomer.telNo = weakSelf.telNoTextField.text;
                                   selectedCustomer.street = weakSelf.streetTextField.text;
                                   selectedCustomer.city = weakSelf.cityTextField.text;
                                   selectedCustomer.state = weakSelf.stateTextField.text;
                                   selectedCustomer.country = weakSelf.countryLabel.text;
                                   selectedCustomer.zipCode = weakSelf.zipCodeTextField.text;
                                   selectedCustomer.notes = weakSelf.noteTextField.text;
                                   
                                   [weakSelf.customerTableView reloadData];
                                   [weakSelf tableView:weakSelf.customerTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                   [weakSelf.customerTableView selectRowAtIndexPath:selectedIndexPath
                                                                           animated:YES
                                                                     scrollPosition:UITableViewScrollPositionNone];
                                   
                                   [[[UIAlertView alloc] initWithTitle:@""
                                                               message:@"Customer Updated"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] show];
                               } else {
                                    [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:response[@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil] show];
                               }
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:[NSString stringWithFormat:@"%@", error]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                           }];
}

- (IBAction)cancelEditProfile:(id)sender {
    [self tableView:self.customerTableView didSelectRowAtIndexPath:self.selectedIndexPath];
    [self.customerTableView selectRowAtIndexPath:self.selectedIndexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
    [self cancelEditProfile];
}

- (void)cancelEditProfile {
    self.editProfileButton.hidden = NO;
    self.saveProfileButton.hidden = self.cancelEditProfileButton.hidden = YES;
    
    self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
    
    [self closeCountryPicker];
    [self closeTitlePicker];
}

#pragma mark - Measurement

- (IBAction)startEditMeasurement:(id)sender {
    if (self.customers.count) {
        self.measurementRotateView.enabled = YES;
        self.measurementCMScrollview.userInteractionEnabled = YES;
        self.measurementInchScrollview.userInteractionEnabled = YES;
        self.measurementSlider.enabled = YES;
        
        self.editMeasurementButton.hidden = YES;
        self.saveMeasurementButton.hidden = NO;
        self.cancelEditMeasurementButton.hidden = NO;
    }
}

- (IBAction)saveMeasurement:(id)sender {
    self.measurementRotateView.enabled = NO;
    self.measurementCMScrollview.userInteractionEnabled = NO;
    self.measurementInchScrollview.userInteractionEnabled = NO;
    self.measurementSlider.enabled = NO;
    
    self.editMeasurementButton.hidden = NO;
    self.saveMeasurementButton.hidden = YES;
    self.cancelEditMeasurementButton.hidden = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    Customer *selectedCustomer = [self.customers objectAtIndex:self.selectedIndexPath.row];
    [[PanachzApi getInstance] POST:@"customer/set/measurement"
                        parameters:@{@"customer_id" : [NSString stringWithFormat:@"%lu", selectedCustomer.customerId],
                                     @"measurement_waist" : self.WaistLabel.text,
                                     @"measurement_hips" : self.HipLabel.text,
                                     @"measurement_thigh" : self.thighLabel.text,
                                     @"measurement_inseam" : self.InseamLabel.text,
                                     @"measurement_outseam" : self.outseamLabel.text,
                                     @"measurement_curve" : self.curveMeasurementLabel.text}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = responseObject[@"response"][0];
                               
                               if ([response[@"code"] intValue] == 302) {
                                   selectedCustomer.waist = weakSelf.WaistLabel.text;
                                   selectedCustomer.hips = weakSelf.HipLabel.text;
                                   selectedCustomer.thigh = weakSelf.thighLabel.text;
                                   selectedCustomer.inseam = weakSelf.InseamLabel.text;
                                   selectedCustomer.outseam = weakSelf.outseamLabel.text;
                                   selectedCustomer.curve = weakSelf.curveMeasurementLabel.text;
                                   
                                   [[[UIAlertView alloc] initWithTitle:@""
                                                               message:@"Customer Updated"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] show];
                               } else {
                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:response[@"message"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] show];
                               }
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:[NSString stringWithFormat:@"%@", error]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                           }];
}

- (IBAction)cancelEditMeasurement:(id)sender {
    self.measurementRotateView.enabled = NO;
    self.measurementCMScrollview.userInteractionEnabled = NO;
    self.measurementInchScrollview.userInteractionEnabled = NO;
    self.measurementSlider.enabled = NO;
    
    self.editMeasurementButton.hidden = NO;
    self.saveMeasurementButton.hidden = YES;
    self.cancelEditMeasurementButton.hidden = YES;
    
    Customer *selectedCustomer = [self.customers objectAtIndex:self.selectedIndexPath.row];
    
    [self.outseamLabel setText:selectedCustomer.outseam];
    [self.InseamLabel setText:selectedCustomer.inseam];
    [self.WaistLabel setText:selectedCustomer.waist];
    [self.HipLabel setText:selectedCustomer.hips];
    [self.thighLabel setText:selectedCustomer.thigh];
    [self.curveMeasurementLabel setText:selectedCustomer.curve];
    
    NSArray *mArray = nil;
    
    switch (self.measurementSegmentedControl.selectedSegmentIndex) {
        case 0:
            mArray = [self.outseamLabel.text componentsSeparatedByString:@"."];
            break;
        case 1:
            mArray = [self.InseamLabel.text componentsSeparatedByString:@"."];
            break;
        case 2:
            mArray = [self.WaistLabel.text componentsSeparatedByString:@"."];
            break;
        case 3:
            mArray = [self.HipLabel.text componentsSeparatedByString:@"."];
            break;
        case 4:
            mArray = [self.thighLabel.text componentsSeparatedByString:@"."];
        default:
            break;
    }
    if ([mArray count] == 2)
    {
        self.measurementRotateView.value = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
    }
    else
    {
        self.measurementRotateView.value = [[mArray objectAtIndex: 0] doubleValue];
    }
    
    [self updateScrollview];
    CGFloat cm = self.measurementRotateView.value; // in cm
    NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
    cm = [theString floatValue];
    CGFloat measurementValue = cm / 2.54f;
    theString = [NSString stringWithFormat:@"%.4f", measurementValue];
    measurementValue = [theString floatValue];
    int inchNumber = floor(measurementValue);
    int a = (int)((measurementValue - inchNumber) * 8.0f);
    NSString *value = nil;
    if (self.measurementInInch) {
        value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
    } else {
        value = [NSString stringWithFormat:@"%.1f", cm];
    }
    [self.measurementLabel setText:value];
}

- (IBAction)switchToInchOrCM:(id)sender {
    if (sender == self.cmButton) {
        self.measurementInInch = NO;
        
        self.measurementCMScrollview.hidden = NO;
        self.measurementInchScrollview.hidden = YES;
        
        [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                            forState:UIControlStateNormal];
        [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                              forState:UIControlStateNormal];
    } else {
        self.measurementInInch = YES;
        
        self.measurementCMScrollview.hidden = YES;
        self.measurementInchScrollview.hidden = NO;
        
        [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                            forState:UIControlStateNormal];
        [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                              forState:UIControlStateNormal];
    }
    
    CGFloat cm = self.measurementRotateView.value; // in cm
    NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
    cm = [theString floatValue];
    CGFloat measurementValue = cm / 2.54f;
    theString = [NSString stringWithFormat:@"%.4f", measurementValue];
    measurementValue = [theString floatValue];
    int inchNumber = floor(measurementValue);
    int a = (int)((measurementValue - inchNumber) * 8.0f);
    NSString *value = nil;
    if (self.measurementInInch) {
        value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
    } else {
        value = [NSString stringWithFormat:@"%.1f", cm];
    }
    [self.measurementLabel setText:value];
    
    [self updateScrollview];
}

- (IBAction)rotaryKnobDidChange {
    CGFloat cm = self.measurementRotateView.value; // in cm
    NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
    cm = [theString floatValue];
    CGFloat measurementValue = cm / 2.54f;
    theString = [NSString stringWithFormat:@"%.4f", measurementValue];
    measurementValue = [theString floatValue];
    int inchNumber = floor(measurementValue);
    int a = (int)((measurementValue - inchNumber) * 8.0f);
    NSString *value = nil;
    if (self.measurementInInch) {
        value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
    } else {
        value = [NSString stringWithFormat:@"%.1f", cm];
    }
    [self.measurementLabel setText:value];
    
    switch (self.measurementSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.outseamLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            break;
        case 1:
            [self.InseamLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            break;
        case 2:
            [self.WaistLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            break;
        case 3:
            [self.HipLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            break;
        case 4:
            [self.thighLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            break;
        case 5:
            [self.curveMeasurementLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            break;
        default:
            break;
    }
    
    //TODO: Find how to set content offset
    [self updateScrollview];
}

- (IBAction)measurementSegmentedControlDidChangeValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    NSArray *mArray = nil;
    if (segmentedControl.selectedSegmentIndex == 0) {
        mArray = [self.outseamLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.outseamLabel.text];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        mArray = [self.InseamLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.InseamLabel.text];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        mArray = [self.WaistLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.WaistLabel.text];
    } else if (segmentedControl.selectedSegmentIndex == 3) {
        mArray = [self.HipLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.HipLabel.text];
    } else if (segmentedControl.selectedSegmentIndex == 4) {
        mArray = [self.thighLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.thighLabel.text];
    } else if (segmentedControl.selectedSegmentIndex == 5) {
        mArray = [self.curveMeasurementLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.curveMeasurementLabel.text];
    }
    
    self.measurementRotateView.value = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
    [self updateScrollview];
}

- (void)setupInchScrollview {
    self.measurementInchScrollview.delegate = self;
    self.measurementInchScrollview.showsVerticalScrollIndicator = NO;
    self.measurementInchScrollview.contentSize = CGSizeMake(153 * 100 + 100, 80);
    
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 50.5, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementInchScrollview addSubview:padding];
    
    padding = [[UIView alloc] initWithFrame:CGRectMake(153 * 100 + 57, 15, 43, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementInchScrollview addSubview:padding];
    
    for (int i = 0; i < 100; i++) {
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(i * 153 + 50, 15, 153.5, 80)];
        im.backgroundColor = [UIColor clearColor];
        [im setImage:[UIImage imageNamed:@"size_inch_customer"]];
        [self.measurementInchScrollview addSubview:im];
    }
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(100 * 153 + 50, 15, 7, 80)];
    im.backgroundColor = [UIColor clearColor];
    [im setImage:[UIImage imageNamed:@"size_inch_customer_placeholder"]];
    [self.measurementInchScrollview addSubview:im];
    
    for (int i = 0; i < 101; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i * 153 + 50 - 15, 45, 30, 30)];
        [l setText:[NSString stringWithFormat:@"%i", i]];
        l.textAlignment = NSTextAlignmentCenter;
        [l setBackgroundColor:[UIColor clearColor]];
        [self.measurementInchScrollview addSubview:l];
    }
}

- (void)setupCMScrollview {
    self.measurementCMScrollview.delegate = self;
    self.measurementCMScrollview.showsVerticalScrollIndicator = NO;
    self.measurementCMScrollview.contentSize = CGSizeMake(60 * 254 + 100, 80);
    
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 50.5, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementCMScrollview addSubview:padding];
    
    padding = [[UIView alloc] initWithFrame:CGRectMake(254 * 60 + 54, 15, 46, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementCMScrollview addSubview:padding];
    
    for (int i = 0; i < 254; i++) {
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(i * 60 + 50, 15, 60, 80)];
        im.backgroundColor = [UIColor clearColor];
        [im setImage:[UIImage imageNamed:@"size_cm_customer"]];
        [self.measurementCMScrollview addSubview:im];
    }
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(254 * 60 + 50, 15, 4, 80)];
    im.backgroundColor = [UIColor clearColor];
    [im setImage:[UIImage imageNamed:@"size_cm_customer_placeholder"]];
    [self.measurementCMScrollview addSubview:im];
    
    for (int i = 0; i < 255; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i * 60 + 50 - 15, 45, 30, 30)];
        [l setText:[NSString stringWithFormat:@"%i", i]];
        l.textAlignment = NSTextAlignmentCenter;
        [l setBackgroundColor:[UIColor clearColor]];
        [self.measurementCMScrollview addSubview:l];
    }
}

- (void)sliderChanged:(UISlider *)sender {
    [self calculateSize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self calculateSize];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self calculateSize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self calculateSize];
}

- (void)calculateSize {
    if (self.measurementInInch) {
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        NSString *measurementValue = @"0.0";
        
        measurementValue = [NSString stringWithFormat:@"%.1f", (sliderValueToPixels + self.measurementInchScrollview.contentOffset.x - 50) / 19.125f];
        int numberInch = [measurementValue intValue] / 8;
        int a = [measurementValue intValue] - numberInch * 8;
        
        if (a < 0) {
            measurementValue = @"0.0";
        } else if (numberInch == 100) {
            measurementValue = @"100.0";
        } else {
            measurementValue = [NSString stringWithFormat:@"%d.%d", numberInch, a];
        }
        
        self.measurementRotateView.value = (numberInch + a * 0.125) * 2.54f;
        [self.measurementLabel setText:measurementValue];
    } else {
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        NSString *measurementValue = @"0.0";
        
        measurementValue = [NSString stringWithFormat:@"%.1f", (sliderValueToPixels + self.measurementCMScrollview.contentOffset.x - 50) / 6];
        int numberCm = [measurementValue intValue] / 10;
        int a = [measurementValue intValue] - numberCm * 10;
        
        if (a < 0) {
            measurementValue = @"0.0";
        } else if (numberCm == 254) {
            measurementValue = @"254.0";
        } else {
            measurementValue = [NSString stringWithFormat:@"%d.%d", numberCm, a];
        }
        
        self.measurementRotateView.value = [measurementValue floatValue];
        [self.measurementLabel setText:measurementValue];
    }
    
    float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
    float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
    float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
    
    NSString *measurementValue = @"0.0";
    
    measurementValue = [NSString stringWithFormat:@"%.1f", (sliderValueToPixels + self.measurementInchScrollview.contentOffset.x - 50) / 19.125f];
    int numberInch = [measurementValue intValue] / 8;
    int a = [measurementValue intValue] - numberInch * 8;
    
    if (a < 0) {
        measurementValue = @"0.0";
    } else if (numberInch == 100) {
        measurementValue = @"100.0";
    } else {
        measurementValue = [NSString stringWithFormat:@"%d.%d", numberInch, a];
    }

    switch (self.measurementSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.outseamLabel setText:measurementValue];
            break;
        case 1:
            [self.InseamLabel setText:measurementValue];
            break;
        case 2:
            [self.WaistLabel setText:measurementValue];
            break;
        case 3:
            [self.HipLabel setText:measurementValue];
            break;
        case 4:
            [self.thighLabel setText:measurementValue];
            break;
        case 5:
            [self.curveMeasurementLabel setText:measurementValue];
            break;
        default:
            break;
    }
}

- (void)updateScrollview {
    CGFloat cm = self.measurementRotateView.value; // in cm
    CGFloat measurementValue = cm / 2.54;
    
    if (measurementValue > 98.625) {
        CGPoint offset = self.measurementInchScrollview.contentOffset;
        offset.x = 153 * 97.25 + 50;
        
        self.measurementSlider.value = 0.5 + 1 - 0.04 * (100 - measurementValue);
    } else if (measurementValue <= 1.25) {
        CGPoint offset = self.measurementInchScrollview.contentOffset;
        offset.x = 0;
        [self.measurementInchScrollview setContentOffset:offset];
        
        self.measurementSlider.value = 0.09 + 0.3 * measurementValue;
    } else {
        self.measurementSlider.value = 0.5;
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        CGPoint offset = self.measurementInchScrollview.contentOffset;
        offset.x = 50 + 153 * measurementValue - sliderValueToPixels;
        [self.measurementInchScrollview setContentOffset:offset];
    }
    
    if (cm < 3.5) {
        
    } else if (cm > 250.5) {
    
    } else {
        self.measurementSlider.value = 0.5;
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        CGPoint offset = self.measurementCMScrollview.contentOffset;
        offset.x = 50 + 60 * cm - sliderValueToPixels;
        [self.measurementCMScrollview setContentOffset:offset];
    }
}

@end
