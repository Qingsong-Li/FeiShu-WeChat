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
#import "ContactsModel.h"
#import "StudentDataManager.h"

@interface ContactsViewController ()

@property(nonatomic,strong) TopView *topView;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIButton *addContactsBtn;
@property(nonatomic,strong) AddContactsViewController *avc;//添加联系人的页面
@property(nonatomic,strong) NSMutableArray<ContactsModel *> *localContacts;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.table];
    self.localContacts = [[StudentDataManager initAllLoaclContact] mutableCopy];
   
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

- (UIButton *)addContactsBtn{
    if(_addContactsBtn == nil){
        _addContactsBtn = [[UIButton alloc] init];
        [_addContactsBtn setBackgroundImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
        [_addContactsBtn addTarget:self action:@selector(moveToAddContactSViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addContactsBtn;
}

- (void)moveToAddContactSViewController {
    [self.navigationController pushViewController:self.avc animated:YES];
}

//将一个联系人添加到用于储存本地联系人的数组
- (void)add{
    if([self.avc.searchField.text length] == 0){
        [self alertWithHint:@"不能为空" comfirm:YES];
    }else{
        ContactsModel *model = [StudentDataManager getStudentWithStunum:self.avc.searchField.text];
        if(model != nil && model.stunum != nil){
            if([StudentDataManager saveToLocalWithContact:model]){
                [self.localContacts addObject:model];
                [self alertWithHint:@"添加成功" comfirm:NO];
            }else{
                [self alertWithHint:@"该联系人已存在" comfirm:YES];
            }
        }else{
            [self alertWithHint:@"未查询到该联系人" comfirm:YES];
        }
    }
}

//提示窗口，参数分别为提示信息和是否需要手动确认
- (void)alertWithHint:(NSString *) hint comfirm:(BOOL) comfirm {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:hint preferredStyle:UIAlertControllerStyleAlert];
    if(comfirm){
        UIAlertAction *back = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:back];
    }
    [self presentViewController:alertController animated:YES completion:nil];
    if(!comfirm){
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


#pragma mark -Lazy
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
- (AddContactsViewController *)avc{
    if(_avc == nil){
        _avc = [[AddContactsViewController alloc] init];
        [_avc.addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avc;
}

- (NSMutableArray<ContactsModel *> *)localContacts{
    if(_localContacts == nil){
        _localContacts = [NSMutableArray array];
    }
    return _localContacts;
}

@end
