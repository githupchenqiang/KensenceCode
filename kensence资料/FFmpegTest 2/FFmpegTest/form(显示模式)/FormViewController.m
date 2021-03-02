//
//  FormViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/25.
//  Copyright © 2016年 times. All rights reserved.
//

#import "FormViewController.h"
#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height

@interface FormViewController ()

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景图
    UIView *BacView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BacView.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:BacView];
    
    
    //HDMI格式
    UIButton *HDButton = [UIButton buttonWithType:UIButtonTypeSystem];
    HDButton.frame = CGRectMake(View4Width * 0.3, 0, View4Width * 0.08, View4Height * 0.04);
    HDButton.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
    [HDButton setTitle:@"HDMI" forState:UIControlStateNormal];
    HDButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [HDButton addTarget:self action:@selector(HDButtonAction:) forControlEvents:UIControlEventTouchDown];
    [BacView addSubview:HDButton];
    
    //DVI格式
    UIButton *DVIButton = [UIButton buttonWithType:UIButtonTypeSystem];
    DVIButton.frame = CGRectMake(View4Width * 0.3+View4Width * 0.08+20, 0, View4Width * 0.08, View4Height * 0.04);
    DVIButton.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
    [DVIButton setTitle:@"DVI" forState:UIControlStateNormal];
    DVIButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [DVIButton addTarget:self action:@selector(DVIButtonAction:) forControlEvents:UIControlEventTouchDown];
    [BacView addSubview:DVIButton];
    
    //cvbs格式
    UIButton *CVBSButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CVBSButton.frame = CGRectMake(View4Width * 0.3+View4Width * 0.08*2+40, 0, View4Width * 0.08, View4Height * 0.04);
    CVBSButton.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
    [CVBSButton setTitle:@"CVBS" forState:UIControlStateNormal];
    CVBSButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [CVBSButton addTarget:self action:@selector(CVBSButtonAction:) forControlEvents:UIControlEventTouchDown];
    [BacView addSubview:CVBSButton];
    
    
    //音量加
    UIButton *ValumAddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ValumAddButton.frame = CGRectMake(View4Width * 0.3,View4Height * 0.04 + 40, View4Width * 0.08, View4Height * 0.04);
    ValumAddButton.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
    [ValumAddButton setTitle:@"HDMI" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"Valum"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [ValumAddButton setImage:image forState:UIControlStateNormal];
    [ValumAddButton setTitle:@"➕" forState:UIControlStateNormal];
    ValumAddButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [ValumAddButton addTarget:self action:@selector(ValumAddButtonAction:) forControlEvents:UIControlEventTouchDown];
    [BacView addSubview:ValumAddButton];
    
    
    
    
    //音量减
    UIButton *ValumRButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ValumRButton.frame = CGRectMake(View4Width * 0.3+View4Width * 0.08+20,View4Height * 0.04 + 40, View4Width * 0.08, View4Height * 0.04);
    ValumRButton.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
    UIImage *Valumimage = [UIImage imageNamed:@"Valum"];
    Valumimage = [Valumimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [ValumRButton setImage:Valumimage forState:UIControlStateNormal];
    [ValumRButton setTitle:@"➖" forState:UIControlStateNormal];
    [ValumRButton addTarget:self action:@selector(ValumRButtonAction:) forControlEvents:UIControlEventTouchDown];
    ValumRButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [BacView addSubview:ValumRButton];
    

    
    //取消按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(View4Width - 140, 0, 40, 40);
    button.layer.cornerRadius =20;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.2;
    [button setTitle:Localized(@"取消") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
    [button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchDown];
    [BacView addSubview:button];
    
    
}


//HDMI格式
- (void)HDButtonAction:(UIButton *)sender
{
    
}

//DVI格式
- (void)DVIButtonAction:(UIButton *)button
{
    
}


//cvbs格式
- (void)CVBSButtonAction:(UIButton *)sender
{
    
}

//音量加
- (void)ValumAddButtonAction:(UIButton *)sender
{
    
}


//音量减
- (void)ValumRButtonAction:(UIButton *)sender
{
    
}



//取消按钮事件
- (void)ButtonAction:(UIButton *)button
{
    [self.view removeFromSuperview];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
