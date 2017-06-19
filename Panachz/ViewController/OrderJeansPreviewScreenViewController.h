//
//  OrderJeansPreviewScreenViewController.h
//  Panachz
//
//  Created by Peter Choi on 4/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderJeansPreviewScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSString *frontPreivewUrl;
@property (nonatomic, strong) NSString *backPreviewUrl;

@end
