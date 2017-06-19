//
//  UIImage+LDImageMerge.m
//  HuiTuTest
//
//  Created by sanlimikaifa on 2017/2/14.
//  Copyright © 2017年 3cm. All rights reserved.
//

#import "UIImage+LDImageMerge.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"

@implementation UIImage (LDImageMerge)

+ (UIImage *) mergeImageWithImageArray:(NSMutableArray *)imgArray AndImagePointArray:(NSMutableArray *)imgPointArray{
    //3cm_根据图片大小，以及中心点的位置，计算生成图片大小，以及计算新的中心店的位置。
    
    NSMutableArray *minXs = [NSMutableArray array];
    NSMutableArray *minYs = [NSMutableArray array];
    NSMutableArray *maxXs = [NSMutableArray array];
    NSMutableArray *maxYs = [NSMutableArray array];
    
    for (int i = 0; i<imgArray.count; i++) {
        UIImage *img = imgArray[i];
        CGFloat centerPointX = [[imgPointArray objectAtIndex:i][MergeX] floatValue];
        CGFloat centerPointY = [[imgPointArray objectAtIndex:i][MergeY] floatValue];
        
        [minXs addObject:[NSNumber numberWithFloat:centerPointX-img.size.width/2]];
        [minYs addObject:[NSNumber numberWithFloat:centerPointY-img.size.height/2]];
        [maxXs addObject:[NSNumber numberWithFloat:centerPointX+img.size.width/2]];
        [maxYs addObject:[NSNumber numberWithFloat:centerPointY+img.size.height/2]];
        
    }
    
    CGFloat minX = [[minXs valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat minY = [[minYs valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat maxX = [[maxXs valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat maxY = [[maxYs valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGSize mainSize = CGSizeMake(maxX-minX, maxY-minY);
    UIGraphicsBeginImageContext(mainSize);
    
    for (int i = 0; i<imgArray.count; i++) {
        UIImage *img = imgArray[i];
        CGFloat centerPointX = [[imgPointArray objectAtIndex:i][MergeX] floatValue];
        CGFloat centerPointY = [[imgPointArray objectAtIndex:i][MergeY] floatValue];
        
        CGPoint centerPoint = CGPointMake(centerPointX-minX,centerPointY-minY);
        CGPoint originPoint = CGPointMake(centerPoint.x-img.size.width/2, centerPoint.y-img.size.height/2);
        [img drawInRect:CGRectMake(originPoint.x,
                                   originPoint.y,
                                   img.size.width,
                                   img.size.height)];
    }
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)fetchOutputImageFromSDCache:(NSURL *)url{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:url];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    UIImage *image = [cache imageFromDiskCacheForKey:key];
    return image;
}

@end
