//
//  MyTime.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate(Day)

// 得到今天日期
+ (NSDate *)today;
// 得到今天的day
- (NSString *)day;
// 得到今天的hour
- (NSString *)hour;
// 得到今天的min
- (NSString *)min;
// 得到今天的month
- (NSString *)month;
//得到详细时间
- (NSString *)detail_time;
// 翻译为中文
- (NSString *)transformChinese;

@end

NS_ASSUME_NONNULL_END
