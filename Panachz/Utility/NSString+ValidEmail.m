//
//  NSString+ValidEmail.m
//  Panachz
//
//  Created by YinYin Chiu on 7/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "NSString+ValidEmail.h"

@implementation NSString (ValidEmail)

- (BOOL)isAValidEmail {
    if([self length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self
                                                     options:0
                                                       range:NSMakeRange(0, [self length])];
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
