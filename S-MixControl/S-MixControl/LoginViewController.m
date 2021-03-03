//
//  LoginViewController.m
//  S-MixControl
//
//  Created by aa on 15/12/1.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "SignalViewController.h"
#import "SignalValue.h"
#import "GCDAsyncUdpSocket.h"
#import "ConnectPort.h"
#import "SockerSever.h"
#import "ConseverViewController.h"
#import "ProConnect.h"
#import "Masonry.h"
#import "MBProgressHUD.h"

#define KscreenWidth self.view.frame.size.width
#define KscreenHeight  self.view.frame.size.height
#define BackKscreenWith _BackView.frame.size.width
#define BackKscreenHeight _BackView.frame.size.height


@interface LoginViewController ()<GCDAsyncUdpSocketDelegate,UITextFieldDelegate>
{
    NSUserDefaults *_userDefault;
    NSUserDefaults *_default;
    GCDAsyncUdpSocket *_udpSocket;
    NSUserDefaults *_getDefault;
    NSUserDefaults *_SDefaults;
    
}
@property (nonatomic ,strong)UITextField *text4ip;
@property (nonatomic ,strong)UITextField *text4port;
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic ,assign)int count;
@property (nonatomic ,assign)NSInteger dispath;
@property (nonatomic ,strong)UIButton *SButton;
@property (nonatomic ,strong)UIButton *Pbutton;
@property (nonatomic ,strong)UIView  *BackView;
@property (nonatomic ,assign)BOOL isChoose;
@property (nonatomic ,strong)MBProgressHUD  *hud;

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    _text4ip.text = [_userDefault objectForKey:@"IPAdress"];
    _text4port.text = [_userDefault objectForKey:@"PortValues"];
    _default = [NSUserDefaults standardUserDefaults];
    NSString *string = [_default objectForKey:@"select"];
    NSInteger inte = string.integerValue;
    
    if (inte == 2) {
        UIButton *button = (UIButton *)[self.view viewWithTag:2999];
        [button setTitle:NSLocalizedString(@"S-MixPro",@"") forState:UIControlStateNormal];
        [SignalValue ShareValue].ProCount = 2;
        
    }else if (inte == 1){
        UIButton *button = (UIButton *)[self.view viewWithTag:2998];
          [button setTitle:@"S-Mix" forState:UIControlStateNormal];
        [SignalValue ShareValue].ProCount = 1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dispath = 0;
    
    _default = [NSUserDefaults standardUserDefaults];
    UIImage *img = [UIImage imageNamed:@"LogBac"];
    UIImageView *imagevi = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    imagevi.backgroundColor = [UIColor orangeColor];
    imagevi.image = img;
    [self.view addSubview:imagevi];
    
//    self.view.backgroundColor = [UIColor colorWithRed:43/255.0 green:161/255.0 blue:250/255.0 alpha:1];
//    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.frame = CGRectMake(0,KscreenHeight, KscreenWidth, -KscreenHeight/4);
//    imageView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:imageView];
//    
//    UIImage *ima = [UIImage imageNamed:@"login_bg"];
//    UIImageView *imgeview = [[UIImageView alloc]init];
//    imgeview.frame = CGRectMake(0, CGRectGetMinY(imageView.frame) - KscreenHeight/9, KscreenWidth, KscreenHeight/9);
//    imgeview.image = ima;
//    [self.view addSubview:imgeview];
    
    _BackView = [[UIView alloc]init];
    _BackView.frame = CGRectMake(KscreenWidth/3.2,  KscreenHeight/3.6, KscreenWidth/2.7, KscreenHeight/2);
    _BackView.backgroundColor = [UIColor clearColor];
//    _BackView.layer.shadowColor = [UIColor grayColor].CGColor;//阴影的颜色
//    _BackView.layer.shadowOpacity = 2.6f; // 阴影透明度
//    _BackView.layer.shadowOffset = CGSizeMake(0.0, 3.0f); // 阴影的范围
//    _BackView.layer.shadowRadius = 3.0;// 阴影扩散的范围控制
//    _BackView.backgroundColor = WhiteColor;
    [self.view addSubview:_BackView];
    UIImageView *Log = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 48, 48)];
    UIImage *LogImage = [UIImage imageNamed:@"kens"];
    LogImage = [LogImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Log.image = LogImage;
    [_BackView addSubview:Log];
    
    UILabel *ProductLabel = [[UILabel alloc]initWithFrame:CGRectMake(61, 0, BackKscreenWith-48, 60)];
    ProductLabel.text = NSLocalizedString(@"Mixed matrix control system",@"");
    ProductLabel.font = [UIFont systemFontOfSize:25];
//    ProductLabel.textAlignment = NSTextAlignmentCenter;
    ProductLabel.textColor = KensColor;
    [_BackView addSubview:ProductLabel];
    
     //添加导航控制器
//    UINavigationController *Nav = [[UINavigationController alloc]init];
//    Nav.navigationItem.title = @"登录";
//    [_BackView addSubview:Nav.view];
//  
        //创建输入框
    _text4ip  = [[UITextField alloc]initWithFrame:CGRectMake(10, 70, BackKscreenWith-20,52)];
//    _text4ip.layer.masksToBounds = YES;
    _text4ip.delegate = self;
    _text4ip.placeholder = NSLocalizedString(@"IP Adress",@"");

        //设置字体对其方式
    _text4ip.textAlignment = NSTextAlignmentNatural;
    _text4ip.borderStyle = UITextBorderStyleRoundedRect;
    
    //做标记以便取得输入的值
    _text4ip.tag = 11232;
    _text4port = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_text4ip.frame)+20, BackKscreenWith - 20,52)];
    _text4port.placeholder = NSLocalizedString(@"Port",@"");
  
    _text4port.textAlignment = NSTextAlignmentNatural;
    _text4port.borderStyle = UITextBorderStyleRoundedRect;
    _text4port.tag = 11231;
    _text4port.delegate = self;
    
    [_BackView addSubview:_text4ip];
    [_BackView addSubview:_text4port];
    
    NSString *string = [_default objectForKey:@"select"];
    NSInteger inte = string.integerValue;
    
    //Pro的选择类型按钮
    _SButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _SButton.frame = CGRectMake(0, CGRectGetMaxY(_text4port.frame)+20,BackKscreenWith/2, 52);
    if (inte == 1) {
        [_SButton setTitle:@"S-Mix" forState:UIControlStateNormal];
    }else if (inte == 2)
    {
       [_SButton setTitle:@"S-MixPro" forState:UIControlStateNormal];
    }else
    {
       [_SButton setTitle:NSLocalizedString(@"Choose types of control",@"") forState:UIControlStateNormal];
    }

    [_SButton setTitleColor:KensColor forState:UIControlStateNormal];
  
    _SButton.backgroundColor = WhiteColor;
    _SButton.layer.cornerRadius = 7;
    _SButton.layer.masksToBounds = YES;
    
    _SButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _SButton.tag = 2999;
    _SButton.titleEdgeInsets = UIEdgeInsetsMake(0,_SButton.titleLabel.bounds.size.width - 80, 0, 0);

          [_SButton setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
    CGSize commandbuttonsize = [_SButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    _SButton.imageEdgeInsets = UIEdgeInsetsMake(0,commandbuttonsize.width + 120, 0, -20);
    [_SButton.imageView setFrame:CGRectMake(_SButton.frame.size.width - 20, 0, 30, 0)];
    [_SButton addTarget:self action:@selector(ProButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:_SButton];
    [_SButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_text4port.mas_bottom).with.offset(20);
        make.left.equalTo(_text4port.mas_left).with.offset(0);
        make.right.equalTo(_text4port.mas_right).with.offset(0);
        make.height.mas_equalTo(52);
        
    }];


    //创建登陆的点击按钮
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(12,CGRectGetMaxY(_SButton.frame) + 20,BackKscreenWith - 24, 52);
    [_button setTitle:NSLocalizedString(@"Login",@"") forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(SendText:) forControlEvents:UIControlEventTouchUpInside];
    _button.backgroundColor = [UIColor orangeColor];
    _button.layer.cornerRadius = 7;
    _button.layer.masksToBounds = YES;
    _button.titleLabel.font = [UIFont systemFontOfSize:23];
    [_BackView addSubview:_button];
    [self SetupUdp];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _BackView.frame = CGRectMake(_BackView.frame.origin.x, _BackView.frame.origin.y - 80, _BackView.frame.size.width, _BackView.frame.size.height);
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _BackView.frame = CGRectMake(_BackView.frame.origin.x, _BackView.frame.origin.y + 80, _BackView.frame.size.width, _BackView.frame.size.height);

}


//选择类型转换背景图片
- (void)ProButtonAction:(UIButton *)sender
{
    if (_isChoose == NO) {
        _isChoose = YES;
    UIButton *PRoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    PRoButton.frame = CGRectMake(0, CGRectGetMaxY(_text4port.frame)+20,BackKscreenWith/2, 52);
    [PRoButton setTitle:@"S-Mix" forState:UIControlStateNormal];
    [PRoButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    PRoButton.backgroundColor = WhiteColor;
//    PRoButton.layer.cornerRadius = 7;
//    PRoButton.layer.masksToBounds = YES;
    PRoButton.backgroundColor = KensColor;
    PRoButton.titleLabel.font = [UIFont systemFontOfSize:20];
    PRoButton.tag = 2998;
    [PRoButton addTarget:self action:@selector(ProBUtton:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:PRoButton];
    [PRoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SButton.mas_bottom).with.offset(2);
        make.left.equalTo(_text4port.mas_left).with.offset(0);
        make.right.equalTo(_text4port.mas_right).with.offset(0);
        make.height.mas_equalTo(52);
        
    }];
    
    
    UIButton *SMButton = [UIButton buttonWithType:UIButtonTypeSystem];
    SMButton.frame = CGRectMake(0, CGRectGetMaxY(_text4port.frame)+20,BackKscreenWith/2, 52);
    [SMButton setTitle:@"S-MixPro" forState:UIControlStateNormal];
    [SMButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    SMButton.backgroundColor = WhiteColor;
//    SMButton.layer.cornerRadius = 7;
//    SMButton.layer.masksToBounds = YES;
    SMButton.backgroundColor = KensColor;
    SMButton.titleLabel.font = [UIFont systemFontOfSize:20];
    SMButton.tag = 2997;
    [SMButton addTarget:self action:@selector(SMButton:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:SMButton];
    [SMButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PRoButton.mas_bottom).with.offset(2);
        make.left.equalTo(_text4port.mas_left).with.offset(0);
        make.right.equalTo(_text4port.mas_right).with.offset(0);
        make.height.mas_equalTo(52);
        
    }];
        
    }
  
}

- (void)ProBUtton:(UIButton *)sender
{
    UIButton *button = (UIButton *)[self.view viewWithTag:2999];
    [button setTitle:@"S-Mix" forState:UIControlStateNormal];
    [SignalValue ShareValue].ProCount = 1;
    NSString *strin =[NSString stringWithFormat:@"%d",1];
    [_default setObject:strin forKey:@"select"];
    
    UIButton *Remove = (UIButton *)[self.view viewWithTag:2998];
    UIButton *Sbutton = (UIButton *)[self.view viewWithTag:2997];
    [Remove removeFromSuperview];
    [Sbutton removeFromSuperview];
    _isChoose = NO;
    
}

- (void)SMButton:(UIButton *)sender
{
    _isChoose = NO;
    UIButton *button = (UIButton *)[self.view viewWithTag:2999];
    [button setTitle:@"S-MixPro" forState:UIControlStateNormal];
    [SignalValue ShareValue].ProCount = 2;
    NSString *strin =[NSString stringWithFormat:@"%d",2];
    [_default setObject:strin forKey:@"select"];
    UIButton *Remove = (UIButton *)[self.view viewWithTag:2998];
    UIButton *Sbutton = (UIButton *)[self.view viewWithTag:2997];
    [Remove removeFromSuperview];
    [Sbutton removeFromSuperview];
    
}

- (void)SbuttonAction:(UIButton *)sender
{
    if ( sender.selected == NO) {
        UIImage *image1 = [UIImage imageNamed:@"复选框-未选中"];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *button = (UIButton *)[self.view viewWithTag:2999];
        [button setImage:image1 forState:UIControlStateNormal];
    
        _default = [NSUserDefaults standardUserDefaults];
        [_default removeObjectForKey:@"select"];
        
        UIImage *image = [UIImage imageNamed:@"复选框-选中"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_Pbutton setImage:image forState:UIControlStateNormal];
        _SDefaults = [NSUserDefaults standardUserDefaults];
        [_SDefaults setBool:sender.selected forKey:@"select"];
        [SignalValue ShareValue].ProCount = 1;
        NSString *strin =[NSString stringWithFormat:@"%d",1];
        [_default setObject:strin forKey:@"select"];
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:11232];
        UITextField *portText = (UITextField *)[self.view viewWithTag:11231];
        [SignalValue ShareValue].SignalIpStr = textField.text;
        NSString *str = portText.text;
        unsigned short utfString = [str integerValue];
        [SignalValue ShareValue].SignalPort =utfString;

    }else
    {
        UIImage *image = [UIImage imageNamed:@"复选框-未选中"];
        [_Pbutton setImage:image forState:UIControlStateNormal];
        _SDefaults = [NSUserDefaults standardUserDefaults];
        [_SDefaults removeObjectForKey:@"select"];
        [SignalValue ShareValue].ProCount = 0;
        sender.selected = NO;
    }
}

  //正则判断
- (BOOL)isValidateIP:(NSString *)IP
{
    NSString *ipRegex = @"(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)";
    NSPredicate *iptext = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegex];
    return [iptext evaluateWithObject:IP];

}



#pragma mark ===登陆的点击事件====
- (void)SendText:(UIButton *)button

{
    [self.view endEditing:YES];
    
      [[SignalValue ShareValue].GetMessage removeAllObjects];
    
     //获取输入的值
    UITextField *textField = (UITextField *)[self.view viewWithTag:11232];
    UITextField *portText = (UITextField *)[self.view viewWithTag:11231];
    
        //判断端口和IP格式是否正确
    if ([self isValidateIP:textField.text]&& portText.text.length == 4) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            self.hud.activityIndicatorColor = [UIColor colorWithRed:246/255.0 green:8/255.0 blue:142/255.0 alpha:1];
            self.hud.tintColor = [UIColor whiteColor];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            self.hud.minSize = CGSizeMake(50, 50);
            self.hud.labelText = NSLocalizedString(@"Login...",@"");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud.labelText = NSLocalizedString(@"TimeOut",@"");
                self.hud.hidden = YES;
            });
            [self.hud show:YES];
        });
        
        [SignalValue ShareValue].SignalIpStr = textField.text;
        NSString *str = portText.text;
        unsigned short utfString = [str integerValue];
        [SignalValue ShareValue].SignalPort =utfString;
        //将用户输入保存到本地方便登陆
        
#pragma mark ===打印场景发送数据
        if ([SignalValue ShareValue].ProCount == 2) {
           
            unsigned char buf[256] = {0};
            unsigned char num = 0;
//            NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
            NSInteger length = make_pack_5555(METHOD_GET, CMD_GLOBAL_ALL, 0, &num, buf);
            NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
            
            [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
            [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
            [_udpSocket receiveOnce:nil];
            
            NSLog(@"%@==%d",[SignalValue ShareValue].SignalIpStr,[SignalValue ShareValue].SignalPort
                  );
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                unsigned char buf1[256] = {0};
                unsigned char num1 = 1;
                
                NSInteger length1 = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num1, buf1);
                NSData *data2 = [NSData dataWithBytes:(void *)&buf1  length:length1];
                
                [_udpSocket sendData:data2 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:990];
                [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
                [_udpSocket receiveOnce:nil];
                NSLog(@"====%@",data2);
            });
            
          
       
            NSLog(@"====%@",data1);
            
        }else if ([SignalValue ShareValue].ProCount == 1){
          
            kice_t kic = scene_print_cmd(0x00);
            NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
            
            [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
            [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
            [_udpSocket receiveOnce:nil];
        }
        
        //将用户保存在本地
        _userDefault = [NSUserDefaults standardUserDefaults];
        [_userDefault setObject:_text4ip.text forKey:@"IPAdress"];
        [_userDefault setObject:_text4port.text forKey:@"PortValues"];
        

    }else
    {
            //提示框
       UIAlertController*alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Input Error",@"") message:NSLocalizedString(@"LinkError",@"") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Action = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancle",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure",@"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:Action];
        [alert addAction:twoAc];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

#pragma mark ===初始化socket====
- (void)SetupUdp
{
    //初始化对象，使用全局队列
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
    [_udpSocket receiveOnce:nil];
}
//发送数据成功
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 544) {
        NSLog(@"标记为544的数据发送完成");
    }
}
//发送失败
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    
     NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag,error);
    
}


//接收数据完成
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [[SignalValue ShareValue].GetMessage removeAllObjects];
    const unsigned char *a= [data bytes];
    kice_t *kic = (kice_t *)a;
    unsigned char cmd = kic->data[0];
     const  unsigned char *resultBuff = [data bytes];
   
    
    if (resultBuff[0] == 0x55 && resultBuff[1] == 0x55 && resultBuff[7] == 0x04 && resultBuff[8] == 0x02) {
//        unsigned short count = 0;
        unsigned char Probuf[512] = {0};
        for (unsigned int i = 0; i < [SignalValue ShareValue].Integer; i++) {
            Probuf[i] = resultBuff[12+i];
            NSInteger proValu = (NSInteger)Probuf[i];
            NSNumber *number = [NSNumber numberWithInteger:proValu];
            [[SignalValue ShareValue].GetMessage addObject:number];
        }
    }
    
    if (resultBuff[0] == 0x55 && resultBuff[1] == 0x55 && resultBuff[7] == 0x00 && resultBuff[8] == 0xfe) {
        unsigned short count = 0;
        memcpy(&count, &resultBuff[15], 1);
//        count = EXCHANGE16BIT(count);
        [SignalValue ShareValue].Integer = count;
        
//        unsigned char Probuf[512] = {0};
//        for (unsigned int i = 0; i < count -1; i++) {
//            Probuf[i] = resultBuff[12+i];
//            NSInteger proValu = (NSInteger)Probuf[i];
//            NSNumber *number = [NSNumber numberWithInteger:proValu];
//            [[SignalValue ShareValue].GetMessage addObject:number];
//        }
      
    }else if (cmd == 0x27)
    {
        sw_state_t *sw = (sw_state_t *)(&((kice_t *)a)->data[3]);
        _count = (unsigned int)(sw->input);
        [SignalValue ShareValue].Integer = _count;
        
        unsigned int buf[512] ={0};
        for(int i = 0; i < _count; i++)
        {
            buf[i] = (unsigned char)sw->group[_count + i];
            NSInteger value = (NSInteger)buf[i];
            NSNumber *number = [NSNumber numberWithInteger:value];
            [[SignalValue ShareValue].GetMessage addObject:number];
        }
    }

    _dispath++;
    if ([SignalValue ShareValue].GetMessage.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.label.text = NSLocalizedString(@"Login success",@"");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud.hidden = YES;
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                //视图跳转
                ViewController *root = [ViewController new];
                root.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:root animated:YES completion:nil];
            });
        });
    }
    
    [sock receiveOnce:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[SockerSever SharedSocket]SendBackToHost:ip port:port withMessage:str];
  
    });
   
}


-(void)SendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)str
{
    NSString *Msg = @"我在发送消息";
    NSData *data = [Msg dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:ip port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:545];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    UIButton *Remove = (UIButton *)[self.view viewWithTag:2998];
    UIButton *Sbutton = (UIButton *)[self.view viewWithTag:2997];
    [Remove removeFromSuperview];
    [Sbutton removeFromSuperview];
    _isChoose = NO;
    
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
