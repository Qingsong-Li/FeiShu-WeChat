//
//  RegisterView.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/24.
//

#import "RegisterView.h"
@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColor.whiteColor;
        [self addAllSubview];
        [self setMasonry];
    }
    return self;
}





//账号和密码lab除文本外都一样，用此方法获得lab;
- (UILabel *)getLab {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:22];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

//获得一个含有一些相同基础属性的UITextField
- (UITextField *)getField {
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:20];
//    field.borderStyle = UITextBorderStyleRoundedRect;
    field.clearsOnBeginEditing = YES;
    return field;
}


#pragma mark - Lazy

- (UILabel *)titleLab{
    if(_titleLab == nil){
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"账号登录";
        _titleLab.font = [UIFont boldSystemFontOfSize:26];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)accountLab{
    if(_accountLab == nil){
        _accountLab = [self getLab];
        _accountLab.text = @"账号";
    }
    return _accountLab;
}

- (UILabel *)passWordLab{
    if(_passWordLab == nil){
        _passWordLab = [self getLab];
        _passWordLab.text = @"密码";
    }
    return _passWordLab;
}

- (UITextField *)accountField{
    if(_accountField == nil){
        _accountField = [self getField];
        _accountField.placeholder = @"请输入账号";
        _accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _accountField;
}

- (UITextField *)passWordField{
    if(_passWordField == nil){
        _passWordField = [self getField];
        _passWordField.placeholder = @"请输入密码";
        _passWordField.autocapitalizationType = UITextAutocapitalizationTypeNone;

    }
    return _passWordField;
}
- (UIImageView *)partingLine1{
    if(_partingLine1 == nil){
        _partingLine1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线"]];
    }
    return _partingLine1;
}

- (UIImageView *)partingLine2{
    if(_partingLine2 == nil){
        _partingLine2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线"]];
    }
    return _partingLine2;
}

- (UIButton *)logBtn{
    if(_logBtn == nil){
        _logBtn = [[UIButton alloc] init];
        _logBtn.layer.cornerRadius = 12;
        _logBtn.titleLabel.textColor = UIColor.whiteColor;
        [_logBtn setTitle:@"同意并登录" forState:UIControlStateNormal];
        _logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        [_logBtn setBackgroundColor:[UIColor colorWithRed:0.15 green:0.85 blue:0.15 alpha:1.0]];
        [_logBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _logBtn;
}


- (void)addAllSubview {
    [self addSubview:self.titleLab];
    [self addSubview:self.accountLab];
    [self addSubview:self.passWordLab];
    [self addSubview:self.accountField];
    [self addSubview:self.passWordField];
    [self addSubview:self.partingLine1];
    [self addSubview:self.partingLine2];
    [self addSubview:self.logBtn];
}

#pragma mark - Masonry
//用于设置所有控件的Masonry约束
- (void)setMasonry {
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0);
        make.top.mas_offset(100);
        make.height.mas_offset(60);
        make.width.mas_offset(130);
    }];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(220);
        make.left.mas_offset(30);
        make.height.mas_offset(40);
        make.width.mas_offset(55);
    }];
    [self.passWordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountLab).mas_offset(90);
        make.left.mas_equalTo(self.accountLab).mas_offset(0);
        make.size.mas_equalTo(self.accountLab).mas_offset(0);
    }];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.accountLab).mas_offset(0);
        make.left.mas_equalTo(self.accountLab.mas_right).mas_offset(30);
        make.width.mas_offset(150);
        make.height.mas_offset(50);
    }];
    
    [self.passWordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passWordLab).mas_offset(0);
        make.left.mas_equalTo(self.accountField).mas_offset(0);
        make.size.mas_equalTo(self.accountField).mas_offset(0);
    }];
    
    [self.partingLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).mas_offset(0);
        make.top.mas_equalTo(self.accountLab.mas_bottom).mas_offset(8);
        make.height.mas_offset(5);
        make.width.mas_equalTo(self).mas_offset(-20);
    }];
    [self.partingLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).mas_offset(0);
        make.top.mas_equalTo(self.passWordLab.mas_bottom).mas_offset(8);
        make.height.mas_offset(5);
        make.width.mas_equalTo(self).mas_offset(-20);
    }];
    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).mas_offset(0);
        make.bottom.mas_equalTo(self).mas_offset(-120);
        make.height.mas_offset(60);
        make.width.mas_offset(180);
    }];
}





@end
