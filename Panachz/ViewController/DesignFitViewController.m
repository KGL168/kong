//
//  DesignFitViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignFitViewController.h"
#import "Jeans.h"
#import "JeansImagePreviewViewController.h"
#import "UIColor+HexColor.h"
#import "LDLanguageTool.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

#define MEN_SKINNY_FIT @"Men's Skinny Fit"
#define WOMEN_SKINNY_FIT @"Women's Skinny Fit"
#define MEN_STRAIGHT_FIT @"Men's Straight Fit"
#define WOMEN_STRAIGHT_FIT @"Women's Straight Fit"
#define MEN_BOOTCUT_FIT @"Men's Bootcut Fit"
#define WOMEN_BOOTCUT_FIT @"Women's Bootcut Fit"
#define WOMEN_JEGGINGS_FIT @"Women's Jeggings Fit"

#define MEN_LOW @"Men Low"
#define MEN_MIDDLE @"Men Middle"
#define WOMEN_LOW @"Women Low"
#define WOMEN_MIDDLE @"Women Middle"

#define ZIP_FLY @"Zip Fly"
#define BUTTON_FLY @"Button Fly"

@interface DesignFitViewController ()

@property (nonatomic, strong) NSArray *checkedIcons;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSDictionary *backgroundImages;
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic) NSUInteger imageSet;

@end

@implementation DesignFitViewController

@synthesize resetButtonImageView;
@synthesize backgroundImage;
@synthesize backgroundImages;
@synthesize fitCheckBarImageView;
@synthesize fitCheckBarTextLabel;
@synthesize currentJeans;
@synthesize gender;
@synthesize genderImageView;
@synthesize rightSegmentedControl;
@synthesize fitCheckIcon;
@synthesize riseCheckIcon;
@synthesize flyCheckIcon;

@synthesize fitView;
@synthesize jeansImageView;
@synthesize jeansFitDescriptionLabel;
@synthesize jeansFitDescriptionLabel2;
@synthesize skinnyFitThumbnailImageView;
@synthesize skinnyFitThumbnailBorder;
@synthesize straightFitThumbnailImageView;
@synthesize straightFitThumbnailBorder;
@synthesize bootutFitThumbnailImageView;
@synthesize bootcutFitThumbnailBorder;
@synthesize jegginsFitThumbnail;
@synthesize jeggingsFitThumbnailImageView;
@synthesize jeggingsFitThumbnailBorder;

@synthesize riseView;
@synthesize riseViewJeansImageView;
@synthesize riseViewJeansDescriptionLabel;
@synthesize riseViewJeansDescriptionLabel2;
@synthesize riseCheckBarImageView;
@synthesize riseCheckBarTextLabel;
@synthesize lowRiseThumbnailImageview;
@synthesize lowRiseThumbnailBorder;
@synthesize midRiseThumbmailImageView;
@synthesize midRiseThumbnailBorder;

@synthesize flyView;
@synthesize flyViewJeansImageView;
@synthesize flyViewJeansDescriptionLabel;
@synthesize flyViewJeansDescriptionLabel2;
@synthesize flyCheckBarImageView;
@synthesize flyCheckBarTextLabel;
@synthesize zipFlyThumbnailImageView;
@synthesize zipFlyThumbnailBorder;
@synthesize buttonFlyThumbnailImageView;
@synthesize buttonFlyThumbnailBorder;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup background image;
    self.backgroundImages = @{@"M" : @[@"Men_Skinny_Fit_bg", @"Men_Straight_Fit_bg", @"Men_Bootcut_fit_bg"],
                              @"F" : @[@"Women_Skinny_Fit_bg", @"Women_Straight_Fit_bg", @"Women_Bootcut_Fit_bg", @"Women_Jeggings_Fit_bg"]};
    
    // Setup Tap gesture on gender image icon
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(switchGender)];
    [tap setNumberOfTapsRequired:1];
    [self.genderImageView setUserInteractionEnabled:YES];
    [self.genderImageView addGestureRecognizer:tap];
    
    // Setup Tap gestue on reset button
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(resetFit)];
    [tap setNumberOfTapsRequired:1];
    [self.resetButtonImageView setUserInteractionEnabled:YES];
    [self.resetButtonImageView addGestureRecognizer:tap];
    
    // Setup segmented control in the right view
    NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                             size:12.0f],
                                       NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0x444444]};
    [self.rightSegmentedControl setTitleTextAttributes:normalAttributes
                                              forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                               size:12.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0xffffff]};
    [self.rightSegmentedControl setTitleTextAttributes:selectedAttributes
                                              forState:UIControlStateSelected];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Fit") forSegmentAtIndex:0];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Rise") forSegmentAtIndex:1];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Fly") forSegmentAtIndex:2];
    
    // Setup checked icons
    self.checkedIcons = @[self.fitCheckIcon, self.riseCheckIcon, self.flyCheckIcon];
    
    /* Setup for fit View */
    
    self.imageSet = 0;
    
    // Setup fit check bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(fitDidCheck)];
    [tap setNumberOfTapsRequired:1];
    [self.fitCheckBarImageView setUserInteractionEnabled:YES];
    [self.fitCheckBarImageView addGestureRecognizer:tap];
    
    // Setup thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToSkinnyFit)];
    [tap setNumberOfTapsRequired:1];
    [self.skinnyFitThumbnailImageView setUserInteractionEnabled:YES];
    [self.skinnyFitThumbnailImageView addGestureRecognizer:tap];
    self.skinnyFitThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.skinnyFitThumbnailBorder.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToStraightFit)];
    [tap setNumberOfTapsRequired:1];
    [self.straightFitThumbnailImageView setUserInteractionEnabled:YES];
    [self.straightFitThumbnailImageView addGestureRecognizer:tap];
    self.straightFitThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.straightFitThumbnailBorder.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToBootcutFit)];
    [tap setNumberOfTapsRequired:1];
    [self.bootutFitThumbnailImageView setUserInteractionEnabled:YES];
    [self.bootutFitThumbnailImageView addGestureRecognizer:tap];
    self.bootcutFitThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.bootcutFitThumbnailBorder.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToJeggingsFit)];
    [tap setNumberOfTapsRequired:1];
    [self.jeggingsFitThumbnailImageView setUserInteractionEnabled:YES];
    [self.jeggingsFitThumbnailImageView addGestureRecognizer:tap];
    self.jeggingsFitThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.jeggingsFitThumbnailBorder.layer.borderWidth = 2.0;
    
    /* End Setup for fit View */
    
    /* Setup for rise view */
    
    // Setup rise check bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(riseDidCheck)];
    [tap setNumberOfTapsRequired:1];
    [self.riseCheckBarImageView setUserInteractionEnabled:YES];
    [self.riseCheckBarImageView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToLowRise)];
    [tap setNumberOfTapsRequired:1];
    [self.lowRiseThumbnailImageview setUserInteractionEnabled:YES];
    [self.lowRiseThumbnailImageview addGestureRecognizer:tap];
    self.lowRiseThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.lowRiseThumbnailBorder.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToMiddleRise)];
    [tap setNumberOfTapsRequired:1];
    [self.midRiseThumbmailImageView setUserInteractionEnabled:YES];
    [self.midRiseThumbmailImageView addGestureRecognizer:tap];
    self.midRiseThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.midRiseThumbnailBorder.layer.borderWidth = 2.0;
    
    /* End Setup for rise view */
    
    /* Setup for fly view */
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(flyDidCheck)];
    [tap setNumberOfTapsRequired:1];
    [self.flyCheckBarImageView setUserInteractionEnabled:YES];
    [self.flyCheckBarImageView addGestureRecognizer:tap];
    
    // Setup thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToZipFly)];
    [tap setNumberOfTapsRequired:1];
    [self.zipFlyThumbnailImageView setUserInteractionEnabled:YES];
    [self.zipFlyThumbnailImageView addGestureRecognizer:tap];
    self.zipFlyThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.zipFlyThumbnailBorder.layer.borderWidth = 2.0;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToButtonFly)];
    [tap setNumberOfTapsRequired:1];
    [self.buttonFlyThumbnailImageView setUserInteractionEnabled:YES];
    [self.buttonFlyThumbnailImageView addGestureRecognizer:tap];
    self.buttonFlyThumbnailBorder.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.buttonFlyThumbnailBorder.layer.borderWidth = 2.0;
    
    /* End Setup for fly view */
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchGender:)
                                                 name:@"SwitchGender"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetFit {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Are you sure to reset Fit?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canel = [UIAlertAction actionWithTitle:@"No"
                                                    style:UIAlertActionStyleCancel
                                                  handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.currentJeans.jeanFit = JEANS_FIT_NOT_SET;
                                                    self.currentJeans.jeanRise = JEANS_RISE_NOT_SET;
                                                    self.currentJeans.jeanFly = JEANS_FLY_NOT_SET;
                                                    
                                                    self.fitView.hidden = NO;
                                                    self.riseView.hidden = YES;
                                                    self.flyView.hidden = YES;
                                                    
                                                    [self.fitCheckIcon setImage:nil];
                                                    [self.riseCheckIcon setImage:nil];
                                                    [self.flyCheckIcon setImage:nil];
                                                    
                                                    [self switchToSkinnyFit];
                                                    [self switchToLowRise];
                                                    [self switchToZipFly];
                                                    
                                                    [self.rightSegmentedControl setSelectedSegmentIndex:0];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFit"
                                                                                                        object:nil];
                                                }];
    [alert addAction:canel];
    [alert addAction:yes];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - NSNotification Centre

- (void)didSelectGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    
    if ([self.gender isEqualToString:@"M"]) {
        [self.genderImageView setImage:[UIImage imageNamed:@"gender_male"]];
        
        // Set the thumbnail
        [self.skinnyFitThumbnailImageView setImage:[UIImage imageNamed:@"USKY-001M-F_thumbnail"]];
        [self.straightFitThumbnailImageView setImage:[UIImage imageNamed:@"USTR-001M-F_thumbnail"]];
        [self.bootutFitThumbnailImageView setImage:[UIImage imageNamed:@"UBTC-001M-F_thumbnail"]];
        [self.jeggingsFitThumbnailImageView setImage:nil];
        [self.jegginsFitThumbnail setBackgroundColor:[UIColor colorWithRBGValue:0xcbcaca]];
        
        [self.lowRiseThumbnailImageview setImage:[UIImage imageNamed:@"men_low_rise_thumbnail"]];
        [self.midRiseThumbmailImageView setImage:[UIImage imageNamed:@"men_mid_rise_thumbnail"]];
    } else {
        [self.genderImageView setImage:[UIImage imageNamed:@"gender_female"]];
        
        // Set the thumbnail
        [self.skinnyFitThumbnailImageView setImage:[UIImage imageNamed:@"USKY-001F-F_thumbnail"]];
        [self.straightFitThumbnailImageView setImage:[UIImage imageNamed:@"USTR-001F-F_thumbnail"]];
        [self.bootutFitThumbnailImageView setImage:[UIImage imageNamed:@"UBTC-001F-F_thumbnail"]];
        [self.jeggingsFitThumbnailImageView setImage:[UIImage imageNamed:@"UJEG-001F-F_thumbnail"]];
        [self.jegginsFitThumbnail setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
        
        [self.lowRiseThumbnailImageview setImage:[UIImage imageNamed:@"lady_low_rise_thumbnail"]];
        [self.midRiseThumbmailImageView setImage:[UIImage imageNamed:@"lady_mid_rise_thumbnail"]];
    }
    
    // Switch to Skinny Fit
    [self switchToSkinnyFit];
    
    // Switch to Low Rise
    [self switchToLowRise];
    
    // Switch to Zip Fly
    [self switchToZipFly];
    
}

- (void)didSwitchGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];

    if ([self.gender isEqualToString:@"M"]) {
        self.currentJeans.jeanGender = JEANS_GENDER_M;
        
        [self.genderImageView setImage:[UIImage imageNamed:@"gender_male"]];
        
        // Switch to Skinny Fit
        [self switchToSkinnyFit];
        
        // Switch the thumbnail
        [self.skinnyFitThumbnailImageView setImage:[UIImage imageNamed:@"USKY-001M-F_thumbnail"]];
        [self.straightFitThumbnailImageView setImage:[UIImage imageNamed:@"USTR-001M-F_thumbnail"]];
        [self.bootutFitThumbnailImageView setImage:[UIImage imageNamed:@"UBTC-001M-F_thumbnail"]];
        [self.jeggingsFitThumbnailImageView setImage:nil];
        [self.jegginsFitThumbnail setBackgroundColor:[UIColor colorWithRBGValue:0xccccccc
                                                                          alpha:0.5]];
        // Switch to Low Rise
        [self switchToLowRise];
        
        [self.lowRiseThumbnailImageview setImage:[UIImage imageNamed:@"men_low_rise_thumbnail"]];
        [self.midRiseThumbmailImageView setImage:[UIImage imageNamed:@"men_mid_rise_thumbnail"]];
    } else {
        self.currentJeans.jeanGender = JEANS_GENDER_F;
        
        [self.genderImageView setImage:[UIImage imageNamed:@"gender_female"]];
        
        // Switch to Skinny Fit
        [self switchToSkinnyFit];
        
        // Switch the thumbnail
        [self.skinnyFitThumbnailImageView setImage:[UIImage imageNamed:@"USKY-001F-F_thumbnail"]];
        [self.straightFitThumbnailImageView setImage:[UIImage imageNamed:@"USTR-001F-F_thumbnail"]];
        [self.bootutFitThumbnailImageView setImage:[UIImage imageNamed:@"UBTC-001F-F_thumbnail"]];
        [self.jeggingsFitThumbnailImageView setImage:[UIImage imageNamed:@"UJEG-001F-F_thumbnail"]];
        [self.jegginsFitThumbnail setBackgroundColor:[UIColor colorWithRBGValue:0xffffff
                                                                          alpha:0.5]];        
        // Switch to Low Rise
        [self switchToLowRise];
        
        [self.lowRiseThumbnailImageview setImage:[UIImage imageNamed:@"lady_low_rise_thumbnail"]];
        [self.midRiseThumbmailImageView setImage:[UIImage imageNamed:@"lady_mid_rise_thumbnail"]];
    }
    
    // Switch to Zip Fly
    [self switchToZipFly];
    
    [self.backgroundImage setImage:[UIImage imageNamed:[[self.backgroundImages objectForKey:self.gender] objectAtIndex:0]]];
}

- (void)switchGender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                   message:@"Switching gender will result in lossing save of the current design. Are you sure to switch gender?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canel = [UIAlertAction actionWithTitle:@"No"
                                                    style:UIAlertActionStyleCancel
                                                  handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    [self.currentJeans resetJeans];
                                                    
                                                    NSDictionary *userInfo = @{@"Gender" : ([self.gender isEqualToString:@"M"] ? @"F" : @"M")};
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchGender"
                                                                                                        object:self
                                                                                                      userInfo:userInfo];
                                                    // TODO Reset Jeans
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetJeans"
                                                                                                        object:self
                                                                                                      userInfo:userInfo];
                                                }];
    [alert addAction:canel];
    [alert addAction:yes];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToJeansImage1PreviewSegue"]) {
        JeansImagePreviewViewController *vc = (JeansImagePreviewViewController *)segue.destinationViewController;
        vc.imageSet = self.imageSet;
        vc.imageNo = 0;
    } else if ([segue.identifier isEqualToString:@"GoToJeansImage2PreviewSegue"]) {
        JeansImagePreviewViewController *vc = (JeansImagePreviewViewController *)segue.destinationViewController;
        vc.imageSet = self.imageSet;
        vc.imageNo = 1;
    } else if ([segue.identifier isEqualToString:@"GoToJeansImage3PreviewSegue"]) {
        JeansImagePreviewViewController *vc = (JeansImagePreviewViewController *)segue.destinationViewController;
        vc.imageSet = self.imageSet;
        vc.imageNo = 2;
    } else if ([segue.identifier isEqualToString:@"GoToJeansImage4PreviewSegue"]) {
        JeansImagePreviewViewController *vc = (JeansImagePreviewViewController *)segue.destinationViewController;
        vc.imageSet = self.imageSet;
        vc.imageNo = 3;
    }
}

#pragma mark - Segmented Control

- (IBAction)didChangeSegmentControlOption:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    for (int i = 0; i < self.checkedIcons.count; i++) {
        UIImageView *checkedIcon = [self.checkedIcons objectAtIndex:i];
        [checkedIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
    }
    
    if (segmentedControl.selectedSegmentIndex < self.checkedIcons.count) {
        [[self.checkedIcons objectAtIndex:segmentedControl.selectedSegmentIndex] setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET) {
        [[self.checkedIcons objectAtIndex:0] setImage:nil];
    }
    
    if (self.currentJeans.jeanRise == JEANS_RISE_NOT_SET) {
        [[self.checkedIcons objectAtIndex:1] setImage:nil];
    }
    
    if (self.currentJeans.jeanFly == JEANS_FLY_NOT_SET) {
        [[self.checkedIcons objectAtIndex:2] setImage:nil];
    }
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.fitView.hidden = NO;
        self.riseView.hidden = YES;
        self.flyView.hidden = YES;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.fitView.hidden = YES;
        self.riseView.hidden = NO;
        self.flyView.hidden = YES;
    } else {
        self.fitView.hidden = YES;
        self.riseView.hidden = YES;
        self.flyView.hidden = NO;
    }
}

#pragma mark - Fit View

- (void)fitDidCheck {
    if (self.currentJeans.jeanFit == JEANS_FIT_SKINNY && ([self.fitCheckBarTextLabel.text isEqualToString:MEN_SKINNY_FIT] || [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_SKINNY_FIT])) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanFit = JEANS_FIT_NOT_SET;
    } else if (self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT && ([self.fitCheckBarTextLabel.text isEqualToString:MEN_STRAIGHT_FIT] || [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_STRAIGHT_FIT])) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanFit = JEANS_FIT_NOT_SET;
    } else if (self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT && ([self.fitCheckBarTextLabel.text isEqualToString:MEN_BOOTCUT_FIT] || [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_BOOTCUT_FIT])) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanFit = JEANS_FIT_NOT_SET;
    } else if (self.currentJeans.jeanFit == JEANS_FIT_JEGGINGS && [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_JEGGINGS_FIT]) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanFit = JEANS_FIT_NOT_SET;
    } else {
        if ([self.fitCheckBarTextLabel.text isEqualToString:MEN_SKINNY_FIT] || [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_SKINNY_FIT]) {
            self.currentJeans.jeanFit = JEANS_FIT_SKINNY;
        } else if ([self.fitCheckBarTextLabel.text isEqualToString:MEN_STRAIGHT_FIT] || [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_STRAIGHT_FIT]) {
            self.currentJeans.jeanFit = JEANS_FIT_STRAIGHT;
        } else if ([self.fitCheckBarTextLabel.text isEqualToString:MEN_BOOTCUT_FIT] || [self.fitCheckBarTextLabel.text isEqualToString:WOMEN_BOOTCUT_FIT]) {
            self.currentJeans.jeanFit = JEANS_FIT_BOOOTCUT;
        } else {
            self.currentJeans.jeanFit = JEANS_FIT_JEGGINGS;
        }
        
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET) {
        [self.fitCheckIcon setImage:nil];
    } else {
        [self.fitCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFit"
                                                        object:nil];
}

- (void)switchToSkinnyFit {
    self.imageSet = self.currentJeans.jeanGender == JEANS_GENDER_M ? 0 : 3;
    self.backgroundImage.image = nil;
    [self.backgroundImage setImage:[UIImage imageNamed:[[self.backgroundImages objectForKey:self.gender] objectAtIndex:0]]];
    
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self.fitCheckBarTextLabel setText:MEN_SKINNY_FIT];
        [self.jeansImageView setImage:[UIImage imageNamed:@"USKY-001M-F"]];
    } else {
        [self.fitCheckBarTextLabel setText:WOMEN_SKINNY_FIT];
        [self.jeansImageView setImage:[UIImage imageNamed:@"USKY-001F-F"]];
    }
    
    // Border
    self.skinnyFitThumbnailBorder.hidden = NO;
    self.straightFitThumbnailBorder.hidden = YES;
    self.bootcutFitThumbnailBorder.hidden = YES;
    self.jeggingsFitThumbnailBorder.hidden = YES;
    
    [self.jeansFitDescriptionLabel setText:FGGetStringWithKeyFromTable(@"SkinnyFitDesc")];
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET || !(self.currentJeans.jeanFit == JEANS_FIT_SKINNY)) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToStraightFit {
    self.imageSet = self.currentJeans.jeanGender == JEANS_GENDER_M ? 1 : 4;
    self.backgroundImage.image = nil;
    [self.backgroundImage setImage:[UIImage imageNamed:[[self.backgroundImages objectForKey:self.gender] objectAtIndex:1]]];
    
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self.fitCheckBarTextLabel setText:MEN_STRAIGHT_FIT];
        [self.jeansImageView setImage:[UIImage imageNamed:@"USTR-001M-F"]];
    } else {
        [self.fitCheckBarTextLabel setText:WOMEN_STRAIGHT_FIT];
        [self.jeansImageView setImage:[UIImage imageNamed:@"USTR-001F-F"]];
    }
    
    // Border
    self.skinnyFitThumbnailBorder.hidden = YES;
    self.straightFitThumbnailBorder.hidden = NO;
    self.bootcutFitThumbnailBorder.hidden = YES;
    self.jeggingsFitThumbnailBorder.hidden = YES;
    
    [self.jeansFitDescriptionLabel setText:FGGetStringWithKeyFromTable(@"StraightFitDesc")];
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET || !(self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT)) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToBootcutFit {
    self.imageSet = self.currentJeans.jeanGender == JEANS_GENDER_M ? 2 : 5;
    self.backgroundImage.image = nil;
    [self.backgroundImage setImage:[UIImage imageNamed:[[self.backgroundImages objectForKey:self.gender] objectAtIndex:2]]];
    
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self.fitCheckBarTextLabel setText:MEN_BOOTCUT_FIT];
        [self.jeansImageView setImage:[UIImage imageNamed:@"UBTC-001M-F"]];
    } else {
        [self.fitCheckBarTextLabel setText:WOMEN_BOOTCUT_FIT];
        [self.jeansImageView setImage:[UIImage imageNamed:@"UBTC-001F-F"]];
    }
    
    // Border
    self.skinnyFitThumbnailBorder.hidden = YES;
    self.straightFitThumbnailBorder.hidden = YES;
    self.bootcutFitThumbnailBorder.hidden = NO;
    self.jeggingsFitThumbnailBorder.hidden = YES;
    
    [self.jeansFitDescriptionLabel setText:FGGetStringWithKeyFromTable(@"BootcutFitDesc")];
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET || !(self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT)) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToJeggingsFit {
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        return;
    }
    
    self.imageSet = 6;
    self.backgroundImage.image = nil;
    [self.backgroundImage setImage:[UIImage imageNamed:[[self.backgroundImages objectForKey:self.gender] objectAtIndex:3]]];
    
    [self.fitCheckBarTextLabel setText:WOMEN_JEGGINGS_FIT];
    [self.jeansImageView setImage:[UIImage imageNamed:@"UJEG-001F-F"]];
    
    // Border
    self.skinnyFitThumbnailBorder.hidden = YES;
    self.straightFitThumbnailBorder.hidden = YES;
    self.bootcutFitThumbnailBorder.hidden = YES;
    self.jeggingsFitThumbnailBorder.hidden = NO;
    
    [self.jeansFitDescriptionLabel setText:FGGetStringWithKeyFromTable(@"JeggFitDesc")];
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET || !(self.currentJeans.jeanFit == JEANS_FIT_JEGGINGS)) {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.fitCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

#pragma mark - Rise View

- (void)riseDidCheck {
    if (self.currentJeans.jeanRise == JEANS_RISE_LOW && ([self.riseCheckBarTextLabel.text isEqualToString:MEN_LOW] || [self.riseCheckBarTextLabel.text isEqualToString:WOMEN_LOW])) {
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanRise = JEANS_RISE_NOT_SET;
    } else if (self.currentJeans.jeanRise == JEANS_RISE_MIDDLE && ([self.riseCheckBarTextLabel.text isEqualToString:MEN_MIDDLE] || [self.riseCheckBarTextLabel.text isEqualToString:WOMEN_MIDDLE])) {
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanRise = JEANS_RISE_NOT_SET;
    } else {
        if ([self.riseCheckBarTextLabel.text isEqualToString:MEN_LOW] || [self.riseCheckBarTextLabel.text isEqualToString:WOMEN_LOW]) {
            self.currentJeans.jeanRise = JEANS_RISE_LOW;
        } else {
            self.currentJeans.jeanRise = JEANS_RISE_MIDDLE;
        }
        
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
    
    if (self.currentJeans.jeanRise == JEANS_RISE_NOT_SET) {
        [self.riseCheckIcon setImage:nil];
    } else {
        [self.riseCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFit"
                                                        object:nil];
}

- (void)switchToLowRise {
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self.riseCheckBarTextLabel setText:MEN_LOW];
        [self.riseViewJeansImageView setImage:[UIImage imageNamed:@"men_low_rise"]];
    } else {
        [self.riseCheckBarTextLabel setText:WOMEN_LOW];
        [self.riseViewJeansImageView setImage:[UIImage imageNamed:@"lady_low_rise"]];
    }
    
    // Border
    self.lowRiseThumbnailBorder.hidden = NO;
    self.midRiseThumbnailBorder.hidden = YES;
    
    [self.riseViewJeansDescriptionLabel setText:FGGetStringWithKeyFromTable(@"LowRiseDesc")];
    
    if (self.currentJeans.jeanRise == JEANS_RISE_NOT_SET || !(self.currentJeans.jeanRise == JEANS_RISE_LOW)) {
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToMiddleRise {
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self.riseCheckBarTextLabel setText:MEN_MIDDLE];
        [self.riseViewJeansImageView setImage:[UIImage imageNamed:@"men_mid_rise"]];
    } else {
        [self.riseCheckBarTextLabel setText:WOMEN_MIDDLE];
        [self.riseViewJeansImageView setImage:[UIImage imageNamed:@"lady_mid_rise"]];
    }
    
    // Border
    self.lowRiseThumbnailBorder.hidden = YES;
    self.midRiseThumbnailBorder.hidden = NO;
    
    [self.riseViewJeansDescriptionLabel setText:FGGetStringWithKeyFromTable(@"MiRiseDesc")];
    
    if (self.currentJeans.jeanRise == JEANS_RISE_NOT_SET || !(self.currentJeans.jeanRise == JEANS_RISE_MIDDLE)) {
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.riseCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

#pragma mark - Fly View

- (void)flyDidCheck {
    if (self.currentJeans.jeanFly == JEANS_FLY_ZIP && [self.flyCheckBarTextLabel.text isEqualToString:ZIP_FLY]) {
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanFly = JEANS_FLY_NOT_SET;
    } else if (self.currentJeans.jeanFly == JEANS_FLY_BUTTON && [self.flyCheckBarTextLabel.text isEqualToString:BUTTON_FLY]) {
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanFly = JEANS_FLY_NOT_SET;
    } else {
        if ([self.flyCheckBarTextLabel.text isEqualToString:ZIP_FLY]) {
            self.currentJeans.jeanFly = JEANS_FLY_ZIP;
        } else {
            self.currentJeans.jeanFly = JEANS_FLY_BUTTON;
        }
        
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
    
    if (self.currentJeans.jeanFly == JEANS_FLY_NOT_SET) {
        [self.flyCheckIcon setImage:nil];
    } else {
        [self.flyCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFit"
                                                        object:nil];
}

- (void)switchToZipFly {
    [self.flyCheckBarTextLabel setText:ZIP_FLY];
    [self.flyViewJeansImageView setImage:[UIImage imageNamed:@"UFFZ-001"]];
    
    [self.flyViewJeansDescriptionLabel setText:FGGetStringWithKeyFromTable(@"ZipFlyDesc")];
    
    // Border
    self.zipFlyThumbnailBorder.hidden = NO;
    self.buttonFlyThumbnailBorder.hidden = YES;
    
    if (self.currentJeans.jeanFly == JEANS_FLY_NOT_SET || !(self.currentJeans.jeanFly == JEANS_FLY_ZIP)) {
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToButtonFly {
    [self.flyCheckBarTextLabel setText:BUTTON_FLY];
    [self.flyViewJeansImageView setImage:[UIImage imageNamed:@"UFFB-001"]];
    
    [self.flyViewJeansDescriptionLabel setText:FGGetStringWithKeyFromTable(@"ButtFlyDesc")];
    
    // Border
    self.zipFlyThumbnailBorder.hidden = YES;
    self.buttonFlyThumbnailBorder.hidden = NO;
    
    if (self.currentJeans.jeanFly == JEANS_FLY_NOT_SET || !(self.currentJeans.jeanFly == JEANS_FLY_BUTTON)) {
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.flyCheckBarImageView setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

@end
