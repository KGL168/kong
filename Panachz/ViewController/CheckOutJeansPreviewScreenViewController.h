//
//  CheckOutJeansPreviewScreenViewController.h
//  Panachz
//
//  Created by Peter Choi on 3/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOutJeansPreviewScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UIImage *frontPreview;
@property (strong, nonatomic) UIImage *backPreiview;

@end
