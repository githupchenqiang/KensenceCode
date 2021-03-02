//
//  CustomData.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/5/23.
//  Copyright © 2016年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomData : NSObject


+(void)CreatSenceTable;

+(void)InsertIntoUserName:(NSString *)UserName Meeting:(NSString *)Meeting ViewDict:(NSString *)CustomRect tagNumber:(int)TagNumber RName:(NSString *)RName destchanid:(NSString *)destch destdevid:(NSString *)destdevid ;

+(NSArray *)SelectName:(NSString *)UserName Meeting:(NSString *)Meeting CustomRct:(NSString *)CustomRect;

+(void)DeleteWithName:(NSString *)UserName Meeting:(NSString *)Meeting tagNumber:(int)TagNumber;

+(void)deleteName:(NSString *)UserName Meeting:(NSString *)Meeting;

//+ (NSArray *)SelectedName:(NSString *)UserName Meeting:(int)Meeting;







@end
