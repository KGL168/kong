//
//  DesignWashViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jeans.h"

@interface DesignWashViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *resetWashButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *jeansView;
@property (strong, nonatomic) IBOutlet UIImageView *jeansViewJeansImageView;
@property (strong, nonatomic) IBOutlet UILabel *washDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *jeansWashScrollview;
@property (strong, nonatomic) IBOutlet UIImageView *jeansWashScrollviewLeftButton;
@property (strong, nonatomic) IBOutlet UIImageView *jeansWashScrollviewRightButton;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *addWashButtonGroup;


@property (strong, nonatomic) IBOutlet UIView *leftAddWashTempView;
@property (strong, nonatomic) IBOutlet UIView *rightAddWashTempView;
@property (strong, nonatomic) IBOutlet UIImageView *leftAddHandWhiskerButton;
@property (strong, nonatomic) IBOutlet UIImageView *rightAddHandWhiskerButton;

@property (strong, nonatomic) IBOutlet UIImageView *leftAddSandBlastingButton;
@property (strong, nonatomic) IBOutlet UIImageView *rightAddSandBlastingButton;

@property (strong, nonatomic) IBOutlet UIImageView *leftAddTackingButton;
@property (strong, nonatomic) IBOutlet UIImageView *rightAddTackingButton;

@property (strong, nonatomic) IBOutlet UIImageView *leftAddRipAndTearButton;
@property (strong, nonatomic) IBOutlet UIImageView *rightAddRipAndTearButton;

@property (strong, nonatomic) IBOutlet UIImageView *leftAddGrindingButton;
@property (strong, nonatomic) IBOutlet UIImageView *rightAddGrindingButton;

@property (strong, nonatomic) IBOutlet UIView *washView;
@property (strong, nonatomic) IBOutlet UIImageView *washImageView;
@property (strong, nonatomic) IBOutlet UIView *washSandBlastingOpacityView;
@property (strong, nonatomic) IBOutlet UIImageView *washSandBlastingPlusOpacityButton;
@property (strong, nonatomic) IBOutlet UIImageView *washSandBlastingMinusOpacityButton;

@property (strong, nonatomic) IBOutlet UIImageView *scrollviewLeftArrowButton;
@property (strong, nonatomic) IBOutlet UIImageView *scrollviewRightArrowButton;
@property (strong, nonatomic) IBOutlet UIScrollView *washScrollview;


- (IBAction)rightSegmentedControlDidChangeValue:(id)sender;

@end
