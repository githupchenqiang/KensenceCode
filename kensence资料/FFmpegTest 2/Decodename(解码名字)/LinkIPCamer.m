//
//  LinkIPCamer.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/8/9.
//  Copyright © 2016年 times. All rights reserved.
//

#import "LinkIPCamer.h"
#import "DataHelp.h"


@implementation LinkIPCamer
static sqlite3 *DB;

+ (void)creatTable
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"LinkIP"];
    const char *CfileName = fileName.UTF8String;
    int result = sqlite3_open(CfileName, &DB);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_LinkIP (id integer PRIMARY KEY AUTOINCREMENT,TDecoder integer NOT NULL, Rdecoder integer NOT NULL,Meeting integer NOT NULL,TIndex integer NOT NULL,Rindex integer NOT NULL,isConnect integer NOT NULL, IP text NOT NULL ,NetWidth text NOT NULL);";
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
+ (void)InsertTDecoder:(BOOL)decoder Rdecoder:(BOOL)Rdecoder Meeting:(NSInteger)Meeting TIndex:(NSInteger)Tindex Rindex:(NSInteger)Rindex  isConnect:(BOOL)isConnect  IP:(NSString *)IP NetWidth:(NSString *)Width
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_LinkIP (TDecoder, Rdecoder,Meeting,TIndex,Rindex, isConnect,IP,NetWidth) VALUES (%d,%d,%lu,%lu,%lu,%d,'%@','%@');",decoder,Rdecoder,(unsigned long)Meeting,(unsigned long)Tindex,(unsigned long)Rindex,isConnect,IP,Width];

    char *erroMsg = NULL;
    sqlite3_exec(DB, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
        printf("插入失败%s",erroMsg);
    }else
    {
        NSLog(@"插入成功");
    }
 }


+ (void)SeleTDecoder:(BOOL)decoder Rdecoder:(BOOL)Rdecoder Meeting:(NSInteger)Meeting TIndex:(NSInteger)Tindex Rindex:(NSInteger)Rindex
{
    NSString *sql = [NSString stringWithFormat:@"SELECT TDecoder,Rdecoder,Meeting,TIndex,Rindex,isConnect,IP,NetWidth FROM t_LinkIP WHERE TDecoder = %d and Rdecoder = %d and Meeting = %ld and TIndex = %ld and Rindex = %ld;",decoder,Rdecoder,(long)Meeting,(long)Tindex,(long)Rindex];

    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;
    
    if ( sqlite3_prepare_v2(DB, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            int isconnect = sqlite3_column_int(stmt, 5);
            const unsigned char *IPtext = sqlite3_column_text(stmt, 6);
            const unsigned char *PortText = sqlite3_column_text(stmt,7);
            
            [DataHelp shareData].IPtext = [NSString stringWithUTF8String:(const char *)IPtext];
            [DataHelp shareData].PortText = [NSString stringWithUTF8String:(const char *)PortText];
            [DataHelp shareData].isConnect = isconnect;

        }
    }else
    {
        NSLog(@"查询失败");
    }
}
+ (void)delectTDecoder:(BOOL)decoder Rdecoder:(BOOL)Rdecoder Meeting:(NSInteger)Meeting TIndex:(NSInteger)Tindex Rindex:(NSInteger)Rindex
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_LinkIP WHERE TDecoder = %d and Rdecoder = %d and Meeting = %ld and TIndex = %ld and Rindex = %ld",decoder,Rdecoder,(long)Meeting,(long)Tindex,(long)Rindex];
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
