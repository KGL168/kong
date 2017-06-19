//
//  OrderJeansPreviewViewController.h
//  Panachz
//
//  Created by Peter Choi on 4/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

@protocol OrderJeansPreviewDelegate <NSObject>

- (void)didChangeToIndex:(NSInteger)index;

@end

@interface OrderJeansPreviewViewController : ViewPagerController

@property (nonatomic, strong) NSString *frontPreviewUrl;
@property (nonatomic, strong) NSString *backPreivewUrl;
@property (nonatomic, strong) id <OrderJeansPreviewDelegate> orderJeansPreviewDelegate;

@end
