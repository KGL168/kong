//
//  User.m
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId;
@synthesize role;
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

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithUserID:(NSUInteger)uId email:(NSString *)e title:(NSString *)t name:(NSString *)n street:(NSString *)str city:(NSString *)cit state:(NSString *)sta country:(NSString *)coun zipCode:(NSString *)zc telNo:(NSString *)tel notes:(NSString *)note {
    self = [super init];
    
    if (self) {
        self.userId = uId;
        self.email = e;
        self.title = t;
        self.name = n;
        self.street = str;
        self.city = cit;
        self.state = sta;
        self.country = coun;
        self.zipCode = zc;
        self.telNo = tel;
        self.notes = note;
    }
    
    return self;
}

@end
