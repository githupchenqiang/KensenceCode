//
//  NSArray+CQCategory.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/4/5.
//  Copyright © 2016年 times. All rights reserved.
//

#import "NSArray+CQCategory.h"

@implementation NSArray (CQCategory)

- (id)objectAtIndex:(NSUInteger)index
    {
        if (index >= [self count]) {
            return nil;
        }
        
        id value = [self objectAtIndex:index];
        if (value == [NSNull null]) {
            return nil;
        }
        return value;
    }
    



@end
