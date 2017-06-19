//
//  DesignBackPatchChooseFontColorViewController.m
//  Panachz
//
//  Created by Peter Choi on 28/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "DesignBackPatchChooseFontColorViewController.h"
#import "FontColorTableViewCell.h"

@interface DesignBackPatchChooseFontColorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *selectedFontColor;
@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation DesignBackPatchChooseFontColorViewController

@synthesize selectedFontColor;
@synthesize colorArray;

@synthesize customNavigationBar;
@synthesize fontColorTable;
@synthesize chooseFontColorDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colorArray = @[@"Black", @"White", @"Red", @"Blue", @"Green", @"Yellow"];
    self.fontColorTable.delegate = self;
    self.fontColorTable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelChooseFontColor:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)doneChooseFontColor:(id)sender {
    [self.chooseFontColorDelegate didChooseFontColor:self.selectedFontColor];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UITableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FontColorTableViewCell *cell = (FontColorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FontColorTableViewCell"];
    [cell.colorLabel setText:[self.colorArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedFontColor = [self.colorArray objectAtIndex:indexPath.row];
}

@end
