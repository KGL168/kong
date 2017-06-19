//
//  DesignSummaryViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignSummaryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *leftView;

@property (strong, nonatomic) IBOutlet UIView *hardwareView;
@property (strong, nonatomic) IBOutlet UIView *backPatchView;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchImageView;
@property (strong, nonatomic) IBOutlet UIImageView *harewareImageView;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@property (weak, nonatomic) IBOutlet UITableView *washDetailsTableView;
@property (weak, nonatomic) IBOutlet UILabel *bottomInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *fitInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *washInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *basecolorInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fabricLabel;
@property (weak, nonatomic) IBOutlet UILabel *fabricInfoLabel;


@end
