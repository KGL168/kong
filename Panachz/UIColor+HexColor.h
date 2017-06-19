//
//  UIColor+HexColor.h
//  Panachz
//
//  Created by YinYin Chiu on 7/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorWithRBGValue:(uint32_t)rgb;
+ (UIColor *)colorWithRBGValue:(uint32_t)rgb alpha:(CGFloat)alpha;

@end
