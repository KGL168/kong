//
//  LDWorkShopViewController.h
//  Panachz
//
//  Created by sanlimikaifa on 2017/3/1.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDWorkShopViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftArrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *realJeanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backViewImageView;
@property (weak, nonatomic) IBOutlet UITableView *washDetailsTableView;
@property (weak, nonatomic) IBOutlet UILabel *bottomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIView *jeanDesignContainerView;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;

@property (weak, nonatomic) IBOutlet UILabel *fitInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *washInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *basecolorInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fabricLabel;
@property (weak, nonatomic) IBOutlet UILabel *fabricInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIButton *outputBtn;

@property (nonatomic) BOOL isMyWorkshop;

- (void)fetchJeanDesigns;

@end
