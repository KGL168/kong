//
//  DesignSizeViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 22/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignSizeViewController.h"
#import "Jeans.h"
#import "UIColor+HexColor.h"

@interface DesignSizeViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic) BOOL measurementInInch;
@property (nonatomic, strong) NSArray *measurementLabels;
@property (nonatomic, strong) NSMutableArray *locks;
@end

@implementation DesignSizeViewController

@synthesize currentJeans;
@synthesize measurementInInch;
@synthesize locks;

@synthesize indicatorImageView;
@synthesize resetSizeButton;

@synthesize rightSegmentedControl;
@synthesize measurementLabels;
@synthesize outseamSizeLabel;
@synthesize inseamSizeLabel;
@synthesize waistSizeLabel;
@synthesize hipsSizeLabel;
@synthesize thighSizeLabel;
@synthesize curveSizeLabel;

@synthesize measurementRotateView;
@synthesize measurementLabel;
@synthesize inchButton;
@synthesize cmButton;
@synthesize lockButton;

@synthesize measurementInchScrollview;
@synthesize measurementCMScrollview;
@synthesize measurementSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup locks
    self.locks = [[NSMutableArray alloc] initWithArray:@[@NO, @NO, @NO, @NO, @NO, @NO]];
    
    // Setup reset button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(resetSize)];
    [tap setNumberOfTapsRequired:1];
    [self.resetSizeButton setUserInteractionEnabled:YES];
    [self.resetSizeButton addGestureRecognizer:tap];
    
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
    
    // Setup Big circle
    self.measurementRotateView.interactionStyle = MHRotaryKnobInteractionStyleRotating;
    self.measurementRotateView.scalingFactor = 1.5;
    self.measurementRotateView.minRequiredDistanceFromKnobCenter = 100.0;
    self.measurementRotateView.minimumValue = 0;
    self.measurementRotateView.maximumValue = 254;
    self.measurementRotateView.defaultValue = 71.12;
    self.measurementRotateView.value = 71.12;
    self.measurementRotateView.maxAngle = 177.5;
    self.measurementRotateView.backgroundImage = [UIImage imageNamed:@"size_big_circle"];
    self.measurementRotateView.backgroundColor = [UIColor clearColor];
    [self.measurementRotateView setKnobImage:[UIImage imageNamed:@"size_knob"]
                                    forState:UIControlStateNormal];
    self.measurementRotateView.knobImageCenter = CGPointMake(192.5, 192.5);
    [self.measurementRotateView addTarget:self
                                   action:@selector(rotaryKnobDidChange)
                         forControlEvents:UIControlEventValueChanged];
    self.measurementInInch = YES;
    
    // Measurement Label Array
    self.measurementLabels = @[self.outseamSizeLabel, self.inseamSizeLabel, self.waistSizeLabel, self.hipsSizeLabel, self.thighSizeLabel, self.curveSizeLabel];
    
    // Setup scrollview
    [self setupCMScrollview];
    [self setupInchScrollview];
    [self updateScrollview];
    
    // Setup slider
    [self.measurementSlider setBackgroundColor:[UIColor clearColor]];
    [self.measurementSlider setThumbImage:[UIImage imageNamed:@"size_pointer"]
                                 forState:UIControlStateNormal];
    [self.measurementSlider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [self.measurementSlider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [self.measurementSlider addTarget:self
                               action:@selector(sliderChanged:)
                     forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
}

#pragma mark - Tap gesture

- (void)reset {
    self.locks = [[NSMutableArray alloc] initWithArray:@[@NO, @NO, @NO, @NO, @NO, @NO]];
    
    [self.rightSegmentedControl setSelectedSegmentIndex:0];
    
    for (UILabel *label in self.measurementLabels) {
        [label setText:@"28.0"];
        [label setHidden:YES];
    }
    
    self.measurementRotateView.value = 71.12;
    [self.measurementLabel setText:@"28.0"];
    self.measurementInInch = YES;
    
    self.measurementCMScrollview.hidden = YES;
    self.measurementInchScrollview.hidden = NO;
    
    self.measurementRotateView.enabled = YES;
    self.measurementCMScrollview.scrollEnabled = YES;
    self.measurementInchScrollview.scrollEnabled = YES;
    self.measurementSlider.enabled = YES;
    
    [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                        forState:UIControlStateNormal];
    [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                          forState:UIControlStateNormal];
    [self.lockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                     forState:UIControlStateNormal];
    
    [self updateScrollview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetSize"
                                                        object:nil];
}

- (void)resetSize {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Waring"
                                                                   message:@"Are you sure to reset Size?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    weakSelf.locks = [[NSMutableArray alloc] initWithArray:@[@NO, @NO, @NO, @NO, @NO, @NO]];
                                                    
                                                    [weakSelf.rightSegmentedControl setSelectedSegmentIndex:0];
                                                    
                                                    for (UILabel *label in weakSelf.measurementLabels) {
                                                        [label setText:@"28.0"];
                                                        [label setHidden:YES];
                                                    }
                                                    
                                                    weakSelf.measurementRotateView.value = 71.12;
                                                    [weakSelf.measurementLabel setText:@"28.0"];
                                                    weakSelf.measurementInInch = YES;
                                                    
                                                    weakSelf.measurementCMScrollview.hidden = YES;
                                                    weakSelf.measurementInchScrollview.hidden = NO;
                                                    
                                                    weakSelf.measurementRotateView.enabled = YES;
                                                    weakSelf.measurementCMScrollview.scrollEnabled = YES;
                                                    weakSelf.measurementInchScrollview.scrollEnabled = YES;
                                                    weakSelf.measurementSlider.enabled = YES;
                                                    
                                                    [weakSelf.cmButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                                                                        forState:UIControlStateNormal];
                                                    [weakSelf.inchButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                                                                          forState:UIControlStateNormal];
                                                    [weakSelf.lockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                                                                     forState:UIControlStateNormal];
                                                    
                                                    [weakSelf updateScrollview];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetSize"
                                                                                                        object:nil];
                                                }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No"
                                                 style:UIAlertActionStyleCancel
                                               handler:nil];
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - Segmented Control

- (IBAction)lockSize:(UIButton *)sender {
    NSNumber *lock = [self.locks objectAtIndex:self.rightSegmentedControl.selectedSegmentIndex];
    
    if ([lock boolValue]) {
        [self.locks setObject:@NO
           atIndexedSubscript:self.rightSegmentedControl.selectedSegmentIndex];
    } else {
        [self.locks setObject:@YES
           atIndexedSubscript:self.rightSegmentedControl.selectedSegmentIndex];
    }
    
    lock = [self.locks objectAtIndex:self.rightSegmentedControl.selectedSegmentIndex];
    
    if ([lock boolValue]) {
        [self.lockButton setImage:[UIImage imageNamed:@"circle_locked"]
                         forState:UIControlStateNormal];
        self.measurementRotateView.enabled = NO;
        self.measurementCMScrollview.scrollEnabled = NO;
        self.measurementInchScrollview.scrollEnabled = NO;
        self.measurementSlider.enabled = NO;
        
        CGFloat cm = self.measurementRotateView.value; // in cm
        NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
        cm = [theString floatValue];
        CGFloat measurementValue = cm / 2.54f;
        theString = [NSString stringWithFormat:@"%.4f", measurementValue];
        measurementValue = [theString floatValue];
        int inchNumber = floor(measurementValue);
        int a = (int)((measurementValue - inchNumber) * 8.0f);
        
        if (self.rightSegmentedControl.selectedSegmentIndex == 0) {
            [self.outseamSizeLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            self.outseamSizeLabel.hidden = NO;
            self.currentJeans.jeanOutseamSize = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 1) {
            [self.inseamSizeLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            self.inseamSizeLabel.hidden = NO;
            self.currentJeans.jeanInseamSize = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 2) {
            [self.waistSizeLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            self.waistSizeLabel.hidden = NO;
            self.currentJeans.jeanWaistSize = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 3) {
            [self.hipsSizeLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            self.hipsSizeLabel.hidden = NO;
            self.currentJeans.jeanHipsSize = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 4) {
            [self.thighSizeLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            self.thighSizeLabel.hidden = NO;
            self.currentJeans.jeanThighSize = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 5) {
            [self.curveSizeLabel setText:[NSString stringWithFormat:@"%d.%d", inchNumber, a]];
            self.curveSizeLabel.hidden = NO;
            self.currentJeans.jeanCurveSize = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
        }
        
    } else {
        [self.lockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                         forState:UIControlStateNormal];
        
        self.measurementRotateView.enabled = YES;
        self.measurementCMScrollview.scrollEnabled = YES;
        self.measurementInchScrollview.scrollEnabled = YES;
        self.measurementSlider.enabled = YES;
        
        if (self.rightSegmentedControl.selectedSegmentIndex == 0) {
            [self.outseamSizeLabel setText:@"28.0"];
            self.outseamSizeLabel.hidden = YES;
            self.currentJeans.jeanOutseamSize = nil;
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 1) {
            [self.inseamSizeLabel setText:@"28.0"];
            self.inseamSizeLabel.hidden = YES;
            self.currentJeans.jeanInseamSize = nil;
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 2) {
            [self.waistSizeLabel setText:@"28.0"];
            self.waistSizeLabel.hidden = YES;
            self.currentJeans.jeanWaistSize = nil;
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 3) {
            [self.hipsSizeLabel setText:@"28.0"];
            self.hipsSizeLabel.hidden = YES;
            self.currentJeans.jeanHipsSize = nil;
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 4) {
            [self.thighSizeLabel setText:@"28.0"];
            self.thighSizeLabel.hidden = YES;
            self.currentJeans.jeanThighSize = nil;
        } else if (self.rightSegmentedControl.selectedSegmentIndex == 5) {
            [self.curveSizeLabel setText:@"28.0"];
            self.curveSizeLabel.hidden = YES;
            self.currentJeans.jeanCurveSize = nil;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetSize"
                                                        object:nil];
}

- (IBAction)rightSegmentedControlDidChangeValue:(UISegmentedControl *)sender {
    NSNumber *lock = [self.locks objectAtIndex:sender.selectedSegmentIndex];
    if ([lock boolValue]) {
        [self.lockButton setImage:[UIImage imageNamed:@"circle_locked"]
                         forState:UIControlStateNormal];
        self.measurementRotateView.enabled = NO;
        self.measurementCMScrollview.scrollEnabled = NO;
        self.measurementInchScrollview.scrollEnabled = NO;
        self.measurementSlider.enabled = NO;
    } else {
        [self.lockButton setImage:[UIImage imageNamed:@"circle_unlocked"]
                         forState:UIControlStateNormal];
        self.measurementRotateView.enabled = YES;
        self.measurementCMScrollview.scrollEnabled = YES;
        self.measurementInchScrollview.scrollEnabled = YES;
        self.measurementSlider.enabled = YES;
    }
    
    NSArray *mArray = nil;
    if (sender.selectedSegmentIndex == 0) {
        [self.indicatorImageView setImage:[UIImage imageNamed:@"measurement_outseam"]];
        mArray = [self.outseamSizeLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.outseamSizeLabel.text];
    } else if (sender.selectedSegmentIndex == 1) {
        [self.indicatorImageView setImage:[UIImage imageNamed:@"measurement_inseam"]];
        mArray = [self.inseamSizeLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.inseamSizeLabel.text];
    } else if (sender.selectedSegmentIndex == 2) {
        [self.indicatorImageView setImage:[UIImage imageNamed:@"measurement_waist"]];
        mArray = [self.waistSizeLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.waistSizeLabel.text];
    } else if (sender.selectedSegmentIndex == 3) {
        [self.indicatorImageView setImage:[UIImage imageNamed:@"measurement_hips"]];
        mArray = [self.hipsSizeLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.hipsSizeLabel.text];
    } else if (sender.selectedSegmentIndex == 4) {
        [self.indicatorImageView setImage:[UIImage imageNamed:@"measurement_thigh"]];
        mArray = [self.thighSizeLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.thighSizeLabel.text];
    } else if (sender.selectedSegmentIndex == 5) {
        [self.indicatorImageView setImage:[UIImage imageNamed:@"measurement_curve"]];
        mArray = [self.curveSizeLabel.text componentsSeparatedByString:@"."];
        [self.measurementLabel setText:self.curveSizeLabel.text];
    }
    
    self.measurementRotateView.value = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
    [self updateScrollview];
}

- (IBAction)switchToInchOrCM:(UIButton *)sender {
    if (sender == self.cmButton) {
        self.measurementInInch = NO;
        
        self.measurementCMScrollview.hidden = NO;
        self.measurementInchScrollview.hidden = YES;
        
        [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                            forState:UIControlStateNormal];
        [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                              forState:UIControlStateNormal];
    } else {
        self.measurementInInch = YES;
        
        self.measurementCMScrollview.hidden = YES;
        self.measurementInchScrollview.hidden = NO;
        
        [self.cmButton setTitleColor:[UIColor colorWithRBGValue:0xb3b3b3]
                            forState:UIControlStateNormal];
        [self.inchButton setTitleColor:[UIColor colorWithRBGValue:0x000000]
                              forState:UIControlStateNormal];
    }
    
    CGFloat cm = self.measurementRotateView.value; // in cm
    NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
    cm = [theString floatValue];
    CGFloat measurementValue = cm / 2.54f;
    theString = [NSString stringWithFormat:@"%.4f", measurementValue];
    measurementValue = [theString floatValue];
    int inchNumber = floor(measurementValue);
    int a = (int)((measurementValue - inchNumber) * 8.0f);
    NSString *value = nil;
    if (self.measurementInInch) {
        value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
    } else {
        value = [NSString stringWithFormat:@"%.1f", cm];
    }
    [self.measurementLabel setText:value];
    
//    for (int i = 0; i < self.measurementLabels.count; i++) {
//        UILabel *mLabel = (UILabel *)[self.measurementLabels objectAtIndex:i];
//        if (mLabel.text.length > 0) {
//            if (self.measurementInInch) {
//                CGFloat cm = [mLabel.text floatValue];
//                CGFloat mValue = cm / 2.54f;
//                NSString *tString = [NSString stringWithFormat:@"%.4f", mValue];
//                mValue = [tString floatValue];
//                int iNumber = floor(mValue);
//                int a = (int)((mValue - iNumber) * 8.0f);
//                NSString *v = [NSString stringWithFormat:@"%d.%d", iNumber, a];
//                [mLabel setText:v];
//            } else {
//                NSArray *mArray = [mLabel.text componentsSeparatedByString:@"."];
//                CGFloat cm = ([[mArray objectAtIndex:0] doubleValue] + [[mArray objectAtIndex:1] doubleValue] * 0.125f ) * 2.54f;// in cm
//                NSString *tString = [NSString stringWithFormat:@"%.4f", cm];
//                cm = [tString floatValue];
//                NSString *v = [NSString stringWithFormat:@"%.1f", cm];
//                [mLabel setText:v];
//            }
//        }
//    }
    
    [self updateScrollview];
}

#pragma mark - Rotary Knob

- (IBAction)rotaryKnobDidChange {
    CGFloat cm = self.measurementRotateView.value; // in cm
    NSString *theString = [NSString stringWithFormat:@"%.4f", cm];
    cm = [theString floatValue];
    CGFloat measurementValue = cm / 2.54f;
    theString = [NSString stringWithFormat:@"%.4f", measurementValue];
    measurementValue = [theString floatValue];
    int inchNumber = floor(measurementValue);
    int a = (int)((measurementValue - inchNumber) * 8.0f);
    NSString *value = nil;
    if (self.measurementInInch) {
        value = [NSString stringWithFormat:@"%d.%d", inchNumber, a];
    } else {
        value = [NSString stringWithFormat:@"%.1f", cm];
    }
    [self.measurementLabel setText:value];
    
    //TODO: Find how to set content offset
    [self updateScrollview];
}

#pragma mark - Scrollview Setup

- (void)setupInchScrollview {
    self.measurementInchScrollview.delegate = self;
    self.measurementInchScrollview.showsVerticalScrollIndicator = NO;
    self.measurementInchScrollview.contentSize = CGSizeMake(153 * 100 + 100, 80);
    
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50.5, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementInchScrollview addSubview:padding];
    
    padding = [[UIView alloc] initWithFrame:CGRectMake(153 * 100 + 57, 0, 43, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementInchScrollview addSubview:padding];
    
    for (int i = 0; i < 100; i++) {
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(i * 153 + 50, 0, 153.5, 80)];
        im.backgroundColor = [UIColor clearColor];
        [im setImage:[UIImage imageNamed:@"size_inch_customer"]];
        [self.measurementInchScrollview addSubview:im];
    }
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(100 * 153 + 50, 0, 7, 80)];
    im.backgroundColor = [UIColor clearColor];
    [im setImage:[UIImage imageNamed:@"size_inch_customer_placeholder"]];
    [self.measurementInchScrollview addSubview:im];
    
    for (int i = 0; i < 101; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i * 153 + 50 - 15, 45, 30, 30)];
        [l setText:[NSString stringWithFormat:@"%i", i]];
        l.textAlignment = NSTextAlignmentCenter;
        [l setBackgroundColor:[UIColor clearColor]];
        [self.measurementInchScrollview addSubview:l];
    }
}

- (void)setupCMScrollview {
    self.measurementCMScrollview.delegate = self;
    self.measurementCMScrollview.showsVerticalScrollIndicator = NO;
    self.measurementCMScrollview.contentSize = CGSizeMake(60 * 254 + 100, 80);
    
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50.5, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementCMScrollview addSubview:padding];
    
    padding = [[UIView alloc] initWithFrame:CGRectMake(254 * 60 + 54, 0, 46, 80)];
    [padding setBackgroundColor:[UIColor colorWithRBGValue:0xdcdddd alpha:0.5]];
    [self.measurementCMScrollview addSubview:padding];
    
    for (int i = 0; i < 254; i++) {
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(i * 60 + 50, 0, 60, 80)];
        im.backgroundColor = [UIColor clearColor];
        [im setImage:[UIImage imageNamed:@"size_cm_customer"]];
        [self.measurementCMScrollview addSubview:im];
    }
    
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(254 * 60 + 50, 0, 4, 80)];
    im.backgroundColor = [UIColor clearColor];
    [im setImage:[UIImage imageNamed:@"size_cm_customer_placeholder"]];
    [self.measurementCMScrollview addSubview:im];
    
    for (int i = 0; i < 255; i++) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i * 60 + 50 - 15, 45, 30, 30)];
        [l setText:[NSString stringWithFormat:@"%i", i]];
        l.textAlignment = NSTextAlignmentCenter;
        [l setBackgroundColor:[UIColor clearColor]];
        [self.measurementCMScrollview addSubview:l];
    }
}

#pragma mark - UIScrollview delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self calculateSize];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self calculateSize];
}

- (void)calculateSize {
    if (self.measurementInInch) {
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        NSString *measurementValue = @"0.0";
        
        measurementValue = [NSString stringWithFormat:@"%.1f", (sliderValueToPixels + self.measurementInchScrollview.contentOffset.x - 50) / 19.125f];
        int numberInch = [measurementValue intValue] / 8;
        int a = [measurementValue intValue] - numberInch * 8;
        
        if (a < 0) {
            measurementValue = @"0.0";
        } else if (numberInch == 100) {
            measurementValue = @"100.0";
        } else {
            measurementValue = [NSString stringWithFormat:@"%d.%d", numberInch, a];
        }
        
        self.measurementRotateView.value = (numberInch + a * 0.125) * 2.54f;
        [self.measurementLabel setText:measurementValue];
    } else {
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        NSString *measurementValue = @"0.0";
        
        measurementValue = [NSString stringWithFormat:@"%.1f", (sliderValueToPixels + self.measurementCMScrollview.contentOffset.x - 50) / 6];
        int numberCm = [measurementValue intValue] / 10;
        int a = [measurementValue intValue] - numberCm * 10;
        
        if (a < 0) {
            measurementValue = @"0.0";
        } else if (numberCm == 254) {
            measurementValue = @"254.0";
        } else {
            measurementValue = [NSString stringWithFormat:@"%d.%d", numberCm, a];
        }
        
        self.measurementRotateView.value = [measurementValue floatValue];
        [self.measurementLabel setText:measurementValue];
    }
}

- (void)updateScrollview {
    CGFloat cm = self.measurementRotateView.value; // in cm
    CGFloat measurementValue = cm / 2.54;
    
    if (measurementValue > 98.625) {
        CGPoint offset = self.measurementInchScrollview.contentOffset;
        offset.x = 153 * 97.25 + 50;
        
        self.measurementSlider.value = 0.5 + 1 - 0.04 * (100 - measurementValue);
    } else if (measurementValue <= 1.25) {
        CGPoint offset = self.measurementInchScrollview.contentOffset;
        offset.x = 0;
        [self.measurementInchScrollview setContentOffset:offset];
        
        self.measurementSlider.value = 0.09 + 0.3 * measurementValue;
    } else {
        self.measurementSlider.value = 0.5;
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        CGPoint offset = self.measurementInchScrollview.contentOffset;
        offset.x = 50 + 153 * measurementValue - sliderValueToPixels;
        [self.measurementInchScrollview setContentOffset:offset];
    }
    
    if (cm < 3.5) {
        
    } else if (cm > 250.5) {
        
    } else {
        self.measurementSlider.value = 0.5;
        float sliderRange = self.measurementSlider.frame.size.width - self.measurementSlider.currentThumbImage.size.width;
        float sliderOrigin = self.measurementSlider.frame.origin.x + (self.measurementSlider.currentThumbImage.size.width / 2);
        float sliderValueToPixels = (((self.measurementSlider.value - self.measurementSlider.minimumValue) / (self.measurementSlider.maximumValue - self.measurementSlider.minimumValue)) * sliderRange) + sliderOrigin;
        
        CGPoint offset = self.measurementCMScrollview.contentOffset;
        offset.x = 50 + 60 * cm - sliderValueToPixels;
        [self.measurementCMScrollview setContentOffset:offset];
    }
}

#pragma mark - Slider

- (void)sliderChanged:(UISlider *)sender {
    [self calculateSize];
}

@end
