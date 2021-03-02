//
//  CustomSwitch.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/8/7.
//  Copyright © 2016年 times. All rights reserved.
//

#import "CustomSwitch.h"

@implementation CustomSwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
    
    
}

- (void)initWithFram:(CGRect)fram
{
    UIView *view = [[UIView alloc]initWithFrame:fram];
    view.layer.cornerRadius = view.frame.size.height/2;
    self.isOn = NO;
    view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
}






@end
