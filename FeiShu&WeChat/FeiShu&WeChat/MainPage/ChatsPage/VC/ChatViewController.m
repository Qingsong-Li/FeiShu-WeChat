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

@interface ChatViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate
>

@property(strong,nonatomic) TopView *topView;
@property(strong,nonatomic) UIButton *headBtn;
@property(strong,nonatomic) UITableView *chatTableView;
@property (strong, nonatomic) NSMutableArray<ChatModel *> *dataArray;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    self.view.backgroundColor = [UIColor colorWithRed:1 green:209/255.0 blue:204/255.0 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [self.view addSubview:self.chatTableView];
}
- (TopView *)topView{
    if(_topView == nil){
        _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 393, 120)];
        _topView.title.text = @"微书";
        [_topView addSubview:self.headBtn];
    }
    return _topView;
}

-(UIButton *)headBtn{
    if(_headBtn == nil){
        _headBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 50, 50)];
        [_headBtn setBackgroundColor:[UIColor systemGray6Color]];
        [_headBtn setImage:[UIImage imageNamed:@"无头像"] forState:UIControlStateNormal];
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
    return 62;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
