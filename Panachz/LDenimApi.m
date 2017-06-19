//
//  LDenimApi.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/16.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import "LDenimApi.h"
#import "AFNetworking.h"

static NSString * const kAPIBaseURLString = @"http://www.ldenim.com/api/";

@implementation LDenimApi

+(LDenimApi *)getInstance {
    static LDenimApi *_apiInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiInstance = [[LDenimApi alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    });
    return _apiInstance;
}

- initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

@end
