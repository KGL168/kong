//
//  DesignHardwareChooseFontTypeViewController.m
//  Panachz
//
//  Created by Peter Choi on 27/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignHardwareChooseFontTypeViewController.h"
#import "FontTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexColor.h"

@interface DesignHardwareChooseFontTypeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *fontArrays;
@property (nonatomic, strong) NSString *selectedFont;
@end

@implementation DesignHardwareChooseFontTypeViewController

@synthesize customNavigationBar;
@synthesize fontArrays;
@synthesize fontTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup fake navigation bar
    self.customNavigationBar.layer.borderWidth = 1.0f;
    self.customNavigationBar.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup font data
    self.fontArrays = @[@"Verdana",
                        @"STHeiti TC",
                        @"Arial",
                        @"Courier New",
                        @"Helvetica",
                        @"Helvetica-Light",
                        @"Times New Roman",
                        @"Zapfino"
                        ];
    self.fontTable.delegate = self;
    self.fontTable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source and Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fontArrays.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FontTableViewCell *cell = (FontTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.selectedFont = cell.fontLabel.text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FontTableViewCell"];
    
    UIFont *font = [UIFont fontWithName:[self.fontArrays objectAtIndex:indexPath.row]
                                   size:14.0f];
    [cell.fontLabel setText:[self.fontArrays objectAtIndex:indexPath.row]];
    [cell.fontLabel setFont:font];
    
    return cell;
}

- (IBAction)doneChooseFont:(id)sender {
    [self.fontTyleSelectedDelegate didSelectFontType:self.selectedFont];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)cancelChooseFont:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
