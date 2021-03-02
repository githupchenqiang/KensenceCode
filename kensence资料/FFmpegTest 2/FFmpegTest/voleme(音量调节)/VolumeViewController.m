//
//  VolumeViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/25.
//  Copyright © 2016年 times. All rights reserved.
//

#import "VolumeViewController.h"
#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height

@interface VolumeViewController ()
@property (nonatomic ,assign)NSInteger volue; //上一次数据的大小
@property (nonatomic ,assign)NSInteger CountValue;
@property (nonatomic ,assign)NSInteger LastValue;
@end

@implementation VolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //背景图
    UIView *BacView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BacView.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:BacView];
    
    UILabel *Input = [[UILabel alloc]init];
    Input.frame = CGRectMake(View4Width *0.05, View4Height * 0.02, 60, 35);
    Input.text = @"输入";
    Input.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:Input];
    self.volue = 10;
    self.CountValue = 10;
    self.LastValue = 10;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(View4Width *0.15,0, View4Width * 0.1, View4Height *0.18)];
    view.backgroundColor = WhiteColor;
    view.alpha = 0.7;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(View4Width *0.15+10, CGRectGetMaxY(view.frame)+2, View4Width * 0.1, 10)];
    label.text = @"MAC音量";
    [self.view addSubview:label];
    
    for (int i = 0 ;i <10 ; i++) {
        UIView *Aview = [[UIView alloc]initWithFrame:CGRectMake(3+ 3*i, 10+(12)*i,view.frame.size.width * 0.6 - (3)*i, 7)];
        Aview.layer.borderColor = [UIColor blackColor].CGColor;
        Aview.layer.borderWidth = 0.4;
//        Aview.backgroundColor = [UIColor redColor];
        Aview.tag = 1000+i;
        [view addSubview:Aview];
        
        
    }
    
    UIView *Twoview = [[UIView alloc]initWithFrame:CGRectMake(View4Width *0.3,0, View4Width * 0.1, View4Height *0.18)];
    Twoview.backgroundColor = WhiteColor;
    Twoview.alpha = 0.7;
    [self.view addSubview:Twoview];
    
    UILabel *Alabel = [[UILabel alloc]initWithFrame:CGRectMake(View4Width *0.3+10, CGRectGetMaxY(Twoview.frame)+2, View4Width * 0.1, 10)];
    Alabel.text = @"输入音量";
    [self.view addSubview:Alabel];
    
    
    
    for (int i = 0 ;i <10 ; i++) {
        UIView *Bview = [[UIView alloc]initWithFrame:CGRectMake(3+ 3*i, 10+(12)*i,Twoview.frame.size.width * 0.6 - (3)*i, 7)];
        Bview.layer.borderColor = [UIColor blackColor].CGColor;
        Bview.layer.borderWidth = 0.4;
        //        Aview.backgroundColor = [UIColor redColor];
        Bview.tag = 1011+i;
        [Twoview addSubview:Bview];
        
        
    }
    
    
    
    //输入Mac音量
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(20, 60,View4Height * 0.17, 25)];
    slider.minimumValue = 0.0;
    slider.maximumValue = 10.0;
    slider.value = 10;
    [slider addTarget:self action:@selector(SliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    slider.transform = CGAffineTransformMakeRotation(M_PI_2);
    [view addSubview:slider];
    UIView *Line = [[UIView alloc]initWithFrame:CGRectMake(View4Width * 0.5, 0, 1, View4Height)];
    Line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:Line];
    
    
    //输入音量
    UISlider *Twoslider = [[UISlider alloc]initWithFrame:CGRectMake(20, 60,View4Height * 0.17, 25)];
    Twoslider.minimumValue = 0.0;
    Twoslider.maximumValue = 10.0;
    Twoslider.value = 10;
    [Twoslider addTarget:self action:@selector(TwosliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    Twoslider.transform = CGAffineTransformMakeRotation(M_PI_2);
    [Twoview addSubview:Twoslider];
    
    UIView *TwoLine = [[UIView alloc]initWithFrame:CGRectMake(View4Width * 0.5, 0, 1, View4Height)];
    TwoLine.backgroundColor = [UIColor blackColor];
    [self.view addSubview:TwoLine];
    
    
    
    UILabel *LetfLabel = [[UILabel alloc]initWithFrame:CGRectMake(View4Width *0.5+10, View4Height * 0.02, 60, 25)];
    LetfLabel.text = @"输出";
    LetfLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:LetfLabel];
    
    UIView *Leftview = [[UIView alloc]initWithFrame:CGRectMake(View4Width *0.6,0, View4Width * 0.1, View4Height *0.18)];
    Leftview.backgroundColor = WhiteColor;
    Leftview.alpha = 0.7;
    [self.view addSubview:Leftview];
    
    UILabel *Leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(View4Width *0.6+25, CGRectGetMaxY(Leftview.frame)+2, View4Width * 0.1, 10)];
    Leftlabel.text = @"输出1";
    [self.view addSubview:Leftlabel];
    
    
    
    for (int i = 0 ;i <10 ; i++) {
        UIView *Left = [[UIView alloc]initWithFrame:CGRectMake(3+ 3*i, 10+(12)*i,Leftview.frame.size.width * 0.6 - (3)*i, 7)];
        Left.layer.borderColor = [UIColor blackColor].CGColor;
        Left.layer.borderWidth = 0.4;
        Left.tag = 1021+i;
        [Leftview addSubview:Left];
        
        
    }

    //输入音量
    UISlider *LeftSlider = [[UISlider alloc]initWithFrame:CGRectMake(20, 60,View4Height * 0.17, 25)];
    LeftSlider.minimumValue = 0.0;
    LeftSlider.maximumValue = 10.0;
    LeftSlider.value = 10;
    [LeftSlider addTarget:self action:@selector(LeftSliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    LeftSlider.transform = CGAffineTransformMakeRotation(M_PI_2);
    [Leftview addSubview:LeftSlider];
    


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

//左边的Slider事件
- (void)SliderChangeAction:(UISlider *)slider
{
    
    NSInteger value = (NSInteger)slider.value;
    
    
    if (self.CountValue - value > 0) {
        self.CountValue = value+1;
        UIView *view = (UIView *)[self.view viewWithTag:1000+self.CountValue];
        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    }else if (self.CountValue - value <= -1)
    {
        self.CountValue = value-1;
        UIView *view = (UIView *)[self.view viewWithTag:1000+self.CountValue];
        view.backgroundColor = WhiteColor;
 
    }


}

//Twoslider的事件
- (void)TwosliderChangeAction:(UISlider *)slider
{
    NSInteger value = (NSInteger)slider.value;
    
    
    if (self.volue - value > 0) {
        self.volue = value+1;
        UIView *view = (UIView *)[self.view viewWithTag:1011+self.volue];
        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    
    }else if (self.volue - value <= -1)
    {
        self.volue = value-1;
        UIView *view = (UIView *)[self.view viewWithTag:1011+self.volue];
        view.backgroundColor = WhiteColor;
  
    }
    
}

//LeftSlider事件
- (void)LeftSliderChangeAction:(UISlider *)slider
{
    NSInteger value = (NSInteger)slider.value;
    
    
    if (self.LastValue - value > 0) {
        self.LastValue = value+1;
        UIView *view = (UIView *)[self.view viewWithTag:1021+self.LastValue];
        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];

    }else if (self.LastValue - value <= -1)
    {
        self.LastValue = value-1;
        UIView *view = (UIView *)[self.view viewWithTag:1021+self.LastValue];
        view.backgroundColor = WhiteColor;

    }
    
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
