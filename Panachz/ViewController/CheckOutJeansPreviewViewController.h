//
//  CheckOutJeansPreviewViewController.h
//  Panachz
//
//  Created by Peter Choi on 3/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

@protocol CheckOutJeansPreviewDelegate <NSObject>

- (void)didChangeToIndex:(NSInteger)index;

@end

@interface CheckOutJeansPreviewViewController : ViewPagerController

@property (nonatomic, strong) UIImage *frontPreview;
@property (nonatomic, strong) UIImage *backPreview;
@property (nonatomic, strong) id <CheckOutJeansPreviewDelegate> checkOutJeansPreviewDelegate;

@end
