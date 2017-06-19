//
//  NSDictionary+Json2Dict.h
//  jialin
//
//  Created by sanlimikaifa on 16/1/12.
//  Copyright © 2016年 sanlimi  . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Json2Dict)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
