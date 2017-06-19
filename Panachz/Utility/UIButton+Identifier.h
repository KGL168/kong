//
//  UIButton+Identifier.h
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (Identifier)

@property (nonatomic, strong) NSString *identifier;

- (void)setIdentifier:(NSString *)identifier;
- (NSString *)identifier;

@end
