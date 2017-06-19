//
//  UserAccountViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "UserAccountViewController.h"
#import "ChangePasswordViewController.h"
#import "MasterViewController.h"
#import "MBProgressHUD.h"
#import "NSString+SHA256.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import "Reachability.h"
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"

#import "LDLanguageTool.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 300;

@interface UserAccountViewController () <UITextFieldDelegate, SlideNavigationControllerDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, ChangePasswordDelegate>

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *countries;

@property (strong, nonatomic) NSString *loginEmail;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *userTitle;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *telNo;
@property (strong, nonatomic) NSString *note;

@end

@implementation UserAccountViewController

CGFloat animatedDistance2;

@synthesize designTabButton;
@synthesize customerTabButton;
@synthesize orderTabButton;

@synthesize titlePickerView;
@synthesize countryPickerView;

@synthesize loginEmailTextField;
@synthesize passwordTextField;
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

@synthesize loginEmail;
@synthesize password;
@synthesize userTitle;
@synthesize name;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize country;
@synthesize zipCode;
@synthesize telNo;
@synthesize note;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup wtf data
    self.titles = @[@"Mr.", @"Ms.", @"Mrs."];
    self.countries = @[@"China", @"Hong Kong", @"Japan", @"United States", @"United Kingdom"];
    
    // Setup navigation bar
    NSString *titleText = @"User Account";
    UIFont* titleFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleText;
    self.navigationItem.titleView = title;
    
    // Setup tab buttons
    self.designTabButton.layer.borderWidth = 1.0;
    self.designTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    [self.designTabButton setTitle:@"L-Denim" forState:UIControlStateNormal];
    
    self.customerTabButton.layer.borderWidth = 1.0;
    self.customerTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    [self.customerTabButton setTitle:FGGetStringWithKeyFromTable(@"My workshop") forState:UIControlStateNormal];
    
    self.orderTabButton.layer.borderWidth = 1.0;
    self.orderTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    [self.orderTabButton setTitle:FGGetStringWithKeyFromTable(@"Ldenim Gallery") forState:UIControlStateNormal];
    
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
    self.passwordTextField.enabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(changePassword)];
    [tap setNumberOfTapsRequired:1];
    [self.passwordTextField setUserInteractionEnabled:NO];
    [self.passwordTextField addGestureRecognizer:tap];
    
    /* Setup the wtf Title and Title PickerView */
    
    // Tap on title label
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
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
    
    // Setup initial data
    if ([[Panachz getInstance] userIsLoggedIn]) {
        User *user = [Panachz getInstance].user;
        
        [self.loginEmailTextField setText:user.email];
        [self.titleLabel setText:user.title];
        [self.nameTextField setText:user.name];
        [self.streetTextField setText:user.street];
        [self.cityTextField setText:user.city];
        [self.stateTextField setText:user.state];
        [self.countryLabel setText:user.country];
        [self.zipCodeTextField setText:user.zipCode];
        [self.telNoTextField setText:user.telNo];
        [self.noteTextField setText:user.notes];
    }
    
    self.loginEmail = self.loginEmailTextField.text;
    self.password = self.passwordTextField.text;
    self.userTitle = self.titleLabel.text;
    self.name = self.nameTextField.text;
    self.street = self.streetTextField.text;
    self.city = self.cityTextField.text;
    self.state = self.stateTextField.text;
    self.country = self.countryLabel.text;
    self.zipCode = self.zipCodeTextField.text;
    self.telNo = self.telNoTextField.text;
    self.note = self.noteTextField.text;
    
    self.loginEmailTextField.enabled = self.passwordTextField.enabled = self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ChangePassword"]) {
        ChangePasswordViewController *vc = (ChangePasswordViewController *)segue.destinationViewController;
        vc.changePasswordDelegate = self;
    }
}

- (void)didChangePasswordToPassword:(NSString *)nPassword {
    [self.passwordTextField setText:nPassword];
    NSLog(@"New Password: %@", nPassword);
}

- (void)changePassword {
    [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
}

- (IBAction)changePassword:(id)sender {
    if (self.passwordTextField.enabled) {
        [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
    }
}

#pragma mark - Slide Navigation Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginEmailTextField) {
        [self.loginEmailTextField resignFirstResponder];
        [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
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
        animatedDistance2 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance2 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance2;
    
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
        animatedDistance2 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance2 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance2;
    
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

#pragma mark - Edit User Account

- (IBAction)startEdit:(id)sender {
    self.editButton.hidden = YES;
    self.saveButton.hidden = self.cancelButton.hidden = NO;
    
    self.loginEmailTextField.enabled = self.passwordTextField.enabled = self.passwordTextField.userInteractionEnabled = self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = YES;
}

- (IBAction)cancel:(id)sender {
    self.editButton.hidden = NO;
    self.saveButton.hidden = self.cancelButton.hidden = YES;
    
    self.loginEmailTextField.enabled = self.passwordTextField.enabled = self.passwordTextField.userInteractionEnabled = self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
    
    self.loginEmailTextField.text = self.loginEmail;
    self.passwordTextField.text = self.password;
    self.titleLabel.text = self.userTitle;
    self.nameTextField.text = self.name;
    self.streetTextField.text = self.street;
    self.cityTextField.text = self.city;
    self.stateTextField.text = self.state;
    self.countryLabel.text = self.country;
    self.zipCodeTextField.text = self.zipCode;
    self.telNoTextField.text = self.telNo;
    self.noteTextField.text = self.note;
}

- (IBAction)save:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"Cannot connect to Internet"
                                    message:@"Please check your Internet Connection"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        [self cancel:sender];
        return;
    }
    
    self.editButton.hidden = NO;
    self.saveButton.hidden = self.cancelButton.hidden = YES;
    
    self.loginEmailTextField.enabled = self.passwordTextField.enabled = self.passwordTextField.userInteractionEnabled = self.titleLabel.userInteractionEnabled =
    self.titleLeftArrowImageView.userInteractionEnabled = self.nameTextField.enabled = self.streetTextField.enabled = self.cityTextField.enabled = self.stateTextField.enabled = self.countryLabel.userInteractionEnabled = self.countryLeftArrowImageView.userInteractionEnabled = self.zipCodeTextField.enabled = self.telNoTextField.enabled = self.noteTextField.editable = NO;
    
    self.loginEmail = self.loginEmailTextField.text;
    self.password = self.passwordTextField.text;
    self.userTitle = self.titleLabel.text;
    self.name = self.nameTextField.text;
    self.street = self.streetTextField.text;
    self.city = self.cityTextField.text;
    self.state = self.stateTextField.text;
    self.country = self.countryLabel.text;
    self.zipCode = self.zipCodeTextField.text;
    self.telNo = self.telNoTextField.text;
    self.note = self.noteTextField.text;
    
    // TODO: Save user
    if ([[Panachz getInstance] userIsLoggedIn]) {
        User *user = [Panachz getInstance].user;
        
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        
        __weak typeof (self) weakSelf = self;
        [[PanachzApi getInstance] POST:@"user/set/info"
                            parameters:@{@"user_id" : [NSString stringWithFormat:@"%lu", user.userId],
                                         @"title" : self.userTitle,
                                         @"name" : self.name,
                                         @"address_street" : self.street,
                                         @"address_city" : self.city,
                                         @"address_state" : self.state,
                                         @"address_country" : self.country,
                                         @"address_zipcode" : self.zipCode,
                                         @"phone_no" : self.telNo,
                                         @"notes" : self.note}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                   if ([[response objectForKey:@"code"] intValue] == 202) {
                                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                      message:@"Updated successfully!"
                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:nil];
                                       [alert addAction:action];
                                       [weakSelf presentViewController:alert
                                                              animated:YES
                                                            completion:nil];
                                       
                                       user.title = self.userTitle;
                                       user.name = self.name;
                                       user.street = self.street;
                                       user.city = self.city;
                                       user.state = self.state;
                                       user.country = self.country;
                                       user.zipCode = self.zipCode;
                                       user.telNo = self.telNo;
                                       user.notes = self.note;
                                       
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"UserUpdated" object:nil];
                                       
                                       [[PanachzApi getInstance] POST:@"user/set/password"
                                                           parameters:@{@"user_id" : [NSString stringWithFormat:@"%lu", user.userId],
                                                                        @"new_password" : [self.passwordTextField.text sha256]}
                                                              success:nil
                                                              failure:nil];
                                   } else {
                                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something wrong"
                                                                                                      message:[response objectForKey:@"message"]
                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:nil];
                                       [alert addAction:action];
                                       [weakSelf presentViewController:alert
                                                              animated:YES
                                                            completion:nil];
                                   }
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                            animated:YES];
                               }
                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something wrong"
                                                                                                  message:@"Please connect developer."
                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                   UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                    style:UIAlertActionStyleDefault
                                                                                  handler:nil];
                                   [alert addAction:action];
                                   [weakSelf presentViewController:alert
                                                          animated:YES
                                                        completion:nil];
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                            animated:YES];
                               }];
    }
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
