//
//  searchCell.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/15.
//

#import "SearchCell.h"

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
        [self.contentView addSubview:self.searchField];
    }
    return self;
}

- (UITextField *)searchField{
    if(_searchField == nil){
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.contentView.bounds.size.width-10, self.contentView.bounds.size.height-10)];
        _searchField.placeholder = @"     🔍  学号/姓名";
        _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _searchField;
}

@end
