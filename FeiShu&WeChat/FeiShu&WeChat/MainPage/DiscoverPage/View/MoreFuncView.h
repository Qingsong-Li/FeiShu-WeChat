//
//  MoreFuncView.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreFuncView : UIView

@property (nonatomic, strong) UIButton *likesBtn;

@property (nonatomic, strong) UIButton *commentsBtn;

/// 点赞和评论之间的分隔线
@property (nonatomic, strong) UIView *separator;

/// 点赞文字
@property (nonatomic, strong) UILabel *likeLab;

/// 评论文字
@property (nonatomic, strong) UILabel *commentLab;

/// 点赞爱心
@property (nonatomic, strong) UIImageView *likeImageView;

/// 评论方框图案
@property (nonatomic, strong) UIImageView *commentImageView;

@end

NS_ASSUME_NONNULL_END
