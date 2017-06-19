//
//  UIImage+CaptureView.m
//  Panachz
//
//  Created by Peter Choi on 29/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "UIImage+CaptureView.h"

@implementation UIImage (CaptureView)

+ (UIImage *) imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end
