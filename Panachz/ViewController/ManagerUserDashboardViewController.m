//
//  ManagerUserDashboardViewController.m
//  Panachz
//
//  Created by Peter Choi on 14/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ManagerUserDashboardViewController.h"
#import "MBProgressHUD.h"
#import "Order.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "SalesRecordTableViewCell.h"
#import "UIColor+HexColor.h"

#define INCREASE_COLOR [UIColor colorWithRBGValue:0x009944]
#define DECREASE_COLOR [UIColor colorWithRBGValue:0xc30d23]

@interface ManagerUserDashboardViewController () <UITableViewDataSource, UITableViewDelegate, PNChartDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSMutableArray *sorts;
@property (nonatomic) NSInteger page;
@end

@implementation ManagerUserDashboardViewController

@synthesize user;
@synthesize userPositionLabel;
@synthesize userNameLabel;

@synthesize thisMonthRevenueLabel;
@synthesize thisMonthCommissionLabel;
@synthesize todayRevenueLabel;
@synthesize todayRevenuePercentageLabel;
@synthesize yesterdayRevenueLabel;
@synthesize yesterdayRevenuePercentageLabel;
@synthesize todayOrderLabel;
@synthesize todayOrderPercentageLabel;
@synthesize yesterdayDaysOrderLabel;
@synthesize yesterdayOrderPercentageLabel;

@synthesize selectDateRangeImageView;
@synthesize dateRangeLabel;
@synthesize dateRangePickerView;

@synthesize barChart;
@synthesize salesRecordTableView;

@synthesize previousPageButton;
@synthesize nextPageButton;
@synthesize paginationLabel;
@synthesize showingLabel;

@synthesize sortClientNameButton;
@synthesize sortTelephoneButton;
@synthesize sortStatusButton;
@synthesize sortOrderButton;
@synthesize sortPurchaseButton;
@synthesize sortLastPurchaseDateButton;
@synthesize sortButtons;

@synthesize sortClientNameImageView;
@synthesize sortTelePhoneImageView;
@synthesize sortStatusImageView;
@synthesize sortOrdersImageView;
@synthesize sortPurchaseImageView;
@synthesize sortLastPurchaseDateImageView;
@synthesize sortImageViews;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup Navigation bar
    NSString *titleText = @"Dashboard";
    UIFont* titleFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleText;
    self.navigationItem.titleView = title;
    
    // Setup Left navigation bar item
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 24, 24)];
    [menuImage setImage:[UIImage imageNamed:@"ic_keyboard_arrow_left_black_48dp"]];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addSubview:menuImage];
    menuButton.frame = CGRectMake(0, 0, 24, 24);
    [menuButton addTarget:self
                   action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = navigationBarMenuButton;
    
    // Setup for User information
    [self.userPositionLabel setText:user.role];
    [self.userNameLabel setText:user.name];
    
    // Setup dateRange Picker View
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(openDateRangePickerView)];
    [recognizer setNumberOfTapsRequired:1];
    [self.selectDateRangeImageView setUserInteractionEnabled:YES];
    [self.selectDateRangeImageView addGestureRecognizer:recognizer];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(openDateRangePickerView)];
    [recognizer setNumberOfTapsRequired:1];
    [self.dateRangeLabel setUserInteractionEnabled:YES];
    [self.dateRangeLabel addGestureRecognizer:recognizer];
    
    self.dateRangePickerView.layer.borderColor = [UIColor colorWithRBGValue:0xdddddd].CGColor;
    self.dateRangePickerView.layer.borderWidth = 1.0;
    
    // Setup bar chart
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString *labelText = [NSString stringWithFormat:@"$%0.f", yValueParsed];
        return labelText;
    };
    self.barChart.yLabelPrefix = @"";
    self.barChart.yLabelSuffix = @"";
    self.barChart.labelMarginTop = 5.0;
    self.barChart.barBackgroundColor = [UIColor clearColor];
    self.barChart.yLabelSum = 5;
    self.barChart.yMaxValue = 3000;
    self.barChart.yMinValue = 0;
    self.barChart.labelFont = [UIFont fontWithName:@"Roboto-Thin"
                                              size:12.0];
    self.barChart.labelTextColor = [UIColor colorWithRBGValue:0x444444];
    self.barChart.showChartBorder = YES;
    self.barChart.delegate = self;
    
    // Setup Tableview
    self.salesRecordTableView.dataSource = self;
    self.salesRecordTableView.delegate = self;
    
    // Setup dashboard
    [self getThisMonthRevenue];
    [self getTodayRevenue];
    [self getYesterdayRevenue];
   
    [self showStatisticsForLast:7];
    
    self.page = 0;
    self.orders = [[NSMutableArray alloc] init];
    [self getAllOrders];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(nextPage:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.nextPageButton setUserInteractionEnabled:YES];
    [self.nextPageButton addGestureRecognizer:recognizer];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(previousPage:)];
    [recognizer setNumberOfTapsRequired:1];
    [self.previousPageButton setUserInteractionEnabled:YES];
    [self.previousPageButton addGestureRecognizer:recognizer];
    
    // Setup for sorting
    self.sorts = [[NSMutableArray alloc] initWithArray:@[@YES, @YES, @YES, @YES, @YES, @YES]];
    
    for (UIImageView *iv in self.sortImageViews) {
        iv.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Bar Button

- (void)back:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Revenue

- (void)getThisMonthRevenue {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders/month", self.user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              [weakSelf.thisMonthRevenueLabel setText:[NSString stringWithFormat:@"$%@.0", [responseObject objectForKey:@"revenue"]]];
                              [weakSelf.thisMonthCommissionLabel setText:[NSString stringWithFormat:@"$%0.1f", ([[responseObject objectForKey:@"commission"] floatValue])]];
                              [hud hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud hide:YES];
                          }];
}

- (void)getTodayRevenue {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders/today", self.user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              [weakSelf.todayRevenueLabel setText:[NSString stringWithFormat:@"$%@.0", [responseObject objectForKey:@"revenue"]]];
                              [weakSelf.todayOrderLabel setText:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"num_of_order"]]];
                              [hud hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud hide:YES];
                          }];
    
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view
                                               animated:YES];
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders/today/increase", self.user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              CGFloat revenuePercentage = [[responseObject objectForKey:@"revenue"] floatValue];
                              CGFloat orderPercentage = [[responseObject objectForKey:@"order"] floatValue];
                              
                              if (revenuePercentage == 0) {
                                  [weakSelf.todayRevenuePercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", revenuePercentage]];
                                  [weakSelf.todayRevenuePercentageLabel setTextColor:INCREASE_COLOR];
                              } else if (revenuePercentage > 0) {
                                  [weakSelf.todayRevenuePercentageLabel setText:[NSString stringWithFormat:@"(+%0.1f%%)", revenuePercentage]];
                                  [weakSelf.todayRevenuePercentageLabel setTextColor:INCREASE_COLOR];
                              } else {
                                  [weakSelf.todayRevenuePercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", revenuePercentage]];
                                  [weakSelf.todayRevenuePercentageLabel setTextColor:DECREASE_COLOR];
                              }
                              
                              if (orderPercentage == 0) {
                                  [weakSelf.todayOrderPercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", orderPercentage]];
                                  [weakSelf.todayOrderPercentageLabel setTextColor:INCREASE_COLOR];
                              } else if (orderPercentage > 0) {
                                  [weakSelf.todayOrderPercentageLabel setText:[NSString stringWithFormat:@"(+%0.1f%%)", orderPercentage]];
                                  [weakSelf.todayOrderPercentageLabel setTextColor:INCREASE_COLOR];
                              } else {
                                  [weakSelf.todayOrderPercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", orderPercentage]];
                                  [weakSelf.todayOrderPercentageLabel setTextColor:DECREASE_COLOR];
                              }
                              
                              [hud2 hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud2 hide:YES];
                          }];
}

- (void)getYesterdayRevenue {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders/1", [Panachz getInstance].user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              [weakSelf.yesterdayRevenueLabel setText:[NSString stringWithFormat:@"$%@.0", [responseObject objectForKey:@"revenue"]]];
                              [weakSelf.yesterdayDaysOrderLabel setText:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"num_of_order"]]];
                              [hud hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud hide:YES];
                          }];
    
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view
                                               animated:YES];
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders/1/increase", [Panachz getInstance].user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              CGFloat revenuePercentage = [[responseObject objectForKey:@"revenue"] floatValue];
                              CGFloat orderPercentage = [[responseObject objectForKey:@"order"] floatValue];
                              
                              if (revenuePercentage == 0) {
                                  [weakSelf.yesterdayRevenuePercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", revenuePercentage]];
                                  [weakSelf.yesterdayRevenuePercentageLabel setTextColor:INCREASE_COLOR];
                              } else if (revenuePercentage > 0) {
                                  [weakSelf.yesterdayRevenuePercentageLabel setText:[NSString stringWithFormat:@"(+%0.1f%%)", revenuePercentage]];
                                  [weakSelf.yesterdayRevenuePercentageLabel setTextColor:INCREASE_COLOR];
                              } else {
                                  [weakSelf.yesterdayRevenuePercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", revenuePercentage]];
                                  [weakSelf.yesterdayRevenuePercentageLabel setTextColor:DECREASE_COLOR];
                              }
                              
                              if (orderPercentage == 0) {
                                  [weakSelf.yesterdayOrderPercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", orderPercentage]];
                                  [weakSelf.yesterdayOrderPercentageLabel setTextColor:INCREASE_COLOR];
                              } else if (orderPercentage > 0) {
                                  [weakSelf.yesterdayOrderPercentageLabel setText:[NSString stringWithFormat:@"(+%0.1f%%)", orderPercentage]];
                                  [self.yesterdayOrderPercentageLabel setTextColor:INCREASE_COLOR];
                              } else {
                                  [weakSelf.yesterdayOrderPercentageLabel setText:[NSString stringWithFormat:@"(%0.1f%%)", orderPercentage]];
                                  [weakSelf.yesterdayOrderPercentageLabel setTextColor:DECREASE_COLOR];
                              }
                              
                              [hud2 hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud2 hide:YES];
                          }];
    
}

#pragma mark - Date Range Picker

- (void)openDateRangePickerView {
    if (self.dateRangePickerView.hidden) {
        self.dateRangePickerView.alpha = 0.0;
        self.dateRangePickerView.hidden = NO;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.dateRangePickerView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.dateRangePickerView becomeFirstResponder];
                             }
                         }];
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.dateRangePickerView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.dateRangePickerView resignFirstResponder];
                                 self.dateRangePickerView.hidden = YES;
                             }
                         }];
    }
}

- (void)closeDateRangePickerView {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.dateRangePickerView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.dateRangePickerView resignFirstResponder];
                             self.dateRangePickerView.hidden = YES;
                         }
                     }];
}

- (IBAction)showLastSevenDaysStatistics:(id)sender {
    [self showStatisticsForLast:7];
    [self.dateRangeLabel setText:@"Date Range (Last 7 days)"];
    [self closeDateRangePickerView];
}

- (IBAction)showLast30DaysStatistics:(id)sender {
    [self showStatisticsForLast:30];
    [self.dateRangeLabel setText:@"Date Range (Last 30 days)"];
    [self closeDateRangePickerView];
}

- (void)showStatisticsForLast:(NSUInteger)days {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders/%lu/stat", self.user.userId, days]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                              
                              if ([[response objectForKey:@"code"] intValue] == 100 ) {
                                  NSArray *statArray = [responseObject objectForKey:@"stat"];
                                  
                                  NSMutableArray *xLabels = [[NSMutableArray alloc] init];
                                  NSMutableArray *yLabels = [[NSMutableArray alloc] init];
                                  NSMutableArray *strokeColors = [[NSMutableArray alloc] init];
                                  UIColor *color1 = [UIColor colorWithRBGValue:0xefefef];
                                  UIColor *color2 = [UIColor colorWithRBGValue:0xdcdddd];
                                  
                                  for (int i = 0; i < statArray.count; i++) {
                                      NSDictionary *stat = [statArray objectAtIndex:i];
                                      [xLabels addObject:[stat objectForKey:@"date"]];
                                      [yLabels addObject:[stat objectForKey:@"revenue"]];
                                      [strokeColors addObject:color1];
                                  }
                                  
                                  [strokeColors replaceObjectAtIndex:strokeColors.count - 1
                                                          withObject:color2];
                                  
                                  weakSelf.barChart.barWidth = 385.0 / statArray.count;
                                  
                                  [weakSelf.barChart setXLabels:xLabels];
                                  [weakSelf.barChart setYValues:yLabels];
                                  
                                  [weakSelf.barChart setStrokeColors:strokeColors];
                                  weakSelf.barChart.isGradientShow = NO;
                                  weakSelf.barChart.isShowNumbers = NO;
                                  [weakSelf.barChart strokeChart];
                              } else {
                                  [[[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:[response objectForKey:@"message"]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              }
                              
                              [hud hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud hide:YES];
                          }];
}

#pragma mark - Order records;

- (void)getAllOrders {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                              animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/orders", self.user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                          
                              if ([[response objectForKey:@"code"] intValue] == 100) {
                                  NSArray *ordersArray = [responseObject objectForKey:@"orders"];
                                  
                                  for (int i = 0; i < ordersArray.count; i++) {
                                      NSDictionary *orderJson = [ordersArray objectAtIndex:i];
                                      
                                      Order *order = [[Order alloc] init];
                                      order.contactPerson = [NSString stringWithFormat:@"%@ (%@)", [orderJson objectForKey:@"contact_person"], [orderJson objectForKey:@"name"]];
                                      order.contactTelNo = [orderJson objectForKey:@"contact_tel_no"];
                                      order.orderStatus = [orderJson objectForKey:@"state"];
                                      order.quantity = [[orderJson objectForKey:@"quantity"] intValue];
                                      order.totalPrice = [[orderJson objectForKey:@"quantity"] intValue] * [[orderJson objectForKey:@"unit_price"] intValue];
                                      order.notes = [orderJson objectForKey:@"last_purchase"];
                                      
                                      [weakSelf.orders addObject:order];
                                  }
                                  [weakSelf.showingLabel setText:[NSString stringWithFormat:@"Showing %lu - %lu of %lu", (weakSelf.page + 1) * 6 - 5, (weakSelf.page + 1) * 6 >= weakSelf.orders.count ? weakSelf.orders.count : (weakSelf.page + 1) * 6,  weakSelf.orders.count]];
                                  [weakSelf.paginationLabel setText:[NSString stringWithFormat:@"Page 1 / %i", (int)(weakSelf.orders.count / 6 + 1)]];
                                  [weakSelf.salesRecordTableView reloadData];
                              } else if ([[response objectForKey:@"code"] intValue] != 406) {
                                  [[[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:[response objectForKey:@"message"]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              } else {
                                  [weakSelf.salesRecordTableView reloadData];
                                  [weakSelf.paginationLabel setText:[NSString stringWithFormat:@"Page 1 / %i", (int)(weakSelf.orders.count / 6 + 1)]];
                                  [weakSelf.showingLabel setText:[NSString stringWithFormat:@"Showing 0 - 0 of 0"]];
                              }
                              
                              [hud hide:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                              [hud hide:YES];
                          }];
    
}

#pragma mark - TableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orders.count == 0) {
        return 1;
    } else {
        if (self.orders.count < (self.page + 1) * 6) {
            return self.orders.count - self.page * 6;
        } else {
            return 6;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orders.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoRecordCell"];
        return cell;
    } else {
        SalesRecordTableViewCell *cell = (SalesRecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SalesRecordTableViewCell"];
        Order *order = [self.orders objectAtIndex:indexPath.row + self.page * 6];
        [cell.clientNameLabel setText:order.contactPerson];
        [cell.telephoneLabel setText:order.contactTelNo];
        [cell.statusLabel setText:order.orderStatus];
        [cell.ordersLabel setText:[NSString stringWithFormat:@"%lu", order.quantity]];
        [cell.purchaseLabel setText:[NSString stringWithFormat:@"%lu", order.totalPrice]];
        [cell.lastPurchaseLabel setText:order.notes];
        return cell;
    }
    
    
    //
}

#pragma mark - Sorting Data

- (IBAction)sortData:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    for (UIImageView *iv in self.sortImageViews) {
        iv.hidden = YES;
    }
    
    if (button == self.sortClientNameButton) {
        NSNumber *up = [self.sorts objectAtIndex:0];
        [self.sorts replaceObjectAtIndex:0
                              withObject:[up boolValue] ? @NO : @YES];
        
        up = [self.sorts objectAtIndex:0];
        
        if ([up boolValue]) {
            self.sortClientNameImageView.hidden = NO;
            [self.sortClientNameImageView setImage:[UIImage imageNamed:@"ic_listing_up"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                return [o1.contactPerson compare:o2.contactPerson];
            }]];
        } else {
            self.sortClientNameImageView.hidden = NO;
            [self.sortClientNameImageView setImage:[UIImage imageNamed:@"ic_listing_down"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                return [o2.contactPerson compare:o1.contactPerson];
            }]];
        }
    } else if (button == self.sortTelephoneButton) {
        NSNumber *up = [self.sorts objectAtIndex:1];
        [self.sorts replaceObjectAtIndex:1
                              withObject:[up boolValue] ? @NO : @YES];
        
        up = [self.sorts objectAtIndex:1];
        
        if ([up boolValue]) {
            self.sortTelePhoneImageView.hidden = NO;
            [self.sortTelePhoneImageView setImage:[UIImage imageNamed:@"ic_listing_up"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                return [o1.contactTelNo compare:o2.contactTelNo];
            }]];
        } else {
            self.sortTelePhoneImageView.hidden = NO;
            [self.sortTelePhoneImageView setImage:[UIImage imageNamed:@"ic_listing_down"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                return [o2.contactTelNo compare:o1.contactTelNo];
            }]];
        }
    } else if (button == self.sortStatusButton) {
        NSNumber *up = [self.sorts objectAtIndex:2];
        [self.sorts replaceObjectAtIndex:2
                              withObject:[up boolValue] ? @NO : @YES];
        
        up = [self.sorts objectAtIndex:2];
        
        if ([up boolValue]) {
            self.sortStatusImageView.hidden = NO;
            [self.sortStatusImageView setImage:[UIImage imageNamed:@"ic_listing_up"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                return [o1.orderStatus compare:o2.orderStatus];
            }]];
        } else {
            self.sortStatusImageView.hidden = NO;
            [self.sortStatusImageView setImage:[UIImage imageNamed:@"ic_listing_down"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                return [o2.orderStatus compare:o1.orderStatus];
            }]];
        }
    } else if (button == self.sortOrderButton) {
        NSNumber *up = [self.sorts objectAtIndex:3];
        [self.sorts replaceObjectAtIndex:3
                              withObject:[up boolValue] ? @NO : @YES];
        
        up = [self.sorts objectAtIndex:3];
        
        if ([up boolValue]) {
            self.sortOrdersImageView.hidden = NO;
            [self.sortOrdersImageView setImage:[UIImage imageNamed:@"ic_listing_up"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                if (o1.quantity < o2.quantity) {
                    return NSOrderedAscending;
                } else if (o1.quantity > o2.quantity) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }]];
        } else {
            self.sortOrdersImageView.hidden = NO;
            [self.sortOrdersImageView setImage:[UIImage imageNamed:@"ic_listing_down"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                if (o1.quantity > o2.quantity) {
                    return NSOrderedAscending;
                } else if (o1.quantity < o2.quantity) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }]];
        }
    } else if (button == self.sortPurchaseButton) {
        NSNumber *up = [self.sorts objectAtIndex:4];
        [self.sorts replaceObjectAtIndex:4
                              withObject:[up boolValue] ? @NO : @YES];
        
        up = [self.sorts objectAtIndex:4];
        
        if ([up boolValue]) {
            self.sortPurchaseImageView.hidden = NO;
            [self.sortPurchaseImageView setImage:[UIImage imageNamed:@"ic_listing_up"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                if (o1.totalPrice < o2.totalPrice) {
                    return NSOrderedAscending;
                } else if (o1.totalPrice > o2.totalPrice) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }]];
        } else {
            self.sortPurchaseImageView.hidden = NO;
            [self.sortPurchaseImageView setImage:[UIImage imageNamed:@"ic_listing_down"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                if (o1.totalPrice > o2.totalPrice) {
                    return NSOrderedAscending;
                } else if (o1.totalPrice < o2.totalPrice) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }]];
        }
    } else if (button == self.sortLastPurchaseDateButton) {
        NSNumber *up = [self.sorts objectAtIndex:5];
        [self.sorts replaceObjectAtIndex:5
                              withObject:[up boolValue] ? @NO : @YES];
        
        up = [self.sorts objectAtIndex:5];
        
        if ([up boolValue]) {
            self.sortLastPurchaseDateImageView.hidden = NO;
            [self.sortLastPurchaseDateImageView setImage:[UIImage imageNamed:@"ic_listing_up"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *date1 = [formatter dateFromString:o1.notes];
                NSDate *date2 = [formatter dateFromString:o2.notes];
                
                if ([date1 timeIntervalSince1970] < [date2 timeIntervalSince1970]) {
                    return NSOrderedAscending;
                } else if ([date1 timeIntervalSince1970] > [date2 timeIntervalSince1970]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }]];
        } else {
            self.sortLastPurchaseDateImageView.hidden = NO;
            [self.sortLastPurchaseDateImageView setImage:[UIImage imageNamed:@"ic_listing_down"]];
            self.orders = [[NSMutableArray alloc] initWithArray:[self.orders sortedArrayUsingComparator:^NSComparisonResult(Order *o1, Order *o2) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *date1 = [formatter dateFromString:o1.notes];
                NSDate *date2 = [formatter dateFromString:o2.notes];
                
                if ([date1 timeIntervalSince1970] > [date2 timeIntervalSince1970]) {
                    return NSOrderedAscending;
                } else if ([date1 timeIntervalSince1970] < [date2 timeIntervalSince1970]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }]];
        }
    }
    self.page = 0;
    [self.salesRecordTableView reloadData];
    [self.paginationLabel setText:[NSString stringWithFormat:@"Page %lu / %i", self.page + 1, (int)(self.orders.count / 6 + 1)]];
    [self.showingLabel setText:[NSString stringWithFormat:@"Showing %lu - %lu of %lu", (self.page + 1) * 6 - 5, (self.page + 1) * 6 >= self.orders.count ? self.orders.count : (self.page + 1) * 6,  self.orders.count]];
}

#pragma mark - Table View Pagination

- (void)nextPage:(UITapGestureRecognizer *)recognizer {
    if (self.page + 1 <= self.orders.count / 6) {
        self.page++;
        [self.salesRecordTableView reloadData];
        [self.paginationLabel setText:[NSString stringWithFormat:@"Page %lu / %i", self.page + 1, (int)(self.orders.count / 6 + 1)]];
        [self.showingLabel setText:[NSString stringWithFormat:@"Showing %lu - %lu of %lu", (self.page + 1) * 6 - 5, (self.page + 1) * 6 >= self.orders.count ? self.orders.count : (self.page + 1) * 6,  self.orders.count]];
    }
}

- (void)previousPage:(UITapGestureRecognizer *)recognizer {
    
    if (self.page - 1 >= 0) {
        self.page--;
        [self.salesRecordTableView reloadData];
        [self.paginationLabel setText:[NSString stringWithFormat:@"Page %lu / %i", self.page + 1, (int)(self.orders.count / 6 + 1)]];
        [self.showingLabel setText:[NSString stringWithFormat:@"Showing %lu - %lu of %lu", (self.page + 1) * 6 - 5, (self.page + 1) * 6 >= self.orders.count ? self.orders.count : (self.page + 1) * 6,  self.orders.count]];
    }
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
