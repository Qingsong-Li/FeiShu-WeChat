//
//  RegisterView.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/24.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterView : UIView

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *accountLab;
@property(nonatomic,strong) UILabel *passWordLab;
@property(nonatomic,strong) UITextField *accountField;
@property(nonatomic,strong) UITextField *passWordField;
@property(nonatomic,strong) UIImageView *partingLine1;
@property(nonatomic,strong) UIImageView *partingLine2;
@property(nonatomic,strong) UIButton *logBtn;

@end

NS_ASSUME_NONNULL_END
