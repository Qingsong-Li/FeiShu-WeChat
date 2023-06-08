//
//  ContactsViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/4.
//

#import "ContactsViewController.h"
#import "AddContactsViewController.h"
#import "TopView.h"
#import "Masonry.h"

@interface ContactsViewController ()

@property(nonatomic,strong) TopView *topView;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIButton *addContactsBtn;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.table];
   
}

- (void)viewDidAppear:(BOOL)animated{
    //这里之所以在viewDidAppear中设置Masonry而不是在ViewDidLoad中设置是因为TabBar的高度在ViewDidLoad时还未完成布局，导致这时获取的高度不是最终显示的高度，而在viewDidAppear中试图布局已完成，这时获取的高度才是正确的
    [self setMasonry];
}

- (void)setMasonry{

    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(0);
        make.width.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(self.view.mas_height).mas_offset(-(self.tabBarController.tabBar.frame.size.height+100));
    }];
    
    [self.addContactsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView).mas_offset(-25);
        make.centerY.mas_equalTo(self.topView.title).mas_offset(0);
        make.size.mas_offset(28);
    }];
}

- (TopView *)topView{
    if(_topView == nil){
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 393, 100)];
        [_topView addSubview:self.addContactsBtn];
        _topView.title.text = @"通讯录";
    }
    return _topView;
}

- (UITableView *)table{
    if(_table == nil){
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.backgroundColor = [UIColor redColor];
    }
    return _table;
}

- (UIButton *)addContactsBtn{
    if(_addContactsBtn == nil){
        _addContactsBtn = [[UIButton alloc] init];
        [_addContactsBtn setBackgroundImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
        [_addContactsBtn addTarget:self action:@selector(moveToAddContactSViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addContactsBtn;
}

- (void)moveToAddContactSViewController {
    AddContactsViewController *avc = [[AddContactsViewController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
}


@end
