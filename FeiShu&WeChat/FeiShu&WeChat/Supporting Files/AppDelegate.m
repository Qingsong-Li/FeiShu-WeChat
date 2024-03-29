//
//  AppDelegate.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/24.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MyTabBarController.h"
#import <Security/Security.h>
#import "KeyChainManager.h"


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//此段代码仅需运行一次将密码保存在项目中即可;
    [KeyChainManager savePassword:@"123456" AndAccount:@"redrock"];
    NSString *rightPassword = [KeyChainManager getPasswordWithAccount:@"redrock"];
    NSLog(@"%@",rightPassword);
    
    NSString *s = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",s);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = nil;
    if([self getStatus] == NO){
        nav = [[UINavigationController alloc] initWithRootViewController:[[RegisterViewController alloc] init]];
    }else if([self getStatus] == YES){
        nav = [[UINavigationController alloc] initWithRootViewController:[[MyTabBarController alloc] init]];
    }
    [nav setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

//获取当前的登录状态
- (BOOL)getStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL status =  [defaults boolForKey:@"loggingStatus"];
    return status;
}

@end
