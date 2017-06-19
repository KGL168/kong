//
//  AppDelegate.m
//  Panachz
//
//  Created by YinYin Chiu on 6/7/15.
//  Copyright (c) 2015 Palapple. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "PayPalMobile.h"
#import "SlideNavigationController.h"
#import "SlideNavigationContorllerAnimatorSlide.h"

#import "LDLauchMovieViewController.h"
#import "LDenimApi.h"

#define IPAD_WIDTH 1024.0
#define MENU_WIDTH 288.0

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置启动动画
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LDLauchMovieViewController *vc = [[LDLauchMovieViewController alloc] init];
    window.rootViewController = vc;
    self.window = window;
    [self.window makeKeyAndVisible];
    
    // Setup for paypal
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"ASq2X9AkigpLXvIUGCI8_Q2jiGgT4R9yLofvLNRMcmYSSAtTm1NW_9wfdlBfgpdmJ6G72BM975MIPr2B",
                                                           PayPalEnvironmentSandbox : @"AaTz7EwN3GN2Nn-z4TIGE61-nrg9EWHeDvGDQARp-9m0YgZYlraI4XyY-vOhZ4F3sMHP9S266kD11c3S"}];
    
    
    return YES;
}

- (void)resetRootViewController{
    // Setup for the navigation menu
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SlideNavigationController *rootNav = [mainStoryboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
    self.window.rootViewController = rootNav;
    
    [SlideNavigationController sharedInstance].landscapeSlideOffset = IPAD_WIDTH - MENU_WIDTH;
    [SlideNavigationController sharedInstance].menuRevealAnimator = [[SlideNavigationContorllerAnimatorSlide alloc] initWithSlideMovement:MENU_WIDTH];
    [SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    
    LeftMenuViewController *lmvc = (LeftMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    [SlideNavigationController sharedInstance].leftMenu = lmvc;
    [self.window makeKeyWindow];
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self fetchLDenimIsNeedUpdate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 检测版本是否需要更新
- (void)fetchLDenimIsNeedUpdate{
    
    
    NSString *urlSuffix = nil;
    urlSuffix = @"appsetting/appversion";
    
    @weakify(self)
    [[LDenimApi getInstance] GET:urlSuffix
                      parameters:@{}
                         success:^(NSURLSessionDataTask *task, id responseObject) {
                             @strongify(self)
                             NSDictionary *response = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                             NSDictionary *appversion = [responseObject objectForKey:@"appversion"][0][0];
                             if ([[response objectForKey:@"code"] intValue] == 200) {
                                 //每次登录的时候，检查下版本，如果当前版本低于最低版本的话。强制更新
                                 if ([self version:appversion[@"minversion"] isGreaterThan:appversion[@"currentversion"]]) {
                                     //版本低于最低版本。强制更新
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Update" message:@"LDenim must be updated" preferredStyle:UIAlertControllerStyleAlert];
                                     
                                     
                                     
                                     [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ldenim.com/app"]];
                                         
                                     }]];
                                     
                                     [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                                     
                                 }else{
                                     //正常运行
                                     
                                 }
                                 
                             }else{
                                 LDLog(@"%@",response[@"message"]);
                             }
                         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                             
                         }];
    
}

- (BOOL)version:(NSString *)version1 isGreaterThan:(NSString *)version2
{
    
    NSArray *versions1 = [version1 componentsSeparatedByString:@"."];
    NSArray *versions2 = [version2 componentsSeparatedByString:@"."];
    
    for (int i = 0; i< (versions1.count> versions2.count)?versions1.count :versions2.count; i++) {
        
        if (versions1.count < i+1) return NO;
        if (versions2.count < i+1) return YES;
        
        int v1 = [versions1[i] intValue];
        int v2 = [versions2[i] intValue];
        if (v1 != v2)
            return v1 > v2;
    }
    return NO;
}

@end
