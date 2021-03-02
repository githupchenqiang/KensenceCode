//
//  DataBase.h
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/16.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataBase : NSObject
+(sqlite3 *)openDB;
+(void)closeDB;

@end
