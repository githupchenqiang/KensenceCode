//
//  SeleDataManager.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/6/16.
//  Copyright © 2016年 times. All rights reserved.
//

#import "SeleDataManager.h"
#import <sqlite3.h>
#import "DataHelp.h"

#define  LogMessage(level,...)  NSLog(__VA_ARGS__)

@implementation SeleDataManager
static sqlite3 *Manager;

+(void)CreatTable{
    //打开数据库
    //取到沙盒
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"Name"];
    const char *CfileName = fileName.UTF8String;
    
    int result = sqlite3_open(CfileName, &Manager);
    if (result == SQLITE_OK) {
      
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_name (id integer PRIMARY KEY AUTOINCREMENT,type text NOT NULL ,Value text NOT NULL);";
        char *erroMsg = NULL;
        sqlite3_exec(Manager, sql, NULL, NULL, &erroMsg);
        if (result == SQLITE_OK) {
//            LogMessage(1,@"创表成功");
        }else
        {
            LogMessage(1,@"创表失败");
        }
    }else
    {
        LogMessage(1,@"打开数据库失败");
    }
 
}

+(void)InsertIntoTemp:(NSString *)temp Value:(NSString *)VAlueString{
   
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_name (type,Value) VALUES ('%@','%@');",temp,VAlueString];
    char *erroMsg = NULL;
    sqlite3_exec(Manager, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
    LogMessage(1,@"插入失败");
    }else
    {
//        LogMessage(1,@"插入成功");
        
    }

    
}


+(NSArray *)SelectTemp:(NSString *)temp Value:(NSString *)ValueString{
   
    NSMutableArray *mutArra = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT type,Value FROM t_name WHERE type = '%@' and Value like '%%%@%%';",temp,ValueString];
    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;
    if ( sqlite3_prepare_v2(Manager, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询语句没问题");
        mutArra = [NSMutableArray array];
        [DataHelp shareData].SelectArray  = [NSMutableArray array];
         
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            
            sqlite3_column_int(stmt, 1);
            const unsigned char *key = sqlite3_column_text(stmt,0);
            const unsigned char *svalue = sqlite3_column_text(stmt, 1);
            NSString *string = [NSString stringWithUTF8String:(const char *)key];
            NSString *obj = [NSString stringWithUTF8String:(const char *)svalue];
         
            [mutArra addObject:obj];
            [[DataHelp shareData].SelectArray addObject:obj];
       
            
        }
    }else
    {
        LogMessage(1,@"查询有问题");
    }
    
    return mutArra;
    
}

+(void)DeleteWithTemp:(NSString *)temp  Value:(NSString *)ValueString{
    
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_name WHERE  type = '%@' and Value = '%@'",temp,ValueString];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(Manager, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                LogMessage(1,@"删除成功");
            }
            LogMessage(1,@"删除失败");
            
        }
    }
}

+(void)DeleteWithTemp:(NSString *)temp {
    
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_name WHERE  type = '%@'",temp];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(Manager, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                LogMessage(1,@"删除成功");
            }
            LogMessage(1,@"删除失败");
            
        }
    }
}
@end
