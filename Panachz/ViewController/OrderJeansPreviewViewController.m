//
//  OrderJeansPreviewViewController.m
//  Panachz
//
//  Created by Peter Choi on 4/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "OrderJeansPreviewViewController.h"
#import "OrderJeansPreviewImageViewController.h"

@interface OrderJeansPreviewViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation OrderJeansPreviewViewController

@synthesize frontPreviewUrl;
@synthesize backPreivewUrl;
@synthesize orderJeansPreviewDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = @"Tab";
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderJeansPreviewImageViewController *vc = [storyborad instantiateViewControllerWithIdentifier:@"OrderJeansPreviewImageViewController"];
    
    if (index == 0) {
        vc.previewUrl = self.frontPreviewUrl;
    } else {
        vc.previewUrl = self.backPreivewUrl;
    }
    
    return vc;
}

#pragma mark - View Pager Delegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    [self.orderJeansPreviewDelegate didChangeToIndex:index];
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabHeight:
            return 0;
        case ViewPagerOptionInitialIndex:
            return 0;
        default:
            return value;
    }
}


@end
