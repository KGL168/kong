//
//  DesignFabricViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 13/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignFabricViewController.h"
#import "UIColor+HexColor.h"
#import "UIImageView+Identifier.h"

#import "LDHeader.h"
#import "LDFabricModel.h"
#import "Panachz.h"

#define WHITE_CHECK_ICON @"ic_check_circle_white_36dp"
#define GREY_CHECK_ICON @"ic_check_circle_grey600_36dp"

#define LEFT_ARROW @"ic_chevron_left_grey600_48dp"
#define RIGHT_ARROW @"ic_chevron_right_grey600_48dp"
#define LEFT_ARROW_TRANS @"ic_chevron_left_grey600_48dp_trans"
#define RIGHT_ARROW_TRANS @"ic_chevron_right_grey600_48dp_trans"

#define COTTON @"COTTON"
#define SPANDEX @"SPANDEX"
#define DENIM @"DENIM"

#define ManCottonDenim @"Man's Cotton Denim"
#define LadyCottonDenim @"Lady's Cotton Denim"
#define ManCottonSpandex @"Man's Cotton Spandex"
#define LadyCottonSpandex @"Lady's Cotton Spandex"
#define ManSuperStretchCottonSpandex @"Man's Super Stretch Cotton Spandex"
#define LadySuperStretchCottonSpandex @"Lady's Super Stretch Cotton Spandex"
#define ManStretchCottonPoly @"Man's Stretch Cotton Poly"
#define LadyStretchCottonPoly @"Lady's Stretch Cotton Poly"
#define ManSuperStretchCottonPoly @"Man's Super Stretch Cotton Poly"
#define LadySuperStretchCottonPoly @"Lady's Super Stretch Cotton Poly"
#define SalvageDenim @"Salvage Denim"
#define StretchSalvageDenim @"Stretch Salvage Denim"

#define KeyManCottonDenim @"1"
#define KeyLadyCottonDenim @"2"
#define KeyManCottonSpandex @"3"
#define KeyLadyCottonSpandex @"4"
#define KeyManSuperStretchCottonSpandex @"5"
#define KeyLadySuperStretchCottonSpandex @"6"
#define KeyManStretchCottonPoly @"8"
#define KeyLadyStretchCottonPoly @"7"
#define KeyManSuperStretchCottonPoly @"10"
#define KeyLadySuperStretchCottonPoly @"9"
#define KeySalvageDenim @"11"
#define KeyStretchSalvageDenim @"12"


#define COPPER @"copper"
#define GOLD @"gold"
#define INDIGO @"indigo"
#define LIGHT_BLUE @"lightblue"
#define WHITE @"white"

@interface DesignFabricViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) Jeans *currentJeans;
@property (nonatomic, strong) NSArray *checkedIcons;
@property (nonatomic, strong) NSArray *constructionThreadPreviewThumbnails;
@property (nonatomic, strong) NSMutableArray *fabricThumbnailImageViews;
@property (nonatomic, strong) NSMutableArray *constructionThreadThumbnailImageViews;
//3cm_保存分类fabric网络数据的字典
@property (nonatomic, strong) NSMutableDictionary *fabricDataDictionary;
//3cm_保存fabric模型数据的数组
@property (nonatomic, strong) NSMutableArray *fabricImageModels;
//3cm_当前选中缩略图的模型数据
@property (nonatomic, strong) LDFabricModel *currentFabricThumbnailModel;
//3cm_
@property (nonatomic, strong) NSMutableArray *fabricTypeMaleArr;
@property (nonatomic, strong) NSMutableArray *fabricTypeFemaleArr;

@property (nonatomic, assign) BOOL isSelectedExtraFabric;


@end

@implementation DesignFabricViewController

@synthesize gender;
@synthesize currentJeans;

@synthesize resetFabricButton;

@synthesize rightSegmentedControl;
@synthesize checkedIcons;
@synthesize fabricCheckIcon;
@synthesize baseColorCheckIcon;
@synthesize constructionThreadCheckIcon;

@synthesize fabricView;
@synthesize fabricViewSegmentedControl;
@synthesize fabricImageView;
@synthesize fabricDescriptionLabel;
@synthesize fabricCheckBarButton;
@synthesize fabricCheckBarTextLabel;
@synthesize fabricPreviewLeftButton;
@synthesize fabricPreviewRightButton;
@synthesize fabricPreviewScrollView;
@synthesize fabricThumbnailImageViews;

@synthesize BaseColorView;
@synthesize baseColorImageView;
@synthesize baseColorDescriptionLabel;
@synthesize baseColorCheckBarButton;
@synthesize baseColorCheckBarTextLabel;
@synthesize lightBaseColorThumbnailImageView;
@synthesize mediumBaseColorThumbnailImageView;
@synthesize darkBaseColorThumbnailImageView;
@synthesize constructionThreadPreviewThumbnails;
@synthesize constructionThreadThumbnailImageViews;

- (void)p_initialer
{
    _isSelectedExtraFabric = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    // Setup reset button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(resetFabric)];
    [tap setNumberOfTapsRequired:1];
    [self.resetFabricButton setUserInteractionEnabled:YES];
    [self.resetFabricButton addGestureRecognizer:tap];
    
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
    
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Fabric") forSegmentAtIndex:0];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Base Color") forSegmentAtIndex:1];
    [self.rightSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Construction Thread") forSegmentAtIndex:2];
    
    // Setup checked icons
    self.checkedIcons = @[self.fabricCheckIcon, self.baseColorCheckIcon, self.constructionThreadCheckIcon];
    
    /* Setup for Fabric View */
    
    // Setup segmented control in fabric view
    [self.fabricViewSegmentedControl setTitleTextAttributes:normalAttributes
                                              forState:UIControlStateNormal];
    [self.fabricViewSegmentedControl setTitleTextAttributes:selectedAttributes
                                              forState:UIControlStateSelected];
    self.fabricViewSegmentedControl.layer.cornerRadius = 4.0;
    self.fabricViewSegmentedControl.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    [self.fabricViewSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Cotton") forSegmentAtIndex:0];
    [self.fabricViewSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Spandex") forSegmentAtIndex:1];
    [self.fabricViewSegmentedControl setTitle:FGGetStringWithKeyFromTable(@"Denim") forSegmentAtIndex:2];
    
    // Check Bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckFabric)];
    [tap setNumberOfTapsRequired:1];
    [self.fabricCheckBarButton setUserInteractionEnabled:YES];
    [self.fabricCheckBarButton addGestureRecognizer:tap];
    
    // Left arrow
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnFabricLeftButton)];
    [tap setNumberOfTapsRequired:1];
    [self.fabricPreviewLeftButton setUserInteractionEnabled:NO];
    [self.fabricPreviewLeftButton addGestureRecognizer:tap];
    [self.fabricPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    // Right arrow
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnFabricRightButton)];
    [tap setNumberOfTapsRequired:1];
    [self.fabricPreviewRightButton setUserInteractionEnabled:NO];
    [self.fabricPreviewRightButton addGestureRecognizer:tap];
    [self.fabricPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    
    // Scroll View
    self.fabricThumbnailImageViews = [[NSMutableArray alloc] init];
    self.fabricPreviewScrollView.delegate = self;
    
    /* End Setup for Fabric View */
    
    /* Setup for Base Color View */
    
    // Check Bar
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckBaseColor)];
    [tap setNumberOfTapsRequired:1];
    [self.baseColorCheckBarButton setUserInteractionEnabled:YES];
    [self.baseColorCheckBarButton addGestureRecognizer:tap];
    
    // Light Thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToLight)];
    [tap setNumberOfTapsRequired:1];
    [self.lightBaseColorThumbnailImageView setUserInteractionEnabled:YES];
    [self.lightBaseColorThumbnailImageView addGestureRecognizer:tap];
    self.lightBaseColorThumbnailImageView.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.lightBaseColorThumbnailImageView.superview.layer.borderWidth = 2.0;
    
    // Medium Thumbnail
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToMedium)];
    [self.mediumBaseColorThumbnailImageView setUserInteractionEnabled:YES];
    [self.mediumBaseColorThumbnailImageView addGestureRecognizer:tap];
    self.mediumBaseColorThumbnailImageView.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.mediumBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    
    // Dark Thumbanil
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(switchToDark)];
    [self.darkBaseColorThumbnailImageView setUserInteractionEnabled:YES];
    [self.darkBaseColorThumbnailImageView addGestureRecognizer:tap];
    self.darkBaseColorThumbnailImageView.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.darkBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    
    /* End Setup for Base Color View */
    
    /* Setup for Construction Thread View */
    
    // Check buttom
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didCheckConstructionThread)];
    [tap setNumberOfTapsRequired:1];
    [self.constructionThreadCheckBarButton setUserInteractionEnabled:YES];
    [self.constructionThreadCheckBarButton addGestureRecognizer:tap];
    
    // Left arrow
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnConstructionThreadLeftButton)];
    [tap setNumberOfTapsRequired:1];
    [self.constructionThreadPreviewLeftButton setUserInteractionEnabled:NO];
    [self.constructionThreadPreviewLeftButton addGestureRecognizer:tap];
    [self.constructionThreadPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    // Right arrow
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTapOnConstructionThreadRightButton)];
    [tap setNumberOfTapsRequired:1];
    [self.constructionThreadPreviewRightButton setUserInteractionEnabled:YES];
    [self.constructionThreadPreviewRightButton addGestureRecognizer:tap];
    [self.constructionThreadPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    
    // Scroll View
    self.constructionThreadThumbnailImageViews = [[NSMutableArray alloc] init];
    self.constructionThreadPreviewScrollView.delegate = self;
    self.constructionThreadPreviewThumbnails = @[COPPER, GOLD, INDIGO, LIGHT_BLUE, WHITE];
    [self setupThumbnailPreviewForConstructionThread];
    
    [self fetchFabricGroupDataFrowNetwork];
    
    self.constructionThreadLabel.text = FGGetStringWithKeyFromTable(@"ConstructionThreadDesc");
    
    /* End Setup for Construction Thread View */
    
    //设置picker相关
    // Qty Picker view
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(openQtyPicker)];
    [tap setNumberOfTapsRequired:1];
    [self.fabricTypeLabel setUserInteractionEnabled:YES];
    [self.fabricTypeLabel addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(closeQtyPicker)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.delegate = self;
    self.fabricTypePicker.userInteractionEnabled = YES;
    [self.fabricTypePicker addGestureRecognizer:tap];
    self.fabricTypePicker.showsSelectionIndicator = YES;
    self.fabricTypePicker.delegate = self;
    self.fabricTypePicker.dataSource = self;
    
    self.fabricTypeMaleArr = [NSMutableArray arrayWithArray:@[ManCottonDenim,ManCottonSpandex,ManSuperStretchCottonSpandex,ManStretchCottonPoly,ManSuperStretchCottonPoly,SalvageDenim,StretchSalvageDenim]];
    self.fabricTypeFemaleArr = [NSMutableArray arrayWithArray:@[LadyCottonDenim,LadyCottonSpandex,LadySuperStretchCottonSpandex,LadyStretchCottonPoly,LadySuperStretchCottonPoly,SalvageDenim,StretchSalvageDenim]];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self closeQtyPicker];
    [super touchesBegan:touches withEvent:event];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetJeans)
                                                 name:@"ResetJeans"
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetJeans {
    self.currentJeans.jeanFabricModel = nil;
    self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_NOT_SET;
    self.currentJeans.jeanContrucstionThread = JEANS_CONSTRUCTION_THREAD_NOT_SET;
    
    [self.rightSegmentedControl setSelectedSegmentIndex:0];
    
    self.fabricView.hidden = NO;
    self.BaseColorView.hidden = YES;
    self.constructionThreadView.hidden = YES;
    
    [self.fabricCheckIcon setImage:nil];
    [self.baseColorCheckIcon setImage:nil];
    [self.constructionThreadCheckIcon setImage:nil];
    
    //3cm
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self setupThumbnailPreviewForFabric:KeyManCottonDenim Completion:nil];
    }else if(self.currentJeans.jeanGender == JEANS_GENDER_F){
        [self setupThumbnailPreviewForFabric:KeyLadyCottonDenim Completion:nil];
    }
    
    [self.fabricViewSegmentedControl setSelectedSegmentIndex:0];
    
    
    [self switchToLight];
    [self setupThumbnailPreviewForConstructionThread];
    
    [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    [self.constructionThreadCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFabric"
                                                        object:nil];
}

- (void)resetFabric {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Are you sure to reset Fabric?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    self.currentJeans.jeanFabricModel = nil;
                                                    self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_NOT_SET;
                                                    self.currentJeans.jeanContrucstionThread = JEANS_CONSTRUCTION_THREAD_NOT_SET;
                                                    
                                                    [self.rightSegmentedControl setSelectedSegmentIndex:0];
                                                    
                                                    self.fabricView.hidden = NO;
                                                    self.BaseColorView.hidden = YES;
                                                    self.constructionThreadView.hidden = YES;
                                                    
                                                    [self.fabricCheckIcon setImage:nil];
                                                    [self.baseColorCheckIcon setImage:nil];
                                                    [self.constructionThreadCheckIcon setImage:nil];
                                                    
                                                    //3cm
                                                    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
                                                        [self setupThumbnailPreviewForFabric:KeyManCottonDenim Completion:nil];
                                                    }else if(self.currentJeans.jeanGender == JEANS_GENDER_F){
                                                        [self setupThumbnailPreviewForFabric:KeyLadyCottonDenim Completion:nil];
                                                    }

                                                    [self.fabricViewSegmentedControl setSelectedSegmentIndex:0];
                                                    
                                                    [self switchToLight];
                                                    [self setupThumbnailPreviewForConstructionThread];
                                                    
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFabric"
                                                                                                        object:nil];
                                                }];
    [alert addAction:cancel];
    [alert addAction:yes];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)didSelectGender:(NSNotification *)notifiction {
    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    [self.fabricTypePicker reloadAllComponents];
    self.fabricTypeLabel.text = [self fetchFabricTypesArr].firstObject;
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self setupThumbnailPreviewForFabric:KeyManCottonDenim Completion:nil];
    }else if(self.currentJeans.jeanGender == JEANS_GENDER_F){
        [self setupThumbnailPreviewForFabric:KeyLadyCottonDenim Completion:nil];
    }
}
- (void)didSwitchGender:(NSNotification *)notifiction {
//    self.gender = [notifiction.userInfo objectForKey:@"Gender"];
//    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
    [self.fabricTypePicker reloadAllComponents];
    self.fabricTypeLabel.text = [self fetchFabricTypesArr].firstObject;
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        [self setupThumbnailPreviewForFabric:KeyManCottonDenim Completion:nil];
    }else if(self.currentJeans.jeanGender == JEANS_GENDER_F){
        [self setupThumbnailPreviewForFabric:KeyLadyCottonDenim Completion:nil];
    }
}

- (IBAction)rightSegmentedControlChangeValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    for (int i = 0; i < self.checkedIcons.count; i++) {
        UIImageView *checkedIcon = [self.checkedIcons objectAtIndex:i];
        [checkedIcon setImage:[UIImage imageNamed:GREY_CHECK_ICON]];
    }
    
    if (segmentedControl.selectedSegmentIndex < self.checkedIcons.count) {
        [[self.checkedIcons objectAtIndex:segmentedControl.selectedSegmentIndex] setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    if (self.currentJeans.jeanFabricModel.fabric_id == nil) {
        [self.fabricCheckIcon setImage:nil];
    }
    
    if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_NOT_SET) {
        [self.baseColorCheckIcon setImage:nil];
    }
    
    if (self.currentJeans.jeanContrucstionThread == JEANS_CONSTRUCTION_THREAD_NOT_SET) {
        [self.constructionThreadCheckIcon setImage:nil];
    }
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.fabricView.hidden = NO;
        self.BaseColorView.hidden = YES;
        self.constructionThreadView.hidden = YES;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.fabricView.hidden = YES;
        self.BaseColorView.hidden = NO;
        self.constructionThreadView.hidden = YES;
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        self.fabricView.hidden = YES;
        self.BaseColorView.hidden = YES;
        self.constructionThreadView.hidden = NO;
    }
}

#pragma mark - Scrolview Delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.fabricPreviewScrollView) {
        CGPoint contentOffset = [self.fabricPreviewScrollView contentOffset];
        contentOffset.x += self.fabricPreviewScrollView.frame.size.width;
        
        if (contentOffset.x >= self.fabricPreviewScrollView.contentSize.width) {
            [self.fabricPreviewRightButton setUserInteractionEnabled:NO];
            [self.fabricPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
        } else {
            [self.fabricPreviewRightButton setUserInteractionEnabled:YES];
            [self.fabricPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
        }
        
        if ([self.fabricPreviewScrollView contentOffset].x == 0) {
            [self.fabricPreviewLeftButton setUserInteractionEnabled:NO];
            [self.fabricPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
        } else {
            [self.fabricPreviewLeftButton setUserInteractionEnabled:YES];
            [self.fabricPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW]];
        }
    } else if (scrollView == self.constructionThreadPreviewScrollView) {
        CGPoint contentOffset = [self.constructionThreadPreviewScrollView contentOffset];
        contentOffset.x += self.constructionThreadPreviewScrollView.frame.size.width;
        
        if (contentOffset.x >= self.constructionThreadPreviewScrollView.contentSize.width) {
            [self.constructionThreadPreviewRightButton setUserInteractionEnabled:NO];
            [self.constructionThreadPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
        } else {
            [self.constructionThreadPreviewRightButton setUserInteractionEnabled:YES];
            [self.constructionThreadPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
        }
        
        if ([self.constructionThreadPreviewScrollView contentOffset].x == 0) {
            [self.constructionThreadPreviewLeftButton setUserInteractionEnabled:NO];
            [self.constructionThreadPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
        } else {
            [self.constructionThreadPreviewLeftButton setUserInteractionEnabled:YES];
            [self.constructionThreadPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW]];
        }
    }
}

#pragma mark - Wash Data Group Of Network
- (NSMutableArray *)fetchFabricModels:(NSArray *)array{
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        LDFabricModel *model = [LDFabricModel mj_objectWithKeyValues:dic];
        model.imageUrl = [model fetchImageUrl:model.image];
        [muArr addObject:model];
    }
    return muArr;
}

//3cm_从网络上获取分类的wash数据
- (void)fetchFabricGroupDataFrowNetwork{
    NSString *urlSuffix = nil;
    urlSuffix = @"fabric/group";
    
    @weakify(self)
    [[LDenimApi getInstance] GET:urlSuffix
                      parameters:@{}
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             @strongify(self)
                             NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                             if ([[response objectForKey:@"code"] intValue] == 200) {
                                 self.fabricDataDictionary = [NSMutableDictionary dictionary];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyManCottonDenim]] forKey:KeyManCottonDenim];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyLadyCottonDenim]] forKey:KeyLadyCottonDenim];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyManCottonSpandex]] forKey:KeyManCottonSpandex];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyLadyCottonSpandex]] forKey:KeyLadyCottonSpandex];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyManSuperStretchCottonSpandex]] forKey:KeyManSuperStretchCottonSpandex];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyLadySuperStretchCottonSpandex]] forKey:KeyLadySuperStretchCottonSpandex];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyLadyStretchCottonPoly]] forKey:KeyLadyStretchCottonPoly];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyManStretchCottonPoly]] forKey:KeyManStretchCottonPoly];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyLadySuperStretchCottonPoly]] forKey:KeyLadySuperStretchCottonPoly];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyManSuperStretchCottonPoly]] forKey:KeyManSuperStretchCottonPoly];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeySalvageDenim]] forKey:KeySalvageDenim];
                                 [self.fabricDataDictionary setValue:[self fetchFabricModels:[responseObject objectForKey:KeyStretchSalvageDenim]] forKey:KeyStretchSalvageDenim];
                                 
                                 if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
                                     [self setupThumbnailPreviewForFabric:KeyManCottonDenim Completion:nil];
                                 }else if(self.currentJeans.jeanGender == JEANS_GENDER_F){
                                     [self setupThumbnailPreviewForFabric:KeyLadyCottonDenim Completion:nil];
                                 }
                                 
                             }else{
                                 LDLog(@"%@",response[@"message"]);
                             }
                         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                             
                         }];
}

#pragma mark - Fabric View

- (IBAction)fabricViewSegmentedControlChangeValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            //3cm 布局布料缩略图，和布料大图
            [self setupThumbnailPreviewForFabric:COTTON Completion:nil];
        }
            
            break;
        case 1:
        {
            //3cm 布局布料缩略图，和布料大图
            [self setupThumbnailPreviewForFabric:SPANDEX Completion:nil];
        }
            
            break;
        case 2:
        {
            //3cm 布局布料缩略图，和布料大图
            [self setupThumbnailPreviewForFabric:DENIM Completion:nil];
        }
            
            break;
        default:
        {
            //3cm 布局布料缩略图，和布料大图
            [self setupThumbnailPreviewForFabric:COTTON Completion:nil];
        }
            
            break;
    }
}

- (void)didCheckFabric {
    
    if (self.currentJeans.jeanFabricModel.sn == self.fabricCheckBarTextLabel.text) {
        self.currentJeans.jeanFabricModel = nil;
        [self.fabricCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        [self.fabricCheckIcon setImage:nil];
    } else {
        self.currentJeans.jeanFabricModel = self.currentFabricThumbnailModel;
        [self.fabricCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
        [self.fabricCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFabric"
                                                        object:nil];
}

//3cm_网络请求，布料数据
- (void)setupThumbnailPreviewForFabric:(NSString *)fabric  Completion:(void(^)() )completion{
    //初始化设置
    self.fabricImageModels = [NSMutableArray array];
    for (UIView *subview in [self.fabricPreviewScrollView subviews]) {
        for (UIGestureRecognizer *recognizer in subview.gestureRecognizers) {
            [subview removeGestureRecognizer:recognizer];
        }
        [subview removeFromSuperview];
    }
    
    [self.fabricThumbnailImageViews removeAllObjects];
    
    self.fabricImageModels = self.fabricDataDictionary[fabric];
    
    //3cm_根据是否是vip，限定展示的洗水图片张数
    NSInteger maxCount = 0;
    if (self.fabricImageModels.count>10) {
        if ([Panachz getInstance].user.isVip) {
            maxCount = self.fabricImageModels.count;
        }else{
            maxCount = 10;
        }
    }else{
        maxCount = self.fabricImageModels.count;
    }
    
    CGFloat xPosition = 0;
    for (int i = 0; i < maxCount; i++) {
        LDFabricModel *model = self.fabricImageModels[i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xffffff alpha:0.5]];
        
        UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 72, 72)];
        [thumbnail sd_setImageWithURL:model.imageUrl];
        [thumbnail setContentMode:UIViewContentModeScaleAspectFill];
        thumbnail.fabricModel = model;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapOnFabricThumbnail:)];
        [tap setNumberOfTapsRequired:1];
        [thumbnail setUserInteractionEnabled:YES];
        [thumbnail addGestureRecognizer:tap];
        
        [self.fabricThumbnailImageViews addObject:thumbnail];
        
        [view addSubview:thumbnail];
        [self.fabricPreviewScrollView addSubview:view];
        
        xPosition += 12.0 + 98.0;
    }
    
//    for (int i = 0; i < self.fabricImageModels.count % 4; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
//        [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
//        
//        [self.fabricPreviewScrollView addSubview:view];
//        xPosition += 12.0 + 98.0;
//    }
    
    if ([self.fabricImageModels count] % 4 != 0) {
        for (int i = 0; i < 4 - [self.fabricImageModels count] % 4; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
            [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
            
            [self.fabricPreviewScrollView addSubview:view];
            xPosition += 12.0 + 98.0;
        }
    }
    
    // Add border to first thumbnail
    UIImageView *firstThumbnail = (UIImageView *)[self.fabricThumbnailImageViews firstObject];
    firstThumbnail.superview.layer.borderWidth = 2.0;
    firstThumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    CGSize contentSize = self.fabricPreviewScrollView.contentSize;
    contentSize.width = xPosition - 12.0 - 98.0;
    [self.fabricPreviewScrollView setContentSize:contentSize];
    
    CGPoint offset = self.fabricPreviewScrollView.contentOffset;
    offset.x = 0;
    [self.fabricPreviewScrollView setContentOffset:offset];
    
    if (self.fabricImageModels.count <= 4) {
        [self.fabricPreviewRightButton setUserInteractionEnabled:NO];
        [self.fabricPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW_TRANS]];
    } else {
        [self.fabricPreviewRightButton setUserInteractionEnabled:YES];
        [self.fabricPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    }
    
    [self.fabricPreviewLeftButton setUserInteractionEnabled:NO];
    [self.fabricPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
    
    self.fabricPreviewScrollView.scrollEnabled = NO;
    
    //3cm_加载数据后，设置相应数据
    LDFabricModel *model = self.fabricImageModels.firstObject;
    [self.fabricImageView sd_setImageWithURL:model.imageUrl];
    [self setFabricDescriptionLabelTextWithFabric:model];
    
    if (self.currentJeans.jeanFabricModel.fabric_id && [self.currentJeans.jeanFabricModel.fabric_id isEqualToString:model.fabric_id]) {
        [self.fabricCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.fabricCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    [self.fabricCheckBarTextLabel setText:model.sn];
    self.currentFabricThumbnailModel = model;
    
    if (completion) {
        completion();
    }
}

- (void)setFabricDescriptionLabelTextWithFabric:(LDFabricModel *)model{
    if (model == NULL) {
        self.fabricDescriptionLabel.text = @"";
    }else{
        self.fabricDescriptionLabel.text = [NSString stringWithFormat:@"Content: %@ \n\nWidth: %@  Unit:%@   SuggestedPrice:%@\nWeaving:%@",model.content,model.width,model.unit,model.suggested_price,model.weaving];
    }
    
}

- (void)didTapOnFabricLeftButton {
    [self.fabricPreviewLeftButton setUserInteractionEnabled:NO];
    [self.fabricPreviewRightButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.fabricPreviewScrollView contentOffset];
    contentOffset.x -= (self.fabricPreviewScrollView.frame.size.width + 12.0);
    [self.fabricPreviewScrollView setContentOffset:contentOffset
                                          animated:YES];
}

- (void)didTapOnFabricRightButton {
    [self.fabricPreviewLeftButton setUserInteractionEnabled:NO];
    [self.fabricPreviewRightButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.fabricPreviewScrollView contentOffset];
    contentOffset.x += self.fabricPreviewScrollView.frame.size.width + 12.0;
    [self.fabricPreviewScrollView setContentOffset:contentOffset
                                          animated:YES];
}

//3cm_根据网络请求的数据，实现点击更换内容
- (void)didTapOnFabricThumbnail:(UITapGestureRecognizer *)tap {
    UIImageView *thumbnail = (UIImageView *)tap.view;
    
    for (UIImageView *iv in self.fabricThumbnailImageViews) {
        iv.superview.layer.borderWidth = 0.0;
    }
    
    thumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    thumbnail.superview.layer.borderWidth = 2.0;
    
    [self.fabricImageView sd_setImageWithURL:thumbnail.fabricModel.imageUrl];
    
    self.fabricCheckBarTextLabel.text = thumbnail.fabricModel.sn;
    self.currentFabricThumbnailModel = thumbnail.fabricModel;
    [self setFabricDescriptionLabelTextWithFabric:thumbnail.fabricModel];
    
    if (self.currentJeans.jeanFabricModel.fabric_id && [self.currentJeans.jeanFabricModel.fabric_id isEqualToString:thumbnail.fabricModel.fabric_id]) {
        [self.fabricCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.fabricCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
    
}

#pragma mark - Base Color View

- (void)didCheckBaseColor {
    if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_LIGHT && [self.baseColorCheckBarTextLabel.text isEqualToString:@"Light"]) {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_NOT_SET;
    } else if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_MEDIUM && [self.baseColorCheckBarTextLabel.text isEqualToString:@"Medium"]) {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_NOT_SET;
    } else if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_DARK && [self.baseColorCheckBarTextLabel.text isEqualToString:@"Dark"]) {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_NOT_SET;
    } else {
        if ([self.baseColorCheckBarTextLabel.text isEqualToString:@"Light"]) {
            self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_LIGHT;
        } else if ([self.baseColorCheckBarTextLabel.text isEqualToString:@"Medium"]) {
            self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_MEDIUM;
        } else  {
            self.currentJeans.jeanBaseColor = JEANS_BASE_COLOR_DARK;
        }
        
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
    
    if (self.currentJeans.jeanBaseColor == JEANS_BASE_COLOR_NOT_SET) {
        NSLog(@"### Jeans Base Color unchecked");
        [self.baseColorCheckIcon setImage:nil];
    } else {
        NSLog(@"### Jeans Base Color checked");
        [self.baseColorCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFabric"
                                                        object:nil];
}

- (void)switchToLight {
    [self.baseColorImageView setImage:[UIImage imageNamed:@"UWBC-002N"]];
    [self.baseColorDescriptionLabel setText:FGGetStringWithKeyFromTable(@"LightBaseColorDesc")];
    [self.baseColorCheckBarTextLabel setText:@"Light"];
    
    self.lightBaseColorThumbnailImageView.superview.layer.borderWidth = 2.0;
    self.mediumBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    self.darkBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    
    if (self.currentJeans.jeanBaseColor != JEANS_BASE_COLOR_LIGHT) {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToMedium {
    [self.baseColorImageView setImage:[UIImage imageNamed:@"UWBC-003N"]];
    [self.baseColorDescriptionLabel setText:FGGetStringWithKeyFromTable(@"MediumBaseColorDesc")];
    [self.baseColorCheckBarTextLabel setText:@"Medium"];
    
    self.lightBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    self.mediumBaseColorThumbnailImageView.superview.layer.borderWidth = 2.0;
    self.darkBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    
    if (self.currentJeans.jeanBaseColor != JEANS_BASE_COLOR_MEDIUM) {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

- (void)switchToDark {
    [self.baseColorImageView setImage:[UIImage imageNamed:@"UWBC-004N"]];
    [self.baseColorDescriptionLabel setText:FGGetStringWithKeyFromTable(@"DarkBaseColorDesc")];
    [self.baseColorCheckBarTextLabel setText:@"Dark"];
    
    self.lightBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    self.mediumBaseColorThumbnailImageView.superview.layer.borderWidth = 0.0;
    self.darkBaseColorThumbnailImageView.superview.layer.borderWidth = 2.0;
    
    if (self.currentJeans.jeanBaseColor != JEANS_BASE_COLOR_DARK) {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    } else {
        [self.baseColorCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    }
}

#pragma mark - Contruction Thread View

- (void)setupThumbnailPreviewForConstructionThread {
    for (UIView *subview in [self.constructionThreadPreviewScrollView subviews]) {
        for (UIGestureRecognizer *recognizer in subview.gestureRecognizers) {
            [subview removeGestureRecognizer:recognizer];
        }
        [subview removeFromSuperview];
    }
    
    [self.constructionThreadThumbnailImageViews removeAllObjects];
    
    CGFloat xPosition = 0;
    for (int i = 0; i < [self.constructionThreadPreviewThumbnails count]; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xffffff alpha:0.5]];
        
        UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 72, 72)];
        [thumbnail setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_thumbnail", [self.constructionThreadPreviewThumbnails objectAtIndex:i]]]];
        [thumbnail setContentMode:UIViewContentModeScaleAspectFill];
        thumbnail.identifier = [self.constructionThreadPreviewThumbnails objectAtIndex:i];
        
        [self.constructionThreadThumbnailImageViews addObject:thumbnail];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapOnConstructionThreadPreviewThumbnail:)];
        [tap setNumberOfTapsRequired:1];
        [thumbnail setUserInteractionEnabled:YES];
        [thumbnail addGestureRecognizer:tap];
        
        [view addSubview:thumbnail];
        [self.constructionThreadPreviewScrollView addSubview:view];
        
        xPosition += 12.0 + 98.0;
    }
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPosition, 0, 98, 98)];
        [view setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc alpha:0.5]];
        
        [self.constructionThreadPreviewScrollView addSubview:view];
        xPosition += 12.0 + 98.0;
    }
    
    // Add border to first thumbnail
    UIImageView *firstThumbnail = (UIImageView *)[self.constructionThreadThumbnailImageViews firstObject];
    firstThumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    firstThumbnail.superview.layer.borderWidth = 2.0;
    
    CGSize contentSize = self.constructionThreadPreviewScrollView.contentSize;
    contentSize.width = xPosition - 110;
    [self.constructionThreadPreviewScrollView setContentSize:contentSize];
    self.constructionThreadPreviewScrollView.scrollEnabled = NO;
    
    CGPoint offset = self.constructionThreadPreviewScrollView.contentOffset;
    offset.x = 0;
    [self.constructionThreadPreviewScrollView setContentOffset:offset];
    
    [self.constructionThreadPreviewRightButton setUserInteractionEnabled:YES];
    [self.constructionThreadPreviewRightButton setImage:[UIImage imageNamed:RIGHT_ARROW]];
    [self.constructionThreadPreviewLeftButton setUserInteractionEnabled:NO];
    [self.constructionThreadPreviewLeftButton setImage:[UIImage imageNamed:LEFT_ARROW_TRANS]];
}

- (void)didCheckConstructionThread {
    JeansConstructionThread jct = JEANS_CONSTRUCTION_THREAD_NOT_SET;
    
    if ([self.constructionThreadCheckBarTextLabel.text isEqualToString:@"Copper"]) {
        jct = JEANS_CONSTRUCTION_THREAD_COPPER;
    } else if ([self.constructionThreadCheckBarTextLabel.text isEqualToString:@"Gold"]) {
        jct = JEANS_CONSTRUCTION_THREAD_GOLD;
    } else if ([self.constructionThreadCheckBarTextLabel.text isEqualToString:@"Indigo"]) {
        jct = JEANS_CONSTRUCTION_THREAD_INDIGO;
    } else if ([self.constructionThreadCheckBarTextLabel.text isEqualToString:@"Light Blue"]) {
        jct = JEANS_CONSTRUCTION_THREAD_LIGHT_BLUE;
    } else if ([self.constructionThreadCheckBarTextLabel.text isEqualToString:@"White"]) {
        jct = JEANS_CONSTRUCTION_THREAD_WHITE;
    }
    
    if (self.currentJeans.jeanContrucstionThread == jct) {
        self.currentJeans.jeanContrucstionThread = JEANS_CONSTRUCTION_THREAD_NOT_SET;
        [self.constructionThreadCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
        [self.constructionThreadCheckIcon setImage:nil];
    } else {
        self.currentJeans.jeanContrucstionThread = jct;
        [self.constructionThreadCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
        [self.constructionThreadCheckIcon setImage:[UIImage imageNamed:WHITE_CHECK_ICON]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetFabric"
                                                        object:nil];
}

- (void)didTapOnConstructionThreadLeftButton {
    [self.constructionThreadPreviewRightButton setUserInteractionEnabled:NO];
    [self.constructionThreadPreviewLeftButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.constructionThreadPreviewScrollView contentOffset];
    contentOffset.x -= (self.constructionThreadPreviewScrollView.frame.size.width + 12.0);
    [self.constructionThreadPreviewScrollView setContentOffset:contentOffset
                                                      animated:YES];
}

- (void)didTapOnConstructionThreadRightButton {
    [self.constructionThreadPreviewRightButton setUserInteractionEnabled:NO];
    [self.constructionThreadPreviewLeftButton setUserInteractionEnabled:NO];
    
    CGPoint contentOffset = [self.constructionThreadPreviewScrollView contentOffset];
    contentOffset.x += (self.constructionThreadPreviewScrollView.frame.size.width + 12.0);
    [self.constructionThreadPreviewScrollView setContentOffset:contentOffset
                                                      animated:YES];
}

- (void)didTapOnConstructionThreadPreviewThumbnail:(UIGestureRecognizer *)tap {
    UIImageView *thumbnail = (UIImageView *)tap.view;
    
    for (UIImageView *iv in self.constructionThreadThumbnailImageViews) {
        iv.superview.layer.borderWidth = 0.0;
    }
    
    thumbnail.superview.layer.borderWidth = 2.0;
    thumbnail.superview.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    [self.constructionThreadImageView setImage:[UIImage imageNamed:thumbnail.identifier]];
    
    JeansConstructionThread jct = JEANS_CONSTRUCTION_THREAD_NOT_SET;
    
    if ([thumbnail.identifier isEqualToString:COPPER]) {
        [self.constructionThreadCheckBarTextLabel setText:@"Copper"];
        jct = JEANS_CONSTRUCTION_THREAD_COPPER;
    } else if ([thumbnail.identifier isEqualToString:GOLD]) {
        [self.constructionThreadCheckBarTextLabel setText:@"Gold"];
        jct = JEANS_CONSTRUCTION_THREAD_GOLD;
    } else if ([thumbnail.identifier isEqualToString:INDIGO]) {
        [self.constructionThreadCheckBarTextLabel setText:@"Indigo"];
        jct = JEANS_CONSTRUCTION_THREAD_INDIGO;
    } else if ([thumbnail.identifier isEqualToString:LIGHT_BLUE]) {
        [self.constructionThreadCheckBarTextLabel setText:@"Light Blue"];
        jct = JEANS_CONSTRUCTION_THREAD_LIGHT_BLUE;
    } else {
        [self.constructionThreadCheckBarTextLabel setText:@"White"];
        jct = JEANS_CONSTRUCTION_THREAD_WHITE;
    }
    
    if (self.currentJeans.jeanContrucstionThread == jct && !(self.currentJeans.jeanContrucstionThread == JEANS_CONSTRUCTION_THREAD_NOT_SET)) {
        [self.constructionThreadCheckBarButton setImage:[UIImage imageNamed:@"button_checked_bar"]];
    } else {
        [self.constructionThreadCheckBarButton setImage:[UIImage imageNamed:@"button_unchecked_bar"]];
    }
}

#pragma mark - UIPickerView Delegate and Datasource

- (NSMutableArray *)fetchFabricTypesArr{
    if (self.currentJeans.jeanGender == JEANS_GENDER_M) {
        return self.fabricTypeMaleArr;
    }else{
        return self.fabricTypeFemaleArr;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self fetchFabricTypesArr].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self fetchFabricTypesArr][row];
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.fabricTypeLabel setText:[self fetchFabricTypesArr][row]];
    if ([self.fabricTypeLabel.text isEqualToString: ManCottonDenim]) {
        [self setupThumbnailPreviewForFabric:KeyManCottonDenim Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: LadyCottonDenim]){
        [self setupThumbnailPreviewForFabric:KeyLadyCottonDenim Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: ManCottonSpandex]){
        [self setupThumbnailPreviewForFabric:KeyManCottonSpandex Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: LadyCottonSpandex]){
        [self setupThumbnailPreviewForFabric:KeyLadyCottonSpandex Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: ManSuperStretchCottonSpandex]){
        [self setupThumbnailPreviewForFabric:KeyManSuperStretchCottonSpandex Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: LadySuperStretchCottonSpandex]){
        [self setupThumbnailPreviewForFabric:KeyLadySuperStretchCottonSpandex Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: ManStretchCottonPoly]){
        [self setupThumbnailPreviewForFabric:KeyManStretchCottonPoly Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: LadyStretchCottonPoly]){
        [self setupThumbnailPreviewForFabric:KeyLadyStretchCottonPoly Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: ManSuperStretchCottonPoly]){
        [self setupThumbnailPreviewForFabric:KeyManSuperStretchCottonPoly Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: LadySuperStretchCottonPoly]){
        [self setupThumbnailPreviewForFabric:KeyLadySuperStretchCottonPoly Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: SalvageDenim]){
        [self setupThumbnailPreviewForFabric:KeySalvageDenim Completion:nil];
    }
    else if([self.fabricTypeLabel.text isEqualToString: StretchSalvageDenim]){
        [self setupThumbnailPreviewForFabric:KeyStretchSalvageDenim Completion:nil];
    }
    
}

#pragma mark - Tap Action

- (void)openQtyPicker {
    self.fabricTypePicker.alpha = 0.0;
    self.fabricTypePicker.hidden = NO;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.fabricTypePicker.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.fabricTypePicker becomeFirstResponder];
                         }
                     }];
}

- (void)closeQtyPicker {
    if (!self.fabricTypePicker.hidden) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.fabricTypePicker.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [self.fabricTypePicker resignFirstResponder];
                                 self.fabricTypePicker.hidden = YES;
                             }
                         }];
    }
}

#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
