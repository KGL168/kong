//
//  DesignBackPocketViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignBackPocketViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *resetBackPocketButton;

@property (strong, nonatomic) IBOutlet UIImageView *backPocketImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backPocketCheckBarButton;
@property (strong, nonatomic) IBOutlet UILabel *backPocketCheckBarTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backPocketPreviewLeftButton;
@property (strong, nonatomic) IBOutlet UIImageView *backPocketPreivewRightButton;
@property (strong, nonatomic) IBOutlet UIScrollView *backPocketPreviewThumbnailScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *backPocketCheckIcon;

@end
