//
//  PanachzApi.m
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "PanachzApi.h"
#import "AFNetworking.h"

//static NSString * const kPanachzAPIBaseURLString = @"http://www.panachz.com/app/panachz/api/";
static NSString * const kPanachzAPIBaseURLString = @"http://www.ldenim.com/api/";

@implementation PanachzApi

+(PanachzApi *)getInstance {
    static PanachzApi *_apiInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiInstance = [[PanachzApi alloc] initWithBaseURL:[NSURL URLWithString:kPanachzAPIBaseURLString]];
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
