//
//  ChatCell.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *message;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIImageView *avatar;


@end

NS_ASSUME_NONNULL_END
