//
//  JeansImagePreviewViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "JeansImagePreviewViewController.h"
#import "JeansImagePreviewScreenViewController.h"

@interface JeansImagePreviewViewController () <JeansImagePreviewDelegate>

@end

@implementation JeansImagePreviewViewController

@synthesize imageNo;
@synthesize imageSet;
@synthesize pageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 24, 24)];
    [menuImage setImage:[UIImage imageNamed:@"ic_keyboard_arrow_left_black_48dp"]];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addSubview:menuImage];
    menuButton.frame = CGRectMake(0, 0, 24, 24);
    [menuButton addTarget:self
                   action:@selector(dismissImagePreview)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = navigationBarMenuButton;
    
    // Setup the page control
    [self.pageControl setCurrentPage:self.imageNo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"JeansImagePreviewSegue"]) {
        JeansImagePreviewScreenViewController *vc = (JeansImagePreviewScreenViewController *) segue.destinationViewController;
        vc.jeansImagePreviewDelegate = self;
        vc.imageSet = self.imageSet;
        vc.imageNo = self.imageNo;
    }
}

- (void)dismissImagePreview {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Jeans Image Preview Delegate

- (void)imagePreviewDidChangeToIndex:(NSUInteger)index {
    [pageControl setCurrentPage:index];
}

@end
