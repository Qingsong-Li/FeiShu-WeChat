//
//  ChatViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/29.
//

#import "ChatViewController.h"
#import "TopView.h"
#import "ChatModel.h"
#import "FMDB.h"
#import "ChatCell.h"
#import "MyColors.h"
#import "MeViewController.h"
#import "RegisterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <PhotosUI/PHPicker.h>

@interface ChatViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPopoverPresentationControllerDelegate,
PHPickerViewControllerDelegate,
UINavigationControllerDelegate
>

@property(strong,nonatomic) TopView *topView;
@property(strong,nonatomic) UIButton *headBtn;
@property(strong,nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) NSMutableArray<ChatModel *> *dataArray;
@property(strong,nonatomic) MeViewController *meVC;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.headBtn];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:209/255.0 blue:204/255.0 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.view addSubview:self.chatTableView];
}

- (void)click {
    self.meVC.preferredContentSize = CGSizeMake(150, 70);
    self.meVC.modalPresentationStyle = UIModalPresentationPopover;
    self.meVC.popoverPresentationController.sourceView = self.headBtn;
    self.meVC.popoverPresentationController.sourceRect = self.headBtn.bounds;
    self.meVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    self.meVC.popoverPresentationController.delegate = self;
    [self presentViewController:self.meVC animated:YES completion:nil];
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatModel *dataModel = self.dataArray[indexPath.row];
    // 复用
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (chatCell == nil) {
        chatCell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
    }
    chatCell.name.text = [dataModel valueForKey:@"name"];
    chatCell.message.text = [dataModel valueForKey:@"text"];
    chatCell.avatar.image = [self getImgWithName:[dataModel valueForKey:@"name"]];
    chatCell.date.text = [dataModel valueForKey:@"date"];
    [chatCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return chatCell;
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark -Lazy
- (TopView *)topView{
    if(_topView == nil){
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 393, 120)];
        _topView.title.text = @"微书";
    }
    return _topView;
}

-(UIButton *)headBtn{
    if(_headBtn == nil){
        _headBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 80, 40, 40)];
        _headBtn.layer.cornerRadius = _headBtn.bounds.size.width/2;
        _headBtn.clipsToBounds = YES;
        [_headBtn setBackgroundColor:[UIColor systemGray6Color]];
        [_headBtn setBackgroundImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        [_headBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBtn;
}

-(UITableView *)chatTableView{
    if(_chatTableView == nil){
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.topView.bounds.size.height - self.tabBarController.tabBar.bounds.size.height ) style:UITableViewStylePlain];
        _chatTableView.dataSource = self;
        _chatTableView.delegate = self;
    }
    return _chatTableView;
}

- (MeViewController *)meVC{
    if(_meVC == nil){
        _meVC = [[MeViewController alloc] init];
        [_meVC.logOutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
        [_meVC.changeHeadBtn addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _meVC;
}

- (NSMutableArray<ChatModel *> *)dataArray{
    if (_dataArray == nil) {
        // 从plist文件中加载
        NSString *path = [[NSBundle mainBundle] pathForResource:@"chatData.plist" ofType:nil];
        NSArray *dataOriginArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *ma = [NSMutableArray array];
        // 数据转模型
        for (NSDictionary *dic in dataOriginArray) {
            ChatModel *model = [[ChatModel alloc] init];
            [model ChatModelWithDic:dic];
            [ma addObject:model];
        }
        _dataArray = ma;
    }
    return _dataArray;
}

- (UIImage *)getImgWithName:(NSString *)name{
    // 定义图片的尺寸
    CGSize imageSize = CGSizeMake(50, 50);
    // 创建图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);

    // 随机生成背景颜色
    UIColor *backgroundColor = [MyColors getRandomColor];
    [backgroundColor setFill];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    // 设置文本属性
    NSDictionary *textAttributes = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };
    // 绘制文本
    NSString *text = [name substringFromIndex:name.length -2] ;
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    CGPoint textOrigin = CGPointMake((imageSize.width - textSize.width) / 2, (imageSize.height - textSize.height) / 2);
    [text drawAtPoint:textOrigin withAttributes:textAttributes];
    // 获取生成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    return image;

}

- (void)logOut{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"loggingStatus"];
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
    
}

- (void)changeBtn {
    PHPickerConfiguration *picker = [[PHPickerConfiguration alloc] init];
    
    picker.selectionLimit =  1;
    picker.filter = [PHPickerFilter imagesFilter];
    // 安装配置
    PHPickerViewController *pVC = [[PHPickerViewController alloc] initWithConfiguration:picker];
    pVC.delegate = self;
    // 显示UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:pVC animated:YES completion:nil];
    }];
   
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
    
}

#pragma mark - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (PHPickerResult *result in results) {
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id <NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            if ([object isKindOfClass:[UIImage class]]) {
                // 更新
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (object) {
                        [self.headBtn setBackgroundImage:object forState:UIControlStateNormal];
                    }
                });
            }
        }];
    }

}

@end
