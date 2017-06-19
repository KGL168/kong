//
//  JeanDesignContainer.h
//  Panachz
//
//  Created by sanlimikaifa on 2017/3/3.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Jeans;

@interface JeanDesignContainer : UIView
@property (strong, nonatomic) UIImageView *jeansBaseImageView;
@property (strong, nonatomic) UIView *leftWashView;
@property (strong, nonatomic) UIView *rightWashView;
@property (nonatomic, strong) UIImageView *dotlineImageView;

@property (nonatomic, strong) Jeans *currentJeans;

@property (nonatomic) BOOL frontView;

- (instancetype)init;
- (void)switchFrontBack;
- (void)updateJeansPreview;

@end
