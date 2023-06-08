//
//  KeyChainManager.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/25.
//

#import "KeyChainManager.h"
#import "Security/Security.h"

@implementation KeyChainManager

//该类方法用于获取一个存储KeyChain的字典
+ (NSMutableDictionary *)getKeyChainQueryWithAccount:(NSString *)account{
    // 把该包的Identifier作为keychain的Service
    NSString *serviceName = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge  id)kSecClass];
    [query setObject:serviceName forKey:(__bridge id)kSecAttrService];
    [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    
    return query;
}

//该方法用于保存一对账号密码
+ (BOOL)savePassword:(NSString *)passWord AndAccount:(NSString *)account{
    NSMutableDictionary *query = [self getKeyChainQueryWithAccount:account];
    NSDate *passwordData = (NSDate *)[passWord dataUsingEncoding:NSUTF8StringEncoding];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    
    //标准操作，判断密码是否已经存在，存在则更新，不存在则创建。但本项目仅在本地保留一对账号密码，不对账号密码做增，删，改。
    if(status == errSecSuccess){
        NSDictionary *newDic = @{(__bridge id)kSecValueData:passwordData};
        status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)newDic);
        if(status == errSecSuccess){
            return YES;
        }
    }
    else if(status == errSecItemNotFound){
        [query setObject:passwordData forKey:(__bridge id)kSecValueData];
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        NSLog(@"%d",(int)status);
        if(status == errSecSuccess){
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getPasswordWithAccount:(NSString *)account{
    NSMutableDictionary *query = [self getKeyChainQueryWithAccount:account];
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    
    CFTypeRef  passwordData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &passwordData);
    
    if(status == errSecSuccess){
        NSDate *password = (__bridge NSDate*)passwordData;
        NSString *passwordStr = [[NSString alloc] initWithData:(NSData * _Nonnull)password encoding:NSUTF8StringEncoding];
        
        //释放内存，避免导致泄漏
        if(passwordData != nil){
            CFRelease(passwordData);
        }
        return passwordStr;
    }
    return nil;
}

@end
