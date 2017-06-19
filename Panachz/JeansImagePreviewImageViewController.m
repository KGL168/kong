//
//  JeansImagePreviewImageViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 10/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "JeansImagePreviewImageViewController.h"

@interface JeansImagePreviewImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation JeansImagePreviewImageViewController

@synthesize image;
@synthesize imageName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.image setImage:[UIImage imageNamed:self.imageName]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.image setImage:[UIImage imageNamed:self.imageName]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.image setImage:nil];
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
