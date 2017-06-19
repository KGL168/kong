//
//  User.h
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSUInteger userId;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *telNo;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic) BOOL isVip;

- (instancetype)init;
- (instancetype)initWithUserID:(NSUInteger)uId email:(NSString *)e title:(NSString *)t name:(NSString *)n street:(NSString *)str city:(NSString *)cit state:(NSString *)sta country:(NSString *)coun zipCode:(NSString *)zc telNo:(NSString *)tel notes:(NSString *)note;

@end
