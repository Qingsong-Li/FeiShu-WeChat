//
//  ChatModel.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *date;

- (instancetype)ChatModelWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
