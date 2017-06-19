//
//  LoginViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 6/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backgrounImage;
@property (strong, nonatomic) IBOutlet UITextField *loginEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)login:(id)sender;

@end
