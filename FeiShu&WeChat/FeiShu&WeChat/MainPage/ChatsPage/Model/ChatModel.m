//
//  ChatModel.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/6.
//

#import "ChatModel.h"

@implementation ChatModel

- (instancetype)ChatModelWithDic:(NSDictionary *)dic{
    [self setValue:dic[@"date"] forKey:@"date"];
    [self setValue:dic[@"text"] forKey:@"text"];
    [self setValue:dic[@"name"] forKey:@"name"];
    return self;
}



@end
