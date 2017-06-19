//
//  ApproveUserViewController.m
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ApproveUserViewController.h"
#import "MBProgressHUD.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"
#import "User.h"

#define RECRUITMENT_MANAGER @"Recruitment Manager"
#define FASHION_ADVISOR @"Fashion Advisor"

@interface ApproveUserViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *rms;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation ApproveUserViewController

@synthesize user_id;
@synthesize approveUserDelegate;
@synthesize customNavigationView;
@synthesize roleLabel;
@synthesize teamLabel;
@synthesize rmView;
@synthesize rmLabel;
@synthesize rolePickerView;
@synthesize rmPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup custom navigation bar
    self.customNavigationView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.customNavigationView.layer.borderWidth = 1.0f;
    
    self.rolePickerView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.rolePickerView.layer.borderWidth = 1.0f;
    
    // Rm Data
    self.rms = [[NSMutableArray alloc] init];
    self.rmPickerView.delegate = self;
    self.rmPickerView.dataSource = self;
    self.rmPickerView.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.rmPickerView.layer.borderWidth = 1.0f;
    self.selectedIndex = -1;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(closeRmPickerView)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    tap.delegate = self;
//    self.rmPickerView.userInteractionEnabled = YES;
//    [self.rmPickerView addGestureRecognizer:tap];
    [self getRecruitmentManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RM Data

- (void)getRecruitmentManager {
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:@"user/rm"
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSArray *usersArray = [responseObject objectForKey:@"users"];
                              for (int i = 0; i < usersArray.count; i++) {
                                  NSDictionary *userJson = [usersArray objectAtIndex:i];
                                  User *user = [[User alloc] init];
                                  user.userId = [[userJson objectForKey:@"user_id"] intValue];
                                  user.name = [userJson objectForKey:@"name"];
                                  [weakSelf.rms addObject:user];
                              }
                              [weakSelf.rmPickerView reloadAllComponents];
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
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

#pragma mark - Role Picker

- (IBAction)openRolePicker:(id)sender {
    if (self.rolePickerView.hidden) {
        self.rolePickerView.alpha = 0.0;
        self.rolePickerView.hidden = NO;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.rolePickerView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.rolePickerView becomeFirstResponder];
                             }
                         }];
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.rolePickerView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.rolePickerView resignFirstResponder];
                                 self.rolePickerView.hidden = YES;
                             }
                         }];
    }
}

- (void)closeRolePickerView {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.rolePickerView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.rolePickerView resignFirstResponder];
                             self.rolePickerView.hidden = YES;
                         }
                     }];
}

- (IBAction)setToRecruitmentManager:(id)sender {
    [self.roleLabel setText:RECRUITMENT_MANAGER];
    [self closeRolePickerView];
    self.teamLabel.hidden = YES;
    self.rmView.hidden = YES;
}

- (IBAction)setToFashionAdvisor:(id)sender {
    [self.roleLabel setText:FASHION_ADVISOR];
    [self closeRolePickerView];
    self.teamLabel.hidden = NO;
    self.rmView.hidden = NO;
}

#pragma mark - RM Picker

- (IBAction)openRmPicker:(id)sender {
    if (self.rmPickerView.hidden) {
        self.rmPickerView.alpha = 0.0;
        self.rmPickerView.hidden = NO;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.rmPickerView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.rmPickerView becomeFirstResponder];
                             }
                         }];
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.rmPickerView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.rmPickerView resignFirstResponder];
                                 self.rmPickerView.hidden = YES;
                             }
                         }];
    }
}

- (void)closeRmPickerView {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.rmPickerView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.rmPickerView resignFirstResponder];
                             self.rmPickerView.hidden = YES;
                         }
                     }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.rms.count) {
        [self.rmLabel setText:((User *)[self.rms objectAtIndex:row]).name];
        self.selectedIndex = ((User *)[self.rms objectAtIndex:row]).userId;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.rms.count == 0 ? 1 : self.rms.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.rms.count == 0 ? @"No Recruitment Manager" : ((User *)[self.rms objectAtIndex:row]).name;
}

#pragma mark - Action

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)save:(id)sender {
    if ([self.roleLabel.text isEqualToString:@"Role"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please select a role"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if ([self.roleLabel.text isEqualToString:FASHION_ADVISOR] && ([self.rmLabel.text isEqualToString:@"Recruitment Manager"] || [self.rmLabel.text isEqualToString:@"No Recruitment Manager"])) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Invalid Recruitment Manager"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] POST:@"user/setRole"
                        parameters:@{@"user_id" : self.user_id,
                                     @"role_id" : [self.roleLabel.text isEqualToString:RECRUITMENT_MANAGER] ? @"2" : @"3",
                                     @"supervisor_id" : [NSString stringWithFormat:@"%lu", self.selectedIndex]}
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [weakSelf.approveUserDelegate didApproveUser];
                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                        animated:YES];
                               [weakSelf cancel:nil];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self closeRolePickerView];
    [self closeRmPickerView];
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
