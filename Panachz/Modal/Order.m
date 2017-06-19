//
//  Order.m
//  Panachz
//
//  Created by Peter Choi on 30/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "Order.h"

@implementation Order

@synthesize orderId;
@synthesize orderStatus;
@synthesize jeansPreviewUrl;
@synthesize jeansFrontPreviewUrl;
@synthesize jeansBackPreviewUrl;
@synthesize jeansDescription;
@synthesize waist;
@synthesize hips;
@synthesize thigh;
@synthesize inseam;
@synthesize outseam;
@synthesize curve;
@synthesize quantity;
@synthesize unitPrice;
@synthesize totalPrice;
@synthesize contactPerson;
@synthesize contactEmail;
@synthesize contactTelNo;
@synthesize shipAddress;
@synthesize trackingNo;
@synthesize createdDate;
@synthesize mailOutDate;
@synthesize notes;

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithOrderId:(NSUInteger)oId status:(NSString *)sta quantity:(NSUInteger)qty createdDate:(NSString *)cd unitPrice:(NSUInteger)up {
    return [self initWithOrderId:oId
                          status:sta
                 jeansPreviewUrl:nil
            jeansFrontPreviewUrl:nil
             jeansBackPreivewUrl:nil
                jeansDescription:nil
                           waist:nil
                            hips:nil
                           thigh:nil
                          inseam:nil
                         outseam:nil
                           curve:nil
                        quantity:qty
                       unitPrice:up
                   contactPerson:nil
                    contactEmail:nil
                    contactTelNo:nil
                          street:nil
                            city:nil
                           state:nil
                         country:nil
                         zipCode:nil
                      trackingNo:0
                     createdDate:cd
                     mailOutDate:nil
                           notes:nil];
}

- (instancetype)initWithOrderId:(NSUInteger)oId status:(NSString *)sta jeansPreviewUrl:(NSString *)url jeansFrontPreviewUrl:(NSString *)jfp jeansBackPreivewUrl:(NSString *)jbp jeansDescription:(NSString *)jd waist:(NSString *)w hips:(NSString *)h thigh:(NSString *)t inseam:(NSString *)i outseam:(NSString *)o curve:(NSString *)cur quantity:(NSUInteger)qty unitPrice:(NSUInteger)up contactPerson:(NSString *)cp contactEmail:(NSString *)ce contactTelNo:(NSString *)ctn street:(NSString *)str city:(NSString *)cit state:(NSString *)stat country:(NSString *)coun zipCode:(NSString *)zc trackingNo:(NSUInteger)tn createdDate:(NSString *)cd mailOutDate:(NSString *)mod notes:(NSString *)ns {
    self = [super init];
    
    if (self) {
        self.orderId = oId;
        self.orderStatus = sta;
        self.jeansPreviewUrl = url;
        self.jeansFrontPreviewUrl = jfp;
        self.jeansBackPreviewUrl = jbp;
        self.jeansDescription = jd;
        self.waist = w;
        self.hips = h;
        self.thigh = t;
        self.inseam = i;
        self.outseam = o;
        self.curve = cur;
        self.quantity = qty;
        self.unitPrice = up;
        self.contactPerson = cp;
        self.contactEmail = ce;
        self.contactTelNo = ctn;
        self.trackingNo = tn;
        self.createdDate = cd;
        self.mailOutDate = mod;
        self.notes = ns;
        self.totalPrice = qty * up;
        self.shipAddress = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", str, cit, stat, coun, zc];
    }
    
    return self;
}

@end
