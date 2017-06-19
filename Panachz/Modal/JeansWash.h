//
//  JeansWash.h
//  Panachz
//
//  Created by YinYin Chiu on 24/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LDWashModel.h"

//3cm_输出展示，缩小比例
#define O_D_Scale 9

@interface JeansWash : NSObject

//3cm_1：1比例输出大图，只能靠中心点来定位，比较准确
@property (nonatomic) CGFloat centerPointX;
@property (nonatomic) CGFloat centerPointY;
@property (nonatomic) BOOL left;
@property (nonatomic) BOOL front;
@property (nonatomic, strong) LDWashModel *washModel;
//3cm_洗水图片放大倍数
@property (nonatomic) CGFloat scoleNum;


- (instancetype)init;

@end
