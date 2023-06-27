//
//  ContactsCell.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/15.
//

#import "ContactsCell.h"

@implementation ContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.separator];
    }
    return self;
}

- (void)setHeadImgWithName:(NSString *)name{
    // 定义图片的尺寸
    CGSize imageSize = CGSizeMake(self.headImg.bounds.size.width, self.headImg.bounds.size.height);
    // 创建图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);

    // 随机生成背景颜色
    UIColor *backgroundColor = [self randomColor];

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
    self.headImg.image = image;

}

- (UILabel *)nameLab{
    if(_nameLab == nil){
        _nameLab = [[UILabel alloc ]initWithFrame:CGRectMake(60, 10, self.contentView.bounds.size.width, self.contentView.bounds.size.height-20)];
    }
    return _nameLab;
}

- (UIImageView *)headImg{
    if(_headImg == nil){
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, self.contentView.bounds.size.height-4, self.contentView.bounds.size.height-4)];
        _headImg.layer.cornerRadius = _headImg.bounds.size.width/2;
        _headImg.clipsToBounds = YES;
    }
    return _headImg;
}

- (UIView *)separator{
    if(_separator == nil){
        _separator = [[UIView alloc] initWithFrame:CGRectMake(50, self.contentView.bounds.size.height-1, self.contentView.bounds.size.width-30, 1)];
        _separator.backgroundColor = [UIColor systemGray5Color];
    }
    return _separator;
}

- (UIColor *)randomColor{
    UIColor *randomColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                           green:arc4random_uniform(256)/255.0
                                            blue:arc4random_uniform(256)/255.0
                                           alpha:1.0];
    //过滤一些较浅的颜色
    CGFloat brightness;
    [randomColor getHue:nil saturation:nil brightness:&brightness alpha:nil];
    CGFloat brightnessThreshold = 0.7;
    if (brightness < brightnessThreshold) {
        return [self randomColor];
    }
    else {
        return randomColor;
    }
    return randomColor;
}
@end
