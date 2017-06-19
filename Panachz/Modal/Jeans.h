//
//  Jeans.h
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define WashOutputFtLt @"wash_output_ft_lt"
#define WashOutputFtRt @"wash_output_ft_rt"
#define WashOutputBkLt @"wash_output_bk_lt"
#define WashOutputBkRt @"wash_output_bk_rt"
@class LDFabricModel;

typedef NS_ENUM(NSUInteger, JeansGender) {
    JEANS_GENDER_NOT_SET,
    JEANS_GENDER_M,
    JEANS_GENDER_F
};

typedef NS_ENUM(NSUInteger, JeansFit) {
    JEANS_FIT_NOT_SET,
    JEANS_FIT_SKINNY,
    JEANS_FIT_STRAIGHT,
    JEANS_FIT_BOOOTCUT,
    JEANS_FIT_JEGGINGS
};

typedef NS_ENUM(NSUInteger, JeansRise) {
    JEANS_RISE_NOT_SET,
    JEANS_RISE_LOW,
    JEANS_RISE_MIDDLE,
};

typedef NS_ENUM(NSUInteger, JeansFly) {
    JEANS_FLY_NOT_SET,
    JEANS_FLY_ZIP,
    JEANS_FLY_BUTTON,
};

typedef NS_ENUM(NSUInteger, JeansFabric) {
    JEANS_FABRIC_NOT_SET,
    JEANS_FABRIC_UFSV_001,
    JEANS_FABRIC_UFSV_002,
    JEANS_FABRIC_UFSV_003,
    JEANS_FABRIC_UFSV_004,
    JEANS_FABRIC_UFCT_001,
    JEANS_FABRIC_UFCT_002,
    JEANS_FABRIC_UFCT_003,
    JEANS_FABRIC_UFCT_004,
    JEANS_FABRIC_UFCT_005,
    JEANS_FABRIC_UFCT_006,
    JEANS_FABRIC_UFSJ_001,
    JEANS_FABRIC_UFSJ_002,
    JEANS_FABRIC_UFSJ_003,
    JEANS_FABRIC_UFSJ_004,
    JEANS_FABRIC_UFSP_001,
    JEANS_FABRIC_UFSP_002,
    JEANS_FABRIC_UFSP_003,
    JEANS_FABRIC_UFSP_004,
    JEANS_FABRIC_UFSP_005,
    JEANS_FABRIC_UFSP_006,
    JEANS_FABRIC_UFSP_007,
    JEANS_FABRIC_UFSP_008,
};

typedef NS_ENUM(NSUInteger, JeansBaseColor) {
    JEANS_BASE_COLOR_NOT_SET,
    JEANS_BASE_COLOR_LIGHT,
    JEANS_BASE_COLOR_MEDIUM,
    JEANS_BASE_COLOR_DARK
};

typedef NS_ENUM(NSUInteger, JeansConstructionThread) {
    JEANS_CONSTRUCTION_THREAD_NOT_SET,
    JEANS_CONSTRUCTION_THREAD_COPPER,
    JEANS_CONSTRUCTION_THREAD_GOLD,
    JEANS_CONSTRUCTION_THREAD_INDIGO,
    JEANS_CONSTRUCTION_THREAD_LIGHT_BLUE,
    JEANS_CONSTRUCTION_THREAD_WHITE
};

typedef NS_ENUM(NSUInteger, JeansBackPocket) {
    JEANS_BACK_POCKET_NOT_SET,
    JEANS_BACK_POCKET_UBPS_001M,
    JEANS_BACK_POCKET_UBPS_002M,
    JEANS_BACK_POCKET_UBPS_003M,
    JEANS_BACK_POCKET_UBPS_004M,
    JEANS_BACK_POCKET_UBPS_001F,
    JEANS_BACK_POCKET_UBPS_002F,
    JEANS_BACK_POCKET_UBPS_003F,
    JEANS_BACK_POCKET_UBPS_004F,
    JEANS_BACK_POCKET_UBPS_005F
};

typedef NS_ENUM(NSUInteger, JeansShank) {
    JEANS_SHANK_NOT_SET,
    JEANS_SHANK_SHINNY_GOLD,
    JEANS_SHANK_SILVER
};

typedef NS_ENUM(NSUInteger, JeansRivet) {
    JEANS_RIVET_NOT_SET,
    JEANS_RIVET_1,
    JEANS_RIVET_2,
    JEANS_RIVET_3,
    JEANS_RIVET_4
};

typedef NS_ENUM(NSUInteger, JeansBackPatchType) {
    JEANS_BACK_PATCH_NOT_SET,
    JEANS_BACK_PATCH_WHITE_COLOR_COATED_GENUINE_BUFFLO_LEATHER,
    JEANS_BACK_PATCH_GENUINE_BULL_LEATHER,
    JEANS_BACK_PATCH_BLACK_COLOR_COATED_GENUINE_BUFFLO_LEATHER,
    JEANS_BACK_PATCH_GENUINE_SUEDE_LEATHER
};

@interface Jeans : NSObject

@property (nonatomic) JeansGender jeanGender;
@property (nonatomic) JeansFit jeanFit;
@property (nonatomic) JeansRise jeanRise;
@property (nonatomic) JeansFly jeanFly;

//3cm_jeanFabric模型数据
@property (nonatomic , strong) LDFabricModel *jeanFabricModel;
@property (nonatomic) JeansBaseColor jeanBaseColor;
@property (nonatomic) JeansConstructionThread jeanContrucstionThread;
@property (nonatomic) JeansBackPocket jeanBackPocket;

@property (nonatomic, strong) NSMutableArray *jeanWashes;
@property (nonatomic) JeansShank jeanShank;
@property (nonatomic, strong) NSString *jeanHardwareWordingFontType;
@property (nonatomic) NSUInteger jeanHardwareWordingFontSize;
@property (nonatomic, strong) NSString *jeanHardwareWordingText;
@property (nonatomic) JeansRivet jeanRivet;
@property (nonatomic,strong) NSString *jeanOutseamSize;
@property (nonatomic,strong) NSString *jeanInseamSize;
@property (nonatomic,strong) NSString *jeanWaistSize;
@property (nonatomic,strong) NSString *jeanHipsSize;
@property (nonatomic,strong) NSString *jeanThighSize;
@property (nonatomic, strong) NSString *jeanCurveSize;
@property (nonatomic) JeansBackPatchType jeanBackPatchType;
@property (nonatomic, strong) NSString *jeanBackPatchFontType;
@property (nonatomic) NSUInteger jeanBackPatchFontSize;
@property (nonatomic, strong) NSString *jeanBackPatchFontColor;
@property (nonatomic, strong) NSString *jeanBackPatchText;

@property (nonatomic, strong) UIImage *hardwareImage;
@property (nonatomic, strong) UIImage *backPatchImage;

@property (nonatomic, copy) NSString *hardwareString;

//新添加
@property (nonatomic, strong) NSString *image_path;
@property (nonatomic, strong) NSString *realimage;
@property (nonatomic, strong) NSURL *realImageUrl;
@property (nonatomic, strong) NSString *jeanId;

- (instancetype)init;
- (instancetype)initWithGender:(JeansGender) gender;
- (void)resetJeans;

- (NSURL *)fetchImageUrl:(NSString *)imgName;

//3cm_输出激光牛读取的wash1：1大图，并按字典形式存储
- (NSMutableDictionary *)fetchOutputImages;

@end
