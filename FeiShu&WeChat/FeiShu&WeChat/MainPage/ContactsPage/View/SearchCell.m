//
//  searchCell.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/15.
//

#import "SearchCell.h"
#import "Masonry.h"

@implementation SearchCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor systemGray6Color];
        [self.contentView addSubview:self.searchField];
        [self.contentView addSubview:self.searchBtn];
        
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.searchField.mas_right).mas_offset(15);
            make.top.mas_equalTo(self.searchField).mas_offset(0);
            make.size.mas_offset(30);
        }];
    }
    
    return self;
}

- (UITextField *)searchField{
    if(_searchField == nil){
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(55, 20, self.contentView.bounds.size.width-50, self.contentView.bounds.size.height-10)];
        _searchField.placeholder = @"               输入姓名以查找      ";
        _searchField.backgroundColor = [UIColor whiteColor];
        _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchField;
}

- (UIButton *)searchBtn{
    if(_searchBtn == nil){
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(clickTheBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (void)clickTheBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(searchContact)]) {
        [self.delegate searchContact];
    }
}

@end
