//
//  LeftMenuViewController.m
//  Panachz
//
//  Created by YinYin Chiu on 6/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "LeftMenuUserTableViewCell.h"
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"

#import "UserAccountViewController.h"
#import "WhatIsPanachzSreenViewController.h"
#import "Panachz.h"


@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *adminMenuItems;

@end

@implementation LeftMenuViewController

@synthesize closeMenuIcon;
@synthesize menuItems;
@synthesize menuTable;
@synthesize adminMenuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup menu table view
    self.menuTable.dataSource = self;
    self.menuTable.delegate = self;
    
    // Setup close menu icon
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeMenu)];
    [tap setNumberOfTapsRequired:1];
    [self.closeMenuIcon setUserInteractionEnabled:YES];
    [self.closeMenuIcon addGestureRecognizer:tap];
    
    // Setup menu items
    self.menuItems = @[@[@"User Account",
                         @"About L-Denim"],
                       @[@"Stanley LAM"]];
    
    self.adminMenuItems = @[@[@"User Account",
                              @"About L-Denim"],
                            @[@"Stanley LAM"]];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin)
                                                 name:@"UserLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidUpdate)
                                                 name:@"UserUpdated"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification

- (void)userDidLogin {
    [self.menuTable reloadData];
}

- (void)userDidUpdate {
    [self.menuTable reloadData];
}

#pragma mark - Menu table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[Panachz getInstance] userIsLoggedIn] && [[Panachz getInstance].user.role isEqualToString:@"Admin"]) {
        return [self.adminMenuItems count];
    }
    return [self.menuItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[Panachz getInstance] userIsLoggedIn] && ([[Panachz getInstance].user.role isEqualToString:@"Admin"] || [[Panachz getInstance].user.role isEqualToString:@"Recruitment Manager"])) {
        return [[self.adminMenuItems objectAtIndex:section] count];
    }
    return [[self.menuItems objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 288, 1)];
    [separator setBackgroundColor:[UIColor colorWithRBGValue:0xcccccc]];
    return separator;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuTableViewCell"];
        
        if ([[Panachz getInstance] userIsLoggedIn] && ([[Panachz getInstance].user.role isEqualToString:@"Admin"] || [[Panachz getInstance].user.role isEqualToString:@"Recruitment Manager"])) {
            [cell.menuLabel setText:[[self.adminMenuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        } else {
            [cell.menuLabel setText:[[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        }
        
        
        return cell;
    } else {
        LeftMenuUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuUserTableViewCell"];
        
        if ([[Panachz getInstance] userIsLoggedIn]) {
            [cell.menuLabel setText:[Panachz getInstance].user.name];
        } else {
            [cell.menuLabel setText:[[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if ([[Panachz getInstance] userIsLoggedIn] && ([[Panachz getInstance].user.role isEqualToString:@"Admin"] || [[Panachz getInstance].user.role isEqualToString:@"Recruitment Manager"])) {
            if (indexPath.row == 0) {
                UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UserAccountViewController *vc = (UserAccountViewController *)[storyborad instantiateViewControllerWithIdentifier:@"UserAccountViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
            } else if (indexPath.row == 1) {
                UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WhatIsPanachzSreenViewController *vc = (WhatIsPanachzSreenViewController *)[storyborad instantiateViewControllerWithIdentifier:@"WhatIsPanachzSreenViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
            }
        } else {
            if (indexPath.row == 0) {
                UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UserAccountViewController *vc = (UserAccountViewController *)[storyborad instantiateViewControllerWithIdentifier:@"UserAccountViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
            } else if (indexPath.row == 1) {
                UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WhatIsPanachzSreenViewController *vc = (WhatIsPanachzSreenViewController *)[storyborad instantiateViewControllerWithIdentifier:@"WhatIsPanachzSreenViewController"];
                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                         withSlideOutAnimation:NO
                                                                                 andCompletion:nil];
            }
        }
    } else if (indexPath.section == 1) {
        [Panachz getInstance].user = nil;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"UserEmail"];
        [userDefaults removeObjectForKey:@"UserPassword"];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
        [[SlideNavigationController sharedInstance] setNavigationBarHidden:YES
                                                                  animated:NO];
    }
}

#pragma mark - Tap Gesture action

- (void)closeMenu {
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
}

@end
