//
//  AddCustomerViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 16/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "AddCustomerViewController.h"
#import "MBProgressHUD.h"
#import "NSString+ValidEmail.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "UIColor+HexColor.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 280;

@interface AddCustomerViewController () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate> 
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *countries;
@end

@implementation AddCustomerViewController

CGFloat animatedDistance4;

@synthesize acDelegate;

@synthesize titlePickerView;
@synthesize countryPickerView;

@synthesize titleLabel;
@synthesize titleLeftArrowImageView;
@synthesize nameTextField;
@synthesize streetTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize emailTextField;
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
    self.customerNavigationBar.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.customerNavigationBar.layer.borderWidth = 1.0;
    
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
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.nameTextField.leftView = leftPadding;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.streetTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.streetTextField.leftView = leftPadding;
    self.streetTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.cityTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.cityTextField.leftView = leftPadding;
    self.cityTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.stateTextField.delegate = self;
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
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.zipCodeTextField.leftView = leftPadding;
    self.zipCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.telNoTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.telNoTextField.leftView = leftPadding;
    self.telNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.emailTextField.delegate = self;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.emailTextField.leftView = leftPadding;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.noteTextField.delegate = self;
    self.noteTextField.layer.cornerRadius = 4.0;
    leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.noteTextField.textContainerInset = UIEdgeInsetsMake(5, 3.5, 5, 3.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation bar buttom action

- (IBAction)addNewCustomer:(id)sender {
    if (self.nameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Name cannot be not empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.streetTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Street cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.cityTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"City cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.stateTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"State cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if ([self.countryLabel.text isEqualToString:@"Country"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please select a country"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.zipCodeTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Zip Code cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.telNoTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Telephone number cannot be empty"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (self.emailTextField.text == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Email cannot be empty"
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
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"customer/create"
                        parameters:@{@"user_id" : [NSString stringWithFormat:@"%lu", [Panachz getInstance].user.userId],
                                     @"email" : self.emailTextField.text,
                                     @"title" : self.titleLabel.text,
                                     @"name" : self.nameTextField.text,
                                     @"phone_no" : self.telNoTextField.text,
                                     @"address_street" : self.streetTextField.text,
                                     @"address_city" : self.cityTextField.text,
                                     @"address_state" : self.stateTextField.text,
                                     @"address_country" : self.countryLabel.text,
                                     @"address_zipcode" : self.zipCodeTextField.text,
                                     @"measurement_waist" : @"0.0",
                                     @"measurement_hips" : @"0.0",
                                     @"measurement_thigh" : @"0.0",
                                     @"measurement_inseam" : @"0.0",
                                     @"measurement_outseam" : @"0.0",
                                     @"measurement_curve" : @"0.0",
                                     @"notes" : self.noteTextField.text}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                               if ([[response objectForKey:@"code"] intValue] == 301) {
                                   NSDictionary *customerJson = [responseObject objectForKey:@"customer"];
                                   Customer *c = [[Customer alloc] initWithCustomerId:[[customerJson objectForKey:@"customer_id"] intValue]
                                                                                email:[customerJson objectForKey:@"email"]
                                                                                title:[customerJson objectForKey:@"title"]
                                                                                 name:[customerJson objectForKey:@"name"]
                                                                               street:[customerJson objectForKey:@"address_street"]
                                                                                 city:[customerJson objectForKey:@"address_city"]
                                                                                state:[customerJson objectForKey:@"address_state"]
                                                                              country:[customerJson objectForKey:@"address_country"]
                                                                              zipCode:[customerJson objectForKey:@"address_zipcode"]
                                                                                telNo:[customerJson objectForKey:@"phone_no"]
                                                                                notes:[customerJson objectForKey:@"notes"]];
                                   c.waist = @"0.0";
                                   c.hips = @"0.0";
                                   c.thigh = @"0.0";
                                   c.inseam = @"0.0";
                                   c.outseam = @"0.0";
                                   c.curve = @"0.0";
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                            animated:YES];
                                   
                                   [weakSelf.acDelegate didAddUser:c];
                                   [weakSelf dismissViewControllerAnimated:YES
                                                                completion:nil];
                                   
                               } else {
                                   NSLog(@"Object: %@", responseObject);
                               }
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:[NSString stringWithFormat:@"%@", error]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                        animated:YES];
                           }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)didAddUser {
    NSDictionary *userInfo = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCustomerForCheckOut"
                                                        object:self
                                                      userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCustomer"
                                                        object:self
                                                      userInfo:userInfo];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.streetTextField becomeFirstResponder];
    } else if (textField == self.streetTextField) {
        [self.cityTextField becomeFirstResponder];
    } else if (textField == self.cityTextField) {
        [self.stateTextField becomeFirstResponder];
    } else if (textField == self.stateTextField) {
        [self.stateTextField resignFirstResponder];
        [self openCountryPicker];
    } else if (textField == self.zipCodeTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.telNoTextField becomeFirstResponder];
    }else if (textField == self.telNoTextField) {
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
        animatedDistance4 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance4 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance4;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
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
        animatedDistance4 = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance4 = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance4;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
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