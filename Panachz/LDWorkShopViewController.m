//
//  LDWorkShopViewController.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/3/1.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import "LDWorkShopViewController.h"
#import "WashDetailsCell.h"
#import "JeanDesignContainer.h"

#import "LDHeader.h"
#import "LDFabricModel.h"
#import "LDWashModel.h"
#import "JeansWash.h"
#import "Jeans.h"
#import "Panachz.h"
#import "NSDictionary+Json2Dict.h"
#import "UIImage+CaptureView.h"

#import "MBProgressHUD.h"

#define WashDetaisCellIdentifier @"WashDetailsCell"

@interface LDWorkShopViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *designJeanArr;
@property (nonatomic, strong) NSMutableArray *washDetailArr;
@property (nonatomic, strong) NSMutableArray *washDetailSectionTitleArr;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) JeanDesignContainer *designContainer;

@property (nonatomic, strong) NSString *recipientEmail;

@end

@implementation LDWorkShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //3cm_基础设置
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(leftArrowAction:)];
    [self.leftArrowImageView setUserInteractionEnabled:YES];
    [self.leftArrowImageView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightArrowAction:)];
    self.rightArrowImageView.userInteractionEnabled = YES;
    [self.rightArrowImageView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewAction:)];
    self.backViewImageView.userInteractionEnabled = YES;
    [self.backViewImageView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editViewAction:)];
    self.editImageView.userInteractionEnabled = YES;
    [self.editImageView addGestureRecognizer:tap];
    
    //realimageview
    self.realJeanImageView.layer.masksToBounds = NO;
    self.realJeanImageView.layer.cornerRadius = 3.0;
    self.realJeanImageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    
    //3cm_设置jeanDesignContainerView
    self.designContainer = [[JeanDesignContainer alloc] init];
    self.designContainer.frame = CGRectMake(0, 0, self.jeanDesignContainerView.frame.size.width, self.jeanDesignContainerView.frame.size.height);
    [self.jeanDesignContainerView addSubview:self.designContainer];
    
    self.currentIndex = 0;
    
    [self.uploadImageButton addTarget:self action:@selector(onSelectAvatar) forControlEvents:UIControlEventTouchUpInside];
    
    [self.outputBtn addTarget:self action:@selector(fetchOutputInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.outputBtn setTitle:FGGetStringWithKeyFromTable(@"Output") forState:UIControlStateNormal];
    
    //3cm_设置用户名字
    if (self.isMyWorkshop) {
        self.accountNameLabel.text = [Panachz getInstance].user.name;
    }else{
        self.accountNameLabel.text = @"";
        self.titleImageView.image = [UIImage imageNamed:@"workshop_gallery_title"];
        self.titleImageView.frame = CGRectMake(100, 33, 300, 43);
        self.bottomInfoLabel.hidden = YES;
        self.outputBtn.hidden = YES;
    }
    
    self.bottomInfoLabel.text = FGGetStringWithKeyFromTable(@"MyWorshopBottomInfo");
}

//3cm_只走一次
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/*
 user_id [int]
 design_id [int]
 receiver_email [string]
 front_left_top_image [file]
 front_left_bottom_image [file]
 front_right_top_image [file]
 front_right_bottom_image [file]
 back_left_top_image [file]
 Back_left_bottom_image [file]
 Back_right_top_image [file]
 Back_right_bottom_image [file]
 front_design_image [file]
 back_design_image [file]
 designjson [string]
 */

#pragma mark 获取输出信息并上传
- (void)fetchOutputInfo{
    if (self.designJeanArr.count == 0) {
        return;
    }
    
    //email
    //Recipient email
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Output Info" message:@"Recipient email" preferredStyle:UIAlertControllerStyleAlert];
    
    @weakify(self)
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
        self.recipientEmail = @"";
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        // Stop listening for text changed notifications.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertController.textFields.firstObject];
        
        if (self.recipientEmail == nil || self.recipientEmail.length == 0) {
            [self showToash:@"Please input Recipient email"];
            return;
        }
        
        
        Jeans *jean = self.designJeanArr[self.currentIndex];
        //3cm_生成输出图
        NSMutableDictionary *outputWashImages = [jean fetchOutputImages];
        
        UIImage *front_design_image;
        UIImage *back_design_image;
        if (self.designContainer.frontView) {
            front_design_image = [UIImage imageWithView:self.jeanDesignContainerView];
            [self.designContainer switchFrontBack];
            back_design_image = [UIImage imageWithView:self.jeanDesignContainerView];
            [self.designContainer switchFrontBack];
        }else{
            back_design_image = [UIImage imageWithView:self.jeanDesignContainerView];
            [self.designContainer switchFrontBack];
            front_design_image = [UIImage imageWithView:self.jeanDesignContainerView];
            [self.designContainer switchFrontBack];
        }
        
        NSString *urlSuffix = nil;
        urlSuffix = @"myworkshop/output";
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelText = @"Processing";
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
        [hud show:YES];
        
        NSMutableDictionary *designDict = jean.mj_keyValues;
        
        NSData *frontPreviewData = UIImagePNGRepresentation([self compressImage:front_design_image]);
        NSData *backPreviewData = UIImagePNGRepresentation([self compressImage:back_design_image]);
        
        
        @weakify(self)
        [[LDenimApi getInstance] POST:urlSuffix
                           parameters:@{@"user_id":[NSNumber numberWithInteger:[Panachz getInstance].user.userId],
                                        @"design_id":jean.jeanId,
                                        @"receiver_email":self.recipientEmail,
                                        @"designjson":[NSDictionary dictionaryToJson:designDict],
                                        }
            constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:frontPreviewData name:@"front_design_image" fileName:@"front_design_image.jpg" mimeType:@"image/png"];
                [formData appendPartWithFileData:backPreviewData name:@"back_design_image" fileName:@"back_design_image.jpg" mimeType:@"image/png"];
                
                if (outputWashImages[@"FA"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"FA"]);
                    [formData appendPartWithFileData:data name:@"front_left_top_image" fileName:@"front_left_top_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"FB"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"FB"]);
                    [formData appendPartWithFileData:data name:@"front_right_top_image" fileName:@"front_right_top_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"FC"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"FC"]);
                    [formData appendPartWithFileData:data name:@"front_left_bottom_image" fileName:@"front_left_bottom_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"FD"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"FD"]);
                    [formData appendPartWithFileData:data name:@"front_right_bottom_image" fileName:@"front_right_bottom_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"BA"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"BA"]);
                    [formData appendPartWithFileData:data name:@"back_left_top_image" fileName:@"back_left_top_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"BB"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"BB"]);
                    [formData appendPartWithFileData:data name:@"back_right_top_image" fileName:@"back_right_top_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"BC"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"BC"]);
                    [formData appendPartWithFileData:data name:@"back_left_bottom_image" fileName:@"back_left_bottom_image.jpg" mimeType:@"image/png"];
                }
                if (outputWashImages[@"BD"]) {
                    NSData *data = UIImagePNGRepresentation(outputWashImages[@"BD"]);
                    [formData appendPartWithFileData:data name:@"back_right_bottom_image" fileName:@"back_right_bottom_image.jpg" mimeType:@"image/png"];
                }
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                @strongify(self)
                
                
                NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                if ([[response objectForKey:@"code"] intValue] == 102) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showToash:@"Success"];
                }else{
                    
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [MBProgressHUD hideAllHUDsForView:self.view
                                         animated:YES];
                NSLog(@"上传图片失败——%@",error);
            }];
        
        
        self.recipientEmail = @"";
        
    }]];
    
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    
    
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    // Enforce a minimum length of >= 5 characters for secure text alerts.
    self.recipientEmail = textField.text;
}

- (UIImage *)compressImage:(UIImage *)image {
    UIGraphicsBeginImageContext(CGSizeMake(1024, 1340));
    [image drawInRect:CGRectMake(0, 0, 1024, 1340)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}


#pragma mark 获取上传的牛仔裤设计信息
//3cm_
- (void)fetchJeanDesigns{
    NSString *urlSuffix = nil;
    
    if (self.isMyWorkshop) {
        urlSuffix = @"myworkshop/get_by_user_id";
        @weakify(self)
        [[LDenimApi getInstance] POST:urlSuffix
                           parameters:@{@"user_id":[NSNumber numberWithInteger:[Panachz getInstance].user.userId]}
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  @strongify(self)
                                  
                                  self.designJeanArr = [NSMutableArray array];
                                  NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                  if ([[response objectForKey:@"code"] intValue] == 200) {
                                      NSArray *myworkshop_list = [responseObject objectForKey:@"myworkshop_list"];
                                      [self fetchJeanDesignsSucceed:myworkshop_list];
                                      
                                  }else{
                                      LDLog(@"%@",response[@"message"]);
                                  }
                              } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              }];
    }else{
        urlSuffix = @"ldenimworkshop/list";
        @weakify(self)
        [[LDenimApi getInstance] GET:urlSuffix
                           parameters:@{}
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  @strongify(self)
                                  
                                  self.designJeanArr = [NSMutableArray array];
                                  NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                  if ([[response objectForKey:@"code"] intValue] == 200) {
                                      NSArray *myworkshop_list = [responseObject objectForKey:@"ldenimworkshop_list"];
                                      [self fetchJeanDesignsSucceed:myworkshop_list];
                                      
                                  }else{
                                      LDLog(@"%@",response[@"message"]);
                                  }
                              } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              }];
    }
    
    
    
}

- (void)fetchJeanDesignsSucceed:(NSArray *)myworkshop_list{
    for (NSDictionary *dict in myworkshop_list) {
        NSString *designjson = dict[@"designjson"];
        NSDictionary *jeanDesignDict = [NSDictionary dictionaryWithJsonString:designjson];
        Jeans *jeanDesign = [Jeans mj_objectWithKeyValues:jeanDesignDict]?:[Jeans new];
        NSString *realimage = dict[@"realimage"];
        if ([realimage isEqual:[NSNull null]] || realimage == nil) {
            realimage = @"";
        }
        
        if (realimage.length>0) {
            jeanDesign.realimage = dict[@"realimage"];
            jeanDesign.image_path = dict[@"image_path"];
            jeanDesign.realImageUrl = [jeanDesign fetchImageUrl:jeanDesign.realimage];
        }
        
        jeanDesign.jeanId = dict[@"id"];
        
        [self.designJeanArr addObject:jeanDesign];
    }
    
    [self reloadWorkShop];
}

//3cm_获取数据后刷新页面
- (void)reloadWorkShop {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (self.designJeanArr.count == 0) {
        return;
    }
    if (self.designJeanArr.count > 0) {
        self.designContainer.currentJeans = self.designJeanArr[self.currentIndex];
        [self.designContainer updateJeansPreview];
    }
    
    Jeans *model = self.designJeanArr[self.currentIndex];
    if (model.realImageUrl != nil) {
        [self.realJeanImageView sd_setImageWithURL:model.realImageUrl];
        self.uploadImageButton.hidden = YES;
    }else{
        self.realJeanImageView.image = [UIImage imageNamed:@"gallery_update_image"];
        if (self.isMyWorkshop) {
            self.uploadImageButton.hidden = NO;
        }else{
            self.uploadImageButton.hidden = YES;
        }
        
    }
    
    [self handleDesignJeanForWashDetail];
    [self setJeanInfoLabels];
}

//3cm_设置牛仔裤信息
- (void)setJeanInfoLabels{
    Jeans *jean = self.designJeanArr[self.currentIndex];
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
    Jeans *jean = self.designJeanArr[self.currentIndex];
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
#pragma mark TapAction
- (void)leftArrowAction:(UIGestureRecognizer *)tap{
    if (self.currentIndex > 0) {
        self.currentIndex--;
        [self reloadWorkShop];
    }
}

- (void)rightArrowAction:(UIGestureRecognizer *)tap{
    if (self.currentIndex < self.designJeanArr.count-1) {
        self.currentIndex++;
        [self reloadWorkShop];
    }
}

- (void)backViewAction:(UIGestureRecognizer *)tap{
    [self.designContainer switchFrontBack];
}

- (void)editViewAction:(UIGestureRecognizer *)tap{
    if (self.designJeanArr.count == 0) {
        return;
    }
    Jeans *jean = self.designJeanArr[self.currentIndex];
    NSString *gender = @"";
    if (jean.jeanGender == JEANS_GENDER_M) {
        gender = @"M";
    }else if(jean.jeanGender == JEANS_GENDER_F){
        gender = @"F";
    }
    
    NSDictionary *userInfo = @{@"Gender" : gender,
                               @"Jeans" :  jean};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectGender"
                                                        object:self
                                                      userInfo:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditJeans"
                                                        object:nil];
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

#pragma mark - picker Delegate
- (void) onSelectAvatar
{
    if (self.designJeanArr.count == 0) {
        return;
    }
    //从相册选取
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    //设置选择后的图片可被编辑
    pickerImage.allowsEditing = NO;
    [self.parentViewController presentViewController:pickerImage animated:YES completion:nil];
}
//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    if ([type isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlSuffix = nil;
            urlSuffix = @"myworkshop/savephoto";
            
            Jeans *jean = self.designJeanArr[self.currentIndex];
            
            [MBProgressHUD showHUDAddedTo:self.view
                                 animated:YES];
            
            @weakify(self)
            [[LDenimApi getInstance] POST:urlSuffix
                               parameters:@{@"id":jean.jeanId}
                                  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                      [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                      @strongify(self)
                                      
                                      
                                      NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                                      if ([[response objectForKey:@"code"] intValue] == 102) {
                                          
                                          [self fetchJeanDesigns];
                                          
                                      }else{
                                          LDLog(@"%@",response[@"message"]);
                                      }
                                  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                                      [MBProgressHUD hideAllHUDsForView:self.view
                                                               animated:YES];
                                      NSLog(@"上传图片失败——%@",error);
                                  }];
            
        });
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
