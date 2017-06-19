//
//  DesignHardwareChooseFontSizeViewController.m
//  Panachz
//
//  Created by Peter Choi on 28/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignHardwareChooseFontSizeViewController.h"
#import "FontSizeTableViewCell.h"
#import "UIColor+HexColor.h"

@interface DesignHardwareChooseFontSizeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSUInteger selectedFontSize;
@end

@implementation DesignHardwareChooseFontSizeViewController

@synthesize customNavigationBar;
@synthesize selectFontSizeDelegate;
@synthesize fontSizeTabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customNavigationBar.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    self.customNavigationBar.layer.borderWidth = 1.0;
    
    self.fontSizeTabel.delegate = self;
    self.fontSizeTabel.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneChooseFontSize:(id)sender {
    [self.selectFontSizeDelegate didSelectedFontSize:self.selectedFontSize];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)cancelChooseFontSize:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UITableView DataSource and Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FontSizeTableViewCell *cell = (FontSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FontSizeTableViewCell"];
    [cell.fontSizeLabel setText:[NSString stringWithFormat:@"%lu", indexPath.row + 40]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedFontSize = indexPath.row + 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 41;
}

@end
