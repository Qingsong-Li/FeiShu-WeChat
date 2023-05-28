//
//  AppDelegate.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/24.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import <Security/Security.h>


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//此段代码仅需运行一次将密码保存在项目中即可;
//    [KeyChainManager savePassword:@"123456" AndAccount:@"redrock"];
//    NSString *rightPassword = [KeyChainManager getPasswordWithAccount:@"redrock"];
//    NSLog(@"%@",rightPassword);
    
    NSString *a = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",a);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = nil;
    if([self getStatus] == NO){
        nav = [[UINavigationController alloc] initWithRootViewController:[[RegisterViewController alloc] init]];
        
    }else if([self getStatus] == YES){
        nav = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    }
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

//获取当前的登录状态
- (BOOL)getStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL status =  [defaults boolForKey:@"loggingStatus"];
    return status;
}

@end
