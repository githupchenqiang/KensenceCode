//
//  Model.h
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/16.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic ,assign)NSInteger ID;
@property (nonatomic ,assign)NSInteger Temp;
@property (nonatomic ,assign)NSInteger Type;
@property (nonatomic ,copy)NSString *Key;
@property (nonatomic ,copy)NSString *Text;

@end
