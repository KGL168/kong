//
//  TrainingVideoViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 15/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingVideoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *designTabButton;
@property (strong, nonatomic) IBOutlet UIButton *customerTabButton;
@property (strong, nonatomic) IBOutlet UIButton *orderTabButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *trainingViewCategorySegmentedControl;
@property (strong, nonatomic) IBOutlet UICollectionView *videoCollectionView;

- (IBAction)tabButtonPressed:(id)sender;

@end
