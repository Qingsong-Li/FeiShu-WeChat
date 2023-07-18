//
//  MeViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/8.
//

#import "MeViewController.h"
#import "TopView.h"


@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.changeHeadBtn];
    [self.view addSubview:self.logOutBtn];
}

#pragma mark - Lazy

- (UIButton *)changeHeadBtn {
    if (_changeHeadBtn == nil) {
        _changeHeadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        [_changeHeadBtn setTitle:@"更换头像" forState:UIControlStateNormal];
        [_changeHeadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _changeHeadBtn;
}

- (UIButton *)logOutBtn {
    if (_logOutBtn == nil) {
        _logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.changeHeadBtn.bounds.size.height, self.changeHeadBtn.bounds.size.width, self.changeHeadBtn.bounds.size.height)];
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _logOutBtn;
}

@end
