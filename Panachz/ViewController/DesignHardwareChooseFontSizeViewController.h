//
//  DesignHardwareChooseFontSizeViewController.h
//  Panachz
//
//  Created by Peter Choi on 28/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectFontSizeDelegate <NSObject>

- (void)didSelectedFontSize:(NSUInteger)fontSize;

@end

@interface DesignHardwareChooseFontSizeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *customNavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *fontSizeTabel;
@property (strong, nonatomic) id <SelectFontSizeDelegate> selectFontSizeDelegate;

- (IBAction)doneChooseFontSize:(id)sender;
- (IBAction)cancelChooseFontSize:(id)sender;

@end
