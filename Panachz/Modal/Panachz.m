//
//  Panachz.m
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "Panachz.h"

static Panachz* instance;

@implementation Panachz

@synthesize user;

+ (Panachz *)getInstance {
    if (instance == nil) {
        instance = [[Panachz alloc] init];
    }
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.user = nil;
    }
    
    return self;
}

- (BOOL)userIsLoggedIn {
    return self.user != nil;
}

@end
