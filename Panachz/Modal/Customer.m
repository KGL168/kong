//
//  Customer.m
//  Panachz
//
//  Created by Peter Choi on 29/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "Customer.h"

@implementation Customer

@synthesize customerId;
@synthesize email;
@synthesize title;
@synthesize name;
@synthesize street;
@synthesize city;
@synthesize state;
@synthesize country;
@synthesize zipCode;
@synthesize telNo;
@synthesize notes;

@synthesize outseam;
@synthesize inseam;
@synthesize waist;
@synthesize hips;
@synthesize thigh;
@synthesize curve;

@synthesize address = _address;
@synthesize orders;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.orders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype)initWithCustomerId:(NSUInteger)cId email:(NSString *)e title:(NSString *)t name:(NSString *)n street:(NSString *)str city:(NSString *)cit state:(NSString *)sta country:(NSString *)coun zipCode:(NSString *)zc telNo:(NSString *)tn notes:(NSString *)note {
    self = [super init];
    
    if (self) {
        self.customerId = cId;
        self.email = e;
        self.title = t;
        self.name = n;
        self.street = str;
        self.city = cit;
        self.state = sta;
        self.country = coun;
        self.zipCode = zc;
        self.telNo = tn;
        self.notes = note;
        
        self.orders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSString *)getAddress {
    return [NSString stringWithFormat:@"%@, %@, %@, %@", self.street, self.city, self.state, self.country];
}

@end
