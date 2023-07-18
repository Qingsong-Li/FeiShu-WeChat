//
//  ContactsTopView.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/4.
//

#import "TopView.h"
#import "Masonry.h"

@interface TopView ()



@end

@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor systemGray6Color];
        [self addSubview:self.title];
        [self setMasonry];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, 393, 100);
        self.backgroundColor = [UIColor systemGray6Color];
        [self addSubview:self.title];
        [self setMasonry];
    }
    return self;
}


- (void)setMasonry{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self).mas_offset(-10);
        make.height.mas_offset(20);
        make.width.mas_offset(130);
    }];
}

- (void)showTheBackBtn{
    [self addSubview:self.backBtn];
}

- (void)hiddenTheBackBtn{
    [self.backBtn removeFromSuperview];
}

- (UILabel *)title{
    if(_title == nil){
        _title = [[UILabel alloc]init];
        _title.font = [UIFont boldSystemFontOfSize:20];
        _title.textAlignment = NSTextAlignmentCenter;
        
    }
    return _title;
}

- (UIButton *)backBtn{
    if(_backBtn == nil){
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 85, 18, 18)];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}





@end
