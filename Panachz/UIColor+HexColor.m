//
//  UIColor+HexColor.m
//  Panachz
//
//  Created by YinYin Chiu on 7/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorWithRBGValue:(uint32_t)rgb {
    return [UIColor colorWithRBGValue:rgb
                                alpha:1.0];
}

+ (UIColor *)colorWithRBGValue:(uint32_t)rgb alpha:(CGFloat)alpha {
    CGFloat red = ((rgb & 0xFF0000) >> 16) / 255.0f;
    CGFloat green = ((rgb & 0x00FF00) >> 8) / 255.0f;
    CGFloat blue = (rgb & 0x0000FF) / 255.0f;
    
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}

@end
