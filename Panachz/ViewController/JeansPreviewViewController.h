//
//  JeansPreviewViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 13/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jeans.h"

@interface JeansPreviewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *jeansBaseImageView;
@property (strong, nonatomic) IBOutlet UIImageView *dotlineImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backPocketImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backPocketDotlineImageView;
@property (strong, nonatomic) IBOutlet UIView *leftWashView;
@property (strong, nonatomic) IBOutlet UIView *rightWashView;
@property (strong, nonatomic) IBOutlet UIImageView *backPatchImageView;

@property (strong, nonatomic) IBOutlet UIImageView *frontBackImageView;

// Back Pocket Size constraint
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backPocketHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backPocketWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backPocketCenterYToJeans;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backPocketDotlineHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backPocketDotlineWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backPocketDotlineCenterYToJeans;

@end
