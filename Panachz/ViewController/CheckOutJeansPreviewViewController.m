//
//  CheckOutJeansPreviewViewController.m
//  Panachz
//
//  Created by Peter Choi on 3/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "CheckOutJeansPreviewViewController.h"
#import "CheckOutJeansPreviewImageViewController.h"

@interface CheckOutJeansPreviewViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation CheckOutJeansPreviewViewController

@synthesize frontPreview;
@synthesize backPreview;
@synthesize checkOutJeansPreviewDelegate;

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

#pragma mark - View Page Data Source and Delegate

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
    CheckOutJeansPreviewImageViewController *vc = [storyborad instantiateViewControllerWithIdentifier:@"CheckOutJeansPreviewImageViewController"];
    
    if (index == 0) {
        vc.previewImage = self.frontPreview;
    } else {
        vc.previewImage = self.backPreview;
    }
    
    return vc;
}

#pragma mark - View Pager Delegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    [self.checkOutJeansPreviewDelegate didChangeToIndex:index];
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
