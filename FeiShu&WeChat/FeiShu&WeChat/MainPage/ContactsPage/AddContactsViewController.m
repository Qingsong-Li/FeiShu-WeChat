//
//  AddContactsViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/8.
//

#import "Masonry.h"
#import "AddContactsViewController.h"

@interface AddContactsViewController ()

@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self setMasonry];
}

- (void) setMasonry{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).mas_offset(20);
        make.centerY.mas_equalTo(self.topView.title).mas_offset(0);
        make.size.mas_offset(15);
    }];
}

- (UIButton *)backBtn{
    if(_backBtn == nil){
        _backBtn = [[UIButton alloc] init];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (TopView *)topView{
    if(_topView == nil){
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 393, 100)];
        _topView.title.text = @"添加联系人";
        [_topView addSubview:self.backBtn];
    }
    return _topView;
}

- (void)backToLastViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
