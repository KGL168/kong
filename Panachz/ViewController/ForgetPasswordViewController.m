//
//  ForgetPasswordViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 7/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "NSString+ValidEmail.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "UIColor+HexColor.h"

@interface ForgetPasswordViewController () <UITextFieldDelegate>

@end

@implementation ForgetPasswordViewController

@synthesize loginEmailTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    // Setup navigation bar title
    NSString *titleText = @"Forget Password";
    UIFont* titleFont = [UIFont fontWithName:@"Helvetica Neue" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = titleText;
    self.navigationItem.titleView = titleLabel;
    
    // Navigation bar buttons
    UIFont* navbarButtonFont = [UIFont fontWithName:@"Helvetica Neue" size:14];
    
    // Cancel Button
    NSString *cancelButtonText = @"Cancel";
    CGSize cancelButtonTextSize = [cancelButtonText sizeWithAttributes:@{NSFontAttributeName: navbarButtonFont}];
    UILabel *cancelButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(-7, 0, cancelButtonTextSize.width, 20)];
    cancelButtonLabel.textColor = [UIColor colorWithRBGValue:0x808080];
    cancelButtonLabel.font = navbarButtonFont;
    cancelButtonLabel.text = cancelButtonText;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addSubview:cancelButtonLabel];
    cancelButton.frame = CGRectMake(0, 0, cancelButtonTextSize.width, 20);
    [cancelButton addTarget:self
                     action:@selector(closeModalView)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarCancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = navigationBarCancelButton;
    
    // Send Button
    NSString *sendButtonText = @"Send";
    CGSize sendButtonTextSize = [sendButtonText sizeWithAttributes:@{NSFontAttributeName: navbarButtonFont}];
    UILabel *sendButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, sendButtonTextSize.width, 20)];
    sendButtonLabel.textColor = [UIColor colorWithRBGValue:0x808080];
    sendButtonLabel.font = navbarButtonFont;
    sendButtonLabel.text = sendButtonText;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addSubview:sendButtonLabel];
    sendButton.frame = CGRectMake(0, 0, sendButtonTextSize.width, 20);
    [sendButton addTarget:self
                     action:@selector(sendPasswordToEmail)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarSendButton = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = navigationBarSendButton;
    
    // Setup Email Text Field
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    self.loginEmailTextField.leftView = leftPaddingView;
    self.loginEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.loginEmailTextField.delegate = self;
    self.loginEmailTextField.layer.cornerRadius = 4.0;
    
    // Setup tap gesture to dismiss keyborad
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation bar buttom action

- (void)closeModalView {
    [self.loginEmailTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)sendPasswordToEmail {
    NSString *email = self.loginEmailTextField.text;
    
    if (![email isAValidEmail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // TODO: Send email to user to give him new password
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            [[[UIAlertView alloc] initWithTitle:@"Cannot connect to Internet"
                                       message:@"Please check your Internet Connection"
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            __weak typeof(self) weakSelf = self;
            [[PanachzApi getInstance] POST:@"user/reset/password"
                                parameters:@{@"email" : email}
                                   success:^(NSURLSessionTask *task, id responseObject) {
                                       NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                       
                                       if ([[response objectForKey:@"code"] intValue] == 202) {
                                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                          message:@"A new Password has sent to your email."
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                           UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                            style:UIAlertActionStyleCancel
                                                                                          handler:^(UIAlertAction *action) {
                                                                                              [weakSelf closeModalView];
                                                                                          }];
                                           [alert addAction:action];
                                           
                                           [weakSelf presentViewController:alert
                                                                  animated:YES completion:nil];
                                       } else {
                                           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                          message:@"Something Wrong"
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                           UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                            style:UIAlertActionStyleCancel
                                                                                          handler:nil];
                                           [alert addAction:action];
                                           
                                           [weakSelf presentViewController:alert
                                                                  animated:YES completion:nil];
                                       }
                                   }
                                   failure:^(NSURLSessionTask *task, NSError *error) {
                                   
                                   }];
        }
    }
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}

- (void)dismissKeyboard {
    [self.loginEmailTextField resignFirstResponder];
    [self.view endEditing:YES];
}

@end