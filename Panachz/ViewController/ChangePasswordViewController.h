//
//  ChangePasswordViewController.h
//  Panachz
//
//  Created by Peter Choi on 29/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePasswordDelegate <NSObject>

- (void)didChangePasswordToPassword:(NSString *)nPassword;

@end

@interface ChangePasswordViewController : UIViewController

@property (strong, nonatomic) id <ChangePasswordDelegate> changePasswordDelegate;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)doneChangePassword:(id)sender;
- (IBAction)cancelChangePassword:(id)sender;

@end
