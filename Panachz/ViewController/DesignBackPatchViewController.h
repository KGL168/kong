//
//  DesignBackPatchViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 22/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignBackPatchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *resetBackPatchButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rightSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchCheckIcon;
@property (strong, nonatomic) IBOutlet UIImageView *wordingCheckIcon;

@property (strong, nonatomic) IBOutlet UIView *backPatchView;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *backPatchCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchThumbnail1;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchThumbnail2;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchThumbnail3;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchThumbnail4;

@property (strong, nonatomic) IBOutlet UIView *wordingView;
@property (strong, nonatomic) IBOutlet UIView *wordingWordView;
@property (strong, nonatomic) IBOutlet UIImageView *wordingBar;
@property (strong, nonatomic) IBOutlet UILabel *wordingViewWord;
@property (strong, nonatomic) IBOutlet UIImageView *wordingImageView;
@property (strong, nonatomic) IBOutlet UIButton *wordingLockButton;
@property (strong, nonatomic) IBOutlet UILabel *wordingFontTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordingFontSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordingFontColorLabel;
@property (strong, nonatomic) IBOutlet UITextField *wordingTextField;

@property (strong, nonatomic) IBOutlet UIView *BackPatchView;
@property (strong, nonatomic) IBOutlet UIView *bpView;



- (IBAction)rightSegmentedControlDidChangeValue:(UISegmentedControl *)sender;
- (IBAction)changeWords:(id)sender;
- (IBAction)wordLocks:(id)sender;


@end
