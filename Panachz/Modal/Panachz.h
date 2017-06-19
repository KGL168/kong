//
//  Panachz.h
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Panachz : NSObject

@property (nonatomic, strong) User *user;

+ (Panachz *)getInstance;
- (BOOL)userIsLoggedIn;

@end
