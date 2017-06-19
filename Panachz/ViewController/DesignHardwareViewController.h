//
//  DesignHardwareViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignHardwareViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *resetHardwareButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *shankCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *wordingCheckIcon;

@property (strong, nonatomic) IBOutlet UIImageView *rivetCheckIcon;

@property (strong, nonatomic) IBOutlet UIView *shankView;
@property (strong, nonatomic) IBOutlet UIImageView *shankImageView;
@property (strong, nonatomic) IBOutlet UIImageView *shankCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *shankCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *shankThumbnail1;
@property (strong, nonatomic) IBOutlet UIImageView *shankThumbnail2;

@property (strong, nonatomic) IBOutlet UIView *wordingView;
@property (strong, nonatomic) IBOutlet UIImageView *wordingImageView;
@property (strong, nonatomic) IBOutlet UIView *wordingWordView;
@property (strong, nonatomic) IBOutlet UIImageView *wordingBarline;
@property (strong, nonatomic) IBOutlet UILabel *wordingWord;
@property (strong, nonatomic) IBOutlet UILabel *wordingViewFontLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordingViewFontSizeLabel;
@property (strong, nonatomic) IBOutlet UITextField *wordingViewTextField;

@property (strong, nonatomic) IBOutlet UIButton *wordingLockButton;

@property (strong, nonatomic) IBOutlet UIView *rivetView;
@property (strong, nonatomic) IBOutlet UIImageView *rivetImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rivetCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *rivetCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rivetThumbnail1;
@property (strong, nonatomic) IBOutlet UIImageView *rivetThumbnail2;
@property (strong, nonatomic) IBOutlet UIImageView *rivetThumbnail3;
@property (strong, nonatomic) IBOutlet UIImageView *rivetThumbnail4;

@property (weak, nonatomic) IBOutlet UIImageView *previousButton;
@property (weak, nonatomic) IBOutlet UIImageView *nextButton;

@property (strong, nonatomic) IBOutlet UIView *hwView;


- (IBAction)rightSegmentedControlDidChangeValue:(id)sender;
- (IBAction)lockWordings:(id)sender;
- (IBAction)changeWords:(id)sender;

@end
