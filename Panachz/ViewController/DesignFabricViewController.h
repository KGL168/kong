//
//  DesignFabricViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 13/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jeans.h"

@interface DesignFabricViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *resetFabricButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *fabricCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *baseColorCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *constructionThreadCheckIcon;

@property (strong, nonatomic) IBOutlet UIView *fabricView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *fabricViewSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *fabricImageView;
@property (strong, nonatomic) IBOutlet UILabel *fabricDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *fabricCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *fabricCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *fabricPreviewScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *fabricPreviewLeftButton;
@property (strong, nonatomic) IBOutlet UIImageView *fabricPreviewRightButton;

@property (strong, nonatomic) IBOutlet UIView *BaseColorView;
@property (strong, nonatomic) IBOutlet UIImageView *baseColorImageView;
@property (strong, nonatomic) IBOutlet UILabel *baseColorDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *baseColorCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *baseColorCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lightBaseColorThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIImageView *mediumBaseColorThumbnailImageView;
@property (strong, nonatomic) IBOutlet UIImageView *darkBaseColorThumbnailImageView;

@property (strong, nonatomic) IBOutlet UIView *constructionThreadView;
@property (strong, nonatomic) IBOutlet UIImageView *constructionThreadImageView;
@property (strong, nonatomic) IBOutlet UIImageView *constructionThreadCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *constructionThreadCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *constructionThreadPreviewScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *constructionThreadPreviewLeftButton;
@property (strong, nonatomic) IBOutlet UIImageView *constructionThreadPreviewRightButton;
@property (weak, nonatomic) IBOutlet UILabel *constructionThreadLabel;
@property (weak, nonatomic) IBOutlet UILabel *fabricTypeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *fabricTypePicker;


- (IBAction)rightSegmentedControlChangeValue:(id)sender;
- (IBAction)fabricViewSegmentedControlChangeValue:(id)sender;

@end
