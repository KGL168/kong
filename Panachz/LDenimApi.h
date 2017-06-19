//
//  LDenimApi.h
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/16.
//  Copyright © 2017年 Palapple. All rights reserved.
//

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#ifdef DEBUG // 处于开发阶段
#define LDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else // 处于发布阶段
#define LDLog(...)
#endif

#import "AFHTTPSessionManager.h"

@interface LDenimApi : AFHTTPSessionManager

+ (LDenimApi *)getInstance;

@end
