//
//  LoginViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 6/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "NSString+SHA256.h"
#import "NSString+ValidEmail.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "UIColor+HexColor.h"
#import "LDLanguageTool.h"
#import "LDenimApi.h"
#import "AppDelegate.h"

@interface LoginViewController () <UITextFieldDelegate> {
    /* keyboard auto go up */
    CGFloat currentKeyboardHeight;
    CGFloat deltaHeight;
    CGFloat moved;
    CGFloat textfield_y;
    bool animated;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonOfEnglish;
@property (weak, nonatomic) IBOutlet UIButton *buttonOfChinese;

@end

@implementation LoginViewController

@synthesize backgrounImage;
@synthesize loginEmailTextField;
@synthesize passwordTextField;
@synthesize forgetPasswordButton;
@synthesize loginButton;
@synthesize signupButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup for text field
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    
    self.loginEmailTextField.delegate = self;
    self.loginEmailTextField.leftView = leftPaddingView;
    self.loginEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.loginEmailTextField.layer.borderWidth = 1.0;
    self.loginEmailTextField.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    self.passwordTextField.delegate = self;
    self.passwordTextField.leftView = leftPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.layer.borderWidth = 1.0;
    self.passwordTextField.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    if ([[LDLanguageTool sharedInstance] getNowLanguageNum] == 0) {
        self.buttonOfEnglish.selected = YES;
        self.buttonOfChinese.selected = NO;
    }else{
        self.buttonOfEnglish.selected = NO;
        self.buttonOfChinese.selected = YES;
    }
    
    //[self tryLogin];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [userDefaults valueForKey:@"UserEmail"];
    NSString *password = [userDefaults valueForKey:@"UserPassword"];
    [self.loginEmailTextField setText:email];
    [self.passwordTextField setText:password];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.backgrounImage setImage:[UIImage imageNamed:@"login_bg"]];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate fetchLDenimIsNeedUpdate];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.backgrounImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.backgrounImage = nil;
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

#pragma mark -  Text Field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect newFrame = [textField convertRect:textField.bounds
                                      toView:nil];
    textfield_y = newFrame.origin.y;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginEmailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)login:(id)sender {
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
    
    NSString *email = self.loginEmailTextField.text;
    NSString *password = self.passwordTextField.text;
   
    if (email.length == 0 || password.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"Please fill in all the fields"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (![email isAValidEmail]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter a valid email"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];

    __weak typeof(self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"user/login"
                        parameters:@{@"email" : email,
                                     @"password" : [password sha256]}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                               
                               if ([[response objectForKey:@"code"] intValue] == 200) {
                                   [self.loginEmailTextField setText:@""];
                                   [self.passwordTextField setText:@""];
                                   
                                   NSDictionary *userInfo = [responseObject objectForKey:@"user"];
                                   
                                   User *user = [[User alloc] initWithUserID:[[userInfo objectForKey:@"user_id"] intValue]
                                                                    email:[userInfo objectForKey:@"email"]
                                                                    title:[userInfo objectForKey:@"title"]
                                                                     name:[userInfo objectForKey:@"name"]
                                                                   street:[userInfo objectForKey:@"address_street"]
                                                                     city:[userInfo objectForKey:@"address_city"]
                                                                    state:[userInfo objectForKey:@"address_state"]
                                                                  country:[userInfo objectForKey:@"address_country"]
                                                                  zipCode:[userInfo objectForKey:@"address_zipcode"]
                                                                    telNo:[userInfo objectForKey:@"phone_no"]
                                                                    notes:[userInfo objectForKey:@"notes"]];
                                   user.role = [userInfo objectForKey:@"role"];
                                   
                                   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                   [userDefault setObject:email forKey:@"UserEmail"];
                                   [userDefault setObject:password forKey:@"UserPassword"];
                                   
                                   //判断是否是vip
                                   user.isVip = [self compareVipuntil:userInfo[@"vipuntil"] withServertime:responseObject[@"servertime"]];
                                   
                                   [Panachz getInstance].user = user;
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogin" object:nil];
                                   //到主页面
                                   [weakSelf performSegueWithIdentifier:@"GoToMainScreen" sender:sender];
                                   //到aboutLdenim页面
//                                   [weakSelf performSegueWithIdentifier:@"GoToTutorialScreen" sender:sender];
                               } else {
                                   NSLog(@"%@", response[@"message"]);
                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"Invalid email or password"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil] show];
                               }
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                        animated:YES];
                           }
                           failure:^(NSURLSessionDataTask *task, id responseObject) {
                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:[NSString stringWithFormat:@"Something wrong! %@", responseObject]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil] show];
                               
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                        animated:YES];
                           }];
}

//3cm_比较日期时间判断，是否是会员
-(BOOL)compareVipuntil:(NSString*)date01 withServertime:(NSString*)date02{
    BOOL ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=NO; break;
            //date02比date01小
        case NSOrderedDescending: ci=YES; break;
            //date02=date01
        case NSOrderedSame: ci=YES; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


#pragma mark - Auto Login

- (void)tryLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [userDefaults valueForKey:@"UserEmail"];
    NSString *password = [userDefaults valueForKey:@"UserPassword"];
    
    if (email != nil && password != nil) {
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        
        __weak typeof(self) weakSelf = self;
        [[PanachzApi getInstance] POST:@"user/login"
                            parameters:@{@"email" : email,
                                         @"password" : [password sha256]}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                   NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                   
                                   if ([[response objectForKey:@"code"] intValue] == 200) {
                                       [self.loginEmailTextField setText:@""];
                                       [self.passwordTextField setText:@""];
                                       
                                       NSDictionary *userInfo = [responseObject objectForKey:@"user"];
                                       
                                       User *user = [[User alloc] initWithUserID:[[userInfo objectForKey:@"user_id"] intValue]
                                                                           email:[userInfo objectForKey:@"email"]
                                                                           title:[userInfo objectForKey:@"title"]
                                                                            name:[userInfo objectForKey:@"name"]
                                                                          street:[userInfo objectForKey:@"address_street"]
                                                                            city:[userInfo objectForKey:@"address_city"]
                                                                           state:[userInfo objectForKey:@"address_state"]
                                                                         country:[userInfo objectForKey:@"address_country"]
                                                                         zipCode:[userInfo objectForKey:@"address_zipcode"]
                                                                           telNo:[userInfo objectForKey:@"phone_no"]
                                                                           notes:[userInfo objectForKey:@"notes"]];
                                       
                                       [Panachz getInstance].user = user;
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLogin" object:nil];
                                       
                                       [weakSelf performSegueWithIdentifier:@"GoToMainScreen" sender:nil];
//                                       [weakSelf performSegueWithIdentifier:@"GoToTutorialScreen" sender:sender];
                                   }
                                   
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                            animated:YES];
                               }
                               failure:^(NSURLSessionDataTask *task, id responseObject) {
                                   [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                            animated:YES];
                               }];
    }
}

- (IBAction)changeLanguageToEnglish:(UIButton *)sender {
    [[LDLanguageTool sharedInstance] changeToLanguage:0];
    self.buttonOfEnglish.selected = YES;
    self.buttonOfChinese.selected = NO;
}

- (IBAction)changeLanguageToChinese:(UIButton *)sender {
    [[LDLanguageTool sharedInstance] changeToLanguage:1];
    self.buttonOfEnglish.selected = NO;
    self.buttonOfChinese.selected = YES;
}


@end
