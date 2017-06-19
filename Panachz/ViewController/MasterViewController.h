//
//  MainViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

typedef NS_ENUM(NSUInteger, MasterView) {
    DESIGN_VIEW,
    CUSTOMER_VIEW,
    ORDER_VIEW
};

@property (nonatomic) MasterView tab;

@property (strong, nonatomic) IBOutlet UIButton *designTabButton;
@property (strong, nonatomic) IBOutlet UIButton *customerTabButton;
@property (strong, nonatomic) IBOutlet UIButton *orderTabButton;
@property (strong, nonatomic) IBOutlet UIView *designContainerView;
@property (strong, nonatomic) IBOutlet UIView *customerContainerView;
@property (strong, nonatomic) IBOutlet UIView *orderContainerView;

- (IBAction)tabButtonPressed:(id)sender;

@end
