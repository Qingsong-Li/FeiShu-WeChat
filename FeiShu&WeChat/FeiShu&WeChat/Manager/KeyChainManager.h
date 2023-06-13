//
//  KeyChainManager.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


//该类为自定义封装的一个管理类，其包含两个类方法，可以根据传入的账号密码使用KeyChain进行保存，或者根据传入的账号返回存在的密码
@interface KeyChainManager : NSObject

+(BOOL)savePassword:(NSString *)passWord AndAccount:(NSString *)account;

+(NSString *)getPasswordWithAccount:(NSString *)account;

@end

NS_ASSUME_NONNULL_END
