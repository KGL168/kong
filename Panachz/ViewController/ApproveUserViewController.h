//
//  ApproveUserViewController.h
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApproveUserDelegate <NSObject>

- (void)didApproveUser;

@end

@interface ApproveUserViewController : UIViewController

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) id <ApproveUserDelegate> approveUserDelegate;
@property (strong, nonatomic) IBOutlet UIView *customNavigationView;
@property (strong, nonatomic) IBOutlet UILabel *roleLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamLabel;
@property (strong, nonatomic) IBOutlet UIView *rmView;
@property (strong, nonatomic) IBOutlet UILabel *rmLabel;
@property (strong, nonatomic) IBOutlet UIView *rolePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *rmPickerView;

- (IBAction)openRolePicker:(id)sender;
- (IBAction)openRmPicker:(id)sender;
- (IBAction)setToRecruitmentManager:(id)sender;
- (IBAction)setToFashionAdvisor:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
