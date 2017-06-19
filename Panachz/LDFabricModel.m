//
//  LDFabricModel.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/23.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import "LDFabricModel.h"
#import "LDImagesUrl.h"

@implementation LDFabricModel

- (NSURL *)fetchImageUrl:(NSString *)imgName{
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@%@",kImagesBaseURLString,self.image_path,imgName]];
    return url;
}

@end
