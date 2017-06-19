//
//  OrderViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 20/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderJeansPreviewScreenViewController.h"
#import "Order.h"
#import "MasterViewController.h"
#import "MBProgressHUD.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import "Reachability.h"
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"
#import "UIImageView+AFNetworking.h"

@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *tempSales;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation OrderViewController

@synthesize orders;
@synthesize tempSales;
@synthesize selectedIndexPath;

@synthesize searchView;
@synthesize searchTextField;
@synthesize orderTableView;
@synthesize orderIDLabel;
@synthesize statusLabel;
@synthesize previewImageView;
@synthesize descriptionTeextView;
@synthesize waistSizeLabel;
@synthesize hipsSizeLabel;
@synthesize thighSizeLabel;
@synthesize inseamSizeLabel;
@synthesize outseamLabel;
@synthesize curvSizeLabel;
@synthesize quantityLabel;
@synthesize unitPriceLabel;
@synthesize totalPriceLabel;
@synthesize contactPersonNameLabel;
@synthesize contactPersonEmailLabel;
@synthesize contactPersonTelNoLabel;
@synthesize shippingAddresLabel;
@synthesize trackingNoLabel;
@synthesize mailOutDateLabel;
@synthesize noteTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *status = @[@"Shipped", @"Not Submitted"];
    
    // Setup Temp record
    self.tempSales = [[NSMutableArray alloc] init];
    for (int i = 0; i < 40; i++) {
        NSDictionary *order = @{@"OrderID" : [NSString stringWithFormat:@"LA0%i", i],
                                @"CustomerName" : [NSString stringWithFormat:@"Client %i", i],
                                @"Status" : [status objectAtIndex:arc4random() % 2],
                                @"Date" : @"05/06/2014"};
        [self.tempSales addObject:order];
    }
    
    // Search
    self.searchView.layer.borderWidth = 1.0;
    self.searchView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.searchTextField.delegate = self;
    
    self.noteTextView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.noteTextView.layer.borderWidth = 1.0;
    self.noteTextView.textContainerInset = UIEdgeInsetsMake(10, 6, 10, 6);
    self.noteTextView.editable = NO;
    
    // Setup Tableview
    self.orderTableView.dataSource = self;
    self.orderTableView.delegate = self;
    self.orderTableView.layer.borderWidth = 1.0;
    self.orderTableView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Preivew Image
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(previewJeans)];
    [tap setNumberOfTapsRequired:1];
    [self.previewImageView setUserInteractionEnabled:YES];
    [self.previewImageView addGestureRecognizer:tap];
    
    self.orders = [[NSMutableArray alloc] init];
    [self getOrders];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewJeans"]) {
        OrderJeansPreviewScreenViewController *vc = (OrderJeansPreviewScreenViewController *)segue.destinationViewController;
        Order *order = [self.orders objectAtIndex:self.selectedIndexPath.row]
        ;
        vc.frontPreivewUrl = order.jeansFrontPreviewUrl;
        vc.backPreviewUrl = order.jeansBackPreviewUrl;
    }
}

- (void)previewJeans {
    if (self.orders.count) {
        [self performSegueWithIdentifier:@"PreviewJeans" sender:nil];
    }
}

#pragma mark - Search Order

- (void)searchOrders {
    if (self.searchTextField.text.length == 0) {
        [self getOrders];
        return;
    }
    
    NSString *keywords = self.searchTextField.text;
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"orders/search"
                        parameters:@{@"user_id" : [NSString stringWithFormat:@"%lu", [Panachz getInstance].user.userId],
                                     @"keyword" : keywords}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                               
                               if ([[response objectForKey:@"code"] intValue] == 100 || [[response objectForKey:@"code"] intValue] == 406) {
                                   NSArray *ordersArray = [responseObject objectForKey:@"orders"];
                                   [weakSelf.orders removeAllObjects];
                                   
                                   for (int i = 0; i < ordersArray.count; i++) {
                                       NSDictionary *orderJson = [ordersArray objectAtIndex:i];
                                       
                                       Order *order = [[Order alloc] initWithOrderId:[[orderJson objectForKey:@"order_id"] intValue]
                                                                              status:[orderJson objectForKey:@"state"]
                                                                     jeansPreviewUrl:[orderJson objectForKey:@"item_image_url"]
                                                                jeansFrontPreviewUrl:[orderJson objectForKey:@"item_front_preview_url"]
                                                                 jeansBackPreivewUrl:[orderJson objectForKey:@"item_back_preview_url"]
                                                                    jeansDescription:[orderJson objectForKey:@"item_detail"]
                                                                               waist:[orderJson objectForKey:@"measurement_waist"]
                                                                                hips:[orderJson objectForKey:@"measurement_hips"]
                                                                               thigh:[orderJson objectForKey:@"measurement_thigh"]
                                                                              inseam:[orderJson objectForKey:@"measurement_inseam"]
                                                                             outseam:[orderJson objectForKey:@"measurement_outseam"]
                                                                               curve:[orderJson objectForKey:@"measurement_curve"]
                                                                            quantity:[[orderJson objectForKey:@"quantity"] intValue]
                                                                           unitPrice:[[orderJson objectForKey:@"unit_price"] intValue]
                                                                       contactPerson:[orderJson objectForKey:@"contact_person"]
                                                                        contactEmail:[orderJson objectForKey:@"contact_email"]
                                                                        contactTelNo:[orderJson objectForKey:@"contact_tel_no"]
                                                                              street:[orderJson objectForKey:@"address_street"]
                                                                                city:[orderJson objectForKey:@"address_city"]
                                                                               state:[orderJson objectForKey:@"address_state"]
                                                                             country:[orderJson objectForKey:@"address_country"]
                                                                             zipCode:[orderJson objectForKey:@"address_zipcode"]
                                                                          trackingNo:[[orderJson objectForKey:@"tracking_no"] intValue]
                                                                         createdDate:[orderJson objectForKey:@"timestamp"]
                                                                         mailOutDate:[orderJson objectForKey:@"mail_out_date"]
                                                                               notes:[orderJson objectForKey:@"note"]];
                                       
                                       [weakSelf.orders addObject:order];
                                   }
                                   
                                   [weakSelf.orderTableView reloadData];
                                   weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                                                   inSection:0];
                                   [weakSelf tableView:weakSelf.orderTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                   [weakSelf.orderTableView selectRowAtIndexPath:selectedIndexPath
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
                                                           message:[NSString stringWithFormat:@"%@", error]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                           }];
}

- (void)getOrders {
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
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders", [Panachz getInstance].user.userId]
                       parameters:nil
                          success:^(NSURLSessionTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                              
                              if ([[response objectForKey:@"code"] intValue] == 100 || [[response objectForKey:@"code"] intValue] == 406) {
                                  NSArray *ordersArray = [responseObject objectForKey:@"orders"];
                                  [weakSelf.orders removeAllObjects];
                                  
                                  for (int i = 0; i < ordersArray.count; i++) {
                                      NSDictionary *orderJson = [ordersArray objectAtIndex:i];
                                      
                                      Order *order = [[Order alloc] initWithOrderId:[[orderJson objectForKey:@"order_id"] intValue]
                                                                             status:[orderJson objectForKey:@"state"]
                                                                    jeansPreviewUrl:[orderJson objectForKey:@"item_image_url"]
                                                               jeansFrontPreviewUrl:[orderJson objectForKey:@"item_front_preview_url"]
                                                                jeansBackPreivewUrl:[orderJson objectForKey:@"item_back_preview_url"]
                                                                   jeansDescription:[orderJson objectForKey:@"item_detail"]
                                                                              waist:[orderJson objectForKey:@"measurement_waist"]
                                                                               hips:[orderJson objectForKey:@"measurement_hips"]
                                                                              thigh:[orderJson objectForKey:@"measurement_thigh"]
                                                                             inseam:[orderJson objectForKey:@"measurement_inseam"]
                                                                            outseam:[orderJson objectForKey:@"measurement_outseam"]
                                                                              curve:[orderJson objectForKey:@"measurement_curve"]
                                                                           quantity:[[orderJson objectForKey:@"quantity"] intValue]
                                                                          unitPrice:[[orderJson objectForKey:@"unit_price"] intValue]
                                                                      contactPerson:[orderJson objectForKey:@"contact_person"]
                                                                       contactEmail:[orderJson objectForKey:@"contact_email"]
                                                                       contactTelNo:[orderJson objectForKey:@"contact_tel_no"]
                                                                             street:[orderJson objectForKey:@"address_street"]
                                                                               city:[orderJson objectForKey:@"address_city"]
                                                                              state:[orderJson objectForKey:@"address_state"]
                                                                            country:[orderJson objectForKey:@"address_country"]
                                                                            zipCode:[orderJson objectForKey:@"address_zipcode"]
                                                                         trackingNo:[[orderJson objectForKey:@"tracking_no"] intValue]
                                                                        createdDate:[orderJson objectForKey:@"timestamp"]
                                                                        mailOutDate:[orderJson objectForKey:@"mail_out_date"]
                                                                              notes:[orderJson objectForKey:@"note"]];
                                      
                                      [weakSelf.orders addObject:order];
                                  }
                                  
                                  [weakSelf.orderTableView reloadData];
                                  weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                                                  inSection:0];
                                  
                                  [weakSelf tableView:weakSelf.orderTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                  [weakSelf.orderTableView selectRowAtIndexPath:selectedIndexPath
                                                                          animated:YES
                                                                    scrollPosition:UITableViewScrollPositionNone];
                              }
                              
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
                          }
                          failure:^(NSURLSessionTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] show];
                              
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                          }];
}

- (IBAction)deleteCustomer:(id)sender {
    if (self.orders.count) {
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
                                                                       message:@"Are you sure to delete this order?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
        __weak typeof (self) weakSelf = self;
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction *action) {
                                                        [MBProgressHUD showHUDAddedTo:weakSelf.view
                                                                             animated:YES];
                                                        
                                                        Order *selectedOrder = [weakSelf.orders objectAtIndex:weakSelf.selectedIndexPath.row];
                                                        [[PanachzApi getInstance] POST:@"orders/delete"
                                                                            parameters:@{@"order_id" : [NSString stringWithFormat:@"%lu", selectedOrder.orderId]}
                                                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                   NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                                                                   
                                                                                   if ([[response objectForKey:@"code"] intValue] == 104) {
                                                                                       [weakSelf.orders removeObject:selectedOrder];
                                                                                       [weakSelf.orderTableView reloadData];
                                                                                       weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:0
                                                                                                                                       inSection:0];
                                                                                       [weakSelf tableView:weakSelf.orderTableView didSelectRowAtIndexPath:weakSelf.selectedIndexPath];
                                                                                       [weakSelf.orderTableView selectRowAtIndexPath:weakSelf.selectedIndexPath
                                                                                                                            animated:YES
                                                                                                                      scrollPosition:UITableViewScrollPositionNone];
                                                                                       [[[UIAlertView alloc] initWithTitle:@""
                                                                                                                   message:@"Order Deleted"
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
                                                                                                               message:[NSString stringWithFormat:@"%@", error]
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"OK"
                                                                                                     otherButtonTitles:nil] show];
                                                                               }];
                                                        
                                                    }];
        [alert addAction:no];
        [alert addAction:yes];
        
        [self presentViewController:alert
                           animated:yes
                         completion:nil];
    }
}

- (IBAction)cancelSearch:(id)sender {
    [self.searchTextField setText:@""];
    [self getOrders];
}

- (IBAction)addOrder:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddOrder"
                                                        object:nil];
}

- (IBAction)viewProfile:(id)sender {
    if (self.orders != nil && self.orders.count > 0) {
        Order *selectedOrder = [self.orders objectAtIndex:self.selectedIndexPath.row];
        NSDictionary *userInfo = @{@"name" : selectedOrder.contactPerson,
                                   @"email" : selectedOrder.contactEmail,
                                   @"tel" : selectedOrder.contactTelNo};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewProfile"
                                                            object:nil
                                                          userInfo:userInfo];
    }
//    NSDictionary *userInfo = @{@"email" : };
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count == 0 ? 1 : self.orders.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orders == nil || self.orders.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoOrderCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.selectedIndexPath.row) {
        cell.checkPosition.constant = 0;
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
        [cell setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.0
                         animations:^(void){
                             [cell setBackgroundColor:[UIColor colorWithRBGValue:0xffffff]];
                             [cell layoutIfNeeded];
                         }];
    }
    
    Order *order = [self.orders objectAtIndex:indexPath.row];
    [cell.orderIDLabel setText:[NSString stringWithFormat:@"FA%lu", order.orderId]];
    [cell.customerNameLabel setText:order.contactPerson];
    [cell.descriptionLabel setText:[NSString stringWithFormat:@"%lu Jeans ($%lu)", order.quantity, order.unitPrice]];
    [cell.statusLabel setText:order.orderStatus];
    [cell.mailOutDateLabel setText:order.createdDate];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orders.count == 0) {
        [self.orderIDLabel setText:@"Order ID"];
        [self.statusLabel setText:@"01/01/1970 | Not Submitted"];
        [self.previewImageView setImage:nil];
        [self.descriptionTeextView setText:@"Jeans Description"];
        [self.waistSizeLabel setText:@":0.0\""];
        [self.hipsSizeLabel setText:@":0.0\""];
        [self.thighSizeLabel setText:@":0.0\""];
        [self.inseamSizeLabel setText:@":0.0\""];
        [self.outseamLabel setText:@":0.0\""];
        [self.curvSizeLabel setText:@":0.0\""];
        [self.quantityLabel setText:@"Qunatity"];
        [self.unitPriceLabel setText:@"$0"];
        [self.totalPriceLabel setText:@"$0"];
        [self.contactPersonNameLabel setText:@"Contact Person"];
        [self.contactPersonEmailLabel setText:@"Contact Email"];
        [self.contactPersonTelNoLabel setText:@"Contact Telephone No"];
        [self.shippingAddresLabel setText:@"Shipping Address"];
        [self.trackingNoLabel setText:@"0000000000"];
        [self.mailOutDateLabel setText:@"01/01/1970"];
        [self.noteTextView setText:@"Notes"];
        
        UIFont *font = [UIFont fontWithName:@"Roboto-Thin" size:14.0];
        [self.descriptionTeextView setFont:font];
        [self.descriptionTeextView setTextColor:[UIColor colorWithRBGValue:0x444444]];
        self.descriptionTeextView.editable = NO;
        return;
    }
    
    OrderTableViewCell *cell = (OrderTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setUserInteractionEnabled:NO];
    
    cell.checkPosition.constant = 0;
    [cell setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [cell setBackgroundColor:[UIColor colorWithRBGValue:0xf7f8f8]];
                         [cell layoutIfNeeded];
                     }];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *today = [[NSDate alloc] init];
    
    Order *order = [self.orders objectAtIndex:indexPath.row];
    [self.orderIDLabel setText:[NSString stringWithFormat:@"FA%lu", order.orderId]];
    [self.statusLabel setText:[NSString stringWithFormat:@"%@ | %@", [dateFormatter stringFromDate:today], order.orderStatus]];
    [self.previewImageView setImageWithURL:[NSURL URLWithString:order.jeansPreviewUrl]];
    [self.descriptionTeextView setText:order.jeansDescription];
    [self.waistSizeLabel setText:[NSString stringWithFormat:@":%@", order.waist]];
    [self.hipsSizeLabel setText:[NSString stringWithFormat:@":%@", order.hips]];
    [self.thighSizeLabel setText:[NSString stringWithFormat:@":%@", order.thigh]];
    [self.inseamSizeLabel setText:[NSString stringWithFormat:@":%@", order.inseam]];
    [self.outseamLabel setText:[NSString stringWithFormat:@":%@", order.outseam]];
    [self.curvSizeLabel setText:[NSString stringWithFormat:@":%@", order.curve]];
    [self.quantityLabel setText:[NSString stringWithFormat:@"%lu", order.quantity]];
    [self.unitPriceLabel setText:[NSString stringWithFormat:@"$%lu", order.unitPrice]];
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"$%lu", order.totalPrice]];
    [self.contactPersonNameLabel setText:order.contactPerson];
    [self.contactPersonEmailLabel setText:order.contactEmail];
    [self.contactPersonTelNoLabel setText:order.contactTelNo];
    [self.shippingAddresLabel setText:order.shipAddress];
    [self.trackingNoLabel setText:[NSString stringWithFormat:@"%lu", order.trackingNo]];
    [self.mailOutDateLabel setText:order.mailOutDate];
    [self.noteTextView setText:order.notes];
    
    UIFont *font = [UIFont fontWithName:@"Roboto-Thin" size:14.0];
    [self.descriptionTeextView setFont:font];
    [self.descriptionTeextView setTextColor:[UIColor colorWithRBGValue:0x444444]];
    self.descriptionTeextView.editable = NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = (OrderTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setUserInteractionEnabled:YES];
    
    cell.checkPosition.constant = -40;
    [cell setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [cell setBackgroundColor:[UIColor colorWithRBGValue:0xffffff]];
                         [cell layoutIfNeeded];
                     }];
    
    return indexPath;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [textField resignFirstResponder];
        [self searchOrders];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.searchTextField) {
       textField.placeholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.searchTextField) {
        [textField setPlaceholder:@"Search"];
    }
}

@end
