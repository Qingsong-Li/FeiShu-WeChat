//
//  StudentDataManager.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/8.
//

#import "StudentDataManager.h"
#import "FMDB.h"
#import "AFHTTPSessionManager.h"


@implementation StudentDataManager

+ (void)getExternalContactsAndStoreInLocal{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    [manager GET:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-text/search/people" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *students = responseObject[@"data"];
        NSString *path = NSTemporaryDirectory();
        NSString *dbPath = [path stringByAppendingPathComponent:@"Student.db"];
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        if ([database open]) {
            [database executeUpdate:@"CREATE TABLE IF NOT EXISTS students (stunum TEXT PRIMARY KEY, name TEXT, gender TEXT, classnum TEXT, major TEXT, depart TEXT, grade TEXT)"];
            for (NSDictionary *studentDict in students) {
                NSString *stunum = studentDict[@"stunum"];
                NSString *name= studentDict[@"name"];
                NSString *gender = studentDict[@"gender"];
                NSString *classnum = studentDict[@"classnum"];
                NSString *major = studentDict[@"major"];
                NSString *depart = studentDict[@"depart"];
                NSString *grade = studentDict[@"grade"];
                [database executeUpdate:@"INSERT INTO students (stunum,name,gender,classnum,major,depart,grade) VALUES (?, ?,?,?,?,?,?)", stunum,name,gender,classnum,major,depart,grade];
            }
                [database close];
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"getting error");
        }];
}

+ (ContactsModel *)getStudentWithStunum:(NSString *)stunum{
    ContactsModel *model = [[ContactsModel alloc] init];
    NSString *path = NSTemporaryDirectory();
    NSString *dbPath = [path stringByAppendingPathComponent:@"Student.db"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if([database open]){
        NSString *string = [NSString stringWithFormat:@"SELECT * FROM students WHERE stunum = '%@'",stunum];
        FMResultSet *result = [database executeQuery:string];
        if (result) {
            // 查询成功
            while([result next]){
                [model setValue:[result stringForColumn:@"stunum"] forKey:@"stunum"];
                [model setValue:[result stringForColumn:@"name"] forKey:@"name"];
                [model setValue:[result stringForColumn:@"gender"] forKey:@"gender"];
                [model setValue:[result stringForColumn:@"classnum"] forKey:@"classnum"];
                [model setValue:[result stringForColumn:@"major"] forKey:@"major"];
                [model setValue:[result stringForColumn:@"depart"] forKey:@"depart"];
                [model setValue:[result stringForColumn:@"grade"] forKey:@"grade"];
            }
            [database close];
            return model;
        } else {
            // 查询失败
            NSLog(@"Failed to execute query: %@", [database lastErrorMessage]);
            [database close];
            return nil;
        }
    }else{
        NSLog(@"fail to open");
    }
    [database close];
    return nil;
 

}

+ (BOOL)saveToLocalWithContact:(ContactsModel *)model{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"Student.db"];
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if([database open]){
        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS students (stunum TEXT PRIMARY KEY NOT NULL, name TEXT, gender TEXT, classnum TEXT, major TEXT, depart TEXT, grade TEXT)"];
        //在往本地保存数据之前应先检查该学生数据是否在本地已存在
        NSString *string = [NSString stringWithFormat:@"SELECT * FROM students WHERE stunum = '%@'",model.stunum];
        FMResultSet *result = [database executeQuery:string];
        //当该数据不存在时才执行插入语句
        if(![result next]){
            [database executeUpdate:@"INSERT INTO students (stunum,name,gender,classnum,major,depart,grade) VALUES (?, ?,?,?,?,?,?)", model.stunum,model.name,model.gender,model.classnum,model.major,model.depart,model.grade];
            [database close];
            return YES;
        }else{
            [database close];
            return NO;
        }
    }
    [database close];
    return NO;
}

+ (NSDictionary *)initAllLocalContact{
    //创建一个有26个从A到Z的键的字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (char c = 'A'; c <= 'Z'; c++) {
        NSString *key = [NSString stringWithFormat:@"%c", c];
        NSMutableArray *value = [NSMutableArray array];
        [dic setObject:value forKey:key];
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [path stringByAppendingPathComponent:@"Student.db"];
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if([database open]){
        FMResultSet *result = [database executeQuery:@"SELECT * FROM students"];
        while([result next]){
            ContactsModel *model = [[ContactsModel alloc] init];
            [model setValue:[result stringForColumn:@"stunum"] forKey:@"stunum"];
            [model setValue:[result stringForColumn:@"name"] forKey:@"name"];
            [model setValue:[result stringForColumn:@"gender"] forKey:@"gender"];
            [model setValue:[result stringForColumn:@"classnum"] forKey:@"classnum"];
            [model setValue:[result stringForColumn:@"major"] forKey:@"major"];
            [model setValue:[result stringForColumn:@"depart"] forKey:@"depart"];
            [model setValue:[result stringForColumn:@"grade"] forKey:@"grade"];
            
            NSString *firstChar = [[model valueForKey:@"name"] substringToIndex:1]; // 获取第一个字
            NSMutableString *mutableString = [firstChar mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, NO); // 转换为拼音
            NSString *firstCharacter = [[mutableString substringToIndex:1] uppercaseString]; // 获取拼音首字母并转为大写
            [[dic mutableArrayValueForKey:firstCharacter] addObject:model];
        }
    }
    return dic;
}
@end
