//
//  LDLanguageTool.m
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/7.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#define CNS @"zh-Hans"
#define EN @"en"
#define LANGUAGE_SET @"langeuageset"

#import "AppDelegate.h"
#import "LDLanguageTool.h"


static LDLanguageTool *sharedModel;

@interface LDLanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;

@end

@implementation LDLanguageTool
+(id)sharedInstance
{
    if (!sharedModel)
    {
        sharedModel = [[LDLanguageTool alloc]init];
    }
    
    return sharedModel;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}

-(void)initLanguage
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:LANGUAGE_SET];
    NSString *path;
    //默认是英文
    if (!tmp)
    {
        tmp = EN;
    }
    
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, table, @"");
}

-(void)changeToLanguage:(NSInteger)languageNum{
    //0-EN
    if (languageNum == 0) {
        [self setNewLanguage:EN];
    }else{
        [self setNewLanguage:CNS];
    }
}

-(NSInteger)getNowLanguageNum{
    if ([self.language isEqualToString:EN])
    {
        return 0;
    }
    else
    {
        return 1;
    }

}

-(void)changeNowLanguage
{
    if ([self.language isEqualToString:EN])
    {
        [self setNewLanguage:CNS];
    }
    else
    {
        [self setNewLanguage:EN];
    }
}

-(void)setNewLanguage:(NSString *)language
{
    if ([language isEqualToString:self.language])
    {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CNS])
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetRootViewController];
}

//重新设置
-(void)resetRootViewController
{
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate resetRootViewController];
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *rootNav = [storyBoard instantiateViewControllerWithIdentifier:@"rootnav"];
//    UINavigationController *personNav = [storyBoard instantiateViewControllerWithIdentifier:@"personnav"];
//    UITabBarController *tabVC = (UITabBarController*)appDelegate.window.rootViewController;
//    tabVC.viewControllers = @[rootNav,personNav];
}
@end
