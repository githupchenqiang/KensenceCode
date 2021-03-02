//
//  SenceData.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/6/1.
//  Copyright © 2016年 times. All rights reserved.
//

#import "SenceData.h"
#import <sqlite3.h>
#import "DataHelp.h"

#define UserNameString [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"]

@implementation SenceData
static sqlite3 *db;
//保存场景的table
+(void)CreatSenceTable
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"senceName"];
    const char *CfileName = fileName.UTF8String;
    int result = sqlite3_open(CfileName, &db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_SenceTable (id integer PRIMARY KEY AUTOINCREMENT,NameOfUser text NOT NULL,PicTag integer NOT NULL,Meeting text NOT NULL,Viewtag integer NOT NULL, SenceNumber integer NOT NULL ,SenceR integer NOT NULL,TLinkTag integer NOT NULL,ViewRect text NOT NULL,RName text NOT NULL,DesVid text NOT NULL,Desch text NOT NULL);";
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
 
    
    NSObject *model;
    
    [[NSUserDefaults standardUserDefaults]setObject:model forKey:@"model"];
}

//创建场景的插入语句
+(void)InsertIntoUserName:(NSString *)NameOfUser ViewTag:(NSInteger)PicTag Meeting:(NSString *)Meeting TViewtage:(NSInteger)Viewtag Temp:(NSInteger)SenceNumber SenceR:(NSInteger)senceR Ttag:(NSInteger)TLinkTag Rect:(NSString *)ViewRect RName:(NSString *)Name DesVid:(NSString *)desvid Desch:(NSString *)desch
{
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_SenceTable (NameOfUser, PicTag,Meeting,Viewtag,SenceNumber,SenceR,TLinkTag,ViewRect,RName,DesVid,Desch) VALUES ('%@',%ld,'%@',%ld,%ld,%ld,%ld,'%@','%@','%@','%@');",NameOfUser,PicTag,Meeting,Viewtag,SenceNumber,senceR,TLinkTag,ViewRect,Name,desvid,desch];
    char *erroMsg = NULL;
    //    sqlite3_stmt *statement;
    
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &erroMsg);
    //    sqlite3_bind_blob(statement, 3, [imageData bytes],[imageData length], SQLITE_TRANSIENT);
    //    sqlite3_step(statement);
    
    if (erroMsg) {
        printf("插入失败%s",erroMsg);
    }else
    {
        NSLog(@"插入成功");
    }
    
}

//保存场景的查询语句
+(NSArray *)UserName:(NSString *)NameOfUser SelectViewTag:(NSInteger)PicTag
{
    
    NSMutableArray *mutArra = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT NameOfUser,PicTag,Meeting,Viewtag,SenceNumber,SenceR,TLinkTag,ViewRect,RName,DesVid,Desch FROM t_SenceTable WHERE NameOfUser = '%@' and PicTag = %ld;",NameOfUser,PicTag];
    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;

    
    SenceData *dataHelp = [SenceData new];
    dataHelp.MeetingNumber = [NSMutableArray array];
    dataHelp.ViewTag = [NSMutableArray array];
    dataHelp.SenceNumberArray = [NSMutableArray array];
    dataHelp.SenceRArray = [NSMutableArray array];
    dataHelp.TLinkTagArray = [NSMutableArray array];
    dataHelp.RnameArray = [NSMutableArray array];
    dataHelp.ViewaRectArray = [NSMutableArray array];
    dataHelp.DesvidArray = [NSMutableArray array];
    dataHelp.DeschArray = [NSMutableArray array];
    
    if ( sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        mutArra = [NSMutableArray array];
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_column_int(stmt, 1);
            
            const unsigned char *MeetingNUmber = sqlite3_column_text(stmt, 2);
            NSInteger Viewtag = sqlite3_column_int(stmt, 3);
            NSInteger SenceNumber = sqlite3_column_int(stmt,4);
            NSInteger SenceR = sqlite3_column_int(stmt, 5);
            NSInteger TLinkTag = sqlite3_column_int(stmt,6);
            
            const unsigned char *ViewRect = sqlite3_column_text(stmt, 7);
            const unsigned char *RName = sqlite3_column_text(stmt, 8);
            const unsigned char *DesVid = sqlite3_column_text(stmt, 9);
            const unsigned char *Desch = sqlite3_column_text(stmt,10);
            
            NSString *MeetingStr = [NSString stringWithUTF8String:(const char *)MeetingNUmber];
            NSString *ViewRectString = [NSString stringWithUTF8String:(const char *)ViewRect];
            NSString *RNameString = [NSString stringWithUTF8String:(const char *)RName];
            NSString *DesVidString = [NSString stringWithUTF8String:(const char *)DesVid];
            NSString *DeschString = [NSString stringWithUTF8String:(const char *)Desch];
            NSString *Meetingstring = [NSString stringWithUTF8String:(const char *)MeetingNUmber];
            
            [dataHelp.ViewTag addObject:[NSNumber numberWithInteger:Viewtag]];
            [dataHelp.MeetingNumber addObject:Meetingstring];
            [dataHelp.SenceNumberArray addObject:[NSNumber numberWithInteger:SenceNumber]];
            [dataHelp.SenceRArray addObject:[NSNumber numberWithInteger:SenceR]];
            [dataHelp.TLinkTagArray addObject:[NSNumber numberWithInteger:TLinkTag]];
            [dataHelp.ViewaRectArray addObject:ViewRectString];
            [dataHelp.RnameArray addObject:RNameString];
            [dataHelp.DesvidArray addObject:DesVidString];
            [dataHelp.DeschArray addObject:DeschString];
            [DataHelp shareData].MeetingIndex = MeetingStr;
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.ViewTag forKey:[NSString stringWithFormat:@"%@ViewTagHelp",UserNameString]];
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.SenceNumberArray forKey:[NSString stringWithFormat:@"%@SenceNumberHelp",UserNameString]];
            
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.SenceRArray forKey:[NSString stringWithFormat:@"%@TLinkTagHelp",UserNameString]];
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.TLinkTagArray forKey:[NSString stringWithFormat:@"%@senceRHelp",UserNameString]];
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.ViewaRectArray forKey:[NSString stringWithFormat:@"%@ViewRectHelp",UserNameString]];
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.RnameArray forKey:[NSString stringWithFormat:@"%@RNameHelp",UserNameString]];
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.DesvidArray forKey:[NSString stringWithFormat:@"%@DesVidHelp",UserNameString]];
            [[NSUserDefaults standardUserDefaults]setObject:dataHelp.DeschArray forKey:[NSString stringWithFormat:@"%@DeschHelp",UserNameString]];

        }
        
        
        
        //创建一个通知
        NSDictionary *DictViewTag = @{@"DictViewTag":dataHelp.ViewTag};
        NSDictionary *dictSenceNumber = @{@"senceNUmberData":dataHelp.SenceNumberArray};
        NSDictionary *dictSenceRArray = @{@"SenceRArrayData":dataHelp.SenceRArray};
        NSDictionary *dictTLinkTagArray = @{@"TLinkTagArrayData":dataHelp.TLinkTagArray};
        NSDictionary *dictViewaRectArray = @{@"ViewaRectArrayData":dataHelp.ViewaRectArray};
        NSDictionary *dictRNamearray = @{@"RNamearrayData":dataHelp.RnameArray};
        NSDictionary *dictDesvidArray = @{@"DesvidArrayData":dataHelp.DesvidArray};
        NSDictionary *dictDeschArray = @{@"DeschArrayData":dataHelp.DeschArray};
        
        NSMutableArray *mutArratData = [NSMutableArray array];
        [mutArratData addObject:DictViewTag];
        [mutArratData addObject:dictSenceNumber];
        [mutArratData addObject:dictSenceRArray];
        [mutArratData addObject:dictTLinkTagArray];
        [mutArratData addObject:dictViewaRectArray];
        [mutArratData addObject:dictRNamearray];
        [mutArratData addObject:dictDesvidArray];
        [mutArratData addObject:dictDeschArray];
        
        NSMutableArray *channel = [[NSMutableArray alloc]init];
        
        [DataHelp shareData].MeetingDestchanid = [NSMutableArray array];
        [DataHelp shareData].MeetingDestdevid = [NSMutableArray array];
        [DataHelp shareData].MeetingRnameArray = [NSMutableArray array];
        
        
        NSInteger Meeting = 0;
        
        for (int i = 0; i < [DataHelp shareData].LocationArray.count; i++) {
            NSString *RName = [NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[i][@"id"]];
            if ([RName isEqualToString:[NSString stringWithFormat:@"%@",dataHelp.MeetingNumber[0]]]) {
                Meeting = i;
            }
        }
        for (NSDictionary *device in [DataHelp shareData].DeviceArray) {
            if ([device[@"type"]isEqualToString:@"RX"] && [device[@"location"][@"id"] isEqualToString:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[Meeting][@"id"]]]) {
                [[DataHelp shareData].MeetingDestdevid addObject:device[@"id"]];
                [[DataHelp shareData].MeetingRnameArray addObject:device[@"name"]];
                channel = device[@"channels"];
                for (NSDictionary *Dict in channel) {
                    [[DataHelp shareData].MeetingDestchanid addObject:Dict[@"id"]];
                }
            }
        }
        NSDictionary *dict = @{@"dataDict":mutArratData};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DataArray" object:nil userInfo:dict];
    }else
    {
        NSLog(@"查询有问题");
    }

    return mutArra;
}


//保存场景的删除
+(void)UserName:(NSString *)NameOfUser DeleteViewTag:(int)PicTag{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_SenceTable WHERE NameOfUser = '%@' and PicTag = %d",NameOfUser,PicTag];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }
            NSLog(@"删除失败");
        }
    }
 
}


+(void)UserName:(NSString *)NameOfUser DeleteViewTag:(NSInteger)PicTag  Meeting:(NSString *)Meeting Ttage:(NSInteger)tag Temp:(NSInteger)SenceNumber SenceR:(NSInteger)senceR
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_SenceTable WHERE NameOfUser = '%@', PicTag = %ld, Viewtag = %ld,SenceNumber = %ld,SenceR = %ld;",NameOfUser,PicTag,tag,SenceNumber,senceR];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }
            NSLog(@"删除失败");
            
        }
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



@end
