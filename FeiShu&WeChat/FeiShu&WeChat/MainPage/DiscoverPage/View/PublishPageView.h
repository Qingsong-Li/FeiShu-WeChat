//
//  PublishPageView.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/17.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublishPageView : UIView

/// 文本编辑框
@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong, nullable) NSMutableArray *photosArray;

/// 用于判断是否为满九宫格照片
@property (nonatomic) BOOL imageIsNine;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, strong) YYLabel *imagesLab;

/// 当文本编辑框内的默认内容
@property (nonatomic, strong) UILabel *defaultLab;

@property (nonatomic, strong) UIImageView *plusImage;

@end

NS_ASSUME_NONNULL_END
