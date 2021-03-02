//
//  InternationalControl.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/6/14.
//  Copyright © 2016年 times. All rights reserved.
//

#import "InternationalControl.h"

@implementation InternationalControl
static NSBundle *bundle = nil;

+ (NSBundle *)bundle
{
    return bundle;
    
}

+ (void)initUserLanguage
{
    NSUserDefaults *def  = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if (string.length == 0) {
        //获取系统当前语言版本
        NSArray *languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        string  = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle]pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
 
}

+ (void)setUserLanguage:(NSString *)language
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    
    [def synchronize];
}

+(NSString *)UserLanguage
{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:@"userLanguage"];
    
    return language;
    
    
}



@end
