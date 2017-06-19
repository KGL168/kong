//
//  JeansPreviewViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 13/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "JeansPreviewViewController.h"
#import "JeansWash.h"
#import "UIImage+Size.h"
#import "UIImageView+WebCache.h"

#define STANDARD_JEANS_HEGIHT 675
#define STANDARD_JEANS_WIDTH 360
#define STANDARD_Y_OFFSET 0

@interface JeansPreviewViewController ()

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic) BOOL frontView;

@end

@implementation JeansPreviewViewController

@synthesize gender;
@synthesize frontView;
@synthesize currentJeans;
@synthesize frontBackImageView;
@synthesize jeansBaseImageView;
@synthesize dotlineImageView;
@synthesize backPocketImageView;
@synthesize backPocketDotlineImageView;
@synthesize backPatchImageView;

@synthesize backPocketHeight;
@synthesize backPocketWidth;
@synthesize backPocketCenterYToJeans;
@synthesize backPocketDotlineHeight;
@synthesize backPocketDotlineWidth;
@synthesize backPocketDotlineCenterYToJeans;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup tap gesture on front back image view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(switchFrontBack)];
    [tap setNumberOfTapsRequired:1];
    [self.frontBackImageView setUserInteractionEnabled:YES];
    [self.frontBackImageView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideRotateButton)
                                                 name:@"HideRotateButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRotateButton)
                                                 name:@"ShowRotateButton"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didSwitchFrontBack:)
//                                                 name:@"SwitchFrontBack"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchFront:)
                                                 name:@"SwitchFront"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchBack:)
                                                 name:@"SwitchBack"
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
    
    // Subscribe for Back Pocket Section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetBackPocket)
                                                 name:@"SetBackPocket"
                                               object:nil];
    
    // Subscribe for fabric section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetWash)
                                                 name:@"SetWash"
                                               object:nil];
    
    // Subscribe for Back Patch Section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetBackPatch)
                                                 name:@"SetBackPatch"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    
    self.frontView = YES;
    [self updateJeansPreview];
}

- (void)didSwitchFrontBack:(NSNotification *)notification {
    [self switchFrontBack];
}

- (void)didSwitchFront:(NSNotification *)notification {
    self.frontView = YES;
    [self updateJeansPreview];
}

- (void)didSwitchBack:(NSNotification *)notification {
    self.frontView = NO;
    [self updateJeansPreview];
}

- (void)hideRotateButton {
    self.frontBackImageView.hidden = YES;
}

- (void)showRotateButton {
    self.frontBackImageView.hidden = NO;
}

- (void)didSetFit {
    [self updateJeansPreview];
}

- (void)didSetFabric {
    [self updateJeansPreview];
}

- (void)didSetBackPocket {
    [self updateJeansPreview];
}

- (void) didSetWash{
    [self updateJeansPreview];
}

- (void)didSetBackPatch {
    [self updateJeansPreview];
}

#pragma mark - Tap Gesture action

- (void)switchFrontBack {
    self.frontView = !self.frontView;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchFrontBack"
                                                        object:nil];
    
    [self updateJeansPreview];
}

- (void)updateJeansPreview {
    [self changeJeansPreviewBase];
    [self changesJeansDotline];
    [self changeBackPocket];
    [self changeWash];
    [self changeBackPatch];
}

- (void)changeJeansPreviewBase {
    NSString *previewImageName = nil;
    
    NSString *jeansFitName = nil;
    NSString *jeansGenderName = nil;
    NSString *jeansFrontBackString = nil;
    NSString *jeansBaseColor = nil;
    
    if (self.currentJeans.jeanFit == JEANS_FIT_SKINNY || self.currentJeans.jeanFit == JEANS_FIT_NOT_SET) {
        jeansFitName = @"USKY";
    } else if (self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT) {
        jeansFitName = @"USTR";
    } else if (self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT) {
        jeansFitName = @"UBTC";
    } else {
        jeansFitName = @"UJEG";
    }
    
    jeansGenderName = self.currentJeans.jeanGender == JEANS_GENDER_M ? @"M" : @"F";
    
    jeansFrontBackString = self.frontView ? @"F" : @"B";
    
    if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_NOT_SET || self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_LIGHT) {
        jeansBaseColor = @"low";
    } else if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_MEDIUM) {
        jeansBaseColor = @"middle";
    }
    else {
        jeansBaseColor = @"high";
    }
    
    previewImageName = [NSString stringWithFormat:@"%@-001%@-%@-%@_jean", jeansFitName, jeansGenderName, jeansFrontBackString, jeansBaseColor];
    
    [self.jeansBaseImageView setImage:[UIImage imageNamed:previewImageName]];
}

- (void)changesJeansDotline {
    if (self.currentJeans.jeanContrucstionThread != JEANS_CONSTRUCTION_THREAD_NOT_SET) {
        self.dotlineImageView.hidden = NO;
        
        NSString *dotlineImageName = nil;
        NSString *jeansFitName = nil;
        NSString *jeansGenderName = nil;
        NSString *jeansFrontBackString = nil;
        NSString *jeansConstructionThreadString = nil;
        
        if (self.currentJeans.jeanFit == JEANS_FIT_SKINNY || self.currentJeans.jeanFit == JEANS_FIT_NOT_SET) {
            jeansFitName = @"USKY";
        } else if (self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT) {
            jeansFitName = @"USTR";
        } else if (self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT) {
            jeansFitName = @"UBTC";
        } else {
            jeansFitName = @"UJEG";
        }
        
        jeansGenderName = self.currentJeans.jeanGender == JEANS_GENDER_M ? @"M" : @"F";
        
        jeansFrontBackString = self.frontView ? @"F" : @"B";
        
        switch (self.currentJeans.jeanContrucstionThread) {
            case JEANS_CONSTRUCTION_THREAD_COPPER:
                jeansConstructionThreadString = @"copper";
                break;
            case JEANS_CONSTRUCTION_THREAD_GOLD:
                jeansConstructionThreadString = @"gold";
                break;
            case JEANS_CONSTRUCTION_THREAD_INDIGO:
                jeansConstructionThreadString = @"indigo";
                break;
            case JEANS_CONSTRUCTION_THREAD_LIGHT_BLUE:
                jeansConstructionThreadString = @"lightblue";
                break;
            case JEANS_CONSTRUCTION_THREAD_WHITE:
                jeansConstructionThreadString = @"white";
                break;
            default:
                jeansConstructionThreadString = @"copper";
                break;
        }
        
        dotlineImageName = [NSString stringWithFormat:@"%@-001%@-%@-%@-dotline", jeansFitName, jeansGenderName, jeansFrontBackString, jeansConstructionThreadString];
        
        [self.dotlineImageView setImage:[UIImage imageNamed:dotlineImageName]];
    } else {
        self.dotlineImageView.hidden = YES;
    }
}

- (void)changeBackPocket {
    if (self.frontView || self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_NOT_SET) {
        self.backPocketDotlineImageView.hidden = YES;
        self.backPocketImageView.hidden = YES;
    } else {
        self.backPocketDotlineImageView.hidden = self.currentJeans.jeanContrucstionThread == JEANS_CONSTRUCTION_THREAD_NOT_SET;
        self.backPocketImageView.hidden = NO;
    }
    
    NSString *backPocketImageName = nil;
    NSString *backPocketDotlineImageName = nil;
    
    NSString *backPocketName = nil;
    NSString *colorName = nil;
    NSString *jeansConstructionThreadString = nil;
    
    switch (self.currentJeans.jeanBackPocket) {
        case JEANS_BACK_POCKET_UBPS_001F:
            backPocketName = @"UBPS-001F";
            break;
        case JEANS_BACK_POCKET_UBPS_001M:
            backPocketName = @"UBPS-001M";
            break;
        case JEANS_BACK_POCKET_UBPS_002F:
            backPocketName = @"UBPS-002F";
            break;
        case JEANS_BACK_POCKET_UBPS_002M:
            backPocketName = @"UBPS-002M";
            break;
        case JEANS_BACK_POCKET_UBPS_003F:
            backPocketName = @"UBPS-003F";
            break;
        case JEANS_BACK_POCKET_UBPS_003M:
            backPocketName = @"UBPS-003M";
            break;
        case JEANS_BACK_POCKET_UBPS_004F:
            backPocketName = @"UBPS-004F";
            break;
        case JEANS_BACK_POCKET_UBPS_004M:
            backPocketName = @"UBPS-004M";
            break;
        case JEANS_BACK_POCKET_UBPS_005F:
            backPocketName = @"UBPS-005F";
            break;
        default:
            backPocketName = self.currentJeans.jeanGender == JEANS_GENDER_M ? @"UBPS-001M" : @"UBPS-001F";
            break;
    }
    
    if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_LIGHT || self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_NOT_SET) {
        colorName = @"low";
    } else if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_MEDIUM) {
        colorName = @"middle";
    } else  {
        colorName = @"high";
    }
    
    backPocketImageName = [NSString stringWithFormat:@"%@-%@-backpocket", backPocketName, colorName];
    [self.backPocketImageView setImage:[UIImage imageNamed:backPocketImageName]];
    
    switch (self.currentJeans.jeanContrucstionThread) {
        case JEANS_CONSTRUCTION_THREAD_COPPER:
            jeansConstructionThreadString = @"copper";
            break;
        case JEANS_CONSTRUCTION_THREAD_GOLD:
            jeansConstructionThreadString = @"gold";
            break;
        case JEANS_CONSTRUCTION_THREAD_INDIGO:
            jeansConstructionThreadString = @"indigo";
            break;
        case JEANS_CONSTRUCTION_THREAD_LIGHT_BLUE:
            jeansConstructionThreadString = @"lightblue";
            break;
        case JEANS_CONSTRUCTION_THREAD_WHITE:
            jeansConstructionThreadString = @"white";
            break;
        default:
            jeansConstructionThreadString = @"copper";
            break;
    }
    
    backPocketDotlineImageName = [NSString stringWithFormat:@"%@-%@", backPocketName, jeansConstructionThreadString];
    [self.backPocketDotlineImageView setImage:[UIImage imageNamed:backPocketDotlineImageName]];
    
    // Fix the position of back pocket
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        if (self.currentJeans.jeanFit == JEANS_FIT_BOOOTCUT) {
            if (self.currentJeans.jeanBackPocket== JEANS_BACK_POCKET_UBPS_001M) {
                self.backPocketCenterYToJeans.constant = STANDARD_Y_OFFSET;
                self.backPocketWidth.constant = STANDARD_JEANS_WIDTH;
                self.backPocketHeight.constant = STANDARD_JEANS_HEGIHT;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_002M) {
                self.backPocketCenterYToJeans.constant = -20;
                self.backPocketHeight.constant = 720;
                self.backPocketWidth.constant = 384;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_003M) {
                self.backPocketCenterYToJeans.constant = -20;
                self.backPocketHeight.constant = 720;
                self.backPocketWidth.constant = 384;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_004M) {
                self.backPocketCenterYToJeans.constant = 8;
                self.backPocketWidth.constant = STANDARD_JEANS_WIDTH;
                self.backPocketHeight.constant = STANDARD_JEANS_HEGIHT;
            }
        } else if (self.currentJeans.jeanFit == JEANS_FIT_SKINNY) {
            if (self.currentJeans.jeanBackPocket== JEANS_BACK_POCKET_UBPS_001M) {
                self.backPocketCenterYToJeans.constant = 12;
                self.backPocketWidth.constant = 352;
                self.backPocketHeight.constant = 660;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_002M) {
                self.backPocketCenterYToJeans.constant = -15;
                self.backPocketHeight.constant = 720;
                self.backPocketWidth.constant = 384;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_003M) {
                self.backPocketCenterYToJeans.constant = -10;
                self.backPocketHeight.constant = 720;
                self.backPocketWidth.constant = 384;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_004M) {
                self.backPocketCenterYToJeans.constant = 10;
                self.backPocketWidth.constant = STANDARD_JEANS_WIDTH;
                self.backPocketHeight.constant = STANDARD_JEANS_HEGIHT;
            }
        } else if (self.currentJeans.jeanFit == JEANS_FIT_STRAIGHT) {
            if (self.currentJeans.jeanBackPocket== JEANS_BACK_POCKET_UBPS_001M) {
                self.backPocketCenterYToJeans.constant = -15;
                self.backPocketWidth.constant = 384;
                self.backPocketHeight.constant = 720;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_002M) {
                self.backPocketCenterYToJeans.constant = -50;
                self.backPocketHeight.constant = 780;
                self.backPocketWidth.constant = 416;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_003M) {
                self.backPocketCenterYToJeans.constant = -45;
                self.backPocketHeight.constant = 780;
                self.backPocketWidth.constant = 416;
            } else if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_004M) {
                self.backPocketCenterYToJeans.constant = -35;
                self.backPocketWidth.constant = 418;
                self.backPocketHeight.constant = 780;
            }
        }
    } else {
        if (self.currentJeans.jeanBackPocket == JEANS_BACK_POCKET_UBPS_001F) {
            self.backPocketCenterYToJeans.constant = 15;
            self.backPocketHeight.constant = 630;
            self.backPocketWidth.constant = 336;
        } else {
            self.backPocketCenterYToJeans.constant = STANDARD_Y_OFFSET;
            self.backPocketWidth.constant = STANDARD_JEANS_WIDTH;
            self.backPocketHeight.constant = STANDARD_JEANS_HEGIHT;
        }
    }
    
    self.backPocketDotlineCenterYToJeans.constant = self.backPocketCenterYToJeans.constant;
    self.backPocketDotlineHeight.constant = self.backPocketHeight.constant;
    self.backPocketDotlineWidth.constant = self.backPocketWidth.constant;
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)changeWash {
    
    for (UIView *view in [self.leftWashView subviews]) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in [self.rightWashView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.currentJeans.jeanWashes.count; i++) {
        JeansWash *jeansWash = [self.currentJeans.jeanWashes objectAtIndex:i];
        
        if (self.frontView == jeansWash.front) {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(jeansWash.frame.origin.x, jeansWash.frame.origin.y, jeansWash.frame.size.width, jeansWash.frame.size.height)];
//            NSLog(@"Add :View : %f, %f, %f, %f", jeansWash.frame.origin.x, jeansWash.frame.origin.y, jeansWash.frame.size.width, jeansWash.frame.size.height);
//            UIImage *image = [UIImage imageNamed:jeansWash.washName];
//            UIImageView *iv = [[UIImageView alloc] initWithFrame:jeansWash.washFrame];
//            [iv setContentMode:UIViewContentModeScaleAspectFill];
//            [iv setImage:[UIImage resizeImage:image toSize:jeansWash.washFrame.size]];
//             NSLog(@"wImage : Add %f %f %f %f", jeansWash.washFrame.origin.x, jeansWash.washFrame.origin.y, jeansWash.washFrame.size.width, jeansWash.washFrame.size.height);
//            [view addSubview:iv];
            
            UIImageView *view = [[UIImageView alloc] init];
            [view sd_setImageWithURL:jeansWash.washModel.display_imgUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat width = image.size.width/O_D_Scale*jeansWash.scoleNum;
                CGFloat height = image.size.height/O_D_Scale*jeansWash.scoleNum;
                view.frame = CGRectMake(0, 0, width, height);
                view.center =  CGPointMake(jeansWash.centerPointX, jeansWash.centerPointY);
            }];
            
            if (jeansWash.left) {
                [self.leftWashView addSubview:view];
            } else {
                [self.rightWashView addSubview:view];
            }
        }
    }
}

- (void)changeBackPatch {
    if (self.frontView || self.currentJeans.jeanBackPatchType == JEANS_BACK_PATCH_NOT_SET) {
        self.backPatchImageView.hidden = YES;
    } else {
        self.backPatchImageView.hidden = NO;
    }
    
    switch (self.currentJeans.jeanBackPatchType) {
        case JEANS_BACK_PATCH_WHITE_COLOR_COATED_GENUINE_BUFFLO_LEATHER:
            [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-001F"]];
            break;
        case JEANS_BACK_PATCH_GENUINE_BULL_LEATHER:
            [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-002F"]];
            break;
        case JEANS_BACK_PATCH_BLACK_COLOR_COATED_GENUINE_BUFFLO_LEATHER:
            [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-003F"]];
            break;
        case JEANS_BACK_PATCH_GENUINE_SUEDE_LEATHER:
            [self.backPatchImageView setImage:[UIImage imageNamed:@"UBLP-004F"]];
            break;
        default:
            [self.backPatchImageView setImage:nil];
            break;
    }
}

@end
