//
//  DesignWashViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

// TODO: Add Washing


/*
 3cm
 猫须 whiksker    分前后，左右
 擦砂 sandblasting    不分前后，只分左右
 辅助擦砂 support sandblasting    不分前后，只分左右
 屌磨 grinding    不分前后，只分左右
 破损 abrasicm/rap and toar    不分前后，只分左右
 */

#import "DesignWashViewController.h"
#import "UIColor+HexColor.h"
#import "UIImageView+Identifier.h"
#import "UIImage+CaptureView.h"

#import "LDHeader.h"
#import "LDWashModel.h"
#import "UIImage+LDImageMerge.h"
#import "Panachz.h"


#import "JeansWash.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

#define LEFT_ARROW @"ic_chevron_left_grey600_48dp"
#define RIGHT_ARROW @"ic_chevron_right_grey600_48dp"
#define LEFT_ARROW_TRANS @"ic_chevron_left_grey600_48dp_trans"
#define RIGHT_ARROW_TRANS @"ic_chevron_right_grey600_48dp_trans"

//#define HAND_WHISKER @"UWAK"
//#define TACKING @"UTCK"
//#define SAND_BLASTING @"USBT"
//#define GRINDING @"UGRD"
//#define RIP_TEAR @"UDST"
#define HAND_WHISKER @"WKS"
#define SUP_SANDBLAST @"SUB"
#define SAND_BLASTING @"SAB"
#define GRINDING @"GRD"
#define RIP_TEAR @"ABS"

#define SAND_BLASTING_HIGH 2
#define SAND_BLASTING_MIDDLE 1
#define SAND_BLASTING_LOW 0

@interface DesignWashViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic) BOOL frontView;
@property (nonatomic) BOOL left;
@property (nonatomic, strong) NSMutableArray *washThumbnailImageViews;
//3cm_编辑框的整个view（包含取消，确认按钮，wash的imageView，border）
@property (nonatomic, strong) UIView *currentWashView;
//3cm_编辑框里面的，wash图片的imageView
@property (nonatomic, strong) UIImageView *currentWashImageView;
@property (nonatomic) NSUInteger sandBlastingOpacity;
//3cm_存储wash模型数据的数组
@property (nonatomic, strong) NSMutableArray *washImageModels;
//3cm_按分类存储wash模型的字典
@property (nonatomic, strong) NSMutableDictionary *washDataDictionary;
//3cm_washview的原始宽度
@property (nonatomic) CGFloat washViewInitialWidth;

@end

@implementation DesignWashViewController

@synthesize currentJeans;
@synthesize gender;
@synthesize left;
@synthesize washThumbnailImageViews;

@synthesize resetWashButton;
@synthesize rightSegmentedControl;
@synthesize jeansView;
@synthesize jeansViewJeansImageView;
@synthesize jeansWashScrollview;

@synthesize washView;
@synthesize sandBlastingOpacity;
@synthesize washSandBlastingOpacityView;
@synthesize washSandBlastingPlusOpacityButton;
@synthesize washSandBlastingMinusOpacityButton;
@synthesize currentWashView;
@synthesize leftAddWashTempView;
@synthesize rightAddWashTempView;
@synthesize addWashButtonGroup;
@synthesize leftAddGrindingButton;
@synthesize rightAddGrindingButton;
@synthesize leftAddHandWhiskerButton;
@synthesize rightAddHandWhiskerButton;
@synthesize leftAddRipAndTearButton;
@synthesize rightAddRipAndTearButton;
@synthesize leftAddSandBlastingButton;
@synthesize rightAddSandBlastingButton;
@synthesize leftAddTackingButton;
@synthesize rightAddTackingButton;

@synthesize washImageView;
@synthesize scrollviewLeftArrowButton;
@synthesize scrollviewRightArrowButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup reset Button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(resetWash)];
    [tap setNumberOfTapsRequired:1];
    [self.resetWashButton setUserInteractionEnabled:YES];
    [self.resetWashButton addGestureRecognizer:tap];
    
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
    
    self.rightSegmentedControl.layer.cornerRadius = 4.0;
    self.rightSegmentedControl.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Whisker") forSegmentAtIndex:0];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Sup Sandblast") forSegmentAtIndex:1];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Sandblasting") forSegmentAtIndex:2];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Grinding") forSegmentAtIndex:3];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Rip & Tear") forSegmentAtIndex:4];
    
    // Setup add button
    for (UIImageView *button in self.addWashButtonGroup) {
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(addWash:)];
        [t setNumberOfTapsRequired:1];
        button.hidden = YES;
        [button setUserInteractionEnabled:YES];
        [button addGestureRecognizer:t];
    }
    
    self.leftAddHandWhiskerButton.hidden = NO;
    self.rightAddHandWhiskerButton.hidden = NO;
    
    // Setup jeans wash scrollview
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnJeansWashScrollviewLeftButton)];
    [tap setNumberOfTapsRequired:1];
    [self.jeansWashScrollviewLeftButton setUserInteractionEnabled:NO];
    [self.jeansWashScrollviewLeftButton addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnJeansWashScrollviewRightButton)];
    [self.jeansWashScrollviewRightButton setUserInteractionEnabled:NO];
    [self.jeansWashScrollviewRightButton addGestureRecognizer:tap];
    
    [self setupJeansWashScrollview];
    self.jeansWashScrollview.delegate = self;
    
    // Setup wash thumbnail
    //Left arrow
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnLeftArrowButton)];
    [tap setNumberOfTapsRequired:1];
    [self.scrollviewLeftArrowButton setUserInteractionEnabled:NO];
    [self.scrollviewLeftArrowButton addGestureRecognizer:tap];
    
    // Right arrow
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnRightArrowButton)];
    [tap setNumberOfTapsRequired:1];
    [self.scrollviewRightArrowButton setUserInteractionEnabled:NO];
    [self.scrollviewRightArrowButton addGestureRecognizer:tap];
    
    self.washThumbnailImageViews = [[NSMutableArray alloc] init];
//    [self setupThumbnailPreviewforWash:HAND_WHISKER Completion:nil];
    self.washScrollview.delegate = self;
    
    // Sand blasting opacity
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(increaseSandBlastingOpacity:)];
    [tap setNumberOfTapsRequired:1];
    [self.washSandBlastingPlusOpacityButton setUserInteractionEnabled:YES];
    [self.washSandBlastingPlusOpacityButton addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(decreaseSandBlastingOpacity:)];
    [tap setNumberOfTapsRequired:1];
    [self.washSandBlastingMinusOpacityButton setUserInteractionEnabled:YES];
    [self.washSandBlastingMinusOpacityButton addGestureRecognizer:tap];
    
    //3cm
    self.washImageView.image = nil;
    [self fetchWashGroupDataFrowNetwork];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetJeans)
                                                 name:@"ResetJeans"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchFrontBack:)
                                                 name:@"SwitchFrontBack"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchFront:)
                                                 name:@"SwitchFront"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSwitchBack:)
                                                 name:@"SwitchBack"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetJeans {
    [self.currentJeans.jeanWashes removeAllObjects];
    
    self.currentWashView = nil;
    self.currentWashImageView = nil;
    self.jeansView.hidden = NO;
    self.washView.hidden = YES;
    self.leftAddWashTempView.hidden = YES;
    self.rightAddWashTempView.hidden = YES;
    self.washSandBlastingOpacityView.hidden = YES;
    [self.rightSegmentedControl setUserInteractionEnabled:YES];
    [self.rightSegmentedControl setEnabled:YES];
    
    [self setupJeansWashScrollview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetWash"
                                                        object:nil];
}

- (void)resetWash {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                   message:@"Are you sure to reset Wash?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    [weakSelf.currentJeans.jeanWashes removeAllObjects];
                                                    
                                                    weakSelf.currentWashView = nil;
                                                    weakSelf.currentWashImageView = nil;
                                                    weakSelf.jeansView.hidden = NO;
                                                    weakSelf.washView.hidden = YES;
                                                    weakSelf.leftAddWashTempView.hidden = YES;
                                                    weakSelf.rightAddWashTempView.hidden = YES;
                                                    weakSelf.washSandBlastingOpacityView.hidden = YES;
                                                    [weakSelf.rightSegmentedControl setUserInteractionEnabled:YES];
                                                    [weakSelf.rightSegmentedControl setEnabled:YES];
                                                    
                                                    [weakSelf setupJeansWashScrollview];
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetWash"
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

#pragma mark - NSNotification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    
    self.frontView = YES;
    [self changeJeansPreviewBase];
    [self setupJeansWashScrollview];
}

- (void)didSwitchFrontBack:(NSNotification *)notification {
    self.frontView = !self.frontView;
    [self changeJeansPreviewBase];
}

- (void)didSwitchFront:(NSNotification *)notification {
    self.frontView = YES;
    [self changeJeansPreviewBase];
}

- (void)didSwitchBack:(NSNotification *)notification {
    self.frontView = NO;
    [self changeJeansPreviewBase];
}

- (void)changeJeansPreviewBase {
    NSString *previewImageName = nil;
    
    NSString *jeansFitName = nil;
    NSString *jeansGenderName = nil;
    NSString *jeansFrontBackString = nil;
    NSString *jeansRiseName = nil;
    
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
    
    if (self.currentJeans.jeanRise == JEANS_RISE_LOW || self.currentJeans.jeanRise == JEANS_RISE_NOT_SET) {
        jeansRiseName = @"low";
    } else {
        jeansRiseName = @"middle";
    }
    
    previewImageName = [NSString stringWithFormat:@"%@-001%@-%@-%@_jean", jeansFitName, jeansGenderName, jeansFrontBackString, jeansRiseName];
    
    [self.jeansViewJeansImageView setImage:[UIImage imageNamed:previewImageName]];
}

#pragma mark - Segmented Control

- (IBAction)rightSegmentedControlDidChangeValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    for (UIImageView *button in self.addWashButtonGroup) {
        button.hidden = YES;
    }
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            self.leftAddHandWhiskerButton.hidden = NO;
            self.rightAddHandWhiskerButton.hidden = NO;
            
            [self.washDescriptionLabel setText:FGGetStringWithKeyFromTable(@"WhiskerDesc")];
            break;
        case 1:
            self.leftAddTackingButton.hidden = NO;
            self.rightAddTackingButton.hidden = NO;
            
            [self.washDescriptionLabel setText:FGGetStringWithKeyFromTable(@"SupSandblastDesc")];
            break;
        case 2:
            self.leftAddSandBlastingButton.hidden = NO;
            self.rightAddSandBlastingButton.hidden = NO;
            
            [self.washDescriptionLabel setText:FGGetStringWithKeyFromTable(@"SandblastingDesc")];
            break;
        case 3:
            self.leftAddGrindingButton.hidden = NO;
            self.rightAddGrindingButton.hidden = NO;
            
            [self.washDescriptionLabel setText:FGGetStringWithKeyFromTable(@"GrindingDesc")];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchBack"
                                                                object:nil];
            
            break;
        case 4:
            
            self.leftAddRipAndTearButton.hidden = NO;
            self.rightAddRipAndTearButton.hidden = NO;
            
            [self.washDescriptionLabel setText:FGGetStringWithKeyFromTable(@"RipTearDesc")];
            break;
        default:
            break;
    }
}

#pragma mark - Add-Wash Button
//3cm_展示wash的编辑框
- (void)showEditWashView{
    [self.rightSegmentedControl setUserInteractionEnabled:NO];
    [self.rightSegmentedControl setEnabled:NO];
    
    self.jeansView.hidden = YES;
    self.washView.hidden = NO;
}

- (void)addWash:(UIGestureRecognizer *)tap {
    UIImageView *addButton = (UIImageView *)tap.view;
    
    if (addButton == self.leftAddHandWhiskerButton) {
        self.left = YES;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:HAND_WHISKER Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 265, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.leftAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.leftAddWashTempView.hidden = NO;
        }];
    } else if (addButton == self.rightAddHandWhiskerButton) {
        self.left = NO;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:HAND_WHISKER Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 265, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.rightAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.rightAddWashTempView.hidden = NO;
        }];
    } else if (addButton == self.leftAddTackingButton) {
        self.left = YES;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:SUP_SANDBLAST Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 90, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.leftAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.leftAddWashTempView.hidden = NO;
        }];
        
    } else if (addButton == self.rightAddTackingButton) {
        self.left = NO;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:SUP_SANDBLAST Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 90, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.rightAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.rightAddWashTempView.hidden = NO;
        }];
        
    } else if (addButton == self.leftAddSandBlastingButton) {
        self.left = YES;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:SAND_BLASTING Completion:^{
            @strongify(self)
            self.washSandBlastingOpacityView.hidden = NO;
            self.sandBlastingOpacity = SAND_BLASTING_MIDDLE;
            
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 215, 125, 201) CheckFrame:CGRectMake(101, 177, 24, 24) BorderFrame:CGRectMake(0, 0, 125, 201) BorderName:@"wash_sb_border"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(125, 201) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.leftAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.leftAddWashTempView.hidden = NO;
        }];
    } else if (addButton == self.rightAddSandBlastingButton) {
        self.left = NO;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:SAND_BLASTING Completion:^{
            @strongify(self)
            self.washSandBlastingOpacityView.hidden = NO;
            self.sandBlastingOpacity = SAND_BLASTING_MIDDLE;
            
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 215, 125, 201) CheckFrame:CGRectMake(101, 177, 24, 24) BorderFrame:CGRectMake(0, 0, 125, 201) BorderName:@"wash_sb_border"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(125, 201) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.rightAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.rightAddWashTempView.hidden = NO;
        }];
        
    } else if (addButton == self.leftAddGrindingButton) {
        self.left = YES;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:GRINDING Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(65, 90, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.leftAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.leftAddWashTempView.hidden = NO;
        }];
        
        
    } else if (addButton == self.rightAddGrindingButton) {
        self.left = NO;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:GRINDING Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(65, 90, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.rightAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.rightAddWashTempView.hidden = NO;
        }];
        
        
    } else if (addButton == self.leftAddRipAndTearButton) {
        self.left = YES;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:RIP_TEAR Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 265, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.leftAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.leftAddWashTempView.hidden = NO;
        }];
        
    } else if (addButton == self.rightAddRipAndTearButton) {
        self.left = NO;
        
        //3cm_网络请求数据生成缩略图，生成washView
        @weakify(self)
        [self setupThumbnailPreviewforWash:RIP_TEAR Completion:^{
            @strongify(self)
            UIView *view = [self fetchAddWashViewFrame:CGRectMake(60, 265, 126, 126) CheckFrame:CGRectMake(102, 102, 24, 24) BorderFrame:CGRectMake(0, 0, 126, 126) BorderName:@"wash_new_element_item_noicon"];
            
            UIImageView *wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:self.washImageModels.firstObject];
            [view addSubview:wash];
            
            self.currentWashView = view;
            self.currentWashImageView = wash;
            
            [self.rightAddWashTempView addSubview:view];
            
            [self showEditWashView];
            self.rightAddWashTempView.hidden = NO;
        }];
        
    }
}

//3cm_封装washView的生成
- (UIView *)fetchAddWashViewFrame:(CGRect)frame CheckFrame:(CGRect)checkFrame BorderFrame:(CGRect)borderFrame BorderName:(NSString *)borderName{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor clearColor]];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(moveWashDynamic:)];
    [view setUserInteractionEnabled:YES];
    [view addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(scaleWashDynamic:)];
    [view addGestureRecognizer:pinch];
    //3cm_获取洗水图片的原始宽度
    self.washViewInitialWidth = view.frame.size.width;
    
    UIImageView *removeButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [removeButton setImage:[UIImage imageNamed:@"ic_remove_circle_white_48dp"]];
    [view addSubview:removeButton];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(removeWash:)];
    [tap setNumberOfTapsRequired:1];
    [removeButton setUserInteractionEnabled:YES];
    [removeButton addGestureRecognizer:tap];
    removeButton.tag = 1;
    
    UIImageView *checkButton = [[UIImageView alloc] initWithFrame:checkFrame];
    [checkButton setImage:[UIImage imageNamed:@"ic_check_circle_white_48dp"]];
    [view addSubview:checkButton];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(addWashToJeans:)];
    [tap setNumberOfTapsRequired:1];
    [checkButton setUserInteractionEnabled:YES];
    [checkButton addGestureRecognizer:tap];
    checkButton.tag = 2;
    
    UIImageView *border = [[UIImageView alloc] initWithFrame:borderFrame];
    [border setImage:[UIImage imageNamed:borderName]];
    [view addSubview:border];
    border.tag = 3;
    
    return view;
    
}

//3cm_根据Url生成编辑框中显示的wash
- (UIImageView *)fetchAddWashImageViewXY:(CGPoint)point Model:(LDWashModel *)model{
    UIImageView *wash = [[UIImageView alloc] init];
    [wash sd_setImageWithURL:model.display_imgUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat width = image.size.width/O_D_Scale;
        CGFloat height = image.size.height/O_D_Scale;
        wash.frame = CGRectMake(point.x / 2 - width / 2, point.y / 2 - height / 2, width, height);
    }];
    wash.washModel = model;
    return wash;
}

#pragma mark - Sand Blasting Opacity

- (void)increaseSandBlastingOpacity:(UITapGestureRecognizer *)tap {
    if (self.sandBlastingOpacity == SAND_BLASTING_LOW) {
        self.sandBlastingOpacity = SAND_BLASTING_MIDDLE;
        
        NSString *identifier = self.currentWashImageView.identifier;
        [self.currentWashImageView removeFromSuperview];
       
        UIImage *washImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-middle_jean-dynamic", identifier]];
        self.currentWashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(125 / 2 - washImage.size.width / 2, 201 / 2 - washImage.size.height / 2, washImage.size.width, washImage.size.height)];
        
        self.currentWashImageView.identifier = [NSString stringWithFormat:@"%@", identifier];
        [self.currentWashImageView setImage:washImage];
        [self.currentWashView addSubview:self.currentWashImageView];
    } else if (self.sandBlastingOpacity == SAND_BLASTING_MIDDLE) {
        self.sandBlastingOpacity = SAND_BLASTING_HIGH;
        
        NSString *identifier = self.currentWashImageView.identifier;
        [self.currentWashImageView removeFromSuperview];
        
        UIImage *washImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-high_jean-dynamic", identifier]];
        self.currentWashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(125 / 2 - washImage.size.width / 2, 201 / 2 - washImage.size.height / 2, washImage.size.width, washImage.size.height)];
        
        self.currentWashImageView.identifier = [NSString stringWithFormat:@"%@", identifier];
        [self.currentWashImageView setImage:washImage];
        [self.currentWashView addSubview:self.currentWashImageView];
    }
}

- (void)decreaseSandBlastingOpacity:(UITapGestureRecognizer *)tap {
    if (self.sandBlastingOpacity == SAND_BLASTING_HIGH) {
        self.sandBlastingOpacity = SAND_BLASTING_MIDDLE;
        
        NSString *identifier = self.currentWashImageView.identifier;
        [self.currentWashImageView removeFromSuperview];
        
        UIImage *washImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-middle_jean-dynamic", identifier]];
        self.currentWashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(125 / 2 - washImage.size.width / 2, 201 / 2 - washImage.size.height / 2, washImage.size.width, washImage.size.height)];
        
        self.currentWashImageView.identifier = [NSString stringWithFormat:@"%@", identifier];
        [self.currentWashImageView setImage:washImage];
        [self.currentWashView addSubview:self.currentWashImageView];
    } else if (self.sandBlastingOpacity == SAND_BLASTING_MIDDLE) {
        self.sandBlastingOpacity = SAND_BLASTING_LOW;
        
        NSString *identifier = self.currentWashImageView.identifier;
        [self.currentWashImageView removeFromSuperview];
        
        UIImage *washImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-low_jean-dynamic", identifier]];
        self.currentWashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(125 / 2 - washImage.size.width / 2, 201 / 2 - washImage.size.height / 2, washImage.size.width, washImage.size.height)];
        
        self.currentWashImageView.identifier = [NSString stringWithFormat:@"%@", identifier];
        [self.currentWashImageView setImage:washImage];
        [self.currentWashView addSubview:self.currentWashImageView];
    }
}

#pragma mark - Gesture on dynamic wash

- (void)moveWashDynamic:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint trans = [recognizer translationInView:recognizer.view];
        CGRect rect = recognizer.view.frame;
        rect.origin.x += trans.x;
        rect.origin.y += trans.y;
        
        if (CGRectContainsRect(recognizer.view.superview.bounds, rect)) {
            recognizer.view.frame = rect;
        }
        
        [recognizer setTranslation:CGPointZero
                            inView:recognizer.view.superview];
    }
}

- (void)scaleWashDynamic:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[recognizer.view.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        CGFloat minScale = 0.5;
        CGFloat maxScale = 1.8;
        CGFloat zoomSpeed = 0.5;
        
        CGFloat deltaScale = recognizer.scale;
        
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(recognizer.view.transform, deltaScale, deltaScale);
        recognizer.view.transform = zoomTransform;
        
        recognizer.scale = 1;
    }
}

- (void)addWashToJeans:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view.superview;
//    NSString *washName = nil;
    
    [[view viewWithTag:1] setHidden:YES];
    [[view viewWithTag:2] setHidden:YES];
    [[view viewWithTag:3] setHidden:YES];
    
//    UIImage *i = [UIImage imageWithView:view];
    JeansWash *jw = [[JeansWash alloc] init];
    jw.left = self.left;
    jw.front = self.frontView;
    
    //3cm
    jw.centerPointX = view.center.x;
    jw.centerPointY = view.center.y;
    jw.washModel = self.currentWashImageView.washModel;
    jw.scoleNum = view.frame.size.width/self.washViewInitialWidth;
    
    
//    if (self.rightSegmentedControl.selectedSegmentIndex == 2) {
//        if (self.sandBlastingOpacity == SAND_BLASTING_LOW) {
//            washName = [NSString stringWithFormat:@"%@-low_jean-dynamic", self.currentWashImageView.identifier];
//        } else if (self.sandBlastingOpacity == SAND_BLASTING_MIDDLE) {
//            washName = [NSString stringWithFormat:@"%@-middle_jean-dynamic", self.currentWashImageView.identifier];
//        } else {
//            washName = [NSString stringWithFormat:@"%@-high_jean-dynamic", self.currentWashImageView.identifier];
//        }
//    } else {
//        washName = [NSString stringWithFormat:@"%@", self.currentWashImageView.identifier];
//    }
//    jw.washName = washName;
    
//    if (self.rightSegmentedControl.selectedSegmentIndex == 2) {
//        NSArray *iArray = [self.currentWashImageView.identifier componentsSeparatedByString:@"-"];
//        jw.thumbnailName = [NSString stringWithFormat:@"%@-%@_%@_thumbnail", iArray[0], iArray[1], self.left ? @"left" : @"right"];
//    } else {
//        NSArray *iArray = [self.currentWashImageView.identifier componentsSeparatedByString:@"-"];
//        jw.thumbnailName = [NSString stringWithFormat:@"%@-%@_thumbnail", iArray[0], iArray[1]];
//    }
    
    [self.currentJeans.jeanWashes addObject:jw];
    
    [recognizer.view.superview removeFromSuperview];
    self.currentWashView = nil;
    self.currentWashImageView = nil;
    self.jeansView.hidden = NO;
    self.washView.hidden = YES;
    self.leftAddWashTempView.hidden = YES;
    self.rightAddWashTempView.hidden = YES;
    self.washSandBlastingOpacityView.hidden = YES;
    [self.rightSegmentedControl setUserInteractionEnabled:YES];
    [self.rightSegmentedControl setEnabled:YES];
    
    [self setupJeansWashScrollview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetWash"
                                                        object:self];
}

- (void)removeWash:(UITapGestureRecognizer *)recognizer {
    [recognizer.view.superview removeFromSuperview];
    self.currentWashView = nil;
    self.currentWashImageView = nil;
    self.jeansView.hidden = NO;
    self.washView.hidden = YES;
    self.leftAddWashTempView.hidden = YES;
    self.rightAddWashTempView.hidden = YES;
    self.washSandBlastingOpacityView.hidden = YES;
    [self.rightSegmentedControl setUserInteractionEnabled:YES];
    [self.rightSegmentedControl setEnabled:YES];
}

#pragma mark - Wash scroll view
//布局添加过的wash列表
- (void)setupJeansWashScrollview {
    for (UIView *subview in [self.jeansWashScrollview subviews]) {
        [subview removeFromSuperview];
    }
    
    CGFloat xPosition = 0;
    
    for (int i = 0; i < self.currentJeans.jeanWashes.count; i++) {
        JeansWash *wash = [self.currentJeans.jeanWashes objectAtIndex:i];
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 110, 110)];
        [container setBackgroundColor:[UIColor clearColor]];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xffffff alpha:0.5]];
        [container addSubview:view];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 90, 90)];
        [iv sd_setImageWithURL:wash.washModel.display_imgUrl];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        [view addSubview:iv];
        
        UIImageView *ic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [ic setImage:[UIImage imageNamed:@"ic_remove_circle_white_48dp"]];
        [ic setContentMode:UIViewContentModeScaleAspectFill];
        [container addSubview:ic];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTaponJeansWashThumbnail:)];
        [tap setNumberOfTapsRequired:1];
        [iv setUserInteractionEnabled:YES];
        [iv addGestureRecognizer:tap];
        iv.identifier = [NSString stringWithFormat:@"%i", i];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(didTapOnDeleteIcon:)];
        [tap setNumberOfTapsRequired:1];
        [ic setUserInteractionEnabled:YES];
        [ic addGestureRecognizer:tap];
        ic.identifier = [NSString stringWithFormat:@"%i", i];
        
        [self.jeansWashScrollview addSubview:container];
        
        xPosition += 98 + 12;
    }
    
    if (self.currentJeans.jeanWashes.count % 4 != 0) {
        for (int i = 0; i < 4 - self.currentJeans.jeanWashes.count % 4; i++) {
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 110, 110)];
            [container setBackgroundColor:[UIColor clearColor]];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 98, 98)];
            [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
            [container addSubview:view];
            
            [self.jeansWashScrollview addSubview:container];
            xPosition += 98 + 12;
        }
    } else if (self.currentJeans.jeanWashes.count == 0) {
        for (int i = 0; i < 4; i++) {
            UIView *container = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 110, 110)];
            [container setBackgroundColor:[UIColor clearColor]];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 98, 98)];
            [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
            [container addSubview:view];
            
            [self.jeansWashScrollview addSubview:container];
            xPosition += 98 + 12;
        }
    }
    
    CGSize contentSize = self.jeansWashScrollview.contentSize;
    contentSize.width = xPosition;
    [self.jeansWashScrollview setContentSize:contentSize];
    
    if (self.currentJeans.jeanWashes.count <= 4) {
        [self.jeansWashScrollviewRightButton setUserInteractionEnabled:NO];
        [self.jeansWashScrollviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    } else {
        [self.jeansWashScrollviewRightButton setUserInteractionEnabled:YES];
        [self.jeansWashScrollviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    }
    
    [self.jeansWashScrollviewLeftButton setUserInteractionEnabled:NO];
    [self.jeansWashScrollviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    self.jeansWashScrollview.scrollEnabled = NO;
}

- (void)didTapOnJeansWashScrollviewLeftButton {
    [self.jeansWashScrollviewRightButton setUserInteractionEnabled:NO];
    [self.jeansWashScrollviewLeftButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.jeansWashScrollview contentOffset];
    contentOffset.x -= (self.jeansWashScrollview.frame.size.width);
    [self.jeansWashScrollview setContentOffset:contentOffset
                                 animated:YES];
}

- (void)didTapOnJeansWashScrollviewRightButton {
    [self.jeansWashScrollviewRightButton setUserInteractionEnabled:NO];
    [self.jeansWashScrollviewLeftButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.jeansWashScrollview contentOffset];
    contentOffset.x += self.jeansWashScrollview.frame.size.width;
    [self.jeansWashScrollview setContentOffset:contentOffset
                                      animated:YES];
}

- (void)didTaponJeansWashThumbnail:(UITapGestureRecognizer *)tap {
//    UIImageView *image = (UIImageView *)tap.view;
//    int deleteIndex = [image.identifier intValue];
//    
//    JeansWash *wash = [self.currentJeans.jeanWashes objectAtIndex:deleteIndex];
//    
//    [self.currentJeans.jeanWashes removeObjectAtIndex:deleteIndex];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetWash"
//                                                        object:self];
//    
//    self.left = wash.left;
//    if (wash.left) {
//        self.leftAddWashTempView.hidden = NO;
//    } else {
//        self.rightAddWashTempView.hidden = NO;
//    }
}

- (void)didTapOnDeleteIcon:(UITapGestureRecognizer *)tap {
    UIImageView *deleteIcon = (UIImageView *)tap.view;
    int deleteIndex = [deleteIcon.identifier intValue];
    [self.currentJeans.jeanWashes removeObjectAtIndex:deleteIndex];
    [self setupJeansWashScrollview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetWash"
                                                        object:self];
}

#pragma mark - Wash Data Group Of Network
- (NSMutableArray *)fetchWashModels:(NSArray *)array{
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        LDWashModel *model = [LDWashModel mj_objectWithKeyValues:dic];
        model.output_imgUrl = [model fetchImageUrl:model.output_img];
        model.display_imgUrl = [model fetchImageUrl:model.display_img];
        model.real_imgUrl = [model fetchImageUrl:model.real_img];
        [muArr addObject:model];
    }
    return muArr;
}

//3cm_从网络上获取分类的wash数据
- (void)fetchWashGroupDataFrowNetwork{
    NSString *urlSuffix = nil;
    urlSuffix = @"wash/group";
    
    @weakify(self)
    [[LDenimApi getInstance] GET:urlSuffix
                      parameters:@{}
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             @strongify(self)
                             NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                             if ([[response objectForKey:@"code"] intValue] == 200) {
                                 self.washDataDictionary = [NSMutableDictionary dictionary];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"WKS_FT_LT"]] forKey:@"WKS_FT_LT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"WKS_FT_RT"]] forKey:@"WKS_FT_RT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"WKS_BK_LT"]] forKey:@"WKS_BK_LT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"WKS_BK_RT"]] forKey:@"WKS_BK_RT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"SUB_LT"]] forKey:@"SUB_LT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"SUB_RT"]] forKey:@"SUB_RT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"SAB_LT"]] forKey:@"SAB_LT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"SAB_RT"]] forKey:@"SAB_RT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"GRD_LT"]] forKey:@"GRD_LT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"GRD_RT"]] forKey:@"GRD_RT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"ABS_LT"]] forKey:@"ABS_LT"];
                                 [self.washDataDictionary setValue:[self fetchWashModels:[responseObject objectForKey:@"ABS_RT"]] forKey:@"ABS_RT"];
                                 
                                 
                             }else{
                                 LDLog(@"%@",response[@"message"]);
                             }
                         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                             
                         }];
}

#pragma mark - Wash thumbnail scroll view
//3cm_网络请求数据生成缩略图
- (void)setupThumbnailPreviewforWash:(NSString *)wash Completion:(void(^)() )completion{
    //初始化数据
    self.washImageModels = [NSMutableArray array];
    for (UIView *subview in [self.washScrollview subviews]) {
        for (UIGestureRecognizer *recognizer in subview.gestureRecognizers) {
            [subview removeGestureRecognizer:recognizer];
        }
        [subview removeFromSuperview];
    }
    [self.washThumbnailImageViews removeAllObjects];
    self.washImageView.image = nil;
    
    //如果网络数据为空的话，返回
    if (self.washDataDictionary == nil) {
        return;
    }
    
    NSString *urlSuffix = nil;
    if ([wash isEqualToString:HAND_WHISKER]) {
        urlSuffix = [NSString stringWithFormat:@"%@_%@_%@",wash,self.frontView ? @"FT":@"BK",self.left ? @"LT" : @"RT"];
        self.washImageModels = self.washDataDictionary[urlSuffix];
        
    }else{
        urlSuffix = [NSString stringWithFormat:@"%@_%@",wash,self.left ? @"LT" : @"RT"];
        self.washImageModels = self.washDataDictionary[urlSuffix];
    }
    
    //数量为0时，不走completion
    if (self.washImageModels.count == 0) {
        //可以加提示
        return;
    }
    
    //3cm_根据是否是vip，限定展示的洗水图片张数
    NSInteger maxWashCount = 0;
    if (self.washImageModels.count>10) {
        if ([Panachz getInstance].user.isVip) {
            maxWashCount = self.washImageModels.count;
        }else{
            maxWashCount = 10;
        }
    }else{
        maxWashCount = self.washImageModels.count;
    }
    
    
    CGFloat xPosition = 0;
    for (int i = 0; i < maxWashCount; i++) {
        LDWashModel *model = self.washImageModels[i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xffffff alpha:0.5]];
        
        UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 90, 90)];
        [thumbnail sd_setImageWithURL:model.display_imgUrl];
        [thumbnail setContentMode:UIViewContentModeScaleAspectFit];
        thumbnail.identifier = model.sn;
        thumbnail.washModel = model;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapOnWashThumbnail:)];
        [tap setNumberOfTapsRequired:1];
        [thumbnail setUserInteractionEnabled:YES];
        [thumbnail addGestureRecognizer:tap];
        
        [self.washThumbnailImageViews addObject:thumbnail];
        [view addSubview:thumbnail];
        [self.washScrollview addSubview:view];
        
        xPosition += 12.0 + 98.0;
        
        //3cm_预加载，1：1outputimage
        UIImageView *outputImage = [[UIImageView alloc] init];
        [outputImage sd_setImageWithURL:model.output_imgUrl];
    }
    [self.washImageView sd_setImageWithURL:((LDWashModel *)self.washImageModels.firstObject).real_imgUrl];
    if ([self.washImageModels count] % 4 != 0) {
        for (int i = 0; i < 4 - [self.washImageModels count] % 4; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
            [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
            
            [self.washScrollview addSubview:view];
            xPosition += 12.0 + 98.0;
        }
    }
    
    // Add border to first thumbnail
    UIImageView *firstThumbnail = (UIImageView *)[self.washThumbnailImageViews firstObject];
    firstThumbnail.superview.layer.borderWidth = 2.0;
    firstThumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    CGSize contentSize = self.washScrollview.contentSize;
//    contentSize.width = xPosition - 12.0 - 98.0;
    contentSize.width = xPosition - 12.0;
    [self.washScrollview setContentSize:contentSize];
    
    if ([self.washImageModels count] <= 4) {
        [self.scrollviewRightArrowButton setUserInteractionEnabled:NO];
        [self.scrollviewRightArrowButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    } else {
        [self.scrollviewRightArrowButton setUserInteractionEnabled:YES];
        [self.scrollviewRightArrowButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    }
    
    // Reset the content offset
    CGPoint offset = self.washScrollview.contentOffset;
    offset.x = 0;
    self.washScrollview.contentOffset = offset;
    
    [self.scrollviewLeftArrowButton setUserInteractionEnabled:NO];
    [self.scrollviewLeftArrowButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    [self.washScrollview setScrollEnabled:YES];
    
    if (completion) {
        completion();
    }
}

- (void)didTapOnLeftArrowButton {
    [self.scrollviewLeftArrowButton setUserInteractionEnabled:NO];
    [self.scrollviewRightArrowButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.washScrollview contentOffset];
    contentOffset.x -= (self.washScrollview.frame.size.width + 12.0f);
    [self.washScrollview setContentOffset:contentOffset
                                 animated:YES];
}

- (void)didTapOnRightArrowButton {
    [self.scrollviewLeftArrowButton setUserInteractionEnabled:NO];
    [self.scrollviewRightArrowButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.washScrollview contentOffset];
    contentOffset.x += self.washScrollview.frame.size.width + 12.0f;
    [self.washScrollview setContentOffset:contentOffset
                                 animated:YES];
}

- (void)didTapOnWashThumbnail:(UIGestureRecognizer *)tap {
    UIImageView *thumbnail = (UIImageView *)tap.view;
    
    for (UIImageView *iv in self.washThumbnailImageViews) {
        iv.superview.layer.borderWidth = 0.0;
    }
    
    thumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    thumbnail.superview.layer.borderWidth = 2.0;
    
    [self.washImageView sd_setImageWithURL:thumbnail.washModel.real_imgUrl];
    
    [self.currentWashImageView removeFromSuperview];
    
    //3cm_根据网络请求的数据，更改washImageView的图片
    UIImageView *wash = nil;
    if (self.rightSegmentedControl.selectedSegmentIndex == 2) {
        wash = [self fetchAddWashImageViewXY:CGPointMake(125, 201) Model:thumbnail.washModel];
        self.sandBlastingOpacity = SAND_BLASTING_MIDDLE;
    } else {
        wash = [self fetchAddWashImageViewXY:CGPointMake(126, 126) Model:thumbnail.washModel];
//        self.currentWashImageView.identifier = [NSString stringWithFormat:@"%@-dynamic", thumbnail.identifier];
    }
    
    self.currentWashImageView = wash;
    
    if (self.rightSegmentedControl.selectedSegmentIndex == 2) {
//        NSArray *iArray = [thumbnail.identifier componentsSeparatedByString:@"_"];
//        self.currentWashImageView.identifier = [NSString stringWithFormat:@"%@-%@", [iArray firstObject], self.left ? @"left" : @"right"];
    }
    
    [self.currentWashView addSubview:self.currentWashImageView];
}

#pragma mark - Scrolview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.washScrollview) {
        if (scrollView.contentOffset.x>0) {
            if (self.scrollviewLeftArrowButton.userInteractionEnabled == NO){
                self.scrollviewLeftArrowButton.userInteractionEnabled = YES;
                [self.scrollviewLeftArrowButton setImage:[UIImage imageNamed:LEFT_ARROW]];
            }
        }else{
            if (self.scrollviewLeftArrowButton.userInteractionEnabled == YES){
                self.scrollviewLeftArrowButton.userInteractionEnabled = NO;
                [self.scrollviewLeftArrowButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
            }
        }
        
        CGPoint contentOffset = [scrollView contentOffset];
        contentOffset.x += scrollView.frame.size.width;
        if (contentOffset.x >= scrollView.contentSize.width) {
            if (self.scrollviewRightArrowButton.userInteractionEnabled == YES){
                self.scrollviewRightArrowButton.userInteractionEnabled = NO;
                [self.scrollviewRightArrowButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
            }
        }else{
            if (self.scrollviewRightArrowButton.userInteractionEnabled == NO){
                self.scrollviewRightArrowButton.userInteractionEnabled = YES;
                [self.scrollviewRightArrowButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
            }
            
        }
        
        
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.washScrollview) {
        CGPoint contentOffset = [scrollView contentOffset];
        contentOffset.x += scrollView.frame.size.width;
        
        if (contentOffset.x >= scrollView.contentSize.width) {
            [self.scrollviewRightArrowButton setUserInteractionEnabled:NO];
            [self.scrollviewRightArrowButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
        } else {
            [self.scrollviewRightArrowButton setUserInteractionEnabled:YES];
            [self.scrollviewRightArrowButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
        }
        
        if ([scrollView contentOffset].x <= 0) {
            [self.scrollviewLeftArrowButton setUserInteractionEnabled:NO];
            [self.scrollviewLeftArrowButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
        } else {
            [self.scrollviewLeftArrowButton setUserInteractionEnabled:YES];
            [self.scrollviewLeftArrowButton setImage:[UIImage imageNamed:LEFT_ARROW]];
        }
    } else if (scrollView == self.jeansWashScrollview) {
        CGPoint contentOffset = [scrollView contentOffset];
        contentOffset.x += scrollView.frame.size.width;
        
        if (contentOffset.x >= scrollView.contentSize.width) {
            [self.jeansWashScrollviewRightButton setUserInteractionEnabled:NO];
            [self.jeansWashScrollviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
        } else {
            [self.jeansWashScrollviewRightButton setUserInteractionEnabled:YES];
            [self.jeansWashScrollviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
        }
        
        if ([scrollView contentOffset].x == 0) {
            [self.jeansWashScrollviewLeftButton setUserInteractionEnabled:NO];
            [self.jeansWashScrollviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
        } else {
            [self.jeansWashScrollviewLeftButton setUserInteractionEnabled:YES];
            [self.jeansWashScrollviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW]];
        }
    }
}

#pragma mark - Scrolview Delegate
//- (void)fetchWashInfo{
//    [[LDenimApi getInstance] GET:@"wash/all"
//                      parameters:@{}
//                         success:^(NSURLSessionDataTask *task, id responseObject) {
//                             NSDictionary *responseDict = responseObject;
//                             NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
//                             if ([[response objectForKey:@"code"] intValue] == 200) {
//                                 
//                             } else {
//                                 LDLog(@"%@",response[@"message"]);
//                             }
//                         }
//                         failure:nil];
//}

@end
