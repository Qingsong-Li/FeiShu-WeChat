//
//  MyTabBarController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/30.
//

#import "MyTabBarController.h"
#import "ContactsViewController.h"
#import "StudentDataManager.h"
#import "ChatViewController.h"
#import "DiscoverViewController.h"
@interface MyTabBarController ()

//自定义的文本
@property (copy,nonatomic) NSDictionary *titleAttributes;

//聊天界面
@property(strong,nonatomic) ChatViewController *chatController;

//联系人界面
@property(strong,nonatomic) ContactsViewController *contactController;

//朋友圈界面
@property(strong,nonatomic) DiscoverViewController *discoverController;

@end


@implementation MyTabBarController

 
- (void)viewDidLoad {
    [super viewDidLoad];
    [StudentDataManager getExternalContactsAndStoreInLocal];//把外部联系人存放到本地   
    self.tabBar.backgroundColor = [UIColor systemGray6Color];
    [[UITabBarItem appearance] setTitleTextAttributes:self.titleAttributes forState:UIControlStateNormal];
    [self addChildViewController:self.chatController];
    [self addChildViewController:self.contactController];
    
    [self addChildViewController:[self discoverNavi]];

    // Do any additional setup after loading the view.
}

- (NSDictionary *)titleAttributes{
    if(_titleAttributes == nil){
        _titleAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:12],
        };
    }
    return _titleAttributes;
}

- (ContactsViewController *)contactController{
    if(_contactController == nil){
        _contactController = [[ContactsViewController alloc] init];
        _contactController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录" image:[UIImage imageNamed:@"通讯录"] selectedImage:[[UIImage imageNamed:@"通讯录"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _contactController.tabBarItem.imageInsets = UIEdgeInsetsMake(-2,-2,-15, -2);
        _contactController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 10);
    }
    return _contactController;
}


- (ChatViewController *)chatController{
    if(_chatController == nil){
        _chatController = [[ChatViewController alloc] init];
        _chatController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"聊天"] selectedImage:[[UIImage imageNamed:@"聊天"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _chatController.tabBarItem.imageInsets = UIEdgeInsetsMake(0,0,-15, 0);
        _chatController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 10);
    }
    return _chatController;
}

- (DiscoverViewController *)discoverController{
    if(_discoverController == nil){
        _discoverController = [[DiscoverViewController alloc] init];
        _discoverController.title = @"发现";
        _discoverController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"发现"] selectedImage:[[UIImage imageNamed:@"发现"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _discoverController.tabBarItem.imageInsets = UIEdgeInsetsMake(0,0,-15, 0);
        _discoverController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 10);
    }
    return _discoverController;
}

- (UINavigationController *) discoverNavi {
    UINavigationController *discoverNavi = [[UINavigationController alloc] initWithRootViewController:self.discoverController];
    discoverNavi.navigationBarHidden = NO;
    discoverNavi.navigationBar.translucent = YES;
    return discoverNavi;
}
@end
