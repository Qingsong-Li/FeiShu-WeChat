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

+ (void)getExternalContactsAndStore{
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
@end
