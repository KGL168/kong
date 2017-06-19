//
//  TutorialViewController.h
//  Panachz
//
//  Created by YinYin Chiu on 9/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

@protocol WhatIsPanachzViewDelegate <NSObject>

- (void)didChangeToTutorialOfIndex:(NSUInteger) index;

@end

@interface WhatIsPanachzViewController : ViewPagerController

@property (nonatomic, strong) id <WhatIsPanachzViewDelegate> tutorialDelegate;

@end
