//
//  SignUpViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 7/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "SignUpViewController.h"
#import "MBProgressHUD.h"
#import "NSString+SHA256.h"
#import "NSString+ValidEmail.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "UIColor+HexColor.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 300;

@interface SignUpViewController () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *countries;
@end

@implementation SignUpViewController

CGFloat animatedDistance;

@synthesize titlePickerView;
@synthesize countryPickerView;

@synthesize loginEmailTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup wtf data
    self.titles = @[@"Mr.", @"Ms.", @"Mrs."];
    self.countries = @[@"China", @"Hong Kong", @"Japan", @"United States", @"United Kingdom"];
    
    // Setup navigation bar
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    // Setup navigation bar title
//    NSString *titleText = @"Sign Up";
//    UIFont* titleFont = [UIFont fontWithName:@"Roboto" size:16];
//    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
//    title.textColor = [UIColor blackColor];
//    title.font = [UIFont fontWithName:@"Roboto" size:16];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.text = titleText;
//    self.navigationItem.titleView = title;
    
    UIImageView *panachzLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    panachzLogo.contentMode = UIViewContentModeScaleAspectFit;
    panachzLogo.clipsToBounds = YES;
    [panachzLogo setImage:[UIImage imageNamed:@"ldenim_app_main_top_logo"]];
    self.navigationItem.titleView = panachzLogo;
    
    // Navigation bar buttons
    UIFont* navbarButtonFont = [UIFont fontWithName:@"Roboto" size:14];
    
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
    NSString *sendButtonText = @"Done";
    CGSize sendButtonTextSize = [sendButtonText sizeWithAttributes:@{NSFontAttributeName: navbarButtonFont}];
    UILabel *sendButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, sendButtonTextSize.width, 20)];
    sendButtonLabel.textColor = [UIColor colorWithRBGValue:0x808080];
    sendButtonLabel.font = navbarButtonFont;
    sendButtonLabel.text = sendButtonText;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addSubview:sendButtonLabel];
    sendButton.frame = CGRectMake(0, 0, sendButtonTextSize.width, 20);
    [sendButton addTarget:self
                   action:@selector(doSignUp)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarSendButton = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = navigationBarSendButton;
    
    // Setup TextFields
    self.loginEmailTextField.delegate = self;
    self.loginEmailTextField.layer.cornerRadius = 4.0;
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.loginEmailTextField.leftView = leftPadding;
    self.loginEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.passwordTextField.leftView = leftPadding;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.confirmPasswordTextField.delegate = self;
    self.confirmPasswordTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.confirmPasswordTextField.leftView = leftPadding;
    self.confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    /* Setup the wtf Title and Title PickerView */
    
    // Tap on title label
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(openTitlePicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.titleLabel.layer.cornerRadius = 4.0;
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
    self.nameTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.nameTextField.leftView = leftPadding;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.streetTextField.delegate = self;
    self.streetTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.streetTextField.leftView = leftPadding;
    self.streetTextField.leftViewMode = UITextFieldViewModeAlways;

    self.cityTextField.delegate = self;
    self.cityTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.cityTextField.leftView = leftPadding;
    self.cityTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.stateTextField.delegate = self;
    self.stateTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.stateTextField.leftView = leftPadding;
    self.stateTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    /* Setup the wtf Country and Country PickerView */

    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(openCountryPicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.countryLabel.layer.cornerRadius = 4.0;
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
    self.zipCodeTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.zipCodeTextField.leftView = leftPadding;
    self.zipCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.telNoTextField.delegate = self;
    self.telNoTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.telNoTextField.leftView = leftPadding;
    self.telNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.noteTextField.delegate = self;
    self.noteTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.noteTextField.textContainerInset = UIEdgeInsetsMake(5, 3.5, 5, 3.5);
}

#pragma mark - Navigation bar buttom action

- (void)closeModalView {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)doSignUp {
   // TODO: User Sign up
    NSString *loginEmail = self.loginEmailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;
    NSString *title = self.titleLabel.text;
    NSString *name = self.nameTextField.text;
    NSString *street = self.streetTextField.text;
    NSString *city = self.cityTextField.text;
    NSString *state = self.stateTextField.text;
    NSString *country = self.countryLabel.text;
    NSString *zipCode = self.zipCodeTextField.text;
    NSString *telNo = self.telNoTextField.text;
    NSString *note = self.noteTextField.text;
    
    if ([loginEmail isEqualToString:@""] || loginEmail.length == 0 || ![loginEmail isAValidEmail]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"Please enter a valid email"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (password.length < 8) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Password length should be equal to or greater than 8"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (![confirmPassword isEqualToString:password]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Passwords do not match"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter your name"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (street.length == 0 || city.length == 0 || state.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter your address"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if ([country isEqualToString:@"Country"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please choose your country"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (zipCode.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter your zip code"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (telNo.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter your telephone number"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
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
    
    NSLog(@"%@", @{@"email" : loginEmail,
                   @"password" : [password sha256],
                   @"title" : title,
                   @"name" : name,
                   @"address_street" : street,
                   @"address_city" : city,
                   @"address_state" : state,
                   @"address_country" : country,
                   @"address_zipcode" : zipCode,
                   @"phone_no" : telNo,
                   @"notes" : note});
    
    __weak typeof(self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"user/signup"
                        parameters:@{@"email" : loginEmail,
                                     @"password" : [password sha256],
                                     @"title" : title,
                                     @"name" : name,
                                     @"address_street" : street,
                                     @"address_city" : city,
                                     @"address_state" : state,
                                     @"address_country" : country,
                                     @"address_zipcode" : zipCode,
                                     @"phone_no" : telNo,
                                     @"notes" : note}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                               
                               NSLog(@"Signup :%@", responseObject);
                               
                               if ([[response objectForKey:@"code"] intValue] == 201) {
                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                  message:@"Sign up successfully"
                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                   UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                    style:UIAlertActionStyleDefault
                                                                                  handler:^(UIAlertAction *action) {
                                                                                      [weakSelf closeModalView];
                                                                                  }];
                                   [alert addAction:action];
                                   [weakSelf presentViewController:alert
                                                          animated:YES
                                                        completion:nil];
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
                               
                           }];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginEmailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else if (textField == self.confirmPasswordTextField) {
        [self.confirmPasswordTextField resignFirstResponder];
        [self openTitlePicker];
    } else if (textField == self.nameTextField) {
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
        return NO;
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
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
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
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
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

@end
