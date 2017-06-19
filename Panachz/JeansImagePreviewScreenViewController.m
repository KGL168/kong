//
//  JeansImagePreviewScreenViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "JeansImagePreviewScreenViewController.h"
#import "JeansImagePreviewImageViewController.h"

@interface JeansImagePreviewScreenViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic, strong) NSArray *images;

@end

@implementation JeansImagePreviewScreenViewController

@synthesize imageNo;
@synthesize imageSet;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.images = @[@[@"Men_Skinny_Fit_preview_1", @"Men_Skinny_Fit_preview_2", @"Men_Skinny_Fit_preview_3", @"Men_Skinny_Fit_preview_4"],
                    @[@"Men_Straight_Fit_preview_1", @"Men_Straight_Fit_preview_2", @"Men_Straight_Fit_preview_3", @"Men_Straight_Fit_preview_4"],
                    @[@"Men_Bootcut_fit_preview_1", @"Men_Bootcut_fit_preview_2", @"Men_Bootcut_fit_preview_3", @"Men_Bootcut_fit_preview_4"],
                    @[@"Women_Skinny_Fit_preview_1", @"Women_Skinny_Fit_preview_2", @"Women_Skinny_Fit_preview_3", @"Women_Skinny_Fit_preview_4"],
                    @[@"Women_Straight_Fit_preview_1", @"Women_Straight_Fit_preview_2", @"Women_Straight_Fit_preview_3", @"Women_Straight_Fit_preview_4"],
                    @[@"Women_Bootcut_Fit_preview_1", @"Women_Bootcut_Fit_preview_2", @"Women_Bootcut_Fit_preview_3", @"Women_Bootcut_Fit_preview_4"],
                    @[@"Women_Jeggings_Fit_preview_1", @"Women_Jeggings_Fit_preview_2", @"Women_Jeggings_Fit_preview_3", @"Women_Jeggings_Fit_preview_4"]];
    
    self.delegate = self;
    self.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Page Data Source and Delegate

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = @"Tab";
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JeansImagePreviewImageViewController *vc = [storyborad instantiateViewControllerWithIdentifier:@"JeansImagePreviewImageViewController"];
    
    vc.imageName = [[self.images objectAtIndex:self.imageSet] objectAtIndex:index];
    
    return vc;
}

#pragma mark - View Pager Delegate

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    [self.jeansImagePreviewDelegate imagePreviewDidChangeToIndex:index];
}

- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabHeight:
            return 0;
        case ViewPagerOptionInitialIndex:
            return self.imageNo;
        default:
            return value;
    }
}


@end
