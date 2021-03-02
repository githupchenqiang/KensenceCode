//
//  LightViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/25.
//  Copyright © 2016年 times. All rights reserved.
//

#import "LightViewController.h"
#import "Masonry.h"

#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height

@interface LightViewController ()
/**
 *  标记开关状态
 */
@property (nonatomic ,assign)BOOL WinBool;
@property (nonatomic ,assign)BOOL LightBool;

@end

@implementation LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //背景图
    UIView *BacView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BacView.backgroundColor = TabbleColor;
    [self.view addSubview:BacView];
    UILabel *WindowLabel = [UILabel new];
    WindowLabel.frame = CGRectMake(10, 10, 100, 110);
    WindowLabel.textColor = TextColor;
    WindowLabel.text = Localized(@"窗帘开关");
    [BacView addSubview:WindowLabel];
    [WindowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(View4Height  * 0.05);
        make.left.equalTo(self.view.mas_left).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(View4Width  * 0.15);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *Onlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    Onlabel.text = Localized(@"开");
//    Onlabel.backgroundColor = [UIColor redColor];
    Onlabel.textColor = WhiteColor;
    Onlabel.tag = 670;
    [self.view addSubview:Onlabel];
    [Onlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WindowLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(self.view.mas_left).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];

    UIView *WinBac = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    WinBac.backgroundColor = ScrollerColor;
    WinBac.layer.cornerRadius =15;
    WinBac.layer.masksToBounds = YES;
    WinBac.layer.borderWidth = 0.2;
    WinBac.layer.borderColor = [UIColor blackColor].CGColor;
    WinBac.tag = 671;
//    UITapGestureRecognizer *winBacTpa = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WinChange:)];
//    winBacTpa.numberOfTapsRequired = 1;
//    [WinBac addGestureRecognizer:winBacTpa];
    [self.view addSubview:WinBac];
    [WinBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WindowLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(Onlabel.mas_right).with.offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *WinImage = [UIImage imageNamed:@"Switch-OF"];
    imageview.tag = 673;
    imageview.userInteractionEnabled = YES;
    WinImage = [WinImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageview.image = WinImage;
    UITapGestureRecognizer *WinTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WinChange:)];
    WinTap.numberOfTapsRequired = 1;
    [imageview addGestureRecognizer:WinTap];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WindowLabel.mas_top).with.offset(View4Height  * 0.04 - 5);
        make.left.equalTo(WinBac.mas_left).with.offset(0 + 45);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *OFFlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    OFFlabel.text = Localized(@"关");
    OFFlabel.tag = 672;
    //    Onlabel.backgroundColor = [UIColor redColor];
    OFFlabel.textColor = [UIColor redColor];
    [self.view addSubview:OFFlabel];
    [OFFlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WindowLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(WinBac.mas_right).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    UIView *separatedLine = [[UIView alloc]init];
    separatedLine.backgroundColor = ScrollerColor;
    [self.view addSubview:separatedLine];
    [separatedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(View4Width  * 0.2);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(View4Height);
    }];
 
    UILabel *LightLabel = [UILabel new];
    LightLabel.frame = CGRectMake(10, 10, 100, 110);
    LightLabel.textColor = TextColor;
    LightLabel.text = Localized(@"灯光开关");
    [BacView addSubview:LightLabel];
    [LightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(View4Height  * 0.05);
        make.left.equalTo(separatedLine.mas_right).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(View4Width  * 0.15);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *LightOnlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    LightOnlabel.text = Localized(@"开");
    //    Onlabel.backgroundColor = [UIColor redColor];
    LightOnlabel.textColor = WhiteColor;
    LightOnlabel.tag = 674;
    [self.view addSubview:LightOnlabel];
    [LightOnlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LightLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(separatedLine.mas_right).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    UIView *LightBac = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    LightBac.backgroundColor = ScrollerColor;
    LightBac.layer.cornerRadius =15;
    LightBac.layer.masksToBounds = YES;
    LightBac.layer.borderWidth = 0.2;
    LightBac.layer.borderColor = [UIColor blackColor].CGColor;
    LightBac.tag = 675;
//    UITapGestureRecognizer *LightBacTpa = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LightChange:)];
//    LightBacTpa.numberOfTapsRequired = 1;
//    [LightBac addGestureRecognizer:LightBacTpa];
    [self.view addSubview:LightBac];
    [LightBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LightLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(LightOnlabel.mas_right).with.offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    UIImageView *Lightimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *LightImage = [UIImage imageNamed:@"Switch-OF"];
    Lightimageview.tag = 676;
    Lightimageview.userInteractionEnabled = YES;
    LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Lightimageview.image = LightImage;
    UITapGestureRecognizer *LightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LightChange:)];
    LightTap.numberOfTapsRequired = 1;
    [Lightimageview addGestureRecognizer:LightTap];
    [self.view addSubview:Lightimageview];
    [Lightimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LightLabel.mas_top).with.offset(View4Height  * 0.04 - 5);
        make.left.equalTo(LightBac.mas_left).with.offset(0 + 45);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *LightOFFlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    LightOFFlabel.text = Localized(@"关");
    LightOFFlabel.tag = 677;
    LightOFFlabel.textColor = [UIColor redColor];
    [self.view addSubview:LightOFFlabel];
    [LightOFFlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LightLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(LightBac.mas_right).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    

    UIView *Midseparated = [[UIView alloc]init];
    Midseparated.backgroundColor = ScrollerColor;
    [self.view addSubview:Midseparated];
    [Midseparated mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(separatedLine.mas_right).with.offset(View4Width  * 0.2);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(View4Height);
    }];
    
    /**
     
     */
    UILabel *SliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    SliderLabel.text = Localized(@"灯光控制");
    SliderLabel.textColor = TextColor;
    [self.view addSubview:SliderLabel];
    [SliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(View4Height  * 0.05);
        make.left.equalTo(Midseparated.mas_right).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(View4Width  * 0.15);
        make.height.mas_equalTo(24);
    }];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *sliderImage = [UIImage imageNamed:@"灯光"];
    sliderImage = [sliderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *MaxSliderImage = [UIImage imageNamed:@"灯光-1"];
    MaxSliderImage = [MaxSliderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    slider.maximumValueImage = MaxSliderImage;
    slider.minimumValueImage = sliderImage;
    slider.minimumValue = 0;
    slider.maximumValue = 1;
//    slider.value = 0.7;
    slider.minimumTrackTintColor = SwitchColor;
    slider.maximumTrackTintColor = ScrollerColor;
//    slider.backgroundColor = ScrollerColor;
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SliderLabel.mas_top).with.offset(View4Height  * 0.04);
        make.left.equalTo(Midseparated.mas_right).with.offset(View4Width  * 0.02);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(30);
    }];
 
}



/**
 *  窗帘开关事件
 *
 *  @param winTap 开关事件
 */
- (void)WinChange:(UITapGestureRecognizer *)winTap
{
    if (self.WinBool == NO) {
        self.WinBool = YES;
        UILabel *label = (UILabel *)[self.view viewWithTag:670];
        label.textColor = SwitchColor;
        UIView *view = (UIView *)[self.view viewWithTag:671];
        view.backgroundColor = SwitchColor;
        UIImageView *WinImageView = (UIImageView*)[self.view viewWithTag:673];
        UIImage *Image = [UIImage imageNamed:@"Switch-on"];
        Image = [Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        WinImageView.image = Image;
        UILabel *Offlabel = (UILabel *)[self.view viewWithTag:672];
        Offlabel.textColor =WhiteColor;
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [WinImageView setFrame:CGRectMake(WinImageView.frame.origin.x - 50
                                         , WinImageView.frame.origin.y, WinImageView.frame.size.width, WinImageView.frame.size.height)];
        [UIView commitAnimations];
        NSLog(@"打开");
    }else
    {
        self.WinBool = NO;
        UILabel *label = (UILabel *)[self.view viewWithTag:670];
        label.textColor = WhiteColor;
        UIView *view = (UIView *)[self.view viewWithTag:671];
        view.backgroundColor = ScrollerColor;
        UIImageView *WinImageView = (UIImageView*)[self.view viewWithTag:673];
        UIImage *Image = [UIImage imageNamed:@"Switch-OF"];
        Image = [Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        WinImageView.image = Image;
        UILabel *Offlabel = (UILabel *)[self.view viewWithTag:672];
        Offlabel.textColor = [UIColor redColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [WinImageView setFrame:CGRectMake(WinImageView.frame.origin.x + 50
                                          , WinImageView.frame.origin.y, WinImageView.frame.size.width, WinImageView.frame.size.height)];
        [UIView commitAnimations];
        NSLog(@"关闭");
    }

}

/**
 *  灯光控制开关事件
 *
 *  @param LightTap
 */
- (void)LightChange:(UITapGestureRecognizer *)LightTap
{
    if (self.LightBool == NO) {
        self.LightBool = YES;
        UILabel *label = (UILabel *)[self.view viewWithTag:674];
        label.textColor = SwitchColor;
        UIView *view = (UIView *)[self.view viewWithTag:675];
        view.backgroundColor = SwitchColor;
        UIImageView *WinImageView = (UIImageView*)[self.view viewWithTag:676];
        UIImage *Image = [UIImage imageNamed:@"Switch-on"];
        Image = [Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        WinImageView.image = Image;
        UILabel *Offlabel = (UILabel *)[self.view viewWithTag:677];
        Offlabel.textColor = WhiteColor;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [WinImageView setFrame:CGRectMake(WinImageView.frame.origin.x - 50
                                          , WinImageView.frame.origin.y, WinImageView.frame.size.width, WinImageView.frame.size.height)];
        [UIView commitAnimations];
        
        NSLog(@"打开");
    }else
    {
        self.LightBool = NO;
        UILabel *label = (UILabel *)[self.view viewWithTag:674];
        label.textColor = WhiteColor;
        UIView *view = (UIView *)[self.view viewWithTag:675];
        view.backgroundColor = ScrollerColor;
        UIImageView *WinImageView = (UIImageView*)[self.view viewWithTag:676];
        UIImage *Image = [UIImage imageNamed:@"Switch-OF"];
        Image = [Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        WinImageView.image = Image;
        UILabel *Offlabel = (UILabel *)[self.view viewWithTag:677];
        Offlabel.textColor = [UIColor redColor];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [WinImageView setFrame:CGRectMake(WinImageView.frame.origin.x + 50
                                          , WinImageView.frame.origin.y, WinImageView.frame.size.width, WinImageView.frame.size.height)];
        [UIView commitAnimations];
        NSLog(@"关闭");
    }
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
