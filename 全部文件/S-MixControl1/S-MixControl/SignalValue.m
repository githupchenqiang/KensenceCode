//
//  SignalValue.m
//  S-MixControl
//
//  Created by aa on 15/12/3.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "SignalValue.h"

@implementation SignalValue


+(SignalValue *)ShareValue
{
    static SignalValue *aValue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      aValue = [SignalValue new];
       
    });
    
    return aValue;

}

- (NSMutableArray *)GetMessage
{
    if (_GetMessage == nil) {
        _GetMessage = [NSMutableArray array];
    }
    
    return _GetMessage;
}


//- (NSMutableArray *)secene
//{
//    if (_secene == nil) {
//        _secene = [NSMutableArray array];
//        
//    }
//    
//    return _secene;
//    
//    
//}










@end
