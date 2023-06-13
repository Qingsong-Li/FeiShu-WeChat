//
//  StudentDataManager.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/8.
//

#import <Foundation/Foundation.h>
#import "ContactsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentDataManager : NSObject

+ (void)getExternalContactsAndStoreInLocal;//获取到所有外部联系人并保存在Tmp文件夹下
+ (ContactsModel *)getStudentWithStunum:(NSString *)stunum;//根据学号查询一个外部联系人
+ (BOOL)saveToLocalWithContact:(ContactsModel *)model;//保存联系人到本地，包含重复判断
+ (NSMutableArray<ContactsModel *> *)initAllLoaclContact;//初始化所有的本地联系人数据

@end



NS_ASSUME_NONNULL_END
