//
//  MomentModel.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/7/14.
//

#import "MomentModel.h"



@interface MomentModel () 

@end

@implementation MomentModel


- (instancetype)momentModelWithDic:(NSDictionary *)dic{
//    self.name = dic[@"name"];
//    self.avatar = dic[@"avatar"];
//    self.text = dic[@"text"];
//    self.comments = dic[@"comments"];
//    self.likes = dic[@"likes"];
//    self.time = dic[@"time"];
//    self.liked = dic[@"liked"];
//    //自己的Moment数
//    if([self.name isEqualToString:@"Double E"]){
////        self.images = [NSMutableArray array];
////        NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"images"]];
////        for(NSData *imageData in array){
////            [self.images addObject:imageData];
////        }
//        self.images = dic[@"images"];
//    }
//    //别人的Moments数据
//    else{
//        self.images = dic[@"images"];
//    }
    [self setValuesForKeysWithDictionary:dic];
    return self;
}

@end
