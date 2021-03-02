//
//  TypeViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/25.
//  Copyright © 2016年 times. All rights reserved.
//

#import "TypeViewController.h"
#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height

@interface TypeViewController ()

@end

@implementation TypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *BacView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BacView.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:BacView];
    
   
      //取消按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(View4Width - 140, 0, 40, 40);
//    button.layer.cornerRadius =20;
//    button.layer.masksToBounds = YES;
//    button.layer.borderColor = [UIColor blackColor].CGColor;
//    button.layer.borderWidth = 0.2;
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor colorWithRed:146/255.0 green:253/255.0 blue:123/255.0 alpha:1];
//    [button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchDown];
//    [BacView addSubview:button];
//    

    
    
    
}




//取消
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
