//
//  ConseverViewController.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//
#import "ConseverViewController.h"
#import "ConnectPort.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
#import "ConnectPort.h"
#import "LoginViewController.h"
//页面大小的宏
#define KScreenWith self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height

//显示端口号滚动视图的宏
#define ScrollerHight  self.BackScroller.frame.size.height
#define ScrollerWith   self.BackScroller.frame.size.width
@interface ConseverViewController ()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *_udpSocket;
}
@property (nonatomic ,strong)UIScrollView *Scroller;  //显示输出端口的滚动视图
@property (nonatomic ,strong)UIButton *Button; //场景按钮
@property (nonatomic ,strong)UIScrollView *BackScroller; //最底层的滚动视图
@property (nonatomic ,strong)UIButton *SaveButton; //保存场景的点击事件
@property (nonatomic ,strong)NSMutableArray *saveArray; //场景保存button的tag值
@property (nonatomic ,assign)NSInteger saveValue; //记录当前点击的button值
@property (nonatomic ,strong)UILabel *valuelabel; //显示值的label
@property (nonatomic ,strong)UILabel *Inlabel; //输入label
@property (nonatomic ,strong)NSMutableArray *tagArray; //存储tag值的数组
@property (nonatomic ,strong)NSMutableArray *InlabelArray;
@property (nonatomic ,assign)int countValue;
@property (nonatomic ,strong)NSMutableArray *getValu;
@property (nonatomic ,strong)NSString *Astring;
@property (nonatomic ,strong)NSString *string;
@property (nonatomic ,strong)NSString *mutString;


@end

@implementation ConseverViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _Scroller.scrollsToTop = YES;
    
    for (int i = 0; i < [SignalValue ShareValue].GetMessage.count; i++) {
        UILabel *input = (UILabel *)[self.view viewWithTag:1200+i];
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        NSString *Key = [NSString stringWithFormat:@"%ld",(long)(i+300+[SignalValue ShareValue].Integer/9*145)];
        NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:Key];
        if (value != nil) {
             //input.font = [UIFont systemFontOfSize:15];
            input.text = value;
            
           
        }else
        {
            
           // input.font = [UIFont systemFontOfSize:23];
            input.text = str;
            NSLog(@"Input%@",str);
            
        }
        
        
        
    }
    kice_t kic = scene_print_cmd(0x00);
    NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
    [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [_udpSocket receiveOnce:nil];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (int i = 0; i < [SignalValue ShareValue].Integer * [SignalValue ShareValue].Integer; i++) {
//            UILabel *label = (UILabel *)[self.view viewWithTag: 2000 + i];
//            label.text = @" ";
//        }
//        NSLog(@"清空");
//        
//    });
  
    UIButton *button = [self.view viewWithTag:700];
    button.backgroundColor = [UIColor orangeColor];
}
//


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIButton *button = [self.view viewWithTag:700+_saveValue];
    button.backgroundColor = [UIColor whiteColor];
    
    
    for (int i = 0; i < [SignalValue ShareValue].Integer ; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag: 2000 + i];
        label.text = @" ";
    }

}

- (void)viewDidDisappear:(BOOL)animated
{   [super viewDidDisappear:animated];
    kice_t kic = scene_print_cmd(0x00);
    NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
    [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
     [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [_udpSocket receiveOnce:nil];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpScroller];
    [self setUpLabel];
    _InlabelArray = [NSMutableArray array];
    _saveArray = [NSMutableArray array];
    _tagArray = [NSMutableArray array];
    _getValu = [NSMutableArray array];
    //将视图添加上来
    [self SetUpButton];
    
    [self setUpSaveButton];
   
    for (int i = 0; i < 12; i++) {
        NSInteger save = 700 + i;
        NSNumber *number = [NSNumber numberWithInteger:save];
        [_saveArray addObject:number];
    }
    self.valueArray = [NSMutableArray array];
    
    UIButton *button = (UIButton *)[self.view viewWithTag:700];
    button.backgroundColor = [UIColor orangeColor];
    //    [self reloadInputViews];
    [self SetUpSocket];
   
}
//创建场景对应的输入输出
- (void)setUpLabel
{
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        for (int j = 0; j < 1; j++) {
            _Inlabel = [[UILabel alloc]initWithFrame:CGRectMake(ScrollerWith/100*j,ScrollerHight/17+ ScrollerHight/9.5*i,ScrollerWith/7,ScrollerHight/13)];
            _Inlabel.backgroundColor = [UIColor whiteColor];
            _Inlabel.layer.masksToBounds = YES;
            _Inlabel.layer.cornerRadius = 5;
            //NSString *str = [NSString stringWithFormat:@"%d",i+1];
             //_Inlabel.text = str;
            _Inlabel.tag = 1200+i;
            NSNumber *num = [NSNumber numberWithInteger:_Inlabel.tag ];
            [_InlabelArray addObject:num];
            _Inlabel.layer.borderColor = [UIColor blackColor].CGColor;
            _Inlabel.layer.borderWidth = 0.50f;
            _Inlabel.font = [UIFont systemFontOfSize:19];
            _Inlabel.textAlignment = NSTextAlignmentCenter;
            
            _Scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_Inlabel.frame) * j +120, KScreenHeight/16 + KScreenHeight/10.6*i,KScreenWith/2,40)];
            _Scroller.contentSize = CGSizeMake(ScrollerWith*[SignalValue ShareValue].Integer/7.2, 40);
            _Scroller.tag = 1000+i;
            
            _Scroller.scrollEnabled = YES;
            _Scroller.layer.borderColor = [UIColor blackColor].CGColor;
            _Scroller.scrollEnabled = YES;
            _Scroller.layer.masksToBounds = YES;
            _Scroller.layer.cornerRadius = 3;
            _Scroller.showsVerticalScrollIndicator = YES;
            _Scroller.layer.borderWidth = 0.50f;
            [_BackScroller addSubview:_Scroller];
            [_BackScroller addSubview:_Inlabel];
    
        }
    }

    for (int i = 0; i < [SignalValue ShareValue].GetMessage.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 5, ScrollerWith*[SignalValue ShareValue].Integer/5, 30);
        label.tag = 2000+i;
        UIScrollView *scroller = [self.view viewWithTag:1000+i];
        [scroller addSubview:label];
    }
    
    
    
}
// 创建最低层的滚动视图
- (void)SetUpScroller
{
    _BackScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(KScreenWith/100, KScreenHeight/10, KScreenWith/1.5,KScreenHeight -  KScreenHeight/10 - 5)];
    _BackScroller.contentSize = CGSizeMake(ScrollerWith,ScrollerHight*[SignalValue ShareValue].Integer/9);
    _BackScroller.showsVerticalScrollIndicator = NO;
   // _BackScroller.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_BackScroller];
}
//创建场景的点击按钮
- (void)SetUpButton
{
    //场景;
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 2; j++) {
            _Button = [UIButton buttonWithType:UIButtonTypeSystem];
            _Button.frame = CGRectMake(KScreenWith/1.3 + (KScreenWith/8) * j, KScreenWith/7+(KScreenHeight/9)*i, KScreenWith/11, KScreenHeight/12);
            _Button.tag = 700+(2)*i+j;
            _Button.layer.borderColor = [UIColor blackColor].CGColor;
            _Button.layer.borderWidth = 0.5f;
            NSString * string = [NSString stringWithFormat:@"场景%d",2*i+j];
            [_Button setTitle:string forState:UIControlStateNormal];
            _Button.layer.masksToBounds = YES;
            _Button.layer.cornerRadius = 7;
            [_Button addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:_Button];
        }
    }
}

//场景按钮的点击事件
- (void)SendMessage:(UIButton *)but
{
    UIButton *button = (UIButton *)[self.view viewWithTag:700];
    button.backgroundColor = [UIColor whiteColor];
    for (int i=0; i< _saveArray.count; i++) {
        UIButton *button = [self.view viewWithTag:[(NSString*)_saveArray[i] integerValue]];
        if (but.tag == button.tag) {
            button.backgroundColor = [UIColor orangeColor];
            
            _saveValue = (NSInteger)(but.tag - 700);
        }
        else
        {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    
}

//场景保存的活动

- (void)setUpSaveButton
{
    _SaveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _SaveButton.frame = CGRectMake(KScreenWith/1.45 + KScreenWith/7, KScreenWith/4.3+(KScreenHeight/9)*5, KScreenWith/11, KScreenHeight/12);
    [_SaveButton setTitle:@"Save" forState:UIControlStateNormal];
    _SaveButton.backgroundColor = [UIColor whiteColor];
    _SaveButton.layer.cornerRadius = 8;
    _SaveButton.layer.masksToBounds = YES;
    _SaveButton.layer.borderColor = [UIColor blackColor].CGColor;
    _SaveButton.layer.borderWidth = 0.5;
    [_SaveButton addTarget:self action:@selector(SaveAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_SaveButton];
 
}

- (void)SaveAction:(UIButton *)sender
{
    
    NSString *host = [SignalValue ShareValue].SignalIpStr;
    uint16_t port = [SignalValue ShareValue].SignalPort;
    
    unsigned char save = _saveValue;
    
    kice_t kic = scene_save_cmd(save);
    
    NSData *data9 = [NSData dataWithBytes:(void *)&kic length:kic.size];
    [_udpSocket sendData:data9 toHost:host port:port withTimeout:60 tag:454];
}
//创建socket
- (void)SetUpSocket
{
    //初始化对象，使用全局队列
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalIpStr error:nil];
    
    [_udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
        //接收一次消息
    [_udpSocket receiveOnce:nil];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 454) {
        NSLog(@"标记为454的数据发送完成");
        
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"标记为tag%ld的发送失败 失败的原因%@",tag,error);
}

//接收数据完成
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    //[[SignalValue ShareValue].secene removeAllObjects];
    if ([SignalValue ShareValue].GetMessage != nil) {
         [[SignalValue ShareValue].GetMessage removeAllObjects];
    }
   
    
    [_getValu removeAllObjects];
    NSString *Host = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    //data接收数据
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    const unsigned char *a= [data bytes];
    kice_t *kic = (kice_t *)a;
    unsigned char cmd = kic->data[0];
    if(cmd == 0x27)
    {
        sw_state_t *sw = (sw_state_t *)(&((kice_t *)a)->data[3]);
        _countValue = (unsigned int)(sw->input);
        [SignalValue ShareValue].Integer = _countValue;
        unsigned int buf[512] ={0};
        for(int i = 0; i < _countValue; i++)
        {
            buf[i] = (unsigned char)sw->group[_countValue + i];
            NSInteger value = (NSInteger)buf[i];
            NSNumber *number = [NSNumber numberWithInteger:value];
            //[[SignalValue ShareValue].secene addObject:number];
            [[SignalValue ShareValue].GetMessage addObject:number];
            [_getValu addObject:number];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
                           for (int i = 0; i < [SignalValue ShareValue].Integer ; i++) {
                    UILabel *label = (UILabel *)[self.view viewWithTag: 2000 + i];
                    label.text = @" ";
                }
                
                NSLog(@"清空");
        
            
            NSString *str = @"";
                _string  = _getValu[0];
            for (int i = 0; i <_getValu.count; i++) {
                NSNumber *number = _getValu[i];
                NSInteger integer = number.integerValue;
                UILabel *text = [self.view viewWithTag:2000 + integer - 1];
                NSString *string = [NSString stringWithFormat:@"%d",i + 1];
                NSString *strVale = [NSString stringWithFormat:@"%ld",(long)(i+600+[SignalValue ShareValue].Integer/9*145+144)];
                NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:strVale];
                if (value == nil) {
                    NSString *stringwe = text.text;
                    str = [NSString stringWithFormat:@"%@ %@,",stringwe ,string];
                    text.text = str;
                }else
                {
                    NSString *textString = text.text;
                    NSString *stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:strVale];
                    str = [NSString stringWithFormat:@"%@ %@,",textString,stringValue];
                    text.text = str;
                }

            }
            
        });
       
        NSLog(@"代理赋值");
    }
   
    [sock receiveOnce:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendBackToHost:Host port:port withMessage:str];
    });

}

- (void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)str
{
    NSString *s = @"我已接收收到消息";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:565];
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
