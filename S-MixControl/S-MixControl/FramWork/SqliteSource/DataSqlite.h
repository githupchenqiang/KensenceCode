//
//  DataSqlite.h
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/8/18.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataSqlite : NSObject
+(void)CreatDataSource;
+(void)InsertIntoType:(NSInteger)type NumberKey:(NSInteger)numberKey isConnect:(NSInteger)isConnect IPString:(NSString *)IpString valueWidth:(NSString *)valueWidth;
+(void)SelectByType:(NSInteger)type numberKey:(NSInteger)numberKey;
+(void)DeleteByType:(NSInteger)type numberKey:(NSInteger)numberKey;

@end
