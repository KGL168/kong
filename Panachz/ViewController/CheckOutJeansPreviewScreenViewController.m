//
//  CheckOutJeansPreviewScreenViewController.m
//  Panachz
//
//  Created by Peter Choi on 3/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "CheckOutJeansPreviewScreenViewController.h"
#import "CheckOutJeansPreviewViewController.h"

@interface CheckOutJeansPreviewScreenViewController ()

@end

@implementation CheckOutJeansPreviewScreenViewController

@synthesize pageControl;
@synthesize frontPreview;
@synthesize backPreiview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [self.pageControl setCurrentPage:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissImagePreview {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewJeansImage"]) {
        CheckOutJeansPreviewViewController *vc = (CheckOutJeansPreviewViewController *)segue.destinationViewController;
        vc.frontPreview = self.frontPreview;
        vc.backPreview = self.backPreiview;
    }
}

@end
