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
    [self.view addSubview:self.searchField];
    [self.view addSubview:self.addBtn];
    [self setMasonry];
}

- (void) setMasonry{
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(0);
        make.centerY.mas_equalTo(self.view).mas_offset(-200);
        make.width.mas_offset(350);
        make.height.mas_offset(40);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(0);
        make.centerY.mas_equalTo(self.searchField).mas_offset(150);
        make.width.mas_offset(100);
        make.height.mas_offset(40);
    }];
}



- (TopView *)topView{
    if(_topView == nil){
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 393, 115)];
        _topView.title.text = @"添加联系人";
        [_topView showTheBackBtn];
        [_topView.backBtn addTarget:self action:@selector(backToLastViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (UITextField *)searchField{
    if(_searchField == nil){
        _searchField = [[UITextField alloc] init];
        _searchField.backgroundColor = [UIColor systemGray6Color];
        _searchField.placeholder = @"请输入您想添加的联系人学号";
        _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    }
    return _searchField;
}

- (UIButton *)addBtn{
    if(_addBtn == nil){
        _addBtn = [[UIButton alloc] init];
        _addBtn.layer.cornerRadius = 12;
        [_addBtn setBackgroundColor:[UIColor systemBlueColor]];
        [_addBtn setTitle:@"点击添加" forState:UIControlStateNormal];
        [_addBtn setTintColor:[UIColor blackColor]];
        _addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    }
    return _addBtn;
}

- (void)backToLastViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
