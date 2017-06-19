//
//  UIImagePickerController+LandScapeImagePicker.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/3/7.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import "UIImagePickerController+LandScapeImagePicker.h"

@implementation UIImagePickerController (LandScapeImagePicker)
//- (BOOL)shouldAutorotate {
//    
//    return NO;
//}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscape;
}

@end
