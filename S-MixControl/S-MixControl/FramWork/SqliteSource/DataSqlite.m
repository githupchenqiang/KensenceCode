//
//  DataSqlite.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/8/18.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "DataSqlite.h"
#import "SignalValue.h"

@implementation DataSqlite
static sqlite3 *DB;

+(void)CreatDataSource
{
    //打开数据库
    //取到沙盒
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"IPString"];
    const char *CfileName = fileName.UTF8String;
    
    int result = sqlite3_open(CfileName, &DB);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS Connect_table (id integer PRIMARY KEY AUTOINCREMENT,Type integer NOT NULL , numberKey integer NOT NULL ,isConnect integer NOT NULL, ipString text NOT NULL , ValueWidth text NOT NULL);";
        char *erroMsg = NULL;
        sqlite3_exec(DB, sql, NULL, NULL, &erroMsg);
        if (result == SQLITE_OK) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创建表失败");
        }
    }else
    {
        NSLog(@"打开数据库失败");
    }
    
}

+(void)InsertIntoType:(NSInteger)type NumberKey:(NSInteger)numberKey isConnect:(NSInteger)isConnect IPString:(NSString *)IpString valueWidth:(NSString *)valueWidth
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Connect_table (Type,numberKey,isConnect,ipString,ValueWidth) VALUES (%ld,%ld,%ld,'%@','%@');",(long)type,(long)numberKey,(long)isConnect,IpString,valueWidth];
    char *erroMsg = NULL;
    sqlite3_exec(DB, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
        printf("插入失败%s",erroMsg);
    }else
    {
        NSLog(@"插入成功");
    }
}

+(void)SelectByType:(NSInteger)type numberKey:(NSInteger)numberKey
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT Type,numberKey,isConnect,ipString,ValueWidth FROM Connect_table WHERE Type = %ld and numberKey = %ld;",(long)type,(long)numberKey];
    NSLog(@"%@",sql);
    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;
    if ( sqlite3_prepare_v2(DB, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询语句没问题");
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_column_int(stmt, 1);
            BOOL IsConnect = sqlite3_column_int(stmt, 2);
            const unsigned char *key = sqlite3_column_text(stmt, 3);
            const unsigned char *svalue = sqlite3_column_text(stmt, 4);
            NSString *string = [NSString stringWithUTF8String:(const char *)key];
            NSString *obj = [NSString stringWithUTF8String:(const char *)svalue];
            [SignalValue ShareValue].isConnect = IsConnect;
            [SignalValue ShareValue].IPstring = string;
            [SignalValue ShareValue].ValueString = obj;
        }
    }else
    {
        NSLog(@"查询有问题");
    }
}

+ (void)DeleteByType:(NSInteger)type numberKey:(NSInteger)numberKey
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Connect_table WHERE stemp = %ld and Type = %ld",(long)type,(long)numberKey];
    
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(DB, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }
            NSLog(@"删除失败");
            
        }
    }
}


@end
