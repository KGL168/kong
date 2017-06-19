//
//  OrderJeansPreviewImageViewController.m
//  Panachz
//
//  Created by Peter Choi on 4/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "OrderJeansPreviewImageViewController.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface OrderJeansPreviewImageViewController ()

@end

@implementation OrderJeansPreviewImageViewController

@synthesize previewUrl;
@synthesize imageView;
@synthesize loadingIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.imageView setImageWithURL:[NSURL URLWithString:self.previewUrl]];
    __weak typeof (self) weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.previewUrl]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 weakSelf.loadingIndicator.hidden = YES;
                             }];
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
