//
//  SignalValue.h
//  S-MixControl
//
//  Created by aa on 15/12/3.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SignalValue : NSObject
@property (nonatomic ,strong)NSString *SignalIpStr; //记录IP地址

@property (nonatomic ,assign)uint16_t  SignalPort; //记录端口号

@property (nonatomic ,assign)NSInteger Integer;
@property (nonatomic ,strong)NSMutableArray *GetMessage; //接收返回的数据
@property (nonatomic ,strong)NSMutableArray *secene;
@property (nonatomic ,strong)NSMutableArray *ProSignal;
@property (nonatomic ,assign)NSInteger ProCount; //记录选择的类型；

//创建单例
+ (SignalValue *)ShareValue;







@end
