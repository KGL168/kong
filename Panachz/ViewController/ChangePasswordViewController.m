//
//  ChangePasswordViewController.m
//  Panachz
//
//  Created by Peter Choi on 29/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "MBProgressHUD.h"
#import "NSString+SHA256.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import "Reachability.h"

@interface ChangePasswordViewController() <UITextFieldDelegate> {
    /* keyboard auto go up */
    CGFloat currentKeyboardHeight;
    CGFloat deltaHeight;
    CGFloat moved;
    CGFloat textfield_y;
    bool animated;
}


@end

@implementation ChangePasswordViewController

@synthesize changePasswordDelegate;
@synthesize passwordTextField;
@synthesize nPasswordTextField;
@synthesize confirmPasswordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Textfield
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.passwordTextField.leftView = leftPadding;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.nPasswordTextField.leftView = leftPadding;
    self.nPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nPasswordTextField.delegate = self;
    
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.confirmPasswordTextField.leftView = leftPadding;
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (IBAction)doneChangePassword:(id)sender {
    if ([[Panachz getInstance] userIsLoggedIn]) {
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
        
        NSString *password = self.passwordTextField.text;
        NSString *nPassword = self.nPasswordTextField.text;
        NSString *confirmPassword = self.confirmPasswordTextField.text;
        
        if (nPassword.length < 8) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Password's length should be equal to or greater than 8."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        if (![nPassword isEqualToString:confirmPassword]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Confirm Password is not correct."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        
        __weak typeof (self) weakSelf = self;
        [[PanachzApi getInstance] POST:@"user/login"
                            parameters:@{@"email" : [Panachz getInstance].user.email,
                                         @"password" : [password sha256]}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                   
                                   if ([[response objectForKey:@"code"] intValue] == 200) {
                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                                animated:YES];
                                       
                                       [weakSelf.changePasswordDelegate didChangePasswordToPassword:nPassword];
                                       [weakSelf dismissViewControllerAnimated:YES
                                                                completion:nil];
                                   } else {
                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                                animated:YES];
                                       
                                       [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:@"Password is not correct"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil] show];
                                   }
                               }
                               failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                            animated:YES];
                               }];
    }
}

- (IBAction)cancelChangePassword:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    deltaHeight = kbSize.height - moved;
    currentKeyboardHeight = kbSize.height;
    [self animateTextField: YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self animateTextField: NO];
    currentKeyboardHeight = 0.0f;
}

- (void)animateTextField:(BOOL)up {
    if (textfield_y > [[UIScreen mainScreen] bounds].size.height - currentKeyboardHeight && !animated && up) {
        animated = YES;
    }
    
    if (animated) {
        const float movementDuration = 0.3f;
        
        int movement = (up ? -deltaHeight : moved);
        
        moved = (up ? moved + deltaHeight : 0.0f);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
        
        if (!up) {
            animated = NO;
        }
    }
    
    textfield_y = 0.0f;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect newFrame = [textField convertRect:textField.bounds
                                      toView:nil];
    textfield_y = newFrame.origin.y;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self.nPasswordTextField becomeFirstResponder];
    } else if (textField == self.nPasswordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmPasswordTextField) {
        [self.confirmPasswordTextField resignFirstResponder];
    }
    return YES;
}

@end
