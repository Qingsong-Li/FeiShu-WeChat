//
//  PublishMomentViewController.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/16.
//

#import <UIKit/UIKit.h>
#import "PublishPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublishMomentViewController : UIViewController

@property(strong,nonatomic) PublishPageView *publishView;
@property(strong,nonatomic) NSMutableArray *publishPhotos;

@end

NS_ASSUME_NONNULL_END
