//
//  LoginViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/28.
//  Copyright © 2016年 times. All rights reserved.
//

#import "LoginViewController.h"

#import "Masonry.h"
#import "BaseViewController.h"
#import "GCDAsyncSocket.h"
#import "MBProgressHUD.h"

#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "SBJsonBase.h"
#import "NSObject+SBJSON.h"
#import "MBProgressHUD+MJ.h"
#import "DataHelp.h"
#import "InternationalControl.h"
#import "AppDelegate.h"
#import "SeleDataManager.h"

#define UserNameString [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"]
#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height

#define HostIP [[NSUserDefaults standardUserDefaults]objectForKey:@"HostKey"]
#define HostPort [[[NSUserDefaults standardUserDefaults]objectForKey:@"PortKey"] integerValue]

@interface LoginViewController ()<UITextFieldDelegate,GCDAsyncSocketDelegate>
{
    NSMutableArray *AllClientArray;
    NSUserDefaults *Hostdefaults;
    NSUserDefaults *Portdefaults;
    MBProgressHUD  *MBPHUD;
}
@property (nonatomic ,strong)UIView *Aview;
@property (nonatomic ,assign)BOOL isBool;
@property (nonatomic ,strong)UIButton *PortButton;
@property (nonatomic ,strong)UIView *Portview;
@property (nonatomic ,strong)UITextField *PortText;
@property (nonatomic ,strong)UITextField *HostText;
@property (nonatomic ,strong)UIButton *SaveButton;
@property (nonatomic ,strong)UIView *BelowView;
@property (nonatomic ,strong)NSString *IP;
@property (nonatomic ,assign)uint16_t Port;
@property (nonatomic ,strong)UITextField *TextField; //用户名
@property (nonatomic ,strong)UITextField *PassTextField; //密码
@property (nonatomic ,assign)NSInteger KeyBordHeight; //键盘高度
@property (nonatomic ,assign)NSInteger KeYBoardNumber;
@property (nonatomic ,assign)NSInteger count;
@property (nonatomic ,strong)NSString *LogSuccess;
@property (nonatomic ,assign)BOOL isClick;
@property (nonatomic ,assign)BOOL isLanguage;
@property (nonatomic ,strong)MBProgressHUD *mbp;
@property (nonatomic ,strong)MBProgressHUD *LinkSuccess;
@property (nonatomic ,strong)MBProgressHUD *LinkError;
@property (nonatomic ,assign)BOOL IsClickLogin;
@property (nonatomic ,strong)UIImageView *BottomView;
@property (nonatomic ,strong)UIButton *LanguageButton;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"];
    NSString *passward = [[NSUserDefaults standardUserDefaults]objectForKey:@"passward"];
    _TextField.text = userName;
    _PassTextField.text = passward;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChangeLanguageNotice) name:@"changeLanguage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyBoardWillHiden:) name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.view.bounds];
    UIImage *image = [UIImage imageNamed:@"LoginBac"];
    imageview.image = image;
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    [self setLongin];
}


- (void)setLongin
{
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([language isEqualToString:@"en"]) {
        _isLanguage = YES;
    }else{
        _isLanguage = NO;
    }
    
    
    UIImageView *LogImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50,195, 63)];
    UIImage *Log = [UIImage imageNamed:@"LoginKensenceLogo"];
    LogImage.image = Log;
    [self.view addSubview:LogImage];
    
    
    [InternationalControl initUserLanguage]; //初始化应用语言
    NSBundle *bundle = [InternationalControl bundle];
    NSString *buttonInfo = [bundle localizedStringForKey:@"ButtonInfo" value:nil table:@"NSLocalizedLanguage"];
    UIButton *button = (UIButton *)[self.view viewWithTag:150];
    [button setTitle:buttonInfo forState:UIControlStateNormal];
    [super viewDidLoad];
    _count = 0;
    //登录界面的最底层view
    _BelowView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_BelowView];
    
    UIView *Bac = [[UIView alloc]initWithFrame:CGRectMake(0,View4Height , View4Width, - View4Height/4)];
    Bac.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:43/255.0 green:161/255.0 blue:250/255.0 alpha:1];
    _Aview = [[UIView alloc]init];
    _Aview.frame = CGRectMake(View4Width/3, View4Height/2.3, View4Width/3, View4Height/2.7);
    [_BelowView addSubview:_Aview];
    UIImage *image1 = [UIImage imageNamed:@"LoginBrand"];
    UIImageView *imagevi = [[UIImageView alloc]init];
    imagevi.image  = image1;
    imagevi.frame = CGRectMake(View4Width/3.5, View4Height/3.5, 64, 64);
    [_Aview addSubview:imagevi];
    [imagevi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_Aview.mas_top).with.offset(50);
        make.left.equalTo(_Aview.mas_left).with.offset(30);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    

    _PortButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *portImage = [UIImage imageNamed:@"Up"];
    portImage = [portImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _PortButton.frame = CGRectMake(Bac.frame.size.width / 2 - 25,View4Height - 30, 50, 20);
    [_PortButton setImage:portImage forState:UIControlStateNormal];
    [_PortButton addTarget:self action:@selector(EditPort:) forControlEvents:UIControlEventTouchDown];
    [_BelowView addSubview:_PortButton];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 10, _Aview.frame.size.width,40);
    label.text = @"云媒体管理平台";
    label.textColor = [UIColor colorWithRed:5/255.0 green:174/255.0 blue:231/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:27];
//    CGSize Meetingbuttonsize = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [_Aview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_Aview.mas_top).with.offset(50);
        make.left.equalTo(imagevi.mas_right).with.offset(10);
        make.right.equalTo(_Aview.mas_right).with.offset(-0);
//        make.width.mas_equalTo(Meetingbuttonsize.width);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *UserName = [[UILabel alloc]init];
    UserName.frame = CGRectMake(CGRectGetMinX(label.frame),CGRectGetMaxY(label.frame)+30,60,20);
    CGSize lableSize = [UserName.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [UserName setFrame:CGRectMake(CGRectGetMinX(label.frame),CGRectGetMaxY(label.frame)+30, lableSize.width, 20)];
    [_Aview addSubview:UserName];

    
    _TextField = [[UITextField alloc]init];
    _TextField.frame = CGRectMake(CGRectGetMaxX(UserName.frame)+10, CGRectGetMaxY(label.frame)+20, 340 ,49);
    _TextField.backgroundColor = WhiteColor;
    _TextField.clearButtonMode = UITextFieldViewModeAlways;
    _TextField.layer.borderWidth = 0.5;
    _TextField.delegate = self;
    _TextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"];
    _TextField.layer.borderColor = [UIColor blackColor].CGColor;
    _TextField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginUserIcon"]];
    _TextField.textColor = UIColor.blackColor;
    _TextField.leftViewMode = UITextFieldViewModeAlways;
    _TextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_Aview addSubview:_TextField];

    
    UILabel *PassWord = [[UILabel alloc]init];
    PassWord.frame = CGRectMake(CGRectGetMinX(UserName.frame),CGRectGetMaxY(UserName.frame)+40,60,20);
//    PassWord.text = Localized(@"密码");
    CGSize palableSize = [PassWord.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [PassWord setFrame:CGRectMake(CGRectGetMinX(UserName.frame),CGRectGetMaxY(UserName.frame)+40, palableSize.width, 20)];
    [_Aview addSubview:PassWord];

        //密码
    _PassTextField = [[UITextField alloc]init];
    _PassTextField.frame = CGRectMake(CGRectGetMaxX(UserName.frame)+10, CGRectGetMaxY(UserName.frame)+30, 340 ,49);
    _PassTextField.layer.borderWidth = 0.5;
    _PassTextField.delegate = self;
    _PassTextField.backgroundColor = WhiteColor;
    _PassTextField.clearButtonMode = UITextFieldViewModeAlways;
    _PassTextField.secureTextEntry = YES;
    _PassTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"passward"];
    _PassTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _PassTextField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginPassWordIcon"]];
    _PassTextField.leftViewMode = UITextFieldViewModeAlways;
    _PassTextField.textColor = UIColor.blackColor;
    [_Aview addSubview:_PassTextField];
    //登录指令
    UIButton *Loginbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    Loginbutton.frame = CGRectMake(CGRectGetMaxX(_PassTextField.frame)+10, CGRectGetMaxY(label.frame)+30, _Aview.frame.size.width/5, 70);
    Loginbutton.layer.borderColor = [UIColor blackColor].CGColor;
    Loginbutton.layer.borderWidth = 0.3;
    UIImage *BacImage = [UIImage imageNamed:@"LoginButton"];
    BacImage = [BacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Loginbutton setBackgroundImage:BacImage forState:UIControlStateNormal];
    [Loginbutton setTitle:Localized(@"登录") forState:UIControlStateNormal];
    [Loginbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [Loginbutton addTarget:self action:@selector(LonginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Aview addSubview:Loginbutton];
    [Loginbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PassTextField.mas_bottom).with.offset(10);
        make.left.equalTo(_PassTextField.mas_left).with.offset(0);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(48.5);
        
    }];
    
    UIImageView *Language = [[UIImageView alloc]initWithFrame:CGRectMake(View4Width -200 , 50, 32, 32)];
    UIImage *LanguageImage = [UIImage imageNamed:@"LoginLanguageIcon"];
    Language.image = LanguageImage;
    [self.view addSubview:Language];
    
    
    _LanguageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_LanguageButton setTitleColor:[UIColor colorWithRed:3/255.0 green:178/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    _LanguageButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _LanguageButton.tag = 152;
    
    if (_isLanguage == YES) {
        
        [_LanguageButton setTitle:@"English" forState:UIControlStateNormal];
        
    }else
    {
        [_LanguageButton setTitle:@"中文" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:_LanguageButton];
    [_LanguageButton addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchDown];
    [_LanguageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.left.equalTo(Language.mas_right).with.offset(-15);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(100);
    }];
    _BottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *bottomImage = [UIImage imageNamed:@"LoginBottom"];
    _BottomView.image = bottomImage;
    [self.view addSubview:_BottomView];
    [_BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(57);
        make.left.equalTo(_LanguageButton.mas_right).with.offset(-15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    
//    UIImageView *raw = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    UIImage *rawImage = [UIImage imageNamed:@"LoginBrand"];
//    raw.image = rawImage;
//    [self.view addSubview:raw];
//    [_BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_TextField.mas_top).with.offset(-10);
//        make.left.equalTo(_TextField.mas_left).with.offset(10);
//        make.height.mas_equalTo(64);
//        make.width.mas_equalTo(64);
//    }];
//
  
    //初始化mutdata存放接收到的数据
    _mutData = [NSMutableData data];
    
    //增加监听，当键盘出现时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JumpViewtoBase:) name:@"Log" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ConnectSucc:) name:@"ConnectSu" object:nil];
}






- (void)ChangeLanguageNotice
{
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate toMain];
}

- (void)ConnectSucc:(NSNotification *)notice
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow];
        [_LinkError hideAnimated:YES];
        
        if (_IsClickLogin == YES) {
            _IsClickLogin = NO;
//            [[NSUserDefaults standardUserDefaults]setObject:_TextField.text forKey:@"Username"];
//            [[NSUserDefaults standardUserDefaults]setObject:_PassTextField.text forKey:@"passward"];
//            
//            NSDictionary *dict = @{
//                                   @"message":@{
//                                           @"function":@"user_login",
//                                           @"user":@{
//                                                   @"name":_TextField.text,
//                                                   @"password":_PassTextField.text
//                                                   }}};
//            NSData *data = [[NSString stringWithFormat:@"%@\n",[dict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
//            [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:500];
//            [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:500];
        }
        
        
        
        
        
        
    });
}
//语言选择
- (void)changeLanguage:(UIButton *)button
{
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([language isEqualToString:@"en"]) {
        _isLanguage = YES;
    }else{
        _isLanguage = NO;
    }
    
    UIImageView *TopView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *image = [UIImage imageNamed:@"LoginTop"];
    TopView.image = image;
    TopView.tag = 1903;
    [self.view addSubview:TopView];
    [TopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomView.mas_bottom).with.offset(3);
        make.left.equalTo(_LanguageButton.mas_right).with.offset(-15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    UIButton *chinabutton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (_isLanguage == YES) {
        chinabutton.backgroundColor = [UIColor colorWithRed:41/255.0 green:51/255.0 blue:61/255.0 alpha:1];
       
    }else
    {
         chinabutton.backgroundColor = [UIColor colorWithRed:5/255.0 green:174/255.0 blue:231/255.0 alpha:1];
    }
    
    [chinabutton setTitle:@"简体中文" forState:UIControlStateNormal];
    chinabutton.tag = 1901;
    [chinabutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [chinabutton addTarget:self action:@selector(ChinaAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chinabutton];
    [chinabutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(TopView.mas_bottom).with.offset(0);
        make.right.equalTo(TopView.mas_right).with.offset(-0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(150);
    }];
    

    UIButton *Engbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (_isLanguage == YES) {
       
       Engbutton.backgroundColor = [UIColor colorWithRed:5/255.0 green:174/255.0 blue:231/255.0 alpha:1];
    }else
    {
         Engbutton.backgroundColor =  [UIColor colorWithRed:41/255.0 green:51/255.0 blue:61/255.0 alpha:1];
    }
    [Engbutton setTitle:@"English" forState:UIControlStateNormal];
    Engbutton.tag = 1902;
    [Engbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [Engbutton addTarget:self action:@selector(EnglishAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:Engbutton];
    [Engbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chinabutton.mas_bottom).with.offset(1);
        make.right.equalTo(TopView.mas_right).with.offset(-0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(150);
    }];
}


- (void)ChinaAction:(UIButton *)button
{
    _isLanguage = NO;
    [[NSUserDefaults standardUserDefaults]setObject:@"zh-Hans" forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIButton *botbutton = (UIButton *)[self.view viewWithTag:152];
    [botbutton setTitle:@"简体中文" forState:UIControlStateNormal];
    //        _isClick = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLanguage" object:nil];
}


- (void)EnglishAction:(UIButton *)button
{
    _isLanguage = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UIButton *botbutton = (UIButton *)[self.view viewWithTag:152];
    [botbutton setTitle:@"English" forState:UIControlStateNormal];
    //        _isClick = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLanguage" object:nil];
    
}



- (void)EngButtonAction:(UIButton *)button
{
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([language isEqualToString:@"en"]) {
        _isLanguage = YES;
    }else{
        _isLanguage = NO;
    }
    if (_isLanguage == NO) {
          _isLanguage = YES;
        [[NSUserDefaults standardUserDefaults]setObject:@"en" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",_isLanguage] forKey:@"languageBool"];
        UIButton *button = (UIButton *)[self.view viewWithTag:152];
        [button setTitle:@"中文" forState:UIControlStateNormal];
//        _isClick = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLanguage" object:nil];
        
    }else
    {
       [[NSUserDefaults standardUserDefaults]setObject:@"zh-Hans" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults]synchronize];
         _isLanguage = NO;
       
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",_isLanguage] forKey:@"languageBool"];
        UIButton *button = (UIButton *)[self.view viewWithTag:152];
        [button setTitle:@"English" forState:UIControlStateNormal];
//        _isClick = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLanguage" object:nil];
    }
    
    UIView *view = (UIView *)[self.view viewWithTag:150];
    [view removeFromSuperview];
    [button removeFromSuperview];
}

//登录成功跳转
- (void)JumpViewtoBase:(NSNotification *)notice
{
    NSMutableArray *channel = [[NSMutableArray alloc]init];
    [DataHelp shareData].MeetingDestchanid = [NSMutableArray array];
    [DataHelp shareData].MeetingDestdevid = [NSMutableArray array];
    [DataHelp shareData].MeetingRnameArray = [NSMutableArray array];
    
    
    for (int i = 0;i < [DataHelp shareData].LocationArray.count; i++) {
        NSDictionary *LocaDict = [DataHelp shareData].LocationArray[i];
        if ([[LocaDict valueForKey:@"name"]isEqualToString:@"默认"]) {
            [[DataHelp shareData].LocationArray insertObject:[DataHelp shareData].LocationArray[i] atIndex:0];
            [[DataHelp shareData].LocationArray removeObjectAtIndex:i+1];
        }
    }
    
        if ([[DataHelp shareData].LocationArray[0][@"id"]isEqualToString:@"0000000000"]) {

            for (NSDictionary *device in [DataHelp shareData].DeviceArray) {
                if ([device[@"type"]isEqualToString:@"RX"] && [device[@"location"][@"id"] isEqualToString:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[0][@"id"] ]]) {
                    [[DataHelp shareData].MeetingDestdevid addObject:device[@"id"]];
                    [[DataHelp shareData].MeetingRnameArray addObject:device[@"name"]];
                    
                    channel = device[@"channels"];
                    [[DataHelp shareData].RIPArray addObject:[device[@"net"] valueForKey:@"ip"]];
                    for (NSDictionary *Dict in channel) {
                        [[DataHelp shareData].MeetingDestchanid addObject:Dict[@"id"]];
                    }
                }
            }
   
        }
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mbp hideAnimated:YES];
        
         [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(JumpController:) userInfo:nil repeats:NO];
        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        mbp.mode = MBProgressHUDModeText;
        mbp.label.text = Localized(@"登录成功");
        mbp.margin = 10.0f; //提示框的大小
        [mbp customView];
        [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
        mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
        [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[BaseViewController new]];
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    });

  
//    UIWindow *window = [[UIWindow ];
//    window.rootViewController = nav;
}

- (void)JumpController:(id)Timer
{
    
}

//键盘出现时的
- (void)keyboardWillShow:(NSNotification *)notice
{
    NSDictionary *userInfo = [notice userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _KeyBordHeight = keyboardRect.size.height;
    
    _KeYBoardNumber++;
    if (_KeYBoardNumber == 1 && _isBool == 0) {
        _KeYBoardNumber++;
        _BelowView.frame  = CGRectMake(0, - (_KeyBordHeight - View4Height / 4) ,View4Width, View4Height);
        
    }else if (_KeYBoardNumber == 1 && _isBool == 1)
    {
        _BelowView.frame  = CGRectMake(0, - (_KeyBordHeight) ,View4Width, View4Height);
    }
}

    //保存ip port；
- (void)SaveButtonAction:(UIButton *)button
{
    
    [_PortText resignFirstResponder];
    [_HostText resignFirstResponder];
    
    if (_PortText.text != nil && _HostText.text != nil) {
         unsigned short utfString = [_PortText.text integerValue];
        _Port = utfString;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        if (_isBool == YES) {
           [_BelowView setFrame:CGRectMake(0, - (_KeyBordHeight ) ,View4Width, View4Height)];
        }
        [UIView commitAnimations];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [_BelowView setFrame:CGRectMake(0, 0, View4Width, View4Height)];
        [UIView commitAnimations];

        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        UIImage *image = [UIImage imageNamed:@"Up"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_PortButton setImage:image forState:UIControlStateNormal];
        [_PortButton setFrame:CGRectMake(self.view.frame.size.width/2 - 25,self.view.frame.size.height - 30,50,20)];
        [UIView commitAnimations];
        
     
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [_Portview setFrame:CGRectMake(0, View4Height, View4Width, 120)];
        [UIView commitAnimations];
        _isBool = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(DalayRemove:) userInfo:nil repeats:NO];
        if ([[DataHelp shareData].ClientSocket isConnected]) {
         
        }
        [self resignFirstResponder];
     }else
     {
         NSLog(@"有问题");
         
     }
    Hostdefaults = [NSUserDefaults standardUserDefaults];
    [Hostdefaults setObject:_HostText.text forKey:@"HostKey"];
    [Hostdefaults synchronize];
    
    Portdefaults = [NSUserDefaults standardUserDefaults];
    [Portdefaults setObject:_PortText.text forKey:@"PortKey"];
    [Portdefaults synchronize];
    
//    if ([[DataHelp shareData].ClientSocket isDisconnected]) {
//        
//        unsigned short utfString = [_PortText.text integerValue];
//        [[DataHelp shareData] CreatTcpSocketWithIP:_HostText.text port:utfString];
//        
//    }else
//    {
//        
//    }
    
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.mode = MBProgressHUDModeText;
    mbp.label.text =Localized(@"保存成功");
    mbp.margin = 10.0f; //提示框的大小
    [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
    mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
    [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏

}

- (void)DalayRemove:(NSTimer *)timer
{
    [_Portview removeFromSuperview];
}

- (void)EditPort:(UIButton *)button
{
    Hostdefaults = [NSUserDefaults standardUserDefaults];
    NSString *host = [Hostdefaults objectForKey:@"HostKey"];
    
    Portdefaults = [NSUserDefaults standardUserDefaults];
    NSString *port = [Portdefaults objectForKey:@"PortKey"];
    
    if (_isBool == 0) {
        _isBool = 1;
        
        _Portview = [[UIView alloc]initWithFrame:CGRectMake(0, View4Height, View4Width, 120)];
        [_BelowView addSubview:_Portview];
        _HostText = [[UITextField alloc]initWithFrame:CGRectMake(10, _Portview.frame.size.height - 70,_Portview.frame.size.width / 4, 40)];
        _HostText.backgroundColor = [UIColor colorWithRed:104/255.0 green:111/255.0 blue:118/255.0 alpha:1];
        _HostText.layer.borderWidth = 0.5;
        _HostText.layer.borderColor = [UIColor blackColor].CGColor;
        _HostText.layer.cornerRadius = 3;
        _HostText.layer.masksToBounds = YES;
        _HostText.placeholder = @"IP地址";
        _HostText.delegate = self;
        _HostText.keyboardType = UIKeyboardTypeNumberPad;
        _HostText.text = host;
        _HostText.textAlignment = NSTextAlignmentCenter;
        [_Portview addSubview:_HostText];
        
        _PortText = [[UITextField alloc]initWithFrame:CGRectMake(_Portview.frame.size.width / 2 - _Portview.frame.size.width / 8 , _Portview.frame.size.height - 70,_Portview.frame.size.width / 4, 40)];
        _PortText.layer.borderWidth = 0.5;
        _PortText.placeholder = @"端口号";
        _PortText.backgroundColor = [UIColor colorWithRed:104/255.0 green:111/255.0 blue:118/255.0 alpha:1];
        _PortText.textAlignment = NSTextAlignmentCenter;
        _PortText.delegate = self;
        _PortText.keyboardType = UIKeyboardTypeNumberPad;
        _PortText.layer.borderColor = [UIColor blackColor].CGColor;
        _PortText.layer.cornerRadius = 3;
        _PortText.layer.masksToBounds = YES;
        _PortText.text = port;
        [_Portview addSubview:_PortText];

        
        _SaveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _SaveButton.frame = CGRectMake(_Portview.frame.size.width - _Portview.frame.size.width / 4 -10 , _Portview.frame.size.height - 70,_Portview.frame.size.width / 4, 40);
        _SaveButton.layer.borderWidth = 0.5;
        _SaveButton.layer.borderColor = [UIColor blackColor].CGColor;
        [_SaveButton setBackgroundImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
        _SaveButton.layer.cornerRadius = 3;
        [_SaveButton setTitle:@"确定" forState:UIControlStateNormal];
        [_SaveButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_SaveButton addTarget:self action:@selector(SaveButtonAction:) forControlEvents:UIControlEventTouchDown];
        _SaveButton.layer.masksToBounds = YES;
        [_Portview addSubview:_SaveButton];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        UIImage *image = [UIImage imageNamed:@"down"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_PortButton setImage:image forState:UIControlStateNormal];
        [_PortButton setFrame:CGRectMake(self.view.frame.size.width/2 - 25,self.view.frame.size.height - 150,50,20)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [_Portview setFrame:CGRectMake(0, View4Height - 120, View4Width, 120)];
        [UIView commitAnimations];
  
    }else
    {
        _isBool = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        UIImage *image = [UIImage imageNamed:@"Up"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_PortButton setImage:image forState:UIControlStateNormal];
        [_PortButton setFrame:CGRectMake(self.view.frame.size.width/2 - 25,self.view.frame.size.height - 30,50,20)];
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.7];
        [_Portview setFrame:CGRectMake(0, View4Height, View4Width, 120)];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(DalayRemove:) userInfo:nil repeats:NO];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_KeYBoardNumber != 1 && _isBool == 1) {
    
      _BelowView.frame  = CGRectMake(0, - (_KeyBordHeight ) ,View4Width, View4Height);
    }else if (_KeYBoardNumber != 1 && _isBool == 0)
    {
        _BelowView.frame  = CGRectMake(0, - (_KeyBordHeight - View4Height /4) ,View4Width, View4Height);
    }
}

- (void)KeyBoardWillHiden:(NSNotification *)notice
{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [_BelowView setFrame:CGRectMake(0, 0, View4Width, View4Height)];
        [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [_BelowView setFrame:CGRectMake(0, 0, View4Width, View4Height)];
//    [UIView commitAnimations];
}

#pragma mark===发送数据===
- (void)LonginAction:(UIButton *)button
{
    [_PortText resignFirstResponder];
    [_HostText resignFirstResponder];
    [_TextField resignFirstResponder];
    [_PassTextField resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    self.mbp = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:self.mbp];
    self.mbp.label.text = Localized(@"正在登录，稍后");
//self.mbp.backgroundColor = [UIColor colorWithRed:154/255.0 green:116/255.0 blue:79/255.0 alpha:0.2];
    self.mbp.mode =  MBProgressHUDModeAnnularDeterminate;
    [self.mbp showAnimated:YES whileExecutingBlock:^{
        Hostdefaults = [NSUserDefaults standardUserDefaults];
        Portdefaults = [NSUserDefaults standardUserDefaults];
        NSString *port = [Portdefaults objectForKey:@"PortKey"];
        unsigned short utfString = [port integerValue];
        NSString *host = [Hostdefaults objectForKey:@"HostKey"];
        [[DataHelp shareData] CreatTcpSocketWithIP:host port:utfString];
        
        if ([[DataHelp shareData].ClientSocket isConnected]) {
            sleep(0);
        }else
        {
        sleep(3);
        }
    } completionBlock:^{
        [self.mbp removeFromSuperview];
        if ([[DataHelp shareData].ClientSocket isConnected]) {
            [SeleDataManager CreatTable];
            [SeleDataManager DeleteWithTemp:UserNameString];
            [self LoginData];
            _IsClickLogin = YES;
          
        }else
        {
                self.mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                self.mbp.mode = MBProgressHUDModeText;
                self.mbp.label.text = Localized(@"网络连接有误，检查N-mix网络配置");
                self.mbp.margin = 10.0f; //提示框的大小
                //                  self.mbp.backgroundColor = WhiteColor;
                self.mbp.label.textColor = [UIColor blackColor];
                [self.mbp customView];
                [self.mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                self.mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除viewR
                [self.mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        }
    }];
         
 });
 
}

//登录指令
- (void)LoginData
{
    [[NSUserDefaults standardUserDefaults]setObject:_TextField.text forKey:@"Username"];
    [[NSUserDefaults standardUserDefaults]setObject:_PassTextField.text forKey:@"passward"];
    
    NSDictionary *dict = @{
                           @"message":@{
                                   @"function":@"user_login",
                                   @"user":@{
                                           @"name":_TextField.text,
                                           @"password":_PassTextField.text
                                           }}};
    NSData *data = [[NSString stringWithFormat:@"%@\n",[dict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:500];
    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:500];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_PortText resignFirstResponder];
    [_HostText resignFirstResponder];
    [_TextField resignFirstResponder];
    [_PassTextField resignFirstResponder];

    _BelowView.frame = CGRectMake(0, 0, View4Width, View4Height);
    UIButton *button = (UIButton *)[self.view viewWithTag:1901];
    UIButton *enButton = (UIButton *)[self.view viewWithTag:1902];
    UIImageView *topView = (UIImageView *)[self.view viewWithTag:1903];
    [topView removeFromSuperview];
    [button removeFromSuperview];
    [enButton removeFromSuperview];
    if (_isClick == YES) {
        _isClick = NO;
        UIButton *button = (UIButton *)[self.view viewWithTag:151];
        [button removeFromSuperview];
        UIView *view = (UIView *)[self.view viewWithTag:150];
        [view removeFromSuperview];
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
