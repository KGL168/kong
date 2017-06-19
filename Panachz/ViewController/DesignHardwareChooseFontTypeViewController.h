//
//  DesignHardwareChooseFontTypeViewController.h
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FontTypeSelectedDelegate <NSObject>

- (void)didSelectFontType:(NSString *)fontName;

@end

@interface DesignHardwareChooseFontTypeViewController : UIViewController

@property (strong, nonatomic) id <FontTypeSelectedDelegate> fontTyleSelectedDelegate;
@property (strong, nonatomic) IBOutlet UIView *customNavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *fontTable;

- (IBAction)doneChooseFont:(id)sender;
- (IBAction)cancelChooseFont:(id)sender;

@end