//
//  AllCamearArray.m
//  KensenceCame
//
//  Created by chenq@kensence.com on 16/3/21.
//  Copyright © 2016年 times. All rights reserved.
//

#import "AllCamearArray.h"

@implementation AllCamearArray

+(AllCamearArray *)ShareCamearArray
{
    static AllCamearArray *CamearArray = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CamearArray = [AllCamearArray new];
    });
    return CamearArray;
}

- (NSMutableArray *)CamearArray
{
    if (_CamearArray == nil) {
        _CamearArray = [NSMutableArray array];
        
    }
    return _CamearArray;
    
}



@end
