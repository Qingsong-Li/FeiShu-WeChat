//
//  MomentTableViewCell.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/14.
//

#import "MomentTableViewCell.h"
#import "Masonry.h"
#import "YYText.h"



#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define Right 80
#define TopAndBottomMargin 20
#define LeftAndRightMargin 14

@interface MomentTableViewCell ()



@end

@implementation MomentTableViewCell

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
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.yyTextLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moreBtn];
        [self setMasonry];
        
        if(self.deleteBtn.superview != nil){
            [self.deleteBtn removeFromSuperview];
        }
    }
    return self;
}

- (void)setLikeAndComment{
    //1.likeLab
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:18];
    if(self.likesArr.count != 0){
        UIImage *img = [[UIImage alloc] init];
        img = [UIImage imageNamed:@"like"];
        NSMutableAttributedString *likeImageAtt =
        [NSMutableAttributedString
            yy_attachmentStringWithContent:img
                               contentMode:UIViewContentModeCenter
                            attachmentSize:CGSizeMake(30, 25)  //图片占位符
                               alignToFont:font
                                 alignment:YYTextVerticalAlignmentBottom
        ];
        [text appendAttributedString:likeImageAtt];
        for (int i = 0; i < self.likesArr.count; i++) {
            NSMutableAttributedString *nameAtt;
            if (i != self.likesArr.count - 1) {
                nameAtt = [[NSMutableAttributedString alloc] initWithString:[self.likesArr[i] stringByAppendingString:@", "]];
            } else {
                nameAtt = [[NSMutableAttributedString alloc] initWithString:self.likesArr[i]];
            }
            nameAtt.yy_font = font;
            nameAtt.yy_color = [UIColor blueColor];
            nameAtt.yy_headIndent = 10;
            nameAtt.yy_firstLineHeadIndent = 10;
            [text appendAttributedString:nameAtt];
        }
        self.likeLab.numberOfLines = 0;
        self.likeLab.preferredMaxLayoutWidth = self.contentView.bounds.size.width;
        self.likeLab.attributedText = text;
        self.likeLab.textAlignment = NSTextAlignmentLeft;
    }else{
        self.likeLab.text = @"";
    }
    //2.commentLab
    NSMutableAttributedString *text1 = [NSMutableAttributedString new];
    UIFont *font1 = [UIFont systemFontOfSize:19];
    for (int i = 0; i < self.commentsArr.count; i++) {
        NSMutableAttributedString *commentsAtt = [[NSMutableAttributedString alloc] initWithString:[self.commentsArr[i] stringByAppendingString:@"\n"]];
        NSString *person = [self.commentsArr[i] componentsSeparatedByString: @" :"][0];
        commentsAtt.yy_font = font1;
        commentsAtt.yy_color = [UIColor blackColor];
        // 设置不同颜色
        NSRange range = [self.commentsArr[i] rangeOfString:person];
        [commentsAtt yy_setColor:[UIColor blueColor] range:range];
        [commentsAtt yy_setFont:font1 range:range];
        commentsAtt.yy_headIndent = 10;
        commentsAtt.yy_firstLineHeadIndent = 10;
        [text1 appendAttributedString:commentsAtt];
    }
    self.commentLab.attributedText = text1;
    self.commentLab.numberOfLines = 0;  // 设置多行
    
    self.commentLab.preferredMaxLayoutWidth = SCREEN_WIDTH - Right - LeftAndRightMargin;
    self.commentLab.textAlignment = NSTextAlignmentLeft;
 
    [self.contentView addSubview:self.likeLab];
    [self.contentView addSubview:self.commentLab];
    if(self.liked == NO){
        [self.likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(self.timeLab);
            make.width.mas_equalTo(self.yyTextLab);
        }];
        [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.likeLab.mas_bottom);
            make.left.mas_equalTo(self.timeLab);
            make.width.mas_equalTo(self.yyTextLab);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);

        }];
    }else if (self.liked == YES){
        [self.likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(self.timeLab);
            make.width.mas_equalTo(self.yyTextLab);
        }];
        [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.likeLab.mas_bottom).mas_offset(0.5);
            make.top.mas_equalTo(self.likeLab.mas_bottom).mas_offset(0.5);
            make.left.mas_equalTo(self.timeLab);
            make.width.mas_equalTo(self.yyTextLab);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        }];
    }
    
    if(self.likesArr.count != 0 && self.commentsArr.count != 0){
        [self.contentView addSubview:self.separateView];
        [self.separateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.likeLab.mas_bottom);
            make.left.mas_equalTo(self.likeLab);
            make.width.mas_equalTo(self.likeLab);
            make.height.mas_offset(0.5);
        }];
    }
    
    
   
}

- (void)setMasonry{
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(20);
        make.left.mas_equalTo(self.contentView).mas_offset(14);
        make.size.mas_offset(55);
      
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(20);
        make.left.mas_equalTo(self.contentView).mas_offset(80);
        make.width.mas_offset(299);
        make.height.mas_offset(30);
    }];
    [self.yyTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self.nameLab).mas_offset(0);
        make.width.mas_offset(299);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.yyTextLab.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.yyTextLab).mas_offset(0);
        make.size.mas_offset(CGSizeMake(50, 20));
       
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab).mas_offset(0);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.size.mas_offset(CGSizeMake(30, 20));
    }];
  
   

}


- (UIImageView *)avatar{
    if(_avatar == nil){
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 10;
        _avatar.clipsToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)nameLab{
    if(_nameLab == nil){
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont boldSystemFontOfSize:23];
        _nameLab.textColor = [UIColor systemBlueColor];
    }
    return _nameLab;
}

- (UILabel *)timeLab{
    if(_timeLab == nil){
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor grayColor];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (YYLabel *)yyTextLab{
    if(_yyTextLab == nil){
        _yyTextLab = [[YYLabel alloc] init];
        _yyTextLab.numberOfLines = 0;
        _yyTextLab.preferredMaxLayoutWidth = self.contentView.bounds.size.width;
        _yyTextLab.font = [UIFont systemFontOfSize:20];
        
    }
    return _yyTextLab;
}


- (UIButton *)moreBtn{
    if(_moreBtn == nil){
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setBackgroundImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}

- (YYLabel *)likeLab{
    if(_likeLab == nil){
        _likeLab = [[YYLabel alloc] init];
        _likeLab.backgroundColor = [UIColor systemGray6Color];
    }
    
    return _likeLab;
}

- (UIView *)separateView{
    if(_separateView == nil){
        _separateView = [[UIView alloc] init];
        _separateView.backgroundColor = [UIColor grayColor];
        _separateView.alpha = 0.5;
    }
    return _separateView;
}


- (YYLabel *)commentLab{
    if(_commentLab == nil){
        _commentLab = [[YYLabel alloc] init];
        _commentLab.backgroundColor = [UIColor systemGray6Color];
    }
    return _commentLab;
}

- (UIButton *)deleteBtn{
    if(_deleteBtn == nil){
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _deleteBtn;
}


- (void)addDeleteBtn{
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLab);
        make.left.mas_equalTo(self.timeLab.mas_right);
        make.height.mas_equalTo(self.timeLab);
        make.width.mas_offset(50);
    }];
}

- (void)addImagesToText{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.yyTextLab.text];
        text.yy_font = [UIFont systemFontOfSize:20];
    UIFont *font = [UIFont systemFontOfSize:20];
    NSMutableAttributedString *textAtt = [[NSMutableAttributedString alloc] init];
    if([self.yyTextLab.text isEqualToString:@""] == NO){
        [textAtt appendAttributedString:[[NSAttributedString alloc]
                                         initWithString:@"\n"]]; //文本没有自带回车，如不添加回车则图片会紧跟着文本
    }
    textAtt.yy_font = font;
    [text appendAttributedString:textAtt];
    for (int i = 0; i < self.imagesArr.count; i++) {
        if([self.nameLab.text isEqualToString:@"Double E"] ){
            UIImage *image = [UIImage imageWithData:self.imagesArr[i]];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            if (self.imagesArr.count == 1) {
                imageView.frame = [self oneImageFit:imageView];
            } else {
                CGFloat maxSize = (SCREEN_WIDTH - Right - LeftAndRightMargin - 35 - 5 ) / 3;
                imageView.frame = CGRectMake(0, 0, maxSize, maxSize);
            }
            // 图片宽高适配
            imageView.clipsToBounds = YES;
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            NSMutableAttributedString *imageAtt = [[NSMutableAttributedString alloc] init];
            imageAtt =
            [NSMutableAttributedString
             yy_attachmentStringWithContent:imageView
             contentMode:UIViewContentModeTopLeft
             attachmentSize:CGSizeMake(imageView.frame.size.width+5 , imageView.frame.size.height+5 ) //图片占位符
             alignToFont:font
             alignment:YYTextVerticalAlignmentTop];
            [text appendAttributedString:imageAtt];
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imagesArr[i]]];
            if (self.imagesArr.count == 1) {
                imageView.frame = [self oneImageFit:imageView];
            } else {
                CGFloat maxSize = (SCREEN_WIDTH - Right - LeftAndRightMargin - 35 - 5 ) / 3;
                imageView.frame = CGRectMake(0, 0, maxSize, maxSize);
            }
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
        }
        
    }
    self.yyTextLab.attributedText  = text;
}

/// 针对只有一张图片的算法
- (CGRect)oneImageFit:(UIImageView *)imageView {
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    if(width >= height) {
        //以最大宽度为宽度将长度等比缩小
        CGFloat maxWidth = SCREEN_WIDTH - Right -LeftAndRightMargin -100;
        CGFloat proportion = width/maxWidth;
        width = maxWidth;
        height = height/proportion;
    }else{
        CGFloat maxHeight = 150;
        CGFloat proportion = height/maxHeight;
        width = width/proportion;
        height = maxHeight;
    }
    return CGRectMake(0, 0, width, height);
}

@end
