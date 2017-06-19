//
//  ManagerUserDashboardViewController.h
//  Panachz
//
//  Created by Peter Choi on 14/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNBarChart.h"
#import "User.h"

@interface ManagerUserDashboardViewController : UIViewController

@property (strong, nonatomic) User *user;

@property (strong, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *thisMonthRevenueLabel;
@property (strong, nonatomic) IBOutlet UILabel *thisMonthCommissionLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayRevenueLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayRevenuePercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *yesterdayRevenueLabel;
@property (strong, nonatomic) IBOutlet UILabel *yesterdayRevenuePercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayOrderLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayOrderPercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *yesterdayDaysOrderLabel;
@property (strong, nonatomic) IBOutlet UILabel *yesterdayOrderPercentageLabel;

@property (strong, nonatomic) IBOutlet UIImageView *selectDateRangeImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateRangeLabel;
@property (strong, nonatomic) IBOutlet UIView *dateRangePickerView;

@property (strong, nonatomic) IBOutlet UITableView *salesRecordTableView;
@property (strong, nonatomic) IBOutlet PNBarChart *barChart;

@property (strong, nonatomic) IBOutlet UIImageView *previousPageButton;
@property (strong, nonatomic) IBOutlet UIImageView *nextPageButton;
@property (strong, nonatomic) IBOutlet UILabel *paginationLabel;
@property (strong, nonatomic) IBOutlet UILabel *showingLabel;

@property (strong, nonatomic) IBOutlet UIButton *sortClientNameButton;
@property (strong, nonatomic) IBOutlet UIButton *sortTelephoneButton;
@property (strong, nonatomic) IBOutlet UIButton *sortStatusButton;
@property (strong, nonatomic) IBOutlet UIButton *sortOrderButton;
@property (strong, nonatomic) IBOutlet UIButton *sortPurchaseButton;
@property (strong, nonatomic) IBOutlet UIButton *sortLastPurchaseDateButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sortButtons;

@property (strong, nonatomic) IBOutlet UIImageView *sortClientNameImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sortTelePhoneImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sortStatusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sortOrdersImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sortPurchaseImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sortLastPurchaseDateImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *sortImageViews;

- (IBAction)sortData:(id)sender;
- (IBAction)showLastSevenDaysStatistics:(id)sender;
- (IBAction)showLast30DaysStatistics:(id)sender;

@end
