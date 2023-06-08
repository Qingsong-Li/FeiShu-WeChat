//
//  ContactsTopView.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/4.
//

#import "TopView.h"
#import "Masonry.h"

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

- (void)setMasonry{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self).mas_offset(-10);
        make.height.mas_offset(20);
        make.width.mas_offset(130);
    }];
}

- (UILabel *)title{
    if(_title == nil){
        _title = [[UILabel alloc]init];
        _title.font = [UIFont boldSystemFontOfSize:19];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

@end
