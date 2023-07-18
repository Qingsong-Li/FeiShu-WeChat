//
//  MomentModel.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/14.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MomentModel : NSObject


@property(copy,nonatomic) NSString *name;
@property(copy,nonatomic) NSString *avatar;
@property(copy,nonatomic) NSString *text;
@property(strong,nonatomic) NSMutableArray *images;
@property(copy,nonatomic) NSString *time;
@property(strong,nonatomic) NSMutableArray *comments;
@property(strong,nonatomic) NSMutableArray *likes;
@property(nonatomic) BOOL liked;

-(instancetype) momentModelWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
