//
//  PublishMomentViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/16.
//

#import "PublishMomentViewController.h"
#import <PhotosUI/PHPicker.h>
#import "MyTime.h"

@interface PublishMomentViewController ()<
YYTextViewDelegate,
PHPickerViewControllerDelegate,
NSCoding
>



@end

@implementation PublishMomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.publishView];
    self.publishView.textView.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    
    //为plusimage添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseImages:)];
    // 将手势识别器添加到 UIImageView 上
    [self.publishView.plusImage addGestureRecognizer:tapGesture];
    // 允许 UIImageView 响应用户交互
    self.publishView.plusImage.userInteractionEnabled = YES;
    
    [self.publishView.cancelBtn addTarget:self action:@selector(cancelPublish) forControlEvents:UIControlEventTouchUpInside];
    [self.publishView.publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [self setImages];
}

- (void)setImages {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    UIFont *font = [UIFont systemFontOfSize:20];
    for (int i = 0; i < self.publishView.photosArray.count; i++) {
        UIImageView *imageView = self.publishView.photosArray[i];
        CGFloat maxSize = (self.publishView.imagesLab.frame.size.width - 15) / 3;
        imageView.frame = CGRectMake(0, 0, maxSize, maxSize);
        // 图片宽高适配
        imageView.clipsToBounds = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        NSMutableAttributedString *imageAtt = [[NSMutableAttributedString alloc] init];
        imageAtt =
        [NSMutableAttributedString
         yy_attachmentStringWithContent:imageView
         contentMode:UIViewContentModeLeft
         attachmentSize:CGSizeMake(imageView.frame.size.width+5 , imageView.frame.size.height+5 ) //图片占位符
         alignToFont:font
         alignment:YYTextVerticalAlignmentTop];
        [text appendAttributedString:imageAtt];
        //每三张图片需要换一次行
        if((i+1)%3 == 0){
            NSAttributedString *newLine = [[NSAttributedString alloc] initWithString:@"\n"];
            [text appendAttributedString:newLine];
        }
     
    }
    self.publishView.imagesLab.attributedText  = text;
}

#pragma mark -SEL

- (void)choseImages:(UIGestureRecognizer*) tapGesture{
    PHPickerConfiguration *picker = [[PHPickerConfiguration alloc] init];
    
    picker.selectionLimit = 9 - self.publishView.photosArray.count + 1;//保证一共添加的不超过9张
    picker.filter = [PHPickerFilter imagesFilter];
    // 安装配置
    PHPickerViewController *pVC = [[PHPickerViewController alloc] initWithConfiguration:picker];
    pVC.delegate = self;
    [self showPHPicker:pVC];
}

- (void)showPHPicker:(PHPickerViewController *)pvc {
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)cancelPublish {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publish {
    [self saveThePublishedMoment];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)saveThePublishedMoment {
    //获取时间
    NSString *hour = [[NSDate today] hour];
    NSString *separator = @" : ";
    NSString *min = [separator stringByAppendingString:[[NSDate today] min]];
    NSString *currentTime = [hour stringByAppendingString:min];
 
    if(self.publishView.imageIsNine == YES){
        for(UIImageView *imgView in self.publishView.photosArray){
            [self.publishPhotos addObject:[UIImage imageWithCGImage:imgView.image.CGImage] ];//第一张plusImage已经没了
        }
    }else{

        for(UIImageView *imgView in [self.publishView.photosArray subarrayWithRange:NSMakeRange(1, self.publishView.photosArray.count - 1)]){
            [self.publishPhotos addObject:[UIImage imageWithCGImage:imgView.image.CGImage]];//第一张plusImage还在，去掉第一张
        }
    }
    NSMutableArray *imagesData = [[NSMutableArray alloc]init];
    // 遍历图片数组
    for (UIImage *image in self.publishPhotos) {
        // 将每张图片转换为数据
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0); // 或者使用UIImageJPEGRepresentation
        if (imageData) {
            // 将图片数据追加到数据容器中
            [imagesData addObject:imageData];
        }
    }
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentsPath stringByAppendingString:@"/momentsData.plist"];
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
        // 获取 dic 字典，并创建可变的副本
    NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary: @{@"avatar":@"头像",@"comments":@[],@"images":imagesData,@"likes":@[],@"liked":@(NO),@"name":@"Double E",@"text":self.publishView.textView.text,@"time":currentTime}];
    [data addObject:dic];
    [data writeToFile:filePath atomically:YES];

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
                        self.publishView.publishBtn.backgroundColor = [UIColor colorWithRed:107/255.0 green:194/255.0 blue:53/255.0 alpha:1];
                        self.publishView.publishBtn.enabled = YES;
                    }
                    // 把图片加载到数组中
                    [self.publishView.photosArray addObject:[[UIImageView alloc] initWithImage:object]];
                    // 用于判断是否为9张选择的照片
                    if (self.publishView.photosArray.count > 9) {
                        // 满九宫格
                        self.publishView.imageIsNine = YES;
                        [self.publishView.photosArray removeObject:self.publishView.photosArray.firstObject];
                    }
                    [self setImages];
                });
            }
        }];
    }

}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.publishPhotos = [coder decodeObjectForKey:@"publishPhotos"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.publishPhotos forKey:@"publishPhotos"];
}

#pragma mark - lazy
- (PublishPageView *)publishView{
    if(_publishView == nil){
        _publishView = [[PublishPageView alloc] initWithFrame:self.view.frame];
    }
    return _publishView;
}

- (NSMutableArray *)publishPhotos{
    if(_publishPhotos == nil){
        _publishPhotos = [NSMutableArray array];
    }
    return _publishPhotos;
}

#pragma mark-TextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    // 文本为0
    if (self.publishView.textView.text.length == 0) {
        // 发布按钮不可用，为灰色
        self.publishView.publishBtn.backgroundColor = [UIColor lightGrayColor];
        self.publishView.publishBtn.enabled = NO;
    } else {
        // 发布按钮可用，为绿色
        self.publishView.publishBtn.enabled = YES;
        self.publishView.publishBtn.backgroundColor = [UIColor colorWithRed:107/255.0 green:194/255.0 blue:53/255.0 alpha:1];
        self.publishView.defaultLab.hidden = YES;
    }
}

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.publishView.textView resignFirstResponder];
}


@end
