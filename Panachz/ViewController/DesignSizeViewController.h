//
//  DesignSizeViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 22/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHRotaryKnob.h"

@interface DesignSizeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *resetSizeButton;

@property (strong, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *outseamSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *inseamSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *waistSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hipsSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *thighSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *curveSizeLabel;

@property (strong, nonatomic) IBOutlet MHRotaryKnob *measurementRotateView;
@property (strong, nonatomic) IBOutlet UILabel *measurementLabel;
@property (strong, nonatomic) IBOutlet UIButton *inchButton;
@property (strong, nonatomic) IBOutlet UIButton *cmButton;
@property (strong, nonatomic) IBOutlet UIButton *lockButton;

@property (strong, nonatomic) IBOutlet UIScrollView *measurementInchScrollview;
@property (strong, nonatomic) IBOutlet UIScrollView *measurementCMScrollview;
@property (strong, nonatomic) IBOutlet UISlider *measurementSlider;

- (IBAction)lockSize:(UIButton *)sender;
- (IBAction)rightSegmentedControlDidChangeValue:(UISegmentedControl *)sender;
- (IBAction)switchToInchOrCM:(UIButton *)sender;
@end
