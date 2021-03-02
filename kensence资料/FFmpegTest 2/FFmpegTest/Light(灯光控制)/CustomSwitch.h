//
//  CustomSwitch.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/8/7.
//  Copyright © 2016年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSwitch : UIView
@property (nonatomic ,strong)UIColor *BackColor;
@property (nonatomic ,strong)UIColor *tintColot;
@property (nonatomic ,assign)BOOL isOn;
@property (nonatomic ,strong)UIImageView *OneImage;
@property (nonatomic ,strong)UIImageView *OfImage;

- (void)initWithFram:(CGRect)fram;
- (void)setOn:(BOOL)on animation:(BOOL)animation;
- (void)setOnImageview:(CGRect)OnImageview;
- (void)setOFFImageview:(CGRect)OFFImageview;




@end
