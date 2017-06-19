//
//  NSString+SHA256.m
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "NSString+SHA256.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SHA256)

- (NSString *)sha256 {
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s
                                     length:strlen(s)];
    
    uint8_t digest[32] = {0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:32];
    
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" "
                                           withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<"
                                           withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">"
                                           withString:@""];
    return hash;
}

@end
