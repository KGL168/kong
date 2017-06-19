//
//  UIImage+LDImageMerge.h
//  HuiTuTest
//
//  Created by sanlimikaifa on 2017/2/14.
//  Copyright © 2017年 3cm. All rights reserved.
//

#define MergeX  @"x"
#define MergeY  @"y"

#import <UIKit/UIKit.h>

@interface UIImage (LDImageMerge)

//3cm_imgPointArray 生成1：1大图的，中心点位置
+ (UIImage *) mergeImageWithImageArray:(NSMutableArray *)imgArray AndImagePointArray:(NSMutableArray *)imgPointArray;

//3cm_从缓存中取输出图片
+ (UIImage *) fetchOutputImageFromSDCache:(NSURL *)url;

@end
