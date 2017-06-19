//
//  NotificationSettingViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "NotificationSettingViewController.h"
#import "MasterViewController.h"
#import "MBProgressHUD.h"
#import "NSString+ValidEmail.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"
#import "UIImage+Size.h"

@interface NotificationSettingViewController () <UITextFieldDelegate, SlideNavigationControllerDelegate>

@property (nonatomic) BOOL on;
@property (nonatomic, strong) NSString *revenue;
@property (nonatomic, strong) NSString *email;

@end

@implementation NotificationSettingViewController

@synthesize designTabButton;
@synthesize customerTabButton;
@synthesize orderTabButton;

@synthesize editButton;
@synthesize saveButton;
@synthesize cancelButton;

@synthesize enableNotifiactionSwitch;
@synthesize revenueTextField;
@synthesize emailTextField;

@synthesize on;
@synthesize revenue;
@synthesize email;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar
    NSString *titleText = @"User Account";
    UIFont* titleFont = [UIFont fontWithName:@"Roboto" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Roboto" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleText;
    self.navigationItem.titleView = title;
    
    // Setup tab buttons
    self.designTabButton.layer.borderWidth = 1.0;
    self.designTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.customerTabButton.layer.borderWidth = 1.0;
    self.customerTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.orderTabButton.layer.borderWidth = 1.0;
    self.orderTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup editable field
    self.enableNotifiactionSwitch.enabled = NO;
    self.enableNotifiactionSwitch.transform = CGAffineTransformMakeScale(0.78, 0.78);
    self.on = self.enableNotifiactionSwitch.on;
    
    self.revenueTextField.enabled = NO;
    self.revenueTextField.delegate = self;
    self.revenueTextField.layer.cornerRadius = 4.0;
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.revenueTextField.leftView = leftPadding;
    self.revenueTextField.leftViewMode = UITextFieldViewModeAlways;
    self.revenue = self.revenueTextField.text;
    
    self.emailTextField.enabled = NO;
    self.emailTextField.delegate = self;
    self.emailTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.emailTextField.leftView = leftPadding;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.email = self.emailTextField.text;
    
    // Get user setting
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/notification/setting", [Panachz getInstance].user.userId]
                       parameters:nil
                          success:^(NSURLSessionTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                              
                              if ([[response objectForKey:@"code"] intValue] == 200) {
                                  NSDictionary *setting = [responseObject objectForKey:@"notification_setting"];
                                  
                                  weakSelf.enableNotifiactionSwitch.on = [[setting objectForKey:@"enable_notification"] intValue] == 0 ? NO : YES;
                                  [weakSelf.revenueTextField setText:[NSString stringWithFormat:@"$%0.1f", [[setting objectForKey:@"revenue_notification"] floatValue]]];
                                  [weakSelf.emailTextField setText:[setting objectForKey:@"notification_email"]];
                                  
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
                          failure:^(NSURLSessionTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] show];
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Slide Navigation Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.revenueTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.emailTextField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)startEdit:(id)sender {
    self.editButton.hidden = YES;
    self.saveButton.hidden = self.cancelButton.hidden = NO;
    
    self.enableNotifiactionSwitch.enabled = YES;
    self.revenueTextField.enabled = YES;
    self.emailTextField.enabled = YES;
}

- (IBAction)saveUpdate:(id)sender {
    if (self.emailTextField.text.length == 0 && self.enableNotifiactionSwitch.on) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter your email"
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
    
    self.on = self.enableNotifiactionSwitch.on;
    self.revenue = self.revenueTextField.text;
    self.email = self.emailTextField.text;
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"user/notification/setting"
                        parameters:@{@"user_id" : [NSString stringWithFormat:@"%lu", [Panachz getInstance].user.userId],
                                     @"enable" : self.enableNotifiactionSwitch.on ? @1 : @0,
                                     @"revenue" : self.revenueTextField.text,
                                     @"email" : self.emailTextField.text}
                           success:^(NSURLSessionTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                               
                               if ([response[@"code"] intValue] == 202) {
                                   weakSelf.editButton.hidden = NO;
                                   weakSelf.saveButton.hidden = weakSelf.cancelButton.hidden = YES;
                                   
                                   weakSelf.enableNotifiactionSwitch.enabled = NO;
                                   weakSelf.revenueTextField.enabled = NO;
                                   weakSelf.emailTextField.enabled = NO;
                                   
                                   weakSelf.on = weakSelf.enableNotifiactionSwitch.on;
                                   weakSelf.revenue = weakSelf.revenueTextField.text;
                                   weakSelf.email = weakSelf.emailTextField.text;
                                   
                                   [[[UIAlertView alloc] initWithTitle:@""
                                                               message:@"Setting Updated"
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
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                        animated:YES];
                           }
                           failure:^(NSURLSessionTask *task, NSError *error) {
                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:[NSString stringWithFormat:@"%@", error]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                           }];
}

- (IBAction)canel:(id)sender {
    self.editButton.hidden = NO;
    self.saveButton.hidden = self.cancelButton.hidden = YES;
    
    self.enableNotifiactionSwitch.enabled = NO;
    self.revenueTextField.enabled = NO;
    self.emailTextField.enabled = NO;
    
    self.enableNotifiactionSwitch.on = self.on;
    [self.revenueTextField setText:self.revenue];
    [self.emailTextField setText:self.email];
}

#pragma mark - Tab Button

- (IBAction)tabButtonPressed:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MasterViewController *vc = (MasterViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    
    if (sender == self.designTabButton) {
        vc.tab = DESIGN_VIEW;
    } else if (sender == self.customerTabButton) {
        vc.tab = CUSTOMER_VIEW;
    } else if (sender == self.orderTabButton) {
        vc.tab = ORDER_VIEW;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                    withCompletion:nil];
}

@end
