//
//  CheckOutJeansPreviewImageViewController.m
//  Panachz
//
//  Created by Peter Choi on 3/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "CheckOutJeansPreviewImageViewController.h"

@interface CheckOutJeansPreviewImageViewController ()

@end

@implementation CheckOutJeansPreviewImageViewController

@synthesize previewImage;
@synthesize previewImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.previewImageView setContentMode:UIViewContentModeScaleAspectFit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.previewImageView setImage:previewImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
