//
//  BaseViewController+categary.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/7/7.
//  Copyright © 2016年 times. All rights reserved.
//

#import "BaseViewController+categary.h"

@implementation BaseViewController (categary)

- (id)objectAtIndex:(NSUInteger)index
{
    if (index >= [self.SaveSenceArray count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
