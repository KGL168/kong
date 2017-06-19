//
//  TutorialViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "WhatIsPanachzViewController.h"
#import "WhatIsPanachzImageViewController.h"

@interface WhatIsPanachzViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation WhatIsPanachzViewController

@synthesize tutorialDelegate;

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

#pragma mark - View Pager Data Source

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = @"l";
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WhatIsPanachzImageViewController *vc = [storyborad instantiateViewControllerWithIdentifier:@"TutorialImageViewController"];
    
    if (index == 0) {
        vc.imageName = @"about_1";
    } else {
        vc.imageName = @"about_2";
    }
    
    return vc;
}

#pragma mark - View Pager Delegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    [self.tutorialDelegate didChangeToTutorialOfIndex:index];
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabHeight:
            return 0;
        default:
            return value;
    }
}

@end
