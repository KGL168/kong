//
//  LDLanguageTool.h
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/7.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#define FGGetStringWithKeyFromTable(key) [[LDLanguageTool sharedInstance] getStringForKey:key withTable:@"LDLanguage"]

#import <Foundation/Foundation.h>

@interface LDLanguageTool : NSObject

+(id)sharedInstance;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
 *  改变当前语言
 */
-(void)changeNowLanguage;

/**
 *  改变到指定语言
 *  0 En
 *  1 Ch
 */
-(void)changeToLanguage:(NSInteger)languageNum;

/**
 *  获取当前语言代表数
 *  0 En
 *  1 Ch
 */
-(NSInteger)getNowLanguageNum;

/**
 *  设置新的语言
 *
 *  @param language 新语言
 */
-(void)setNewLanguage:(NSString*)language;
@end
