//
//  Order.h
//  Panachz
//
//  Created by Peter Choi on 30/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic) NSUInteger orderId;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *jeansPreviewUrl;
@property (nonatomic, strong) NSString *jeansFrontPreviewUrl;
@property (nonatomic, strong) NSString *jeansBackPreviewUrl;
@property (nonatomic, strong) NSString *jeansDescription;
@property (nonatomic, strong) NSString *waist;
@property (nonatomic, strong) NSString *hips;
@property (nonatomic, strong) NSString *thigh;
@property (nonatomic, strong) NSString *inseam;
@property (nonatomic, strong) NSString *outseam;
@property (nonatomic, strong) NSString *curve;
@property (nonatomic) NSUInteger quantity;
@property (nonatomic) NSUInteger unitPrice;
@property (nonatomic) NSUInteger totalPrice;
@property (nonatomic, strong) NSString *contactPerson;
@property (nonatomic, strong) NSString *contactEmail;
@property (nonatomic, strong) NSString *contactTelNo;
@property (nonatomic, strong) NSString *shipAddress;
@property (nonatomic) NSUInteger trackingNo;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *mailOutDate;
@property (nonatomic, strong) NSString *notes;

- (instancetype)init;
- (instancetype)initWithOrderId:(NSUInteger) oId status:(NSString *)sta quantity:(NSUInteger)qty createdDate:(NSString *)cd unitPrice:(NSUInteger)up;
- (instancetype)initWithOrderId:(NSUInteger)oId status:(NSString *)sta jeansPreviewUrl:(NSString *)url jeansFrontPreviewUrl:(NSString *)jfp jeansBackPreivewUrl:(NSString *)jbp jeansDescription:(NSString *)jd waist:(NSString *)w hips:(NSString *)h thigh:(NSString *)t inseam:(NSString *)i outseam:(NSString *)o curve:(NSString *)cur quantity:(NSUInteger)qty unitPrice:(NSUInteger)up contactPerson:(NSString *)cp contactEmail:(NSString *)ce contactTelNo:(NSString *)ctn street:(NSString *)str city:(NSString *)cit state:(NSString *)stat country:(NSString *)coun zipCode:(NSString *)zc trackingNo:(NSUInteger)tn createdDate:(NSString *)cd mailOutDate:(NSString *)mod notes:(NSString *)ns;

@end
