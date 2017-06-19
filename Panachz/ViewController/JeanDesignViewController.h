//
//  JeanDesignViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jeans.h"

@interface JeanDesignViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *jeanDesignSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *fitCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *fabricCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *washCheckIcon;

@property (strong, nonatomic) IBOutlet UIView *FitContainerView;
@property (strong, nonatomic) IBOutlet UIView *FabricContainerView;
@property (strong, nonatomic) IBOutlet UIView *WashContainerView;
@property (strong, nonatomic) IBOutlet UIView *SummaryContainerView;

- (IBAction)switchDesignItem:(id)sender;

@end
