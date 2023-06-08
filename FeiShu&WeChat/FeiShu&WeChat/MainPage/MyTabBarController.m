//
//  MyTabBarController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/30.
//

#import "MyTabBarController.h"
#import "ContactsViewController.h"
#import "StudentDataManager.h"
@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [StudentDataManager getExternalContactsAndStore];
    self.tabBar.backgroundColor = [UIColor systemGray6Color];
    ContactsViewController *cvc = [[ContactsViewController alloc] init];
    cvc.tabBarItem.title = @"通讯录";
    cvc.tabBarItem.image = [[UIImage imageNamed:@"通讯录"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:cvc];
    // Do any additional setup after loading the view.
}



@end
