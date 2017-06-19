//
//  ChooseCustomerViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ChooseCustomerViewController.h"
#import "CustomerOrderTableViewCell.h"
#import "ChooseCustomerTableViewCell.h"
#import "MBProgressHUD.h"
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

@interface ChooseCustomerViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *tempClient;
@property (strong, nonatomic) NSMutableArray *customers;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic) BOOL measurementInInch;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *countries;
@end

@implementation ChooseCustomerViewController

@synthesize ccDelegate;
@synthesize customers;

CGFloat animatedDistance9;

@synthesize tempClient;
@synthesize selectedIndexPath;

@synthesize designTab;
@synthesize customerTab;
@synthesize orderTab;

@synthesize searchView;

@synthesize customerTableView;

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
@synthesize curveMeasurementLabel;
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
    
    // Setup navigation bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self navigationController].navigationBar.barTintColor = [UIColor colorWithRBGValue:0xf8f8f8];
    
    UIImageView *panachzLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 164, 28.7)];
    //panachzLogo.contentMode = UIViewContentModeScaleAspectFill;
    //panachzLogo.clipsToBounds = YES;
    [panachzLogo setImage:[UIImage imageNamed:@"panachz_logo"]];
    self.navigationItem.titleView = panachzLogo;
    
    // Setup Left navigation bar item
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 24, 24)];
    [menuImage setImage:[UIImage imageNamed:@"ic_menu_black_48dp"]];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addSubview:menuImage];
    menuButton.frame = CGRectMake(0, 0, 24, 24);
    UIBarButtonItem *navigationBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = navigationBarMenuButton;
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    // Setup tab bar
    self.designTab.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.designTab.layer.borderWidth = 1.0;
    
    self.customerTab.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.customerTab.layer.borderWidth = 1.0;
    
    self.orderTab.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.orderTab.layer.borderWidth = 1.0;
    
    // Search View
    self.searchView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.searchView.layer.borderWidth = 1.0;
    
    // Customer table view
    self.customerTableView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.customerTableView.layer.borderWidth = 1.0;
    self.customerTableView.delegate = self;
    self.customerTableView.dataSource = self;
    self.customerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
    self.telNoTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.telNoTextField.leftView = leftPadding;
    self.telNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.emailTextField.leftView = leftPadding;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
//    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self tableView:self.customerTableView didSelectRowAtIndexPath:selectedIndexPath];
//    [self.customerTableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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

#pragma mark - UITableview Datasource and Delegate

- (IBAction)didChooseCustomer:(id)sender {
    if (customers.count) {
        Customer *customer = [self.customers objectAtIndex:self.selectedIndexPath.row];
        [self.ccDelegate didChooseCustomer:customer];
    }

    [[self navigationController] popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView) {
        if (self.customers.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoCustomerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        ChooseCustomerTableViewCell *cell = (ChooseCustomerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChooseCustomerTableViewCell" forIndexPath:indexPath];
        
        Customer *client = [self.customers objectAtIndex:indexPath.row];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@", client.title, client.name]];
        [cell.telLabel setText:[NSString stringWithFormat:@"%@", client.telNo]];
        [cell.emailLabel setText:[NSString stringWithFormat:@"%@", client.email]];
        
        for (UIGestureRecognizer *r in cell.createOrderView.gestureRecognizers) {
            [cell.createOrderView removeGestureRecognizer:r];
        }
        
        [cell.createButton addTarget:self
                              action:@selector(didChooseCustomer:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == self.selectedIndexPath.row) {
            cell.checkPosition.constant = 0;
            cell.createOrderPosition.constant = 0;
            [cell setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.0
                             animations:^(void){
                                 [cell setBackgroundColor:[UIColor colorWithRBGValue:0xf7f8f8]];
                                 [cell layoutIfNeeded];
                             }];
        } else {
            [cell setUserInteractionEnabled:YES];
            [cell setBackgroundColor:[UIColor colorWithRBGValue:0xffffff]];
            
            cell.checkPosition.constant = -40;
            cell.createOrderPosition.constant = -90;
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
        
        if (self.customers == nil || self.customers.count == 0) {
            return cell;
        }
        
        Customer *client = [self.customers objectAtIndex:self.selectedIndexPath.row];
        NSLog(@"%@ %lu %lu", client.name, client.orders.count, indexPath.row);
        Order *order = [client.orders objectAtIndex:indexPath.row];
        [cell.orderIDLabel setText:[NSString stringWithFormat:@"%lu", order.orderId]];
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
        return 85.0;
    } else {
        return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView) {
        ChooseCustomerTableViewCell * cell = (ChooseCustomerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        [cell setUserInteractionEnabled:NO];
        
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
        
        if (client.notes && [client.notes isKindOfClass: [NSString class]] && client.notes.length)
        {
            [self.noteTextField setText: client.notes];
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
        if (mArray.count ==2)
        {
        self.measurementRotateView.value = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
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
        
        [self.rightSegmentedControl setSelectedSegmentIndex:0];
        
        if (indexPath.row == self.selectedIndexPath.row) {
            return;
        }
        
        self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        // Orders
        [self.orderTableView reloadData];
        
        cell.checkPosition.constant = 0;
        cell.createOrderPosition.constant = 0;
       
        [cell setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [cell setBackgroundColor:[UIColor colorWithRBGValue:0xf7f8f8]];
                             [cell layoutIfNeeded];
                         }];
        
        self.profileView.hidden = NO;
        self.measurementView.hidden = YES;
        self.orderView.hidden = YES;
        
        [self cancelEditProfile];
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.customerTableView) {
        ChooseCustomerTableViewCell * cell = (ChooseCustomerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setUserInteractionEnabled:YES];
        
        cell.checkPosition.constant = -40;
        cell.createOrderPosition.constant = -90;
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
        animatedDistance9 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance9 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance9;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance9;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
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
        animatedDistance9 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance9 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance9;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance9;
    
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
    self.editProfileButton.hidden = YES;
    self.saveProfileButton.hidden = self.cancelEditProfileButton.hidden = NO;
    
    self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = YES;
}

- (IBAction)saveProfile:(id)sender {
    self.editProfileButton.hidden = NO;
    self.saveProfileButton.hidden = self.cancelEditProfileButton.hidden = YES;
    
    self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
}

- (IBAction)cancelEditProfile:(id)sender {
    [self cancelEditProfile];
}

- (void)cancelEditProfile {
    self.editProfileButton.hidden = NO;
    self.saveProfileButton.hidden = self.cancelEditProfileButton.hidden = YES;
    
    self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
}

#pragma mark - Measurement

- (IBAction)startEditMeasurement:(id)sender {
    self.measurementRotateView.enabled = YES;
    self.measurementCMScrollview.userInteractionEnabled = YES;
    self.measurementInchScrollview.userInteractionEnabled = YES;
    
    self.editMeasurementButton.hidden = YES;
    self.saveMeasurementButton.hidden = NO;
    self.cancelEditMeasurementButton.hidden = NO;
}

- (IBAction)saveMeasurement:(id)sender {
    self.measurementRotateView.enabled = NO;
    self.measurementCMScrollview.userInteractionEnabled = NO;
    self.measurementInchScrollview.userInteractionEnabled = NO;
    
    self.editMeasurementButton.hidden = NO;
    self.saveMeasurementButton.hidden = YES;
    self.cancelEditMeasurementButton.hidden = YES;
}

- (IBAction)cancelEditMeasurement:(id)sender {
    self.measurementRotateView.enabled = NO;
    self.measurementCMScrollview.userInteractionEnabled = NO;
    self.measurementInchScrollview.userInteractionEnabled = NO;
    
    self.editMeasurementButton.hidden = NO;
    self.saveMeasurementButton.hidden = YES;
    self.cancelEditMeasurementButton.hidden = YES;
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
