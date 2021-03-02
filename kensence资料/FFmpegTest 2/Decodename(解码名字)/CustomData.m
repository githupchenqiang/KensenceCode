//
//  CustomData.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/5/23.
//  Copyright © 2016年 times. All rights reserved.
//

#import "CustomData.h"
#import <sqlite3.h>
#import "DataHelp.h"
#define UserNameString [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"]
@implementation CustomData
static sqlite3 *sql3;

+(void)CreatSenceTable
{
    
    
  
    
    
    
    //打开数据库
    //取到沙盒
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"CustomData"];
    const char *CfileName = fileName.UTF8String;
    
    int result = sqlite3_open(CfileName, &sql3);
    if (result == SQLITE_OK) {
        
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS Custom_table (id integer PRIMARY KEY AUTOINCREMENT,UserName text NOT NULL,Meeting text NOT NULL ,CustomRect text NOT NULL,tagNumber integer NOT NULL ,RName text NOT NULL, destchanid text NOT NULL , destdevid text NOT NULL);";
        char *erroMsg = NULL;
        sqlite3_exec(sql3, sql, NULL, NULL, &erroMsg);
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

+(void)InsertIntoUserName:(NSString *)UserName Meeting:(NSString *)Meeting ViewDict:(NSString *)CustomRect tagNumber:(int)TagNumber RName:(NSString *)RName destchanid:(NSString *)destch destdevid:(NSString *)destdevid

{
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Custom_table (UserName,Meeting,CustomRect,tagNumber,RName,destchanid,destdevid) VALUES ('%@','%@','%@','%d','%@','%@','%@');",UserName,Meeting,CustomRect,TagNumber,RName,destch,destdevid];
    char *erroMsg = NULL;
    sqlite3_exec(sql3, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
        printf("插入失败%s",erroMsg);
    }else
    {
        NSLog(@"插入成功");
        
        
    }

}


+(NSArray *)SelectName:(NSString *)UserName Meeting:(NSString *)Meeting CustomRct:(NSString *)CustomRect
{
    NSString *sql = [NSString stringWithFormat:@"SELECT UserName, Meeting,CustomRect,tagNumber,RName,destchanid,destdevid FROM Custom_table WHERE UserName = '%@'and Meeting = '%@' and CustomRect = '%@';",UserName,Meeting,CustomRect];

    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;

    if ( sqlite3_prepare_v2(sql3, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
        
            int tagNumber = sqlite3_column_int(stmt, 3);
            const unsigned char *RName = sqlite3_column_text(stmt, 4);
            const unsigned char *destchanid = sqlite3_column_text(stmt,5);
            const unsigned char *destdevid = sqlite3_column_text(stmt, 6);
            
            const unsigned char *Meeting = sqlite3_column_text(stmt, 1);
            NSString *MeetingStr = [NSString stringWithUTF8String:(const char *)Meeting];
            [DataHelp shareData].MeetingIndex = MeetingStr;
            NSString *string = [NSString stringWithUTF8String:(const char *)RName];
           
            NSString *Rdestchanid = [NSString stringWithUTF8String:(const char *)destchanid];
            
            NSString *Rdestdevid = [NSString stringWithUTF8String:(const char *)destdevid];
            if ([DataHelp shareData].CreatRView == YES) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",tagNumber] forKey:[NSString stringWithFormat:@"%@tagNumber",UserNameString]];
                [[NSUserDefaults standardUserDefaults]setObject:string forKey:[NSString stringWithFormat:@"%@RNameData",UserNameString]];
                [[NSUserDefaults standardUserDefaults]setObject:Rdestchanid forKey:[NSString stringWithFormat:@"%@Rdestchanid",UserNameString]];
                [[NSUserDefaults standardUserDefaults]setObject:Rdestdevid forKey:[NSString stringWithFormat:@"%@Rdestdevid",UserNameString]];
            
            }else  if ([DataHelp shareData].CreatRView == NO){
                 [DataHelp shareData].RnameData = string;
                [DataHelp shareData].destchanid = Rdestchanid;
                [DataHelp shareData].destdevid = Rdestdevid;
            }
            
            NSLog(@"查询语句没问题");
           
        }
    }else
    {
        NSLog(@"11查询有问题");

        
        
    }

    return nil;
    
}
+(void)DeleteWithName:(NSString *)UserName Meeting:(NSString *)Meeting tagNumber:(int)TagNumber
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_name WHERE UserName = '%@' and Meeting = '%@' and tagNumber = %d",UserName,Meeting,TagNumber];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(sql3, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }
            NSLog(@"删除失败");
        }
    }
}

+(void)deleteName:(NSString *)UserName Meeting:(NSString *)Meeting
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_name WHERE UserName = '%@', Meeting = '%@'",UserName,Meeting];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(sql3, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }
            NSLog(@"删除失败");
        }
    }

    
}








+ (NSArray *)SelectedMeeting:(NSString *)Meeting
{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT Meeting,CustomRect,tagNumber,RName,destchanid,destdevid FROM Custom_table WHERE Meeting = '%@';",Meeting];
    
    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;
   
    if ( sqlite3_prepare_v2(sql3, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            
//             const unsigned char *Rect = sqlite3_column_text(stmt, 1);
//            int tagNumber = sqlite3_column_int(stmt, 2);
//            const unsigned char *RName = sqlite3_column_text(stmt, 3);
//            const unsigned char *destchanid = sqlite3_column_text(stmt,4);
//            const unsigned char *destdevid = sqlite3_column_text(stmt, 5);
//            NSString *Rectstring = [NSString stringWithUTF8String:(const char *)Rect];
//            NSString *string = [NSString stringWithUTF8String:(const char *)RName];
//            NSString *Rdestchanid = [NSString stringWithUTF8String:(const char *)destchanid];
//            NSString *Rdestdevid = [NSString stringWithUTF8String:(const char *)destdevid];
            NSLog(@"查询语句没问题");
        }
    }else
    {
        NSLog(@"11查询有问题");

    }
    
    return nil;
    

    
}

- (void)dealloc
{
    
}


@end
