//
//  ApproveUsersViewController.m
//  Panachz
//
//  Created by Peter Choi on 17/8/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "ApproveUsersViewController.h"
#import "ApproveUsersTableViewCell.h"
#import "ApproveUserViewController.h"
#import "MBProgressHUD.h"
#import "Order.h"
#import "Panachz.h"
#import "PanachzApi.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "UIButton+Identifier.h"
#import "UIColor+HexColor.h"
#import "User.h"

@interface ApproveUsersViewController () <UITableViewDataSource, UITableViewDelegate, ApproveUserDelegate>
@property (nonatomic, strong) NSMutableArray *notApprovedUsers;
@end

@implementation ApproveUsersViewController

@synthesize notApprovedUserTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup Navigation bar
    NSString *titleText = @"Approve Users";
    UIFont* titleFont = [UIFont fontWithName:@"Roboto-Regular" size:16];
    CGSize titleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, 20)];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = titleText;
    self.navigationItem.titleView = title;
    
    // Setup Left navigation bar item
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 24, 24)];
    [menuImage setImage:[UIImage imageNamed:@"ic_keyboard_arrow_left_black_48dp"]];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addSubview:menuImage];
    menuButton.frame = CGRectMake(0, 0, 24, 24);
    [menuButton addTarget:self
                   action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navigationBarMenuButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = navigationBarMenuButton;
    
    // Tableview Setup
    self.notApprovedUserTableView.delegate = self;
    self.notApprovedUserTableView.dataSource = self;
    self.notApprovedUsers = [[NSMutableArray alloc] init];
    [self getNotApprovedUser];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Bar Button

- (void)back:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToApproveUser"]) {
        UIButton *button = (UIButton *)sender;
        ApproveUserViewController *vc = (ApproveUserViewController *)segue.destinationViewController;
        vc.user_id = button.identifier;
        vc.approveUserDelegate = self;
    }
}

- (void)didApproveUser {
    self.notApprovedUsers = [[NSMutableArray alloc] init];
    [self.notApprovedUserTableView reloadData];
    [self getNotApprovedUser];
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"User Approved"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - User Data

- (void)getNotApprovedUser {
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    __weak typeof (self) weakSelf = self;
    [[PanachzApi getInstance] GET:@"user/unapproved"
                       parameters:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                              
                              if ([[response objectForKey:@"code"] intValue] == 200) {
                                  NSArray *usersArray = [responseObject objectForKey:@"users"];
                                  
                                  for (int i = 0; i < usersArray.count; i++) {
                                      NSDictionary *userJson = [usersArray objectAtIndex:i];
                                      User *user = [[User alloc] init];
                                      user.userId = [[userJson objectForKey:@"user_id"] intValue];
                                      user.name = [userJson objectForKey:@"name"];
                                      user.email = [userJson objectForKey:@"email"];
                                      user.telNo = [userJson objectForKey:@"phone_no"];
                                      [weakSelf.notApprovedUsers addObject:user];
                                  }
                                  
                                  [weakSelf.notApprovedUserTableView reloadData];
                              }
                              
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
                          }
                          failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:[NSString stringWithFormat:@"%@", error]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] show];
                              
                              [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                       animated:YES];
                          }];
}

#pragma mark - Tableview Data Sourve and Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApproveUsersTableViewCell *cell = (ApproveUsersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ApproveUsersTableViewCell"];
    User *user = [self.notApprovedUsers objectAtIndex:indexPath.row];
    [cell.nameLabel setText:user.name];
    [cell.emailLabel setText:user.email];
    [cell.telephoneName setText:user.telNo];
    [cell.approveButton addTarget:self
                           action:@selector(openApproveUserModal:)
                 forControlEvents:UIControlEventTouchUpInside];
    cell.approveButton.identifier = [NSString stringWithFormat:@"%lu", user.userId];
    [cell.deleteButton addTarget:self
                          action:@selector(deleteUsers:)
                forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.identifier = [NSString stringWithFormat:@"%lu", user.userId];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notApprovedUsers.count;
}

#pragma mark - Approve User Action

- (IBAction)openApproveUserModal:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoToApproveUser"
                              sender:sender];
    NSLog(@"%@", sender.identifier);
}

- (IBAction)deleteUsers:(UIButton *)sender {
    NSLog(@"Delete User with user id: %@", sender.identifier);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Are you to delete this unapproved user?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *action) {
                                                    [MBProgressHUD showHUDAddedTo:weakSelf.view
                                                                         animated:YES];
                                                    [[PanachzApi getInstance] POST:@"user/unapprove"
                                                                        parameters:@{@"user_id" : sender.identifier}
                                                                           success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                               NSDictionary *response = [[responseObject objectForKey:@"response"] firstObject];
                                                                               
                                                                               if ([[response objectForKey:@"code"] intValue] == 202) {
                                                                                   [[[UIAlertView alloc] initWithTitle:@""
                                                                                                               message:@"Unapproved User Deleted"
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"OK"
                                                                                                     otherButtonTitles:nil] show];
                                                                                   [weakSelf.notApprovedUsers removeAllObjects];
                                                                                   [weakSelf getNotApprovedUser];
                                                                               } else {
                                                                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                               message:[response objectForKey:@"error"]
                                                                                                              delegate:nil
                                                                                                     cancelButtonTitle:@"OK"
                                                                                                     otherButtonTitles:nil] show];
                                                                               }
                                                                               
                                                                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                                                                        animated:YES];
                                                                           }
                                                                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                               [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                           message:[NSString stringWithFormat:@"%@", error]
                                                                                                          delegate:nil
                                                                                                 cancelButtonTitle:@"OK"
                                                                                                 otherButtonTitles:nil] show];
                                                                               
                                                                               [MBProgressHUD hideAllHUDsForView:weakSelf.view
                                                                                                        animated:YES];
                                                                           }];
                                                }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO"
                                                 style:UIAlertActionStyleCancel
                                               handler:nil];
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
