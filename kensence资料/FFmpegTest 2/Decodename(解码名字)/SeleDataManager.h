//
//  SeleDataManager.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/6/16.
//  Copyright © 2016年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeleDataManager : NSObject
@property(nonatomic,assign)NSInteger NUmber;
@property(nonatomic,strong)NSMutableArray *SelectArray;


+(void)CreatTable;

+(void)InsertIntoTemp:(NSString *)temp Value:(NSString *)VAlueString;

+(NSArray *)SelectTemp:(NSString *)temp Value:(NSString *)ValueString;

+(void)DeleteWithTemp:(NSString *)temp Value:(NSString *)ValueString;
+(void)DeleteWithTemp:(NSString *)temp;
@end
