//
//  DesignSummaryViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignSummaryViewController.h"
#import "CheckOutViewController.h"
#import "Jeans.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"
#import "UIImage+CaptureView.h"
#import "LDenimApi.h"
#import "MJExtension.h"
#import "LDFabricModel.h"
#import "LDWashModel.h"
#import "JeansWash.h"
#import "NSDictionary+Json2Dict.h"
#import "WashDetailsCell.h"
#import "MBProgressHUD.h"
#import "LDLanguageTool.h"

#define WashDetaisCellIdentifier @"WashDetailsCell"

@interface DesignSummaryViewController () < UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource> {
    /* keyboard auto go up */
    CGFloat currentKeyboardHeight;
    CGFloat deltaHeight;
    CGFloat moved;
    CGFloat textfield_y;
    bool animated;
}
@property (nonatomic) BOOL frontView;
@property (nonatomic, strong) Jeans *currentJeans;

@property (nonatomic, assign) BOOL isSelectedExtraFabric;

@property (nonatomic, assign) NSInteger unitPrice;

@property (nonatomic, assign) NSInteger unitExtraPrice;

@property (nonatomic, strong) NSMutableArray *washDetailArr;
@property (nonatomic, strong) NSMutableArray *washDetailSectionTitleArr;

@end

@implementation DesignSummaryViewController

@synthesize frontView;
@synthesize currentJeans;

@synthesize leftView;
@synthesize hardwareView;
@synthesize backPatchView;

- (void)initialer
{
    _isSelectedExtraFabric = NO;
    //_unitPrice = 298;
    _unitPrice = 1;
    //_unitExtraPrice = 100;
    _unitExtraPrice = 1;
}

- (void)setIsSelectedExtraFabric: (BOOL)isSelectedExtraFabric
{
    _isSelectedExtraFabric = isSelectedExtraFabric;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialer];
    // Do any additional setup after loading the view.

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    
    [self.saveButton addTarget:self action:@selector(postJeanDesign) forControlEvents:UIControlEventTouchUpInside];
    
    //3cm_设置tableView
    self.washDetailsTableView.delegate = self;
    self.washDetailsTableView.dataSource = self;
    self.washDetailsTableView.layer.masksToBounds = YES;
    self.washDetailsTableView.layer.cornerRadius = 3.0;
    
    [self.washDetailsTableView registerNib:[UINib nibWithNibName:@"WashDetailsCell" bundle:nil] forCellReuseIdentifier:WashDetaisCellIdentifier];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 184, 40)];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 120, 22)];
    headerImageView.image = [UIImage imageNamed:@"wash_details_title"];
    [headerView addSubview:headerImageView];
    self.washDetailsTableView.tableHeaderView = headerView;
    
    self.bottomInfoLabel.text = FGGetStringWithKeyFromTable(@"SummaryBottomInfo");
}

//3cm_上传设计
- (void)postJeanDesign{
    NSString *urlSuffix = nil;
    urlSuffix = @"myworkshop/save";
    
    //保存，再次编辑的设计时，真实的牛仔裤图片清空
    self.currentJeans.realimage = nil;
    self.currentJeans.realImageUrl = nil;
    
    NSMutableDictionary *designDict = self.currentJeans.mj_keyValues;
    
//    //Fit
//    designDict[@"jeanGender"] = [NSNumber numberWithInteger:self.currentJeans.jeanGender];
//    designDict[@"jeanFit"] = [NSNumber numberWithInteger:self.currentJeans.jeanFit];
//    designDict[@"jeanRise"] = [NSNumber numberWithInteger:self.currentJeans.jeanRise];
//    designDict[@"jeanFly"] = [NSNumber numberWithInteger:self.currentJeans.jeanFly];
//    
//    //fabric
//    designDict[@"jeanFabricModel"] = ((LDFabricModel *)self.currentJeans.jeanFabricModel).mj_keyValues;
//    designDict[@"jeanBaseColor"] = [NSNumber numberWithInteger:self.currentJeans.jeanBaseColor];
//    designDict[@"jeanContrucstionThread"] = [NSNumber numberWithInteger:self.currentJeans.jeanContrucstionThread];
//    
//    //washs
//    designDict[@"jeanWashes"] = [JeansWash mj_keyValuesArrayWithObjectArray:self.currentJeans.jeanWashes];
    
    
    [[LDenimApi getInstance] POST:urlSuffix
                      parameters:@{@"user_id":[NSNumber numberWithInteger:[Panachz getInstance].user.userId],
                                   @"designjson":[NSDictionary dictionaryToJson:designDict]}
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             
                             NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                             if ([[response objectForKey:@"code"] intValue] == 301) {
                                 
                                 [self showToash:@"Save success"];
                                 
                             }else{
                                 LDLog(@"%@",response[@"message"]);
                             }
                         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                             
                         }];
}

- (void)showToash:(NSString *)info{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = info;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

#pragma mark - 重新加载页面相关数据
- (void)reloadSummaryView{
    [self handleDesignJeanForWashDetail];
    [self setJeanInfoLabels];
}

/*
 WKS - Whisker
 SUB - Support Sandblasting
 SAB - Sandblasting
 GRD - Grinding
 ABS – Abrasion
 */
#pragma mark - 处理洗水数组详细信息，供洗水列表展示
- (void)handleDesignJeanForWashDetail{
    self.washDetailArr = [NSMutableArray array];
    self.washDetailSectionTitleArr = [NSMutableArray array];
    Jeans *jean = self.currentJeans;
    NSMutableArray *jeanWashs = jean.jeanWashes;
    NSMutableArray *WKSArr = [NSMutableArray array];
    NSMutableArray *SUBArr = [NSMutableArray array];
    NSMutableArray *SABArr = [NSMutableArray array];
    NSMutableArray *GRDArr = [NSMutableArray array];
    NSMutableArray *ABSArr = [NSMutableArray array];
    
    for (JeansWash *wash in jeanWashs) {
        if ([wash.washModel.category isEqualToString:@"WKS"]) {
            [WKSArr addObject:wash];
        }
        if ([wash.washModel.category isEqualToString:@"SUB"]) {
            [SUBArr addObject:wash];
        }
        if ([wash.washModel.category isEqualToString:@"SAB"]) {
            [SABArr addObject:wash];
        }
        if ([wash.washModel.category isEqualToString:@"GRD"]) {
            [GRDArr addObject:wash];
        }
        if ([wash.washModel.category isEqualToString:@"ABS"]) {
            [ABSArr addObject:wash];
        }
    }
    
    if (WKSArr.count>0) {
        [self.washDetailArr addObject:WKSArr];
        [self.washDetailSectionTitleArr addObject:@"Whisker"];
    }
    if (SUBArr.count>0) {
        [self.washDetailArr addObject:SUBArr];
        [self.washDetailSectionTitleArr addObject:@"Support Sandblasting"];
    }
    if (SABArr.count>0) {
        [self.washDetailArr addObject:SABArr];
        [self.washDetailSectionTitleArr addObject:@"Sandblasting"];
    }
    if (GRDArr.count>0) {
        [self.washDetailArr addObject:GRDArr];
        [self.washDetailSectionTitleArr addObject:@"Grinding"];
    }
    if (ABSArr.count>0) {
        [self.washDetailArr addObject:ABSArr];
        [self.washDetailSectionTitleArr addObject:@"Rip & Tear"];
    }
    
    [self.washDetailsTableView reloadData];
}

//3cm_设置牛仔裤信息
- (void)setJeanInfoLabels{
    Jeans *jean = self.currentJeans;
    NSString *fitInfo = @"FIT:";
    if (jean.jeanFit == JEANS_FIT_SKINNY) {
        fitInfo = [fitInfo stringByAppendingString:@" SKINNY"];
    }else if (jean.jeanFit == JEANS_FIT_STRAIGHT){
        fitInfo = [fitInfo stringByAppendingString:@" STRAIGHT"];
    }else if (jean.jeanFit == JEANS_FIT_BOOOTCUT){
        fitInfo = [fitInfo stringByAppendingString:@" BOOOTCUT"];
    }else if (jean.jeanFit == JEANS_FIT_JEGGINGS){
        fitInfo = [fitInfo stringByAppendingString:@" JEGGINGS"];
    }
    self.fitInfoLabel.text = fitInfo;
    
    NSString *basecolorInfo = @"BASE COLOR:";
    if (jean.jeanBaseColor == JEANS_BASE_COLOR_LIGHT) {
        basecolorInfo = [basecolorInfo stringByAppendingString:@" LIGHT"];
    }else if (jean.jeanBaseColor == JEANS_BASE_COLOR_MEDIUM){
        basecolorInfo = [basecolorInfo stringByAppendingString:@" MEDIUM"];
    }else if (jean.jeanBaseColor == JEANS_BASE_COLOR_DARK){
        basecolorInfo = [basecolorInfo stringByAppendingString:@" DARK"];
    }
    self.basecolorInfoLabel.text = basecolorInfo;
    
    NSString *fabricText = @"FABRIC#: ";
    fabricText = [fabricText stringByAppendingString:jean.jeanFabricModel.sn?:@""];
    self.fabricLabel.text = fabricText;
    
    NSString *fabricInfoText = @"FABRIC INFO: ";
    fabricInfoText = [fabricInfoText stringByAppendingString:jean.jeanFabricModel.type?:@""];
    self.fabricInfoLabel.text = fabricInfoText;
}


- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectGender:)
                                                 name:@"SelectGender"
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

    
    // Sbuscribe for hardware section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetHardware)
                                                 name:@"SetHardware"
                                               object:nil];
    
    // Subscribe for back patch section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSetBackPatch)
                                                 name:@"SetBackPatch"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToCheckOutView"]) {
        CheckOutViewController *vc = (CheckOutViewController *)segue.destinationViewController;
        
        vc.unitPrice = self.unitPrice + (self.isSelectedExtraFabric? self.unitExtraPrice: 0);
        vc.jeans = self.currentJeans;
        
        // Preview
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HideRotateButton"
                                                            object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchFront"
                                                            object:nil];
        self.backPatchView.hidden = YES;
        self.hardwareView.hidden = YES;
        UIImage *previewImage = [UIImage imageWithView:self.leftView];
        
        // Front Preview
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchFront"
                                                            object:nil];
        UIImage *frontPreviewImage = [UIImage imageWithView:self.leftView];
        
        // Back Preview
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchBack"
                                                            object:nil];
        UIImage *backPreviewImage = [UIImage imageWithView:self.leftView];
        
        vc.jeansPreview = previewImage;
        vc.jeansFrontPreview = frontPreviewImage;
        vc.jeansBackPreview = backPreviewImage;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowRotateButton"
                                                            object:nil];
    }
}

#pragma mark - Notification

- (void)didSelectGender:(NSNotification *)notifiction {
    self.currentJeans = [notifiction.userInfo objectForKey:@"Jeans"];
}

- (void)didSwitchFrontBack:(NSNotification *)notification {
    self.frontView = !self.frontView;
    self.hardwareView.hidden = !self.frontView;
    self.backPatchView.hidden = self.frontView;
}

- (void)didSwitchFront:(NSNotification *)notification {
    self.frontView = YES;
    self.hardwareView.hidden = !self.frontView;
    self.backPatchView.hidden = self.frontView;
    
    [self reloadSummaryView];
}

- (void)didSwitchBack:(NSNotification *)notification {
    self.frontView = NO;
    self.hardwareView.hidden = !self.frontView;
    self.backPatchView.hidden = self.frontView;
}


- (void)didSetHardware {
    [self.harewareImageView setImage:self.currentJeans.hardwareImage];
}

- (void)didSetBackPatch {
    [self.backPatchImageView setImage:self.currentJeans.backPatchImage];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark TableDelegate

//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.washDetailSectionTitleArr.count;//返回标题数组中元素的个数来确定分区的个数
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ((NSMutableArray *)self.washDetailArr[section]).count;
    
}

//sectionTitle
//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];//创建一个视图
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 300, 25)];
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    headerLabel.textColor = [UIColor colorWithRed:135/255.f green:206/255.f blue:235/255.f alpha:1.f];
    headerLabel.text = self.washDetailSectionTitleArr[section];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WashDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:WashDetaisCellIdentifier forIndexPath:indexPath];
    JeansWash *wash = self.washDetailArr[indexPath.section][indexPath.row];
    cell.infoLabel.text = [NSString stringWithFormat:@"(%@) on %@ and %@",wash.washModel.sn,wash.left?@"Left(LT)":@"Right(RT)",wash.front?@"Front(FT)":@"Back(BK)"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38.f;
}

@end
