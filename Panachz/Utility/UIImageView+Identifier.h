//
//  UIImageView+Identifier.h
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@class LDWashModel;
@class LDFabricModel;
@interface UIImageView (Identifier)

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) LDWashModel *washModel;
@property (nonatomic, strong) LDFabricModel *fabricModel;

- (void)setIdentifier:(NSString *)identifier;
- (NSString *)identifier;

- (void)setWashModel:(LDWashModel *)model;
- (LDWashModel *)washModel;

- (void)setFabricModel:(LDFabricModel *)model;
- (LDFabricModel *)fabricModel;

@end
