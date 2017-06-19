//
//  JeansImagePreviewViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JeansImagePreviewViewController : UIViewController

@property (nonatomic) NSUInteger imageSet;
@property (nonatomic) NSUInteger imageNo;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
