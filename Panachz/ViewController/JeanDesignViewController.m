//
//  JeanDesignViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "JeanDesignViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"
#import "LDFabricModel.h"
#import "LDLanguageTool.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

@interface JeanDesignViewController ()

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic, strong) NSArray *checkedIcons;
@property (nonatomic, strong) NSArray *containerViews;

@end

@implementation JeanDesignViewController

@synthesize currentJeans;
@synthesize gender;
@synthesize jeanDesignSegmentedControl;

@synthesize fitCheckIcon;
@synthesize fabricCheckIcon;
@synthesize washCheckIcon;

@synthesize FitContainerView;
@synthesize FabricContainerView;
@synthesize WashContainerView;
@synthesize SummaryContainerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Subscribe notification */
    
    // Subscribe a notification for changing gender
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
    
    // Subscribe for Fit section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetFit)
                                                 name:@"SetFit"
                                               object:nil];
    
    // Subscribe for fabric section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetFabric)
                                                 name:@"SetFabric"
                                               object:nil];
    
    // Subscribe for wash section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetWash)
                                                 name:@"SetWash"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchDesignItemWash)
                                                 name:@"EditJeans"
                                               object:nil];
    
    /* End Subscribe notifiction*/
    
    // Setup the segmented control bar
    NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                             size:12.0f],
                                       NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0x444444]};
    [self.jeanDesignSegmentedControl setTitleTextAttributes:normalAttributes
                                                   forState:UIControlStateNormal];
    NSDictionary *selectedAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Roboto-Regular"
                                                                               size:12.0f],
                                         NSForegroundColorAttributeName: [UIColor colorWithRBGValue:0xffffff]};
    [self.jeanDesignSegmentedControl setTitleTextAttributes:selectedAttributes
                                                   forState:UIControlStateSelected];
    
    self.jeanDesignSegmentedControl.layer.cornerRadius = 4.0;
    self.jeanDesignSegmentedControl.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    [self.jeanDesignSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Fit") forSegmentAtIndex:0];
    [self.jeanDesignSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Fabric") forSegmentAtIndex:1];
    [self.jeanDesignSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Wash") forSegmentAtIndex:2];
    [self.jeanDesignSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Summary") forSegmentAtIndex:3];
    
    // Setup checked Icon
    [self.fitCheckIcon setImage:nil];
    [self.fabricCheckIcon setImage:nil];
    [self.washCheckIcon setImage:nil];
    self.checkedIcons = @[self.fitCheckIcon,
                          self.fabricCheckIcon,
                          self.washCheckIcon];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchDesignItemWash{
    self.jeanDesignSegmentedControl.selectedSegmentIndex = 2;
    [self switchDesignItem:self.jeanDesignSegmentedControl];
}

- (IBAction)switchDesignItem:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    for (int i = 0; i < self.checkedIcons.count; i++) {
        UIImageView *checkedIcon = [self.checkedIcons objectAtIndex:i];
        [checkedIcon setImage:nil];
    }
    
    if (segmentedControl.selectedSegmentIndex < self.checkedIcons.count) {
        [[self.checkedIcons objectAtIndex:segmentedControl.selectedSegmentIndex] setImage:[UIImage imageNamed:@"ic_check_circle_white_36dp"]];
    }
    
    if (self.currentJeans.jeanFit == JEANS_FIT_NOT_SET || self.currentJeans.jeanRise == JEANS_RISE_NOT_SET || self.currentJeans.jeanFly == JEANS_FLY_NOT_SET) {
        [[self.checkedIcons objectAtIndex:0] setImage:nil];
    } else if (segmentedControl.selectedSegmentIndex == 0) {
        [self.fitCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    } else {
        [self.fitCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
    }
    
    if (self.currentJeans.jeanFabricModel.fabric_id == nil || self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_NOT_SET || self.currentJeans.jeanContrucstionThread == JEANS_CONSTRUCTION_THREAD_NOT_SET) {
        [self.fabricCheckIcon setImage:nil];
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        [self.fabricCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    } else {
        [self.fabricCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
    }
    
    
    if (self.currentJeans.jeanWashes.count == 0) {
        [self.washCheckIcon setImage:nil];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        [self.washCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    } else {
        [self.washCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
    }
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.FitContainerView.hidden = NO;
        self.FabricContainerView.hidden = YES;
        self.WashContainerView.hidden = YES;
        self.SummaryContainerView.hidden = YES;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.FitContainerView.hidden = YES;
        self.FabricContainerView.hidden = NO;
        self.WashContainerView.hidden = YES;
        self.SummaryContainerView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchFront"
                                                            object:nil];
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        self.FitContainerView.hidden = YES;
        self.FabricContainerView.hidden = YES;
        self.WashContainerView.hidden = NO;
        self.SummaryContainerView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchFront"
                                                            object:nil];
    } else if (segmentedControl.selectedSegmentIndex == 3) {
        self.FitContainerView.hidden = YES;
        self.FabricContainerView.hidden = YES;
        self.WashContainerView.hidden = YES;
        self.SummaryContainerView.hidden = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchFront"
                                                            object:nil];
    }
}

#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notification {
    self.gender = [notification.userInfo objectForKey:@"Gender"];
    self.currentJeans = [notification.userInfo objectForKey:@"Jeans"];
}

- (void)didSetFit {
    if (self.currentJeans.jeanFit != JEANS_FIT_NOT_SET && self.currentJeans.jeanRise != JEANS_RISE_NOT_SET && self.currentJeans.jeanFly != JEANS_FLY_NOT_SET) {
        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 0) {
            [self.fitCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        } else {
            [self.fitCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
    } else {
        [self.fitCheckIcon setImage:nil];
    }
}

- (void)didSetFabric {
    if (self.currentJeans.jeanFabricModel.fabric_id != nil && self.currentJeans.jeanBaseColor != JEANS_BASE_COLOR_NOT_SET && self.currentJeans.jeanContrucstionThread != JEANS_CONSTRUCTION_THREAD_NOT_SET) {
        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 1) {
            [self.fabricCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        } else {
            [self.fabricCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
    } else {
        [self.fabricCheckIcon setImage:nil];
    }
}

//- (void)didSetBackPocket {
//    if (self.currentJeans.jeanBackPocket != JEANS_BACK_POCKET_NOT_SET) {
//        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 2) {
//            [self.backPocketCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
//        } else {
//            [self.backPocketCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
//        }
//    } else {
//        [self.backPocketCheckIcon setImage:nil];
//    }
//}

- (void)didSetWash {
    if (self.currentJeans.jeanWashes.count > 0) {
        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 2) {
            [self.washCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
        } else {
            [self.washCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
        }
    } else {
        [self.washCheckIcon setImage:nil];
    }
}

//- (void)didSetHardware {
//    if (self.currentJeans.jeanShank != JEANS_SHANK_NOT_SET && self.currentJeans.jeanRivet != JEANS_RIVET_NOT_SET) {
//        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 4) {
//            [self.hardwareCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
//        } else {
//            [self.hardwareCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
//        }
//    } else {
//        [self.hardwareCheckIcon setImage:nil];
//    }
//}

//- (void)didSetBackPatch {
//    if (self.currentJeans.jeanBackPatchType != JEANS_BACK_PATCH_NOT_SET) {
//        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 5) {
//            [self.backPatchCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
//        } else {
//            [self.backPatchCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
//        }
//    } else {
//        [self.backPatchCheckIcon setImage:nil];
//    }
//}
//
//- (void)didSetSize {
//    if (self.currentJeans.jeanOutseamSize != nil && self.currentJeans.jeanInseamSize != nil && self.currentJeans.jeanWaistSize != nil && self.currentJeans.jeanHipsSize != nil && self.currentJeans.jeanThighSize != nil && self.currentJeans.jeanCurveSize != nil) {
//        if (self.jeanDesignSegmentedControl.selectedSegmentIndex == 6) {
//            [self.sizeCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
//        } else {
//            [self.sizeCheckIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
//        }
//    } else {
//        [self.sizeCheckIcon setImage:nil];
//    }
//}

@end
