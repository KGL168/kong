//
//  DesignViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignViewController.h"
#import "Jeans.h"

@interface DesignViewController ()
@property (nonatomic, strong) Jeans *j;
@end

@implementation DesignViewController

@synthesize j;
@synthesize bigMenImageView;
@synthesize bigFemaleImageView;
@synthesize jeanDesignContainView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup tap gesture on men and women image
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(chooseMen)];
    [tap setNumberOfTapsRequired:1];
    [bigMenImageView setUserInteractionEnabled:YES];
    [bigMenImageView addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(chooseWomen)];
    [tap setNumberOfTapsRequired:1];
    [bigFemaleImageView setUserInteractionEnabled:YES];
    [bigFemaleImageView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.bigMenImageView.image = nil;
    self.bigFemaleImageView.image = nil;
}

#pragma mark - Choose men or women

- (void)chooseMen {
    self.j =[[Jeans alloc] initWithGender:JEANS_GENDER_M];
    NSDictionary *userInfo = @{@"Gender" : @"M",
                               @"Jeans" :  self.j};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectGender"
                                                        object:self
                                                      userInfo:userInfo];
    self.bigMenImageView.hidden = YES;
    self.bigMenImageView.image = nil;
    self.bigFemaleImageView.hidden = YES;
    self.bigFemaleImageView.image = nil;
    self.jeanDesignContainView.hidden = NO;
}

- (void)chooseWomen {
    self.j =[[Jeans alloc] initWithGender:JEANS_GENDER_F];
    NSDictionary *userInfo = @{@"Gender" : @"F",
                               @"Jeans" :  self.j};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectGender"
                                                        object:self
                                                      userInfo:userInfo];
    self.bigMenImageView.hidden = YES;
    self.bigMenImageView.image = nil;
    self.bigFemaleImageView.hidden = YES;
    self.bigFemaleImageView.image = nil;
    self.jeanDesignContainView.hidden = NO;
}

@end
