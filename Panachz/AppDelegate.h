//
//  AppDelegate.h
//  Panachz
//
//  Created by YinYin Chiu on 6/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)resetRootViewController;
- (void)fetchLDenimIsNeedUpdate;

@end

