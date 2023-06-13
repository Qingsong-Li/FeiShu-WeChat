//
//  ContactsModel.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactsModel : NSObject

@property(nonatomic,copy) NSString *stunum;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *classnum;
@property(nonatomic,copy) NSString *major;
@property(nonatomic,copy) NSString *depart;
@property(nonatomic,copy) NSString *grade;

@end

NS_ASSUME_NONNULL_END
