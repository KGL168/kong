//
//  UIImageView+Identifier.m
//  Panachz
//
//  Created by YinYin Chiu on 14/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "UIImageView+Identifier.h"
#import "LDWashModel.h"
#import "LDFabricModel.h"


@implementation UIImageView (Identifier)

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, @selector(identifier));
}

- (void)setWashModel:(LDWashModel *)model{
    objc_setAssociatedObject(self, @selector(washModel), model, OBJC_ASSOCIATION_RETAIN);
}

- (LDWashModel *)washModel{
    return objc_getAssociatedObject(self, @selector(washModel));
}

- (void)setFabricModel:(LDFabricModel *)model{
    objc_setAssociatedObject(self, @selector(fabricModel), model, OBJC_ASSOCIATION_RETAIN);
}

- (LDFabricModel *)fabricModel{
    return objc_getAssociatedObject(self, @selector(fabricModel));
}

@end
