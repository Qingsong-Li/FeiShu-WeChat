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
#import "SearchCell.h"
#import "ContactsCell.h"

@interface ContactsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SearchCellDelegate
>

@property(nonatomic,strong) TopView *topView;
@property(nonatomic,strong) UITableView *table;
@property(nonatomic,strong) UIButton *addContactsBtn;
@property(nonatomic,strong) AddContactsViewController *avc;//添加联系人的页面
@property(nonatomic,strong) NSDictionary *localContacts;//包含26个键对应26个字母，每个键对应的值为一个NSMutableArray存放联系人模型
@property(nonatomic,strong) SearchCell *searchCell;//顶部用于查找本地联系人的cell

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.table];
    self.localContacts = [StudentDataManager initAllLocalContact];//初始化所以本地联系人
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

- (void)moveToAddContactSViewController {
    [self.navigationController pushViewController:self.avc animated:YES];
}

//将一个联系人添加到用于储存本地联系人的字典
- (void)add{
    if([self.avc.searchField.text length] == 0){
        [self alertWithHint:@"不能为空" comfirm:YES];
    }else{
        ContactsModel *model = [StudentDataManager getStudentWithStunum:self.avc.searchField.text];
        if(model != nil && model.stunum != nil){
            if([StudentDataManager saveToLocalWithContact:model]){
                
                NSString *firstChar = [[model valueForKey:@"name"] substringToIndex:1]; // 获取第一个字
                NSMutableString *mutableString = [firstChar mutableCopy];
                CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO); // 转换为拼音
                NSString *firstCharacter = [[mutableString substringToIndex:1] uppercaseString]; // 获取拼音首字母并转为大写
                [[self.localContacts mutableArrayValueForKey:firstCharacter] addObject:model];
                [self alertWithHint:@"添加成功" comfirm:NO];
            }else{
                [self alertWithHint:@"该联系人已存在" comfirm:YES];
            }
        }else{
            [self alertWithHint:@"未查询到该联系人" comfirm:YES];
        }
    }
    [self.table reloadData];
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


#pragma mark -TableDelegate

//组数仅为储存数据的字典中键对应的非空数组的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //将所有值为非空数组的键存放进数组，并返回这个数组的conut作为组数
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *key in self.localContacts){
        NSArray *a = self.localContacts[key];
        if(a.count>0){
            [array addObject:key];
        }
    }
    return array.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0.0000001;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == tableView.numberOfSections){
        return 50;
    }else{
        return 0.000001;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
        return headerView;
    }
    //将所有值为非空数组的键存放进数组
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *key in self.localContacts){
        NSArray *a = self.localContacts[key];
        if(a.count>0){
            [array addObject:key];
        }
    }
    //排序
    array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    //自定义headerview
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.bounds.size.width - 30, 40)];
       titleLabel.textColor = [UIColor systemGrayColor];
       titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
       titleLabel.text = array[section-1]; // 使用存储非空数组的键来设置标题
       [headerView addSubview:titleLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        NSMutableArray *array = [NSMutableArray array];
        for(NSString *key in self.localContacts){
            NSArray *a = self.localContacts[key];
            if(a.count>0){
                [array addObject:key];
            }
        }
        //排序
        array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        return [self.localContacts mutableArrayValueForKey:array[section-1]].count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //顶部的搜索本地联系人
    if(indexPath.section == 0){
        return self.searchCell;
    }
    //每个联系人cell
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell  = [[ContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *key in self.localContacts){
        NSArray *a = self.localContacts[key];
        if(a.count>0){
            [array addObject:key];
        }
    }
    //排序
    array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
//    NSLog(@"%ld",(long)indexPath.section);
//    NSLog(@"%ld",(long)indexPath.item);
    NSMutableArray *a =[self.localContacts mutableArrayValueForKey:array[indexPath.section-1]];
    ContactsModel *model = a[indexPath.item];
    cell.nameLab.text = [model valueForKey:@"name"];
    [cell setHeadImgWithName:[model valueForKey:@"name"]];
    return cell;
}

    
#pragma mark -SearchCellDelegate

- (void)searchContact{
    NSString *name = self.searchCell.searchField.text;
    if([name length] == 0){
        [self alertWithHint:@"请输入联系人姓名后再点击" comfirm:YES];
        return;
    }
    //获取到需要显示的字母
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *key in self.localContacts){
        NSArray *a = self.localContacts[key];
        if(a.count>0){
            [array addObject:key];
        }
    }
    //对需要显示的字母排序
    array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    //查找联系人，如查找到就保存其所在的section和item，用于后续通过indexpath定位
    NSString *key = [NSString string];
    NSInteger count = 0;
    NSInteger flag = 0;//用于break外层循环以及标记输入联系人是否找到
    for( key in self.localContacts){
        NSArray *a = self.localContacts[key];
        if(a.count>0){
            for(ContactsModel *model in a){
                if([name isEqualToString:model.name]){
                    count = [a indexOfObject:model];
                    flag = 1 ;
                    break;
                }
            }
        }
        if(flag == 1){
            break;
        }
    }
    if(flag == 1){
        NSIndexPath *index = [NSIndexPath indexPathForItem:count inSection:[array indexOfObject:key]+1];
        
        [self.table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        CGFloat delay = 0.5;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [[self.table cellForRowAtIndexPath:index] setBackgroundColor:[UIColor systemGray6Color]];
        });
        dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay*1.5 * NSEC_PER_SEC));
        dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
            [[self.table cellForRowAtIndexPath:index] setBackgroundColor:[UIColor whiteColor]];
        });
    }else{
        [self alertWithHint:@"该联系人不存在" comfirm:NO];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *key in self.localContacts){
        NSArray *a = self.localContacts[key];
        if(a.count>0){
            [array addObject:key];
        }
    }
    array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index+1;
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

- (SearchCell *)searchCell{
    if(_searchCell == nil){
        _searchCell = [[SearchCell alloc] init];
        _searchCell.delegate = self;
    }
    return _searchCell;
}

- (UITableView *)table{
    if(_table == nil){
        
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //此处不设置为Group样式的原因是Group样式下的Header不会自动悬浮，导致每个section之间会有空隙，需要手动返回一个大小为零的FooterView，即使设置heightForFooter为0也不能解决
        _table.sectionHeaderTopPadding = 0;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
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

- (UIButton *)addContactsBtn{
    if(_addContactsBtn == nil){
        _addContactsBtn = [[UIButton alloc] init];
        [_addContactsBtn setBackgroundImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
        [_addContactsBtn addTarget:self action:@selector(moveToAddContactSViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addContactsBtn;
}

- (NSDictionary *)localContacts{
    if(_localContacts == nil){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (char c = 'A'; c <= 'Z'; c++) {
            NSString *key = [NSString stringWithFormat:@"%c", c];
            NSMutableArray *value = [NSMutableArray array];
            [dic setObject:value forKey:key];
        }
        _localContacts = [NSDictionary dictionaryWithDictionary:dic];
    }
    return _localContacts;
}

@end
