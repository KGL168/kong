//
//  JeansImagePreviewScreenViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

@protocol JeansImagePreviewDelegate <NSObject>

- (void)imagePreviewDidChangeToIndex:(NSUInteger) index;

@end

@interface JeansImagePreviewScreenViewController : ViewPagerController

@property (nonatomic) NSUInteger imageNo;
@property (nonatomic) NSUInteger imageSet;
@property (nonatomic, strong) id <JeansImagePreviewDelegate> jeansImagePreviewDelegate;

@end
