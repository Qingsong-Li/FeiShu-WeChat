//
//  AppDelegate.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/24.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RegisterViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RegisterViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}


@end
