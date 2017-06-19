//
//  MainViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "MasterViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"
#import "UIImage+Size.h"
#import "LDLanguageTool.h"
#import "LDWorkShopViewController.h"

@interface MasterViewController () <SlideNavigationControllerDelegate>
@property (nonatomic, strong) LDWorkShopViewController *workshopController;
@property (nonatomic, strong) LDWorkShopViewController *lDenimGallery;

@end

@implementation MasterViewController

@synthesize tab;

@synthesize designTabButton;
@synthesize customerTabButton;
@synthesize orderTabButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup navigation bar
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self navigationController].navigationBar.barTintColor = [UIColor colorWithRBGValue:0xf8f8f8];
    
    UIImageView *panachzLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    panachzLogo.contentMode = UIViewContentModeScaleAspectFit;
    panachzLogo.clipsToBounds = YES;
    [panachzLogo setImage:[UIImage imageNamed:@"ldenim_app_main_top_logo"]];
    self.navigationItem.titleView = panachzLogo;
    
    // Setup tab buttons
    self.designTabButton.layer.borderWidth = 1.0;
    self.designTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.customerTabButton.layer.borderWidth = 1.0;
    self.customerTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.orderTabButton.layer.borderWidth = 1.0;
    self.orderTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    [self.designTabButton setTitle:@"L-Denim" forState:UIControlStateNormal];
    [self.customerTabButton setTitle:FGGetStringWithKeyFromTable(@"My workshop") forState:UIControlStateNormal];
    [self.orderTabButton setTitle:FGGetStringWithKeyFromTable(@"Ldenim Gallery") forState:UIControlStateNormal];
    
    //3cm_添加My workshop，Ldenim Gallery的containerview
    self.workshopController = [[LDWorkShopViewController alloc] init];
    self.workshopController.isMyWorkshop = YES;
    self.workshopController.view.frame = CGRectMake(0, 0, self.customerContainerView.frame.size.width, self.customerContainerView.frame.size.height);
    [self.customerContainerView addSubview:self.workshopController.view];
    [self addChildViewController:self.workshopController];
    
    //3cm_
    self.lDenimGallery = [[LDWorkShopViewController alloc] init];
    self.lDenimGallery.isMyWorkshop = NO;
    self.lDenimGallery.view.frame = CGRectMake(0, 0, self.orderContainerView.frame.size.width, self.orderContainerView.frame.size.height);
    [self.orderContainerView addSubview:self.lDenimGallery.view];
    [self addChildViewController:self.lDenimGallery];
    
    
    // Setup container views
    if (self.tab == CUSTOMER_VIEW) {
        [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        
        self.designContainerView.hidden = YES;
        self.customerContainerView.hidden = NO;
        self.orderContainerView.hidden = YES;
    } else if (self.tab == ORDER_VIEW) {
        [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        
        self.designContainerView.hidden = YES;
        self.customerContainerView.hidden = YES;
        self.orderContainerView.hidden = NO;
    } else {
        [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        
        self.designContainerView.hidden = NO;
        self.customerContainerView.hidden = YES;
        self.orderContainerView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addOrder)
                                                 name:@"AddOrder"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewProfile)
                                                 name:@"ViewProfile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tabButtonPressedDesign)
                                                 name:@"EditJeans"
                                               object:nil];
}

- (void)addOrder {
    [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
    [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
    [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
    
    self.designContainerView.hidden = NO;
    self.customerContainerView.hidden = YES;
    self.orderContainerView.hidden = YES;
}

- (void)viewProfile {
    [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
    [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
    [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
    
    self.designContainerView.hidden = YES;
    self.customerContainerView.hidden = NO;
    self.orderContainerView.hidden = YES;
}

#pragma mark - Slide Navigation Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}

#pragma mark - Tab Button Action
- (void)tabButtonPressedDesign{
    [self tabButtonPressed:self.designTabButton];
}

- (IBAction)tabButtonPressed:(id)sender {
    UIButton *tabButton = (UIButton *)sender;
    
    if (tabButton == self.designTabButton) {
        [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        
        self.designContainerView.hidden = NO;
        self.customerContainerView.hidden = YES;
        self.orderContainerView.hidden = YES;
    } else if (tabButton == self.customerTabButton) {
        //重新刷新请求
        [self.workshopController fetchJeanDesigns];
        
        [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        
        self.designContainerView.hidden = YES;
        self.customerContainerView.hidden = NO;
        self.orderContainerView.hidden = YES;
    } else if (tabButton == self.orderTabButton) {
        //重新刷新请求
        [self.lDenimGallery fetchJeanDesigns];
        
        [self.designTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.customerTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        [self.orderTabButton setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        
        self.designContainerView.hidden = YES;
        self.customerContainerView.hidden = YES;
        self.orderContainerView.hidden = NO;
    }
}

@end
