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

#define KscreenWidth self.view.frame.size.width
#define KscreenHeight  self.view.frame.size.height
@interface LoginViewController ()<GCDAsyncUdpSocketDelegate>
{
    NSUserDefaults *_userDefault;
    
    GCDAsyncUdpSocket *_udpSocket;
    NSUserDefaults *_getDefault;
    
}
@property (nonatomic ,strong)UITextField *text4ip;
@property (nonatomic ,strong)UITextField *text4port;
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic ,assign)int count;
@property (nonatomic ,assign)NSInteger dispath;
@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    _text4ip.text = [_userDefault objectForKey:@"IPAdress"];
    _text4port.text = [_userDefault objectForKey:@"PortValues"];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _dispath = 0;
    self.view.backgroundColor = [UIColor whiteColor];
     //添加导航控制器
    UINavigationController *Nav = [[UINavigationController alloc]init];
    Nav.navigationItem.title = @"登录";
    [self.view addSubview:Nav.view];
  
        //创建输入框
    _text4ip  = [[UITextField alloc]initWithFrame:CGRectMake(KscreenWidth/3, KscreenWidth/7, KscreenWidth/3,52)];
    _text4ip.layer.masksToBounds = YES;

        _text4ip.placeholder = @"请输入ip地址";

        //设置字体对其方式
    _text4ip.textAlignment = NSTextAlignmentNatural;
    _text4ip.borderStyle = UITextBorderStyleRoundedRect;
    
    //做标记以便取得输入的值
    _text4ip.tag = 11232;
    _text4port = [[UITextField alloc]initWithFrame:CGRectMake(KscreenWidth/3, CGRectGetMaxY(_text4ip.frame)+40, KscreenWidth/3,52)];
         _text4port.placeholder = @"请输入端口号";
  
    _text4port.textAlignment = NSTextAlignmentNatural;
    _text4port.borderStyle = UITextBorderStyleRoundedRect;
    _text4port.tag = 11231;
    [self.view addSubview:_text4ip];
    [self.view addSubview:_text4port];
    
    //创建登陆的点击按钮
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(KscreenWidth/3,CGRectGetMaxY(_text4port.frame) + 20, KscreenWidth/3, 52);
    [_button setTitle:@"登录" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(SendText:) forControlEvents:UIControlEventTouchUpInside];
    _button.backgroundColor = [UIColor orangeColor];
    _button.layer.cornerRadius = 7;
    _button.layer.masksToBounds = YES;
    _button.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.view addSubview:_button];
    [self SetupUdp];
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

{      [self.view endEditing:YES];
      [[SignalValue ShareValue].GetMessage removeAllObjects];
    
     //获取输入的值
    UITextField *textField = (UITextField *)[self.view viewWithTag:11232];
    UITextField *portText = (UITextField *)[self.view viewWithTag:11231];
    
        //判断端口和IP格式是否正确
    if ([self isValidateIP:textField.text]&& portText.text.length == 4) {
      
        [SignalValue ShareValue].SignalIpStr = textField.text;
        NSString *str = portText.text;
        unsigned short utfString = [str integerValue];
        [SignalValue ShareValue].SignalPort =utfString;
        //将用户输入保存到本地方便登陆
        
#pragma mark ===打印场景发送数据
        kice_t kic = scene_print_cmd(0x00);
        NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
        //将用户保存在本地
        _userDefault = [NSUserDefaults standardUserDefaults];
        [_userDefault setObject:_text4ip.text forKey:@"IPAdress"];
        [_userDefault setObject:_text4port.text forKey:@"PortValues"];
        
        
        kice_t kicT = scene_print_cmd(0x00);
        NSData *dataT = [NSData dataWithBytes:(void *)&kicT  length:kicT.size];
        [_udpSocket sendData:dataT toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
        

    }else
    {
            //提示框
       UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"输入有误" message:@"连接失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
     const unsigned char *a= [data bytes];
    kice_t *kic = (kice_t *)a;
    unsigned char cmd = kic->data[0];
    if(cmd == 0x27)
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
            NSLog(@"%@",[SignalValue ShareValue].GetMessage);
        }
    }
    
    _dispath++;
    if (_dispath == 1 && [SignalValue ShareValue].GetMessage!=nil) {
        //视图跳转
        ViewController *root = [ViewController new];
        [self presentViewController:root animated:YES completion:nil];
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
