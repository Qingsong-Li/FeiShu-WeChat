//
//  ContactsCell.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactsCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImg;
@property(nonatomic,strong) UILabel *nameLab;
@property(nonatomic,strong) UIView *separator;

- (void)setHeadImgWithName:(NSString *) name;

@end

NS_ASSUME_NONNULL_END
