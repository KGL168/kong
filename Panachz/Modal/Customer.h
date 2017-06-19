//
//  Customer.h
//  Panachz
//
//  Created by Peter Choi on 29/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (nonatomic) NSUInteger customerId;
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

@property (nonatomic, strong) NSString *outseam;
@property (nonatomic, strong) NSString *inseam;
@property (nonatomic, strong) NSString *waist;
@property (nonatomic, strong) NSString *hips;
@property (nonatomic, strong) NSString *thigh;
@property (nonatomic, strong) NSString *curve;

@property (nonatomic, strong, readonly, getter=getAddress) NSString *address;
@property (nonatomic, strong) NSMutableArray *orders;

- (instancetype)init;
- (instancetype)initWithCustomerId:(NSUInteger)cId email:(NSString *)e title:(NSString *)t name:(NSString *)n street:(NSString *)str city:(NSString *)cit state:(NSString *)sta country:(NSString *)coun zipCode:(NSString *)zc telNo:(NSString *)tn notes:(NSString *)note;

@end
