//
//  TutorialImageViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "WhatIsPanachzImageViewController.h"

@interface WhatIsPanachzImageViewController ()

@end

@implementation WhatIsPanachzImageViewController

@synthesize imageName;
@synthesize tutorialImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tutorialImage setImage:[UIImage imageNamed:self.imageName]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tutorialImage setImage:[UIImage imageNamed:self.imageName]];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.tutorialImage.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.tutorialImage.image = nil;
}

@end
