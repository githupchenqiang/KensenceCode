
//
//  TViewModel.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/5/17.
//  Copyright © 2016年 times. All rights reserved.
//

#import "TViewModel.h"

@implementation TViewModel


//处理关键字异常
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        value = self.srcdiv;
    }
 
}



@end
