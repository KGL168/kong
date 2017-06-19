//
//  UIButton+Identifier.m
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "UIButton+Identifier.h"

@implementation UIButton (Identifier)

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, @selector(identifier));
}

@end
