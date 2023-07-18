//
//  MomentTableViewCell.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/14.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

NS_ASSUME_NONNULL_BEGIN

@interface MomentTableViewCell : UITableViewCell

@property(strong,nonatomic) UIImageView *avatar;
@property(strong,nonatomic) UILabel *nameLab;
@property(strong,nonatomic) YYLabel *yyTextLab;
@property(strong,nonatomic) UILabel *timeLab;
@property(strong,nonatomic) UIButton *moreBtn;
@property(strong,nonatomic) UIButton *deleteBtn;
@property(strong,nonatomic) YYLabel *likeLab;
@property(strong,nonatomic) YYLabel *commentLab;
@property(strong,nonatomic) UIView *separateView;
@property(copy,nonatomic) NSArray *imagesArr;
@property(copy,nonatomic) NSArray *likesArr;
@property(copy,nonatomic) NSArray *commentsArr;
@property(nonatomic) BOOL liked;

- (void)addImagesToText ;
- (void)setLikeAndComment;
- (void)addDeleteBtn;

@end

NS_ASSUME_NONNULL_END
