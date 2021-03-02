//
//  InternationalControl.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/6/14.
//  Copyright © 2016年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalControl : NSObject
+ (NSBundle *)bundle; //获取当前资源文件

+ (void)initUserLanguage;//初始化语言文件
+ (NSString *)UserLanguage;//获取应用当前语言
+ (void)setUserLanguage:(NSString *)language; //设置当前语言


@end
