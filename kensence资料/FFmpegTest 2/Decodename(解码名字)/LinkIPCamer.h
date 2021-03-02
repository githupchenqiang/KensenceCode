//
//  LinkIPCamer.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/8/9.
//  Copyright © 2016年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LinkIPCamer : NSObject
+ (void)creatTable;
+ (void)InsertTDecoder:(BOOL)decoder Rdecoder:(BOOL)Rdecoder Meeting:(NSInteger)Meeting TIndex:(NSInteger)Tindex Rindex:(NSInteger)Rindex  isConnect:(BOOL)isConnect  IP:(NSString *)IP NetWidth:(NSString *)Width;
+ (void)SeleTDecoder:(BOOL)decoder Rdecoder:(BOOL)Rdecoder Meeting:(NSInteger)Meeting TIndex:(NSInteger)Tindex Rindex:(NSInteger)Rindex;
+ (void)delectTDecoder:(BOOL)decoder Rdecoder:(BOOL)Rdecoder Meeting:(NSInteger)Meeting TIndex:(NSInteger)Tindex Rindex:(NSInteger)Rindex;

@end
