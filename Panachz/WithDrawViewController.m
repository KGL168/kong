//
//  WithDrawViewController.m
//  Panachz
//
//

#import "WithDrawViewController.h"
#import "SlideNavigationController.h"
#import "PanachzApi.h"
#import "Panachz.h"

@interface WithDrawViewController () <SlideNavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WithDrawViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[PanachzApi getInstance] GET: @"/applycommission/requesthistory"
                       parameters: @{@"user_id" : [NSString stringWithFormat: @"%lu", [Panachz getInstance].user.userId]}
                          success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                              NSLog(@"success");
                          }
                          failure: ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                              NSLog(@"failure");
                          }];
}

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
