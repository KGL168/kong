//
//  Jeans.m
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "Jeans.h"
#import "JeansWash.h"
#import "LDFabricModel.h"
#import "UIImage+LDImageMerge.h"
#import "LDImagesUrl.h"
#import "UIImage+CaptureView.h"

#define A_C_Border_Y 118.0

@implementation Jeans

@synthesize jeanGender;
@synthesize jeanFit;
@synthesize jeanRise;
@synthesize jeanFly;
@synthesize jeanBaseColor;
@synthesize jeanContrucstionThread;
@synthesize jeanBackPocket;
@synthesize jeanWashes;
@synthesize jeanShank;
@synthesize jeanHardwareWordingFontType;
@synthesize jeanHardwareWordingFontSize;
@synthesize jeanHardwareWordingText;
@synthesize jeanRivet;
@synthesize jeanOutseamSize;
@synthesize jeanInseamSize;
@synthesize jeanWaistSize;
@synthesize jeanHipsSize;
@synthesize jeanThighSize;
@synthesize jeanCurveSize;
@synthesize jeanBackPatchType;
@synthesize jeanBackPatchFontType;
@synthesize jeanBackPatchFontSize;
@synthesize jeanBackPatchFontColor;
@synthesize jeanBackPatchText;

@synthesize backPatchImage;
@synthesize hardwareImage;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self resetJeans];
    }
    
    return self;
}

- (instancetype)initWithGender:(JeansGender)gender {
    self = [super init];
    
    if (self) {
        [self resetJeans];
        self.jeanGender = gender;
    }
    
    return self;
}

- (void)resetJeans {
    self.jeanGender = JEANS_GENDER_NOT_SET;
    self.jeanFit = JEANS_FIT_NOT_SET;
    self.jeanRise = JEANS_RISE_NOT_SET;
    self.jeanFly = JEANS_FLY_NOT_SET;
    self.jeanBaseColor = JEANS_BASE_COLOR_NOT_SET;
    self.jeanContrucstionThread = JEANS_CONSTRUCTION_THREAD_NOT_SET;
    self.jeanBackPocket = JEANS_BACK_POCKET_NOT_SET;
    self.jeanWashes = [[NSMutableArray alloc] init];
    self.jeanShank = JEANS_SHANK_NOT_SET;
    self.jeanHardwareWordingFontSize = 72;
    self.jeanHardwareWordingFontType = @"Arial";
    self.jeanHardwareWordingText = nil;
    self.jeanRivet = JEANS_RIVET_NOT_SET;
    self.jeanOutseamSize = nil;
    self.jeanInseamSize = nil;
    self.jeanWaistSize = nil;
    self.jeanHipsSize = nil;
    self.jeanThighSize = nil;
    self.jeanCurveSize = nil;
    self.jeanBackPatchType = JEANS_BACK_PATCH_NOT_SET;
    self.jeanBackPatchFontType = @"Arial";
    self.jeanBackPatchFontSize = 72;
    self.jeanBackPatchFontColor = @"Black";
    self.jeanBackPatchText = @"";
    
    self.hardwareImage = nil;
    self.backPatchImage = nil;
    
    //3cm
    self.jeanFabricModel = [[LDFabricModel alloc] init];
}

// 这个方法对比上面的2个方法更加没有侵入性和污染，因为不需要导入Status和Ad的头文件
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"jeanWashes" : @"JeansWash"
             };
}

- (NSMutableDictionary *)fetchOutputImages{
    NSMutableDictionary *outputDict = [NSMutableDictionary dictionary];
    
    NSPredicate* predicateFA = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY<=%f",YES,YES,A_C_Border_Y];
    NSArray *ftltArrFA=[self.jeanWashes filteredArrayUsingPredicate: predicateFA];
    if (ftltArrFA.count > 0) {
        UIImage *outputImageFA = [self fetchMergeOutputImage:ftltArrFA];
        outputDict[@"FA"] = outputImageFA;
    }
    
    NSPredicate* predicateFB = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY<=%f",YES,NO,A_C_Border_Y];
    NSArray *ftltArrFB=[self.jeanWashes filteredArrayUsingPredicate: predicateFB];
    if (ftltArrFB.count > 0) {
        UIImage *outputImageFB = [self fetchMergeOutputImage:ftltArrFB];
        outputDict[@"FB"] = outputImageFB;
    }
    
    NSPredicate* predicateFC = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY>%f",YES,YES,A_C_Border_Y];
    NSArray *ftltArrFC=[self.jeanWashes filteredArrayUsingPredicate: predicateFC];
    if (ftltArrFC.count > 0) {
        UIImage *outputImageFC = [self fetchMergeOutputImage:ftltArrFC];
        outputDict[@"FC"] = outputImageFC;
    }
    
    NSPredicate* predicateFD = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY>%f",YES,NO,A_C_Border_Y];
    NSArray *ftltArrFD=[self.jeanWashes filteredArrayUsingPredicate: predicateFD];
    if (ftltArrFD.count > 0) {
        UIImage *outputImageFD = [self fetchMergeOutputImage:ftltArrFD];
        outputDict[@"FD"] = outputImageFD;
    }
    
    
    
    //bk
    NSPredicate* predicateBA = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY<=%f",NO,YES,A_C_Border_Y];
    NSArray *ftltArrBA=[self.jeanWashes filteredArrayUsingPredicate: predicateBA];
    if (ftltArrBA.count > 0) {
        UIImage *outputImageBA = [self fetchMergeOutputImage:ftltArrBA];
        outputDict[@"BA"] = outputImageBA;
    }
    
    NSPredicate* predicateBB = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY<=%f",NO,NO,A_C_Border_Y];
    NSArray *ftltArrBB=[self.jeanWashes filteredArrayUsingPredicate: predicateBB];
    if (ftltArrBB.count > 0) {
        UIImage *outputImageBB = [self fetchMergeOutputImage:ftltArrBB];
        outputDict[@"BB"] = outputImageBB;
    }
    
    NSPredicate* predicateBC = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY>%f",NO,YES,A_C_Border_Y];
    NSArray *ftltArrBC=[self.jeanWashes filteredArrayUsingPredicate: predicateBC];
    if (ftltArrBC.count > 0) {
        UIImage *outputImageBC = [self fetchMergeOutputImage:ftltArrBC];
        outputDict[@"BC"] = outputImageBC;
    }
    
    NSPredicate* predicateBD = [NSPredicate predicateWithFormat:@"front==%d AND left ==%d AND centerPointY>%f",NO,NO,A_C_Border_Y];
    NSArray *ftltArrBD=[self.jeanWashes filteredArrayUsingPredicate: predicateBD];
    if (ftltArrBD.count > 0) {
        UIImage *outputImageBD = [self fetchMergeOutputImage:ftltArrBD];
        outputDict[@"BD"] = outputImageBD;
    }
    
    
    
    return outputDict;
}

//3cm_根据出来的jeanWashes数据，合并成一张输出大图
- (UIImage *)fetchMergeOutputImage:(NSArray *)arr{
    NSMutableArray *imagesArr = [NSMutableArray array];
    NSMutableArray *pointsArr = [NSMutableArray array];
    for (JeansWash *wash in arr) {
        
        UIImage *outputImage = [UIImage fetchOutputImageFromSDCache:wash.washModel.output_imgUrl];
        
        //根据输出图的放大比例，放大合成图上的洗水图片
        CGFloat width = outputImage.size.width*wash.scoleNum;
        CGFloat height = outputImage.size.height*wash.scoleNum;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image = outputImage;
        outputImage = [UIImage imageWithView:imageView];
        
        
        [imagesArr addObject:outputImage];
        
        NSMutableDictionary *pointDict = [NSMutableDictionary dictionary];
        pointDict[MergeX] = [NSNumber numberWithFloat:wash.centerPointX*O_D_Scale];
        pointDict[MergeY] = [NSNumber numberWithFloat:wash.centerPointY*O_D_Scale];
        [pointsArr addObject:pointDict];
    }
    
    UIImage *image = [UIImage mergeImageWithImageArray:imagesArr AndImagePointArray:pointsArr];
    return image;
}

- (NSURL *)fetchImageUrl:(NSString *)imgName{
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@",kImagesBaseURLString,self.image_path,imgName]];
    return url;
}

@end
