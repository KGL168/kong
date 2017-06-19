//
//  DesignBackPatchChooseFontColorViewController.h
//  Panachz
//
//  Created by Peter Choi on 28/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFontColorDelegate <NSObject>

- (void)didChooseFontColor:(NSString *)fontColor;

@end

@interface DesignBackPatchChooseFontColorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *customNavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *fontColorTable;
@property (strong, nonatomic) id <ChooseFontColorDelegate> chooseFontColorDelegate;

- (IBAction)cancelChooseFontColor:(id)sender;
- (IBAction)doneChooseFontColor:(id)sender;

@end
