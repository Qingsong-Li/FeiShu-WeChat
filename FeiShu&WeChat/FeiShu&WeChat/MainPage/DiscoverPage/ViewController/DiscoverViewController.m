//
//  DiscoverViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/13.
//

#import "DiscoverViewController.h"
#import "Masonry.h"
#import "MomentModel.h"
#import "MomentTableViewCell.h"
#import "MoreFuncView.h"
#import "MyColors.h"
#import "PublishMomentViewController.h"
#define StatusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height

@interface DiscoverViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPopoverPresentationControllerDelegate,
UINavigationControllerDelegate
>

@property(nonatomic,strong) UIView *topView;//顶部试图
@property(nonatomic,strong) UIImageView *top_BackGroundView;//顶部试图的背景图片
@property(nonatomic,strong) UIImageView *headView;//头像
@property(nonatomic,strong) UILabel *nameLab;//名字
@property(nonatomic,strong) UIButton *publishBtn;//发布按钮
@property(nonatomic,strong) UITableView *table;//朋友圈列表
@property(nonatomic,strong) NSMutableArray *dataArray;//数据源
@property(nonatomic,strong) MoreFuncView *moreView;//点赞或者评论的视图
@property(nonatomic,strong) UIView *backView;//蒙版用于取消moreView
@property(nonatomic,strong) UITextField *inputTextField;//评论输入框
@property(nonatomic,strong) UIButton *confirmBtn;//确定发布评论按钮





@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self copyTheDataToDocuments];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.navigationController.navigationBar addSubview:self.publishBtn];
    [self.top_BackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.topView).mas_offset(0);
        make.size.mas_equalTo(self.topView).mas_offset(0);
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topView.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.topView.mas_right).mas_offset(-10);
        make.size.mas_offset(80);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topView).mas_offset(0);
        make.right.mas_equalTo(self.headView.mas_left).mas_offset(0);
        make.size.mas_offset(CGSizeMake(80,30));
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.view addSubview:self.table];
    self.navigationController.navigationBarHidden = NO;
    [self updateTheDataArray];
    [self.table reloadData];
}

- (void)dismissBackViewWithGesture{
    [self.moreView removeFromSuperview];
    [self.backView removeFromSuperview];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentModel *model = self.dataArray[self.dataArray.count - indexPath.row -1];//反转是为了最后添加的cell在最上面
    MomentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[MomentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.avatar.image = [UIImage imageNamed:model.avatar];
    cell.nameLab.text = model.name;
    cell.yyTextLab.text = model.text;
    cell.imagesArr = model.images;
    cell.timeLab.text = model.time;
    cell.liked = model.liked;
    cell.likesArr = model.likes;
    cell.commentsArr = model.comments;
    [cell setLikeAndComment];//点赞和评论需要在拿到数据后再加载出来;
    if(cell.imagesArr.count > 0){
        [cell addImagesToText];
    }
    if([cell.nameLab.text isEqualToString:@"Double E"]){
        [cell addDeleteBtn];
    }else{
        [cell.deleteBtn removeFromSuperview];
    }
    [cell.moreBtn addTarget:self action:@selector(clickForMoreFun:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteTheMoment:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark-SEL

- (void)deleteTheMoment:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:touchPoint];
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentsPath stringByAppendingString:@"/momentsData.plist"];
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
    [data removeObjectAtIndex:self.dataArray.count - indexPath.row - 1];
    [data writeToFile:filePath atomically:YES];
    [self updateTheDataArray];
    [self.table reloadData];
}

- (void)clickForMoreFun:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:touchPoint];
    MomentTableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    UIWindow *window = self.view.window;
    CGRect frame = [cell.moreBtn convertRect:cell.moreBtn.bounds toView:window];
    
    [self.moreView.likesBtn addTarget:self action:@selector(clickToLike:) forControlEvents:UIControlEventTouchUpInside];
    self.moreView.likesBtn.tag = self.dataArray.count-indexPath.row-1;
    
    [self.moreView.commentsBtn addTarget:self action:@selector(clikeToComment:) forControlEvents:UIControlEventTouchUpInside];
    self.moreView.commentsBtn.tag = self.dataArray.count - indexPath.row -1;
    if(cell.liked == NO){
        self.moreView.likeLab.text = @"赞";
    }else{
        self.moreView.likeLab.text = @"取消";
    }
    self.moreView.commentLab.text = @"评论";
    self.moreView.frame = CGRectMake(frame.origin.x - [UIScreen mainScreen].bounds.size.width * 0.47, frame.origin.y, 172, 35);
    [self.view.window addSubview:self.backView];
    [self.view.window addSubview:self.moreView];
    
}



- (void)clikeToComment:(UIButton *)sender{
    [self.moreView removeFromSuperview];
    //这个手势用于点击除输入框以外的地方时可以收起输入框和键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.view.window addSubview:self.inputTextField];
    [self.view.window addSubview:self.confirmBtn];
    [self.inputTextField becomeFirstResponder];//弹出键盘
    self.table.scrollEnabled = NO;
}

- (void)keyboardWillShow:(NSNotification *) notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.inputTextField.frame = CGRectMake(0, keyboardFrame.origin.y - 50, keyboardFrame.size.width, 50);
    self.confirmBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, self.inputTextField.frame.origin.y + 5, 50, 40);
}

//隐藏键盘以及输入框
- (void)hideKeyboard:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self.view];
    if (![self.inputTextField pointInside:[self.inputTextField convertPoint:tapPoint fromView:self.view] withEvent:nil]) {
        [self.inputTextField resignFirstResponder]; // 收起键盘
        [self.inputTextField removeFromSuperview];
        [self.confirmBtn removeFromSuperview];
        self.table.scrollEnabled = YES;
    }
}

- (void)clickToLike:(UIButton *)sender {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima.byValue = @(0.7);
    [self.moreView.likeImageView.layer addAnimation:anima forKey:@"scaleAnimation"];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500/*延迟执行时间*/*NSEC_PER_MSEC));
    dispatch_after(delayTime,dispatch_get_main_queue(), ^{
        [self.moreView removeFromSuperview];
        
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [documentsPath stringByAppendingString:@"/momentsData.plist"];
        NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
        // 获取 dic 字典，并创建可变的副本
        NSMutableDictionary *dic= [data[sender.tag] mutableCopy];
        // 获取 dic 字典中的 likes 数组并转换为可变数组
        NSMutableArray *likesArray = [dic[@"likes"] mutableCopy];
        
        NSString *myName = @"Double E";
        
        if([likesArray containsObject:myName]){
            //已经点赞了
            [likesArray removeObject:myName];
            [dic setObject:@(NO) forKey:@"liked"];
        }else{
            //没有点赞
            // 添加新的数据到 likes 数组
            [likesArray addObject:@"Double E"];
            [dic setObject:@(YES) forKey:@"liked"];
        }
        // 更新 dic 字典中的 likes 数组
        [dic setObject:likesArray forKey:@"likes"];
        // 将更新后的 dic 字典放回 plistArray
        [data replaceObjectAtIndex:sender.tag withObject:dic];
        // 将修改后的数组写回到 plist 文件
        [data writeToFile:filePath atomically:YES];
        [self updateTheDataArray];
        [self.table reloadData];
    });
}

- (void)confirmTheComment {
    
    if(self.inputTextField.text.length != 0){
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [documentsPath stringByAppendingString:@"/momentsData.plist"];
        NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
        // 获取 dic 字典，并创建可变的副本
        NSMutableDictionary *dic= [data[self.moreView.commentsBtn.tag] mutableCopy];
        // 获取 dic 字典中的 likes 数组并转换为可变数组
        NSMutableArray *commentsArray = [dic[@"comments"] mutableCopy];
        NSString *myName = @"Double E : ";
        NSString *myComment = [myName stringByAppendingString:self.inputTextField.text];
        [commentsArray addObject:myComment];
        [dic setObject:commentsArray forKey:@"comments"];
        // 将更新后的 dic 字典放回 plistArray
        [data replaceObjectAtIndex:self.moreView.commentsBtn.tag withObject:dic];
        // 将修改后的数组写回到 plist 文件
        [data writeToFile:filePath atomically:YES];
    }
    [self.inputTextField resignFirstResponder]; // 收起键盘
    [self.inputTextField removeFromSuperview];
    [self.confirmBtn removeFromSuperview];
    [self updateTheDataArray];
    [self.table reloadData];
    self.table.scrollEnabled = YES;
}

- (void)updateTheDataArray{
    self.dataArray = [NSMutableArray array];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentsPath stringByAppendingString:@"/momentsData.plist"];
    NSLog(@"%@",filePath);
    NSArray *data = [NSArray arrayWithContentsOfFile:filePath];
    for(NSDictionary *dic in data){
        MomentModel *model = [[MomentModel alloc] init];
        [model momentModelWithDic:dic];
        [self.dataArray addObject:model];
    }
}

- (void)copyTheDataToDocuments {
    // 获取应用程序的可写目录路径
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    // 指定复制后的文件路径
    NSString *copiedFilePath = [documentsPath stringByAppendingPathComponent:@"momentsData.plist"];
    // 检查是否已经复制过该文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:copiedFilePath]) {
        // 复制 plist 文件到可写目录中
        NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:@"momentsData" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:sourceFilePath toPath:copiedFilePath error:nil];
    }
    NSLog(@"%@",copiedFilePath);
}

- (void)clickToPublish {
    PublishMomentViewController *pVC = [[PublishMomentViewController alloc] init];
    [self.navigationController pushViewController:pVC animated:YES];
    
}

#pragma mark-Lazy

- (UIView *)backView{
    if(_backView == nil){
        _backView = [[UIView alloc]init];
        _backView.frame = [UIScreen mainScreen].bounds;
        _backView.backgroundColor = UIColor.clearColor;
        // 手势1:点击任意一处使多功能按钮消失
        UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
        [_backView addGestureRecognizer:dismiss];
        // 手势2:使上下滑动时也使多功能按钮消失
        UISwipeGestureRecognizer *swipeUP = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
        swipeUP.direction = UISwipeGestureRecognizerDirectionUp;
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [_backView addGestureRecognizer:swipeUP];
        [_backView addGestureRecognizer:swipeDown];
    }
    return _backView;
}

- (MoreFuncView *)moreView{
    if(_moreView == nil){
        _moreView = [[MoreFuncView alloc] init];
    }
    return _moreView;
}


- (UIView *)topView{
    if(_topView == nil){
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _topView.backgroundColor = [UIColor grayColor];
        [_topView addSubview:self.top_BackGroundView];
        [_topView addSubview:self.headView];
        [_topView addSubview:self.nameLab];
    }
    return _topView;
}

- (UIImageView *)top_BackGroundView{
    if(_top_BackGroundView == nil){
        _top_BackGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_backGround"]];
    }
    return _top_BackGroundView;
}

- (UIImageView *)headView{
    if(_headView == nil){
        _headView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"头像"], 1.0)]];
        _headView.layer.cornerRadius = 7;
        _headView.clipsToBounds = YES;
    }
    return _headView;
}

- (UILabel *)nameLab{
    if(_nameLab == nil){
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"Double E";
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLab;
}

- (UIButton *)publishBtn{
    if(_publishBtn == nil){
        _publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-50, 10, 32, 28)];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(clickToPublish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

- (UITableView *)table{
    if(_table == nil){
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, - StatusBarHeight - 60, self.view.bounds.size.width,  self.view.bounds.size.height-self.tabBarController.tabBar.bounds.size.height + StatusBarHeight+60)];
        _table.tableHeaderView = self.topView;
        _table.delegate = self;
        _table.dataSource = self;
        _table.allowsSelection = NO;

        
        
    }
    return _table;
}

- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [documentsPath stringByAppendingString:@"/momentsData.plist"];
        NSLog(@"%@",filePath);
        NSArray *data = [NSArray arrayWithContentsOfFile:filePath];
        for(NSDictionary *dic in data){
            MomentModel *model = [[MomentModel alloc] init];
            [model momentModelWithDic:dic];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (UITextField *)inputTextField{
    if(_inputTextField == nil){
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height, 0, 0)];
        _inputTextField.backgroundColor = [UIColor systemGray6Color];
        _inputTextField.placeholder = @"发表你的评论......";
        
    }
    return _inputTextField;
}

- (UIButton *)confirmBtn{
    if(_confirmBtn == nil){
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmTheComment) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setBackgroundColor:[UIColor colorWithRed:107/255.0 green:194/255.0 blue:53/255.0 alpha:1]];
        _confirmBtn.layer.cornerRadius = 10.0; 
        _confirmBtn.layer.masksToBounds = YES;

    }
    return _confirmBtn;
}


@end
