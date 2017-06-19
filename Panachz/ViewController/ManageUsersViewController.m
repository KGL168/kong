//
//  ManageUsersViewController.m
//  Panachz
//
//  Created by Peter Choi on 14/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ManageUsersViewController.h"
#import "MasterViewController.h"
#import "ManagerUersTableViewCell.h"
#import "ManagerUserDashboardViewController.h"
#import "MBProgressHUD.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import "SlideNavigationController.h"
#import "UIColor+HexColor.h"
#import "User.h"

@interface ManageUsersViewController () <SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *myTeamRms;
@property (nonatomic, strong) NSMutableArray *myTeamFms;
@property (nonatomic, strong) User *selectedUser;
@end

@implementation ManageUsersViewController

@synthesize myTeamRms;
@synthesize myTeamFms;

@synthesize designTabButton;
@synthesize customerTabButton;
@synthesize orderTabButton;
@synthesize usersTableView;
@synthesize approveNewUsersButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup navigation bar
    NSString *titleText = @"Manage Users";
    UIFont* titleFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleText;
    self.navigationItem.titleView = title;
    
    // Setup tab buttons
    self.designTabButton.layer.borderWidth = 1.0;
    self.designTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.customerTabButton.layer.borderWidth = 1.0;
    self.customerTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    self.orderTabButton.layer.borderWidth = 1.0;
    self.orderTabButton.layer.borderColor = [UIColor colorWithRBGValue:0xcccccc].CGColor;
    
    // Setup usersTable
    self.usersTableView.delegate = self;
    self.usersTableView.dataSource = self;
    
    self.myTeamRms = [[NSMutableArray alloc] init];
    self.myTeamFms = [[NSMutableArray alloc] init];
    //[self getTeamUsers];
    
    // Setup approve new users
    if (![[Panachz getInstance].user.role isEqualToString:@"Admin"]) {
        self.approveNewUsersButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.myTeamRms removeAllObjects];
    [self.myTeamFms removeAllObjects];
    [self getTeamUsers];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewUserDashboard"]) {
        ManagerUserDashboardViewController *vc = (ManagerUserDashboardViewController *)segue.destinationViewController;
        vc.user = self.selectedUser;
    }
}

#pragma mark - Slide Navigation Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}

#pragma mark - Tab Pressed

- (IBAction)tabButtonPressed:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MasterViewController *vc = (MasterViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    
    if (sender == self.designTabButton) {
        vc.tab = DESIGN_VIEW;
    } else if (sender == self.customerTabButton) {
        vc.tab = CUSTOMER_VIEW;
    } else if (sender == self.orderTabButton) {
        vc.tab = ORDER_VIEW;
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                    withCompletion:nil];
}

#pragma mark - Table View Delegate and Data source

- (void)getTeamUsers {
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:[NSString stringWithFormat:@"user/%lu/myTeam", [Panachz getInstance].user.userId]
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                              
                              if ([[response objectForKey:@"code"] intValue] == 200) {
                                  NSArray *rms = [responseObject objectForKey:@"rms"];
                                  
                                  for (int i = 0; i < rms.count; i++) {
                                      NSDictionary *rmJsonObject = [rms objectAtIndex:i];
                                      
                                      User *rm = [[User alloc] init];
                                      rm.userId = [[rmJsonObject objectForKey:@"user_id"] intValue];
                                      rm.name = [rmJsonObject objectForKey:@"name"];
                                      rm.telNo = [rmJsonObject objectForKey:@"phone_no"];
                                      rm.email = [rmJsonObject objectForKey:@"email"];
                                      rm.role = [rmJsonObject objectForKey:@"role"];
                                      rm.notes = [NSString stringWithFormat:@"%@", [rmJsonObject objectForKey:@"revenue"]];
                                      
                                      NSMutableArray *rmfms = [[NSMutableArray alloc] init];
                                      NSArray *fms = [rmJsonObject objectForKey:@"fms"];
                                      for (int j = 0; j < fms.count; j++) {
                                          NSDictionary *fmJsonObject = [fms objectAtIndex:j];
                                          
                                          User *fm = [[User alloc] init];
                                          fm.userId = [[fmJsonObject objectForKey:@"user_id"] intValue];
                                          fm.name = [fmJsonObject objectForKey:@"name"];
                                          fm.telNo = [fmJsonObject objectForKey:@"phone_no"];
                                          fm.email = [fmJsonObject objectForKey:@"email"];
                                          fm.role = [fmJsonObject objectForKey:@"role"];
                                          fm.notes = [NSString stringWithFormat:@"%@", [fmJsonObject objectForKey:@"revenue"]];
                                          
                                          [rmfms addObject:fm];
                                      }
                                      
                                      [weakSelf.myTeamRms addObject:rm];
                                      [weakSelf.myTeamFms addObject:rmfms];
                                  }
                              }
                              
                              [weakSelf.usersTableView reloadData];
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
                          }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagerUersTableViewCell *cell = (ManagerUersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ManagerUersTableViewCell"];
    
    User *fm = [[self.myTeamFms objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.nameLabel setText:fm.name];
    [cell.telephoneLabel setText:fm.telNo];
    [cell.emailLabel setText:fm.email];
    [cell.positionLabel setText:fm.role];
    [cell.revenueLabel setText:fm.notes];
    CGFloat comm = [fm.notes intValue] * 0.2;
    [cell.commissionLabel setText:[NSString stringWithFormat:@"%0.1f", comm]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 44)];
    [view setBackgroundColor:[UIColor colorWithRBGValue:0xf8f8f8]];
    
    User *rm = [self.myTeamRms objectAtIndex:section];
    
    // Name label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 256, 44)];
    [nameLabel setText:rm.name];
    [nameLabel setFont:[UIFont fontWithName:@"Roboto-Regular"
                                       size:12]];
    [view addSubview:nameLabel];
    
    // Telephone Label
    UILabel *teleLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 132, 44)];
    [teleLabel setText:rm.telNo];
    [teleLabel setFont:[UIFont fontWithName:@"Roboto-Regular"
                                       size:12]];
    [view addSubview:teleLabel];
    
    // Email Label
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(424, 0, 132, 44)];
    [emailLabel setText:rm.email];
    [emailLabel setFont:[UIFont fontWithName:@"Roboto-Regular"
                                        size:12]];
    [view addSubview:emailLabel];
    
    // Position Label
    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(568, 0, 132, 44)];
    [positionLabel setText:rm.role];
    [positionLabel setFont:[UIFont fontWithName:@"Roboto-Regular"
                                           size:12]];
    [view addSubview:positionLabel];
    
    // Revenue Label
    UILabel *revenueLabel = [[UILabel alloc] initWithFrame:CGRectMake(712, 0, 132, 44)];
    [revenueLabel setText:rm.notes];
    [revenueLabel setFont:[UIFont fontWithName:@"Roboto-Regular"
                                          size:12]];
    [view addSubview:revenueLabel];
    
    // Commission Label
    CGFloat comm = [rm.notes intValue] * 0.2 * 0.2;
    UILabel *commLabel = [[UILabel alloc] initWithFrame:CGRectMake(856, 0, 132, 44)];
    [commLabel setText:[NSString stringWithFormat:@"%0.1f", comm]];
    [commLabel setFont:[UIFont fontWithName:@"Roboto-Regular"
                                       size:12]];
    [view addSubview:commLabel];
    
    //UIButton
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1024, 44)];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = section;
    [button addTarget:self
               action:@selector(didSelectHeader:)
     forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

- (IBAction)didSelectHeader:(UIButton *)sender {
    self.selectedUser = [self.myTeamRms objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:@"ViewUserDashboard"
                              sender:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedUser = [[self.myTeamFms objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ViewUserDashboard"
                              sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.myTeamFms objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.myTeamRms count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}



@end
