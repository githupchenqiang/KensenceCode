//
//  DataBase.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/16.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "DataBase.h"
#define FILE_NAME @"dataBase.sqlite"
static sqlite3 *db = nil;

@implementation DataBase
//打开数据库
+(sqlite3 *)openDB
{
    //打开数据库
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"Name"];
    const char *cfileName = fileName.UTF8String;
    int result = sqlite3_open(cfileName, &db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //创建表
        
        const char *sql = "CREATE TABLE IF NOT EXISTS t_name (id integer PRIMARY KEY AUTOINCREMENT,Temp integer NOT NULL,type integer NOT NULL,Key text NOT NULL, Text text NOT NULL);";
        char *erroMsg = NULL;
        sqlite3_exec(db, sql, NULL, NULL, &erroMsg);
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

   
    return db;
    
}

+(void)closeDB
{
    sqlite3_close(db);
    db = nil;
    
}


@end
