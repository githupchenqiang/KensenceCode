//
//  CamerViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/25.
//  Copyright © 2016年 times. All rights reserved.
#import "CamerViewController.h"
#import "Masonry.h"
#import "DataHelp.h"
#import <QuartzCore/QuartzCore.h>
#import "GCDAsyncSocket.h"
#import "MBProgressHUD.h"
#import "LinkIPCamer.h"
#import "KTOneFingerRotationGestureRecognizer.h"

#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height
#define AViewWidth     aView.frame.size.width
#define AViewHeight     aView.frame.size.height
#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180 / M_PI)


@interface CamerViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,GCDAsyncSocketDelegate,UITableViewDataSource,UITableViewDelegate>
{
    GCDAsyncSocket *CamerGCD;
    UITableView *tabel;
}

@property (nonatomic ,strong)UITextField *IPtext; //ip
@property (nonatomic ,strong)UITextField *IPcametext; //带宽
@property (nonatomic ,strong)UITextField *Resolution; //分辨率
@property (nonatomic ,assign)CGFloat lastRotation;
@property (nonatomic ,assign)NSInteger CamerInder; //当前的设备
@property (nonatomic ,assign)NSInteger Number;
@property (nonatomic ,assign)BOOL isconnect; //是否连接
@property (nonatomic ,assign)CGFloat KeyboardHeight; //获取键盘高度
@property (nonatomic ,assign)BOOL isBoaed;
@property (nonatomic ,assign)NSInteger IntCount;

@property (nonatomic ,assign)CGFloat Rotation; //旋转角度
@property (nonatomic, assign) CGFloat currentAngle;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat stopAngle;

@property (nonatomic ,assign)NSInteger index;
@property (nonatomic ,assign)CGFloat Anycle;
@property (nonatomic ,strong)NSMutableArray *ResolutionArray;




@end

@implementation CamerViewController


@synthesize currentAngle = _currentAngle;
@synthesize startAngle = _startAngle;
@synthesize stopAngle = _stopAngle;

- (void)viewDidAppear:(BOOL)animated
{
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)dealloc
{
    [CamerGCD disconnect];
    CamerGCD = nil;
    [DataHelp shareData].TCamerIndex = 0;
    [DataHelp shareData].RCamerIndx = 0;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [CamerGCD disconnect];
    _TIndex = 0;
    _Rindex = 0;
    [DataHelp shareData].IPtext = nil;
    [DataHelp shareData].PortText = nil;
    [DataHelp shareData].isConnect = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ResolutionArray = [NSMutableArray arrayWithObjects:@"HD720p30",@"HD720p60",@"HD1080p30",@"HD1080P60", nil];
    
    if ([DataHelp shareData].isTdecore == YES) {
        [LinkIPCamer creatTable];
        [LinkIPCamer SeleTDecoder:YES Rdecoder:NO Meeting:0 TIndex:_TIndex Rindex:_Rindex];
    }else
    {
        [LinkIPCamer creatTable];
        [LinkIPCamer SeleTDecoder:NO Rdecoder:YES Meeting:[DataHelp shareData].MeetingNumber TIndex:_TIndex Rindex:_Rindex];
    }
     _CamerInder = [DataHelp shareData].TCamerIndex;
    self.view.backgroundColor = [UIColor colorWithRed:42/255.0 green:50/255.0 blue:60/255.0 alpha:1];
    UIImageView*HederView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 675, 47)];
//    HederView.backgroundColor = [UIColor colorWithRed:32/255.0 green:40/255.0 blue:50/255.0 alpha:1];
    UIImage *HeadeImage = [UIImage imageNamed:@"AlertTitleBg"];
    HeadeImage = [HeadeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HederView.image = HeadeImage;
    HederView.userInteractionEnabled = YES;
    [self.view addSubview:HederView];
    [HederView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.height.mas_equalTo(47);
        make.right.equalTo(self.view.mas_right).with.offset(-0);
    }];
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(675 - 55, 3, 40, 40);
    UIImage *BacImage = [UIImage imageNamed:@"Remove"];
    BacImage = [BacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cancleButton setImage:BacImage forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(CanButtonAction:) forControlEvents:UIControlEventTouchDown];
    [HederView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(3);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
   
    UILabel *HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0,200, 47)];
    HeaderLabel.text = [NSString stringWithFormat:@"%@ (%@) %@",[DataHelp shareData].camerIndexName,[DataHelp shareData].ipString,Localized(@"控制")];
    HeaderLabel.backgroundColor = [UIColor colorWithRed:32/255.0 green:40/255.0 blue:50/255.0 alpha:1];
    HeaderLabel.textColor = kensenceColor;
    HeaderLabel.font = [UIFont systemFontOfSize:20];
    CGSize Emergencysize = [HeaderLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [HeaderLabel setFrame:CGRectMake(15, 0,Emergencysize.width,47)];
    [self.view addSubview:HeaderLabel];
    [HeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HederView.mas_top).with.offset(3);
        make.left.equalTo(HederView.mas_left).with.offset(15);
        make.bottom.equalTo(HederView.mas_bottom).with.offset(-2);
        make.right.equalTo(cancleButton.mas_right).with.offset(-55);
    }];
  
    
    
    UILabel *Orient = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    Orient.text =Localized(@"方向调节");
    Orient.textColor = TextColor;
    Orient.font = [UIFont systemFontOfSize:20];
    Orient.textAlignment = NSTextAlignmentCenter;
    [HederView addSubview:Orient];
    [Orient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HederView.mas_bottom).with.offset(15);
        make.left.equalTo(HederView.mas_left).with.offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(675/4);
    }];
    //方向背景
    UIImageView *CamerOrient = [[UIImageView alloc]initWithFrame:CGRectMake(15,100, 675/4,675/4)];
    UIImage *Came = [UIImage imageNamed:@"DirectionTool"];
    Came = [Came imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CamerOrient.image = Came;
    CamerOrient.userInteractionEnabled = YES;
    [self.view addSubview:CamerOrient];
    [CamerOrient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HederView.mas_top).with.offset(100);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.height.mas_equalTo(675/4);
        make.width.mas_equalTo(675/4);
    }];
    //向上
    UIButton *UpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UpButton.frame = CGRectMake(675/8 - 15.5,22, 34, 28);
  
 if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
     UpButton.userInteractionEnabled = NO;
     UIImage *topImage = [UIImage imageNamed:@"DirectionTool-Top-Disabled"];
     topImage = [topImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [UpButton setBackgroundImage:topImage forState:UIControlStateNormal];
 }else
 {
     UIImage *topImage = [UIImage imageNamed:@"DirectionTool-Top-Active"];
     topImage = [topImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [UpButton setBackgroundImage:topImage forState:UIControlStateNormal];
 }
    [UpButton addTarget:self action:@selector(UpButtonAction:) forControlEvents:UIControlEventTouchDown];
    [CamerOrient addSubview:UpButton];
    
    //向左
    UIButton *LeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    LeftButton.frame = CGRectMake(21.5,675/8 - 18,  28, 34);
  
    [LeftButton addTarget:self action:@selector(LeftButtonAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        LeftButton.userInteractionEnabled = NO;
        UIImage *leftImage = [UIImage imageNamed:@"DirectionTool-Left-Disabled"];
        leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [LeftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    }else
    {
        UIImage *leftImage = [UIImage imageNamed:@"DirectionTool-Left-Active"];
        leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [LeftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    }
    [CamerOrient addSubview:LeftButton];
    
    //向下
    UIButton *BottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    BottomButton.frame = CGRectMake(675/8 - 15.5,675/4 - 53,  34, 28);
  
    [BottomButton addTarget:self action:@selector(BottomButtonAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        BottomButton.enabled = NO;
        UIImage *BottomImage = [UIImage imageNamed:@"DirectionTool-Bottom-Disabled"];
        BottomImage = [BottomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [BottomButton setBackgroundImage:BottomImage forState:UIControlStateNormal];
    }else
    {
        UIImage *BottomImage = [UIImage imageNamed:@"DirectionTool-Bottom-Active"];
        BottomImage = [BottomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [BottomButton setBackgroundImage:BottomImage forState:UIControlStateNormal];
    }
    [CamerOrient addSubview:BottomButton];
    
    //向右
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RightButton.frame = CGRectMake(675/4 - 52,675/8- 18.5, 28, 34);
    [RightButton addTarget:self action:@selector(RightAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
          RightButton.userInteractionEnabled = NO;
        UIImage *RightImage = [UIImage imageNamed:@"DirectionTool-Right-Disabled"];
        RightImage = [RightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [RightButton setBackgroundImage:RightImage forState:UIControlStateNormal];
    }else
    {
    UIImage *RightImage = [UIImage imageNamed:@"DirectionTool-Right-Active"];
    RightImage = [RightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [RightButton setBackgroundImage:RightImage forState:UIControlStateNormal];
    }
     [CamerOrient addSubview:RightButton];
    //调焦
    UILabel *Foucelabel = [[UILabel alloc]initWithFrame:CGRectMake(675/8 - 18 + 15, CGRectGetMaxY(CamerOrient.frame)+5, 40, 20)];
    Foucelabel.text = Localized(@"调焦");
    Foucelabel.textColor = TextColor;
    Foucelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:Foucelabel];
    
    //焦距加
    UIButton *AddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    AddButton.frame = CGRectMake(50, CGRectGetMaxY(Foucelabel.frame)+20, 40, 40);
    UIImage *addImage = [UIImage imageNamed:@"FocusBtn"];
    addImage = [addImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [AddButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [AddButton setTitle:@"＋" forState:UIControlStateNormal];
     if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
         AddButton.userInteractionEnabled = NO;
     }
     [AddButton setTitleColor:kensenceColor forState:UIControlStateNormal];
    [AddButton addTarget:self action:@selector(AddButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:AddButton];

    //焦距减
    UIButton *SubtractButton = [UIButton buttonWithType:UIButtonTypeSystem];
    SubtractButton.frame = CGRectMake(CGRectGetMaxX(AddButton.frame) + 20, CGRectGetMaxY(Foucelabel.frame)+20, 40, 40);
    UIImage *SubtractImage = [UIImage imageNamed:@"FocusBtn"];
    SubtractImage = [SubtractImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [SubtractButton setBackgroundImage:SubtractImage forState:UIControlStateNormal];
    [SubtractButton setTitle:@"－" forState:UIControlStateNormal];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        SubtractButton.enabled = NO;
    }
    [SubtractButton setTitleColor:kensenceColor forState:UIControlStateNormal];
    [SubtractButton addTarget:self action:@selector(SubtracAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:SubtractButton];
    
    UILabel *VolueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    VolueLabel.text = Localized(@"音量调节");
    VolueLabel.textColor = TextColor;
    VolueLabel.font = [UIFont systemFontOfSize:20];
    VolueLabel.textAlignment = NSTextAlignmentCenter;
    [HederView addSubview:VolueLabel];
    [VolueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HederView.mas_bottom).with.offset(15);
        make.left.equalTo(HederView.mas_left).with.offset(675/3 - 25);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(675/4);
    }];
    
    UILabel *format = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    format.text =Localized(@"输出格式");
    format.textColor = TextColor;
    format.font = [UIFont systemFontOfSize:20];
    format.textAlignment = NSTextAlignmentLeft;
    [HederView addSubview:format];
    [format mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(VolueLabel.mas_top).with.offset(0);
        make.left.equalTo(VolueLabel.mas_right).with.offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(170);
    }];
    
    
    UIImageView *volueBac = [[UIImageView  alloc]initWithFrame:CGRectMake(675/2.8 + 15, 115, 675/4.7,675/4.7)];
    UIImage *voBacImage = [UIImage imageNamed:@"VolBac"];
    voBacImage = [voBacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    volueBac.userInteractionEnabled = YES;
    volueBac.image = voBacImage;
    [self.view addSubview:volueBac];
    [volueBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(115);
        make.left.equalTo(CamerOrient.mas_right).with.offset(35);
        make.height.mas_equalTo(675/4.7);
        make.width.mas_equalTo(675/4.7);
    }];
    
    
    UIImageView *volueImage = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, 675/4.7,675/4.7)];
    UIImage *voImage = [UIImage imageNamed:@"Vol"];
    voImage = [voImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    volueImage.userInteractionEnabled = YES;
    volueImage.tag = 122;
    volueImage.image = voImage;
    KTOneFingerRotationGestureRecognizer *Rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotating:)];
    Rotation.delegate = self;
    [volueImage addGestureRecognizer:Rotation];
    [volueBac addSubview:volueImage];
    [self setStartAngle:0];
    [self setStopAngle:255];
    
    //减号
    UIImageView *remo = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 - 20 + 15, 675/2.8 - 5, 25, 25)];
    UIImage *image = [UIImage imageNamed:@"VolBtn"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    remo.image = image;
    [self.view addSubview:remo];
    [remo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volueImage.mas_bottom).with.offset(-20);
        make.right.equalTo(volueImage.mas_left).with.offset(-0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];

    //加号
    UIImageView *add = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 675/4.7 + 15, 675/2.8 - 5, 25, 25)];
    UIImage *addimage = [UIImage imageNamed:@"Voladd"];
    addimage = [addimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    add.image = addimage;
    [self.view addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volueImage.mas_bottom).with.offset(-20);
        make.left.equalTo(volueImage.mas_right).with.offset(5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    
    UIImageView *One = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 - 28 + 15, 675/2.8 - 40, 30, 30)];
    UIImage *OneImage = [UIImage imageNamed:@"VolBig"];
    OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    One.image = OneImage;
    One.tag = 2320;
    [self.view addSubview:One];
    [One mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volueImage.mas_bottom).with.offset(-50);
        make.right.equalTo(volueImage.mas_left).with.offset(-4);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    
    UIImageView *two = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 - 22 + 15, 675/2.8 - 60, 22, 22)];
    UIImage *twoImage = [UIImage imageNamed:@"VolSmall"];
    twoImage = [twoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    two.image = twoImage;
    two.tag = 2321;
    [self.view addSubview:two];
    [two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(One.mas_top).with.offset(-0);
        make.right.equalTo(volueImage.mas_left).with.offset(- 3);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];

    UIImageView *Three = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 - 17 + 15, 675/2.8 - 80, 22,22)];
    UIImage *ThreeImage = [UIImage imageNamed:@"VolSmall"];
    ThreeImage = [ThreeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Three.image = ThreeImage;
    Three.tag = 2322;
    [self.view addSubview:Three];
    [Three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(two.mas_top).with.offset(-0);
        make.right.equalTo(volueImage.mas_left).with.offset(2);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    UIImageView *Four = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 - 10 + 15, 675/2.8 - 100, 22, 22)];
    UIImage *FourImage = [UIImage imageNamed:@"VolSmall"];
    FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Four.image = FourImage;
    Four.tag = 2323;
    [self.view addSubview:Four];
    [Four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(Three.mas_top).with.offset(-0);
        make.right.equalTo(volueImage.mas_left).with.offset(10);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    UIImageView *Five = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 7 + 15, 675/2.8 - 120, 22, 22)];
    UIImage *FiveImage = [UIImage imageNamed:@"VolSmall"];
    FiveImage = [FiveImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Five.image = FiveImage;
    Five.tag = 2324;
    [self.view addSubview:Five];
    [Five mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(Four.mas_top).with.offset(- 0);
        make.right.equalTo(volueImage.mas_left).with.offset(26);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    UIImageView *six = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 30 + 15, 675/2.8 - 135, 22,22)];
    UIImage *sixImage = [UIImage imageNamed:@"VolSmall"];
    sixImage = [sixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    six.image = sixImage;
    six.tag = 2325;
    [self.view addSubview:six];
    [six mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(Five.mas_top).with.offset(4);
        make.right.equalTo(volueImage.mas_left).with.offset(52);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    UIImageView *MidTop = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 55 + 15, 675/2.8 - 147, 30,30)];
    UIImage *MidTopImage = [UIImage imageNamed:@"VolBig"];
    MidTopImage = [MidTopImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MidTop.image = MidTopImage;
    MidTop.tag = 2326;
    [self.view addSubview:MidTop];
    [MidTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(volueImage.mas_top).with.offset(7);
        make.left.equalTo(volueImage.mas_centerX).with.offset(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    
    UIImageView *RightSix = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 143 + 15, 675/2.8 - 41, 30,30)];
    UIImage *RightSixImage = [UIImage imageNamed:@"VolBig"];
    RightSixImage = [RightSixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RightSix.image = RightSixImage;
    RightSix.tag = 2332;
    [self.view addSubview:RightSix];
    [RightSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volueImage.mas_bottom).with.offset(-50);
        make.left.equalTo(volueImage.mas_right).with.offset(4);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];

    UIImageView *RightFive = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 145 + 15, 675/2.8 - 55, 22,22)];
    UIImage *RightFiveImage = [UIImage imageNamed:@"VolSmall"];
    RightFiveImage = [RightFiveImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RightFive.image = RightFiveImage;
    RightFive.tag = 2331;
    [self.view addSubview:RightFive];
    [RightFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(RightSix.mas_top).with.offset(-0);
        make.left.equalTo(volueImage.mas_right).with.offset(5);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    
    UIImageView *Rightfour = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 140 + 15, 675/2.8 - 77, 22,22)];
    UIImage *RightfourImage = [UIImage imageNamed:@"VolSmall"];
    RightfourImage = [RightfourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Rightfour.image = RightfourImage;
    Rightfour.tag = 2330;
    [self.view addSubview:Rightfour];
    
    [Rightfour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(RightFive.mas_top).with.offset(-0);
        make.left.equalTo(volueImage.mas_right).with.offset(0);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    UIImageView *RightThree = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 132 + 15, 675/2.8 - 100, 22,22)];
    UIImage *RightThreeImage = [UIImage imageNamed:@"VolSmall"];
    RightThreeImage = [RightThreeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RightThree.image = RightThreeImage;
    RightThree.tag = 2329;
    
    [self.view addSubview:RightThree];
    [RightThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(Rightfour.mas_top).with.offset(-0);
        make.left.equalTo(volueImage.mas_right).with.offset(-8);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    UIImageView *Righttwo = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 115 + 15, 675/2.8 - 120, 22,22)];
    UIImage *RighttwoImage = [UIImage imageNamed:@"VolSmall"];
    RighttwoImage = [RighttwoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Righttwo.image = RighttwoImage;
    Righttwo.tag = 2328;
  
    [self.view addSubview:Righttwo];
    [Righttwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(RightThree.mas_top).with.offset(- 0);
        make.left.equalTo(volueImage.mas_right).with.offset(-22);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    
    UIImageView *RightOne = [[UIImageView alloc]initWithFrame:CGRectMake(675/2.8 + 90 + 15, 675/2.8 - 135, 22,22)];
    UIImage *RightOneImage = [UIImage imageNamed:@"VolSmall"];
    RightOneImage = [RightOneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RightOne.image = RightOneImage;
    RightOne.tag = 2327;
    [self.view addSubview:RightOne];
    
    [RightOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(Righttwo.mas_top).with.offset(4);
        make.right.equalTo(volueImage.mas_right).with.offset(-27);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
  
    

    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeSystem];
    callButton.frame = CGRectMake(CGRectGetMaxX(_IPcametext.frame) + 10, CGRectGetMaxY(AddButton.frame) + 55, 120,50);
    callButton.tag = 12311;
    CGRect rect = CGRectMake(0, 0, 120, 50);
    CGSize radio = CGSizeMake(5, 5);
    UIRectCorner corner = (UIRectCornerTopLeft | UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = callButton.bounds;
    masklayer.path = path.CGPath;
    callButton.layer.mask = masklayer;
    callButton.layer.cornerRadius = 5;
    [callButton addTarget:self action:@selector(CallButtonAction:) forControlEvents:UIControlEventTouchDown];
    
    if ([DataHelp shareData].isConnect == YES) {
        
        [callButton setTitle:Localized(@"挂断") forState:UIControlStateNormal];
        [callButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        callButton.backgroundColor = [UIColor colorWithRed:243/255.0 green:50/255.0 blue:49/255.0 alpha:1];
        _isconnect = YES;
    }else
    {
        [callButton setTitle:Localized(@"呼叫") forState:UIControlStateNormal];
        [callButton setTitleColor:WhiteColor forState:UIControlStateNormal];
        [callButton setBackgroundColor:[UIColor colorWithRed:49/255.0 green:197/255.0 blue:100/255.0 alpha:1]];
        _isconnect = NO;
    }
    [self.view addSubview:callButton];
    [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AddButton.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *registImage = [UIButton buttonWithType:UIButtonTypeSystem];
    registImage.frame = CGRectMake(0 + 35, CGRectGetMaxY(Foucelabel.frame)+20, 120, 40);
    [registImage setTitle:Localized(@"修改图片") forState:UIControlStateNormal];
       if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
           UIImage * imageResizer = [UIImage imageNamed:@"BigBtn"];
           imageResizer = [ imageResizer imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
           [registImage setBackgroundImage:imageResizer forState:UIControlStateNormal];
           registImage.enabled = NO;
       }else if ([DataHelp shareData].TapTagNumber >= 7999)
       {
           UIImage * imageResizer = [UIImage imageNamed:@"BigBtn"];
           imageResizer = [ imageResizer imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
           [registImage setBackgroundImage:imageResizer forState:UIControlStateNormal];
           registImage.enabled = NO;
       }else
       {
           
           UIImage * imageResizer = [UIImage imageNamed:@"BigBtnActive"];
           imageResizer = [ imageResizer imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
           [registImage setBackgroundImage:imageResizer forState:UIControlStateNormal];

       }
    [registImage setTitleColor:WhiteColor forState:UIControlStateNormal];
    [registImage addTarget:self action:@selector(RegistImageAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registImage];
    [registImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AddButton.mas_top).with.offset(0);
        make.right.equalTo(callButton.mas_left).with.offset(-5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
   
    
    UIButton *regist = [UIButton buttonWithType:UIButtonTypeSystem];
    regist.frame = CGRectMake(0 + 35, CGRectGetMaxY(Foucelabel.frame)+20, 120, 40);
    UIImage *registimage = [UIImage imageNamed:@"BigBtnActive"];
    registimage = [registimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [regist setBackgroundImage:registimage forState:UIControlStateNormal];
    [regist setTitle:Localized(@"修改名称") forState:UIControlStateNormal];
    [regist setTitleColor:WhiteColor forState:UIControlStateNormal];
    [regist addTarget:self action:@selector(RegistAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:regist];
    [regist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AddButton.mas_top).with.offset(0);
        make.right.equalTo(registImage.mas_left).with.offset(-5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];

    
    UIButton *replay = [UIButton buttonWithType:UIButtonTypeSystem];
    replay.frame = CGRectMake(CGRectGetMaxX(SubtractButton.frame) + 35,CGRectGetMaxY(Foucelabel.frame)+20, 120, 40);
    UIImage *replayimage = [UIImage imageNamed:@"BigBtnActive"];
    [replay setBackgroundImage:replayimage forState:UIControlStateNormal];
    [replay setTitle:Localized(@"恢复预置位") forState:UIControlStateNormal];
    [replay setTitleColor:WhiteColor forState:UIControlStateNormal];
    [replay addTarget:self action:@selector(ReplayButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:replay];
    [replay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AddButton.mas_top).with.offset(0);
        make.right.equalTo(regist.mas_left).with.offset(-5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    
    UIButton *ICD = [UIButton buttonWithType:UIButtonTypeSystem];
    ICD.frame = CGRectMake(0, CGRectGetMaxY(HederView.frame)+65,70,30);

    [ICD setTitle:@"ICD" forState:UIControlStateNormal];
    [ICD setTitleColor:WhiteColor forState:UIControlStateNormal];
    [ICD addTarget:self action:@selector(ICDAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        UIImage * ICDimage = [UIImage imageNamed:@"FormActive"];
        ICDimage = [ ICDimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [ICD setBackgroundImage:ICDimage forState:UIControlStateNormal];
    }else
    {
        UIImage * ICDimage = [UIImage imageNamed:@"Form"];
        ICDimage = [ICDimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [ICD setBackgroundImage:ICDimage forState:UIControlStateNormal];
        ICD.userInteractionEnabled = NO;
        
    }
    [self.view addSubview:ICD];
    [ICD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(format.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    
    UIButton *HDMI = [UIButton buttonWithType:UIButtonTypeSystem];
    HDMI.frame = CGRectMake(675/1.35, CGRectGetMaxY(HederView.frame)+65,70,30);
    [HDMI setTitle:@"HDMI" forState:UIControlStateNormal];
    [HDMI setTitleColor:WhiteColor forState:UIControlStateNormal];
    [HDMI addTarget:self action:@selector(HDMIAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        UIImage * HDMIimage = [UIImage imageNamed:@"FormActive"];
        HDMIimage = [ HDMIimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [HDMI setBackgroundImage:HDMIimage forState:UIControlStateNormal];
       
    }else
    {
        UIImage * HDMIimage = [UIImage imageNamed:@"Form"];
        HDMIimage = [ HDMIimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [HDMI setBackgroundImage:HDMIimage forState:UIControlStateNormal];
         HDMI.userInteractionEnabled = NO;
    }
    [self.view addSubview:HDMI];
    [HDMI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(format.mas_bottom).with.offset(10);
        make.right.equalTo(ICD.mas_left).with.offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    
    UIButton *VGA = [UIButton buttonWithType:UIButtonTypeSystem];
    VGA.frame = CGRectMake(CGRectGetMaxX(HDMI.frame)+ 10, CGRectGetMaxY(ICD.frame)+25,70,30);
  
    [VGA setTitle:@"VGA" forState:UIControlStateNormal];
    [VGA setTitleColor:WhiteColor forState:UIControlStateNormal];
    [VGA addTarget:self action:@selector(VGAAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        UIImage * VGAimage = [UIImage imageNamed:@"FormActive"];
        VGAimage = [ VGAimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [VGA setBackgroundImage:VGAimage forState:UIControlStateNormal];
    }else
    {
        UIImage * VGAimage = [UIImage imageNamed:@"Form"];
        VGAimage = [VGAimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [VGA setBackgroundImage:VGAimage forState:UIControlStateNormal];
        VGA.userInteractionEnabled = NO;
    }
    [self.view addSubview:VGA];
    [VGA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ICD.mas_bottom).with.offset(10);
        make.left.equalTo(ICD.mas_left).with.offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    
    UIButton *PDF = [UIButton buttonWithType:UIButtonTypeSystem];
    PDF.frame = CGRectMake(675/1.35, CGRectGetMaxY(HDMI.frame)+25,70,30);
    
    [PDF setTitle:@"PDF" forState:UIControlStateNormal];
    [PDF setTitleColor:WhiteColor forState:UIControlStateNormal];
    [PDF addTarget:self action:@selector(PDFACtion:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        UIImage * PDFimage =  [UIImage imageNamed:@"FormActive"];
        PDFimage = [ PDFimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [PDF setBackgroundImage:PDFimage forState:UIControlStateNormal];
    }else
    {
        UIImage * PDFimage = [UIImage imageNamed:@"Form"];
        PDFimage = [ PDFimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [PDF setBackgroundImage:PDFimage forState:UIControlStateNormal];
        PDF.userInteractionEnabled = NO;
    }
    [self.view addSubview:PDF];
    [PDF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HDMI.mas_bottom).with.offset(10);
        make.left.equalTo(HDMI.mas_left).with.offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *CMYK = [UIButton buttonWithType:UIButtonTypeSystem];
    CMYK.frame = CGRectMake(675/1.35, CGRectGetMaxY(PDF.frame)+25,70,30);
   
    [CMYK setTitle:@"CMYK" forState:UIControlStateNormal];
    [CMYK setTitleColor:WhiteColor forState:UIControlStateNormal];
    [CMYK addTarget:self action:@selector(CMYKAction:) forControlEvents:UIControlEventTouchDown];
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        UIImage * CMYKimage =[UIImage imageNamed:@"FormActive"];
        CMYKimage = [ CMYKimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [CMYK setBackgroundImage:CMYKimage forState:UIControlStateNormal];
    }else
    {
        UIImage * CMYKimage =  [UIImage imageNamed:@"Form"];
        CMYKimage = [CMYKimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [CMYK setBackgroundImage:CMYKimage forState:UIControlStateNormal];
        CMYK.userInteractionEnabled = NO;
        
    }
    [self.view addSubview:CMYK];
    [CMYK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PDF.mas_bottom).with.offset(10);
        make.left.equalTo(PDF.mas_left).with.offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(70);
    }];
    
    _IPtext = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(AddButton.frame) + 55, 675/3, 50)];
    _IPtext.backgroundColor = [UIColor colorWithRed:24/255.0 green:32/255.0 blue:40/255.0 alpha:1];
    _IPtext.adjustsFontSizeToFitWidth = YES;
    _IPtext.keyboardType = UIKeyboardTypeNumberPad;
    _IPtext.clearButtonMode = UITextFieldViewModeAlways;
    _IPtext.text = [DataHelp shareData].IPtext;
    _IPtext.placeholder = Localized(@"ip地址");
    [_IPtext setValue:[UIColor colorWithRed:50/255.0 green:56/255.0 blue:70/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_IPtext setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _IPtext.textColor = WhiteColor;
    _IPtext.delegate = self;
    [self.view addSubview:_IPtext];
    [_IPtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AddButton.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo((580 - 32)/3);
    }];
    
    /**
     带宽输入
     */
    _IPcametext = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_IPtext.frame)+25, CGRectGetMaxY(AddButton.frame) + 55, 675/3, 50)];
    _IPcametext.rightViewMode = UITextFieldViewModeAlways;
    _IPcametext.adjustsFontSizeToFitWidth = YES;
    _IPtext.keyboardType = UIKeyboardTypeNumberPad;
    _IPcametext.text = [DataHelp shareData].PortText;
    _IPcametext.textColor = WhiteColor;
    _IPcametext.placeholder = Localized(@"带宽  范围 512~4000");
    [_IPcametext setValue:[UIColor colorWithRed:50/255.0 green:56/255.0 blue:70/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_IPcametext setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    _IPcametext.backgroundColor = [UIColor colorWithRed:24/255.0 green:32/255.0 blue:40/255.0 alpha:1];
    _IPcametext.keyboardType = UIKeyboardTypeNumberPad;
    _IPcametext.delegate = self;
    [self.view addSubview:_IPcametext];
    [_IPcametext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IPtext.mas_top).with.offset(0);
        make.left.equalTo(_IPtext.mas_right).with.offset(6);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo((580 - 32)/3);
    }];
    
    _Resolution = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_IPtext.frame)+25, CGRectGetMaxY(AddButton.frame) + 55, 675/3, 50)];
    _Resolution.rightViewMode = UITextFieldViewModeAlways;
    _Resolution.adjustsFontSizeToFitWidth = YES;
    _Resolution.text = [DataHelp shareData].PortText;
    _Resolution.textColor = WhiteColor;
    _Resolution.enabled = NO;
    _Resolution.placeholder = Localized(@"分辨率");
    [_Resolution setValue:[UIColor colorWithRed:50/255.0 green:56/255.0 blue:70/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_Resolution setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _Resolution.backgroundColor = [UIColor colorWithRed:24/255.0 green:32/255.0 blue:40/255.0 alpha:1];
    _Resolution.keyboardType = UIKeyboardTypeNumberPad;
    _Resolution.delegate = self;
    [self.view addSubview:_Resolution];
    [_Resolution mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IPtext.mas_top).with.offset(0);
        make.left.equalTo(_IPcametext.mas_right).with.offset(6);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo((580 - 32)/3);
    }];
    UIView *tapView = [[UIView alloc]initWithFrame:CGRectZero];
    tapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textAction:)];
    tap.numberOfTapsRequired = 1;
//    tapView.backgroundColor = [UIColor cyanColor];
    [tapView addGestureRecognizer:tap];
    [self.view addSubview:tapView];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Resolution.mas_top).with.offset(0);
        make.left.equalTo(_Resolution.mas_left).with.offset(0);
        make.bottom.equalTo(_Resolution.mas_bottom).with.offset(0);
        make.width.mas_equalTo((580 - 32)/3);
    }];

}

- (void)textAction:(UITapGestureRecognizer *)text
{
    if (text.state ==  UIGestureRecognizerStateEnded) {
        tabel = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tabel.delegate = self;
        tabel.dataSource = self;
        tabel.layer.cornerRadius = 5;
        tabel.layer.masksToBounds = YES;
        tabel.bounces = NO;
        [tabel registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Text"];
        [self.view addSubview:tabel];
        [tabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_Resolution.mas_top).offset(3);
            make.left.mas_equalTo(_Resolution.mas_left).offset(0);
            make.width.mas_equalTo((580 - 32)/3);
            make.height.mas_equalTo(160);
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ResolutionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Text"];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0,cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    label.text = _ResolutionArray[indexPath.row];
    label.backgroundColor = BacViewRGB;
    [cell.contentView addSubview:label];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Resolution.text = _ResolutionArray[indexPath.row];
    [tabel removeFromSuperview];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"1");
}
/**
 *  键盘弹出后的执行事件
 *
 *  @param notice
 */
- (void)keyboardWasShown:(NSNotification *)notice;
{
    NSDictionary *info = [notice userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
  
        _KeyboardHeight = keyboardSize.height;
        self.view.frame = CGRectMake(self.view.frame.origin.x,[UIScreen mainScreen].bounds.size.height - _KeyboardHeight - 415,self.view.frame.size.width,self.view.frame.size.height);

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  
    self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.3,[UIScreen mainScreen].bounds.size.height * 0.16,self.view.frame.size.width,self.view.frame.size.height);
}

/**
 *  输入输出的旋转
 *
 *  @param sender
 */
- (void)Rotating:(KTOneFingerRotationGestureRecognizer *)recognizer
{
    
    CGFloat degrees = radiansToDegrees([recognizer rotation]);
    CGFloat currentAngle = [self currentAngle] + degrees;
    CGFloat relativeAngle = fmodf(currentAngle, 1080);  // Converts to angle between 0 and 360 degrees.
    BOOL shouldRotate = NO;
    if ([self startAngle] <= [self stopAngle]) {
        shouldRotate = (relativeAngle >= [self startAngle] && relativeAngle <= [self stopAngle]);
    } else if ([self startAngle] > [self stopAngle]) {
        shouldRotate = (relativeAngle >= [self startAngle] || relativeAngle <= [self stopAngle]);
    }
   
    if (recognizer.state == UIGestureRecognizerStateChanged) {
    if (shouldRotate) {
        [self setCurrentAngle:currentAngle];
        UIView *view = [recognizer view];
        [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
    }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_Rotation < relativeAngle) {
                _Rotation = relativeAngle;
                UIImageView *imageView = (UIImageView *)[self.view viewWithTag:2320 + relativeAngle / 20.2];
                NSLog(@"++++++%f",fabs(relativeAngle / 21.4));
                imageView.image = [UIImage imageNamed:@"VolSmallActive"];
                
            }else
            {
                _Rotation = relativeAngle;
                UIImageView *imageView = (UIImageView *)[self.view viewWithTag:2320 + fabs(relativeAngle / 20.2)];
                imageView.image = [UIImage imageNamed:@"VolSmall"];
                NSLog(@"++++++%f",fabs(relativeAngle / 21.4));
                   NSLog(@"%f",relativeAngle);
            }
        });
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
   NSLog(@"%f",relativeAngle);
        NSLog(@"这里");
    }
 
}

- (void)rotation:(NSTimer *)timer
{
    NSLog(@"连接成功1234");
}

//创建socket
- (void)SocketToConnect:(NSString *)Host Port:(uint16_t)port
{
    dispatch_queue_t Queue = dispatch_queue_create("client tcp socket", NULL);
    CamerGCD  = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:Queue socketQueue:nil];
    [CamerGCD connectToHost:Host onPort:port error:nil];
    [CamerGCD readDataWithTimeout:-1 tag:700];
}


#pragma mark === CamerGCDSocket ===
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
 
    _Number = 1;
}

/**
 *  socket断开重连
 *
 *  @param sock
 *  @param err
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [CamerGCD connectToHost:[DataHelp shareData].ipString onPort:45678 withTimeout:-1 error:nil];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送成功");
}

//向上
- (void)UpButtonAction:(UIButton *)button
{
    NSLog(@"向上");
}

//向左
- (void)LeftButtonAction:(UIButton *)button
{
     NSLog(@"向左");
}

//向下
- (void)BottomButtonAction:(UIButton *)button
{
     NSLog(@"向下");
}

//向右
- (void)RightAction:(UIButton *)button
{
     NSLog(@"向右");
}

//恢复预置位
- (void)ReplayButton:(UIButton *)button
{
    
}

//修改名称
- (void)RegistAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RegistName" object:nil];
}


//修改图片
- (void)RegistImageAction:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RegistPuture" object:nil];
    
}

/**
 *  呼叫响应事件
 *
 *  @param call
 */
- (void)CallButtonAction:(UIButton *)call
{
    [_IPtext resignFirstResponder];
    [_IPcametext resignFirstResponder];
    
    /**
     *  定时在点击呼叫后1s再执行呼叫
     *
     *  @param call: 执行事件
     *
     *  @return
     */
    NSString *host = [DataHelp shareData].ipString;
    [self SocketToConnect:host Port:45678];
   

    if (![self isValidateIP:host]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"ip输入有误");
            mbp.margin = 10.0f; //提示框的大小
            [mbp customView];
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });

    }else if (_IPtext.text.length == 0)
    {
        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        mbp.mode = MBProgressHUDModeText;
        mbp.label.text = Localized(@"ip不能为空");
        mbp.margin = 10.0f; //提示框的大小
        [mbp customView];
        mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
        [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        
    }else if (_IPcametext.text.length == 0)
    {
         MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        mbp.mode = MBProgressHUDModeText;
        mbp.label.text = Localized(@"带宽不能为空");
        mbp.margin = 10.0f; //提示框的大小
        [mbp customView];
        mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
        [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        
    }else if ([self isRangeValue:_IPcametext.text.integerValue] && [self isValidateIP:host])
    {
        [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(call:) userInfo:nil repeats:NO];
    }
    
   }
//正则判断
- (BOOL)isValidateIP:(NSString *)IP
{
    NSString *ipRegex = @"(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)";
    NSPredicate *iptext = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegex];
    return [iptext evaluateWithObject:IP];
    
}

- (BOOL)isRangeValue:(NSInteger)value
{
    if (value < 512)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"输入带宽值过小 请输入512~4000");
            mbp.margin = 10.0f; //提示框的大小
            [mbp customView];
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
        return NO;
        
    }else if(value > 4000)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"输入带宽超出最大值 请输入512~4000");
            mbp.margin = 10.0f; //提示框的大小
            [mbp customView];
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
    
        return NO;
        
    }else
    {
        return YES;
    }
}

/**
 *指令发送后,等待两秒后执行方法
 *
 *  @param timer
 */

- (void)call:(NSTimer *)timer
{
    UIButton *button = (UIButton *)[self.view viewWithTag:12311];
    /**
     *  判断socket是否已连接
     */
    if ([CamerGCD isConnected]) {
    
        if (_isconnect == NO) {
            _isconnect = YES;
            if ([DataHelp shareData].isTdecore == YES) {
                [LinkIPCamer creatTable];
                [LinkIPCamer delectTDecoder:1 Rdecoder:0 Meeting:0 TIndex:_TIndex Rindex:_Rindex];
                [LinkIPCamer InsertTDecoder:1 Rdecoder:0 Meeting:0 TIndex:_TIndex Rindex:_Rindex isConnect:1 IP:_IPtext.text NetWidth:_IPcametext.text];
            }else
            {
                [LinkIPCamer creatTable];
                [LinkIPCamer delectTDecoder:0 Rdecoder:1 Meeting:[DataHelp shareData].MeetingNumber TIndex:_TIndex Rindex:_Rindex];
                [LinkIPCamer InsertTDecoder:0 Rdecoder:1 Meeting:[DataHelp shareData].MeetingNumber TIndex:_TIndex Rindex:_Rindex isConnect:1 IP:_IPtext.text NetWidth:_IPcametext.text];
            }
                button.backgroundColor = [UIColor colorWithRed:243/255.0 green:50/255.0 blue:49/255.0 alpha:1];
                [button setTitle:Localized(@"挂断") forState:UIControlStateNormal];
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                mbp.mode = MBProgressHUDModeText;
                mbp.label.text = Localized(@"呼叫已发出");
                [mbp customView];
                mbp.margin = 10.0f; //提示框的大小
                [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                //                       mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                [mbp hideAnimated:YES afterDelay:2];//多久后隐藏
            });
          
            unsigned short utfString = [_IPcametext.text integerValue];
            NSString *set =  [NSString
                              stringWithFormat:@"<command><message>dial</message><number>%@</number><bandwidth>%d</bandwidth></command>\n",_IPtext.text,utfString];
            
            NSLog(@"%@",set);
            NSData *CancleData = [set dataUsingEncoding:NSUTF8StringEncoding];
            [CamerGCD writeData:CancleData withTimeout:-1 tag:700];
            [_IPtext resignFirstResponder];
            [_IPcametext resignFirstResponder];
            
            
        }else
        {
            if ([DataHelp shareData].isTdecore == YES) {
                [LinkIPCamer creatTable];
                [LinkIPCamer delectTDecoder:1 Rdecoder:0 Meeting:0 TIndex:_TIndex Rindex:_Rindex];
                [LinkIPCamer InsertTDecoder:1 Rdecoder:0 Meeting:0 TIndex:_TIndex Rindex:_Rindex isConnect:0 IP:_IPtext.text NetWidth:_IPcametext.text];
            }else
            {
                [LinkIPCamer creatTable];
                [LinkIPCamer delectTDecoder:0 Rdecoder:1 Meeting:[DataHelp shareData].MeetingNumber TIndex:_TIndex Rindex:_Rindex];
                [LinkIPCamer InsertTDecoder:0 Rdecoder:1 Meeting:1 TIndex:_TIndex Rindex:_Rindex isConnect:0 IP:_IPtext.text NetWidth:_IPcametext.text];
                
            }
            
            _isconnect = NO;
            NSString *Clost = @"<command><message>hangup</message></command>\n";
            NSData *Data = [Clost dataUsingEncoding:NSUTF8StringEncoding];
            [CamerGCD writeData:Data withTimeout:-1 tag:700];
            [button setTitle:Localized(@"呼叫") forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:49/255.0 green:197/255.0 blue:100/255.0 alpha:1]];
        }

    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"呼叫网络连接失败");
            [mbp customView];
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            //                       mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:2];//多久后隐藏
        });
    }
}







//HDMI
- (void)HDMIAction:(UIButton *)HDMI
{
    
}

//ICD
- (void)ICDAction:(UIButton *)ICD
{
    
}

//VGA
- (void)VGAAction:(UIButton *)VGA
{
    
    
}


//CMYK
- (void)CMYKAction:(UIButton *)CMYK
{
    
}


//PDF
- (void)PDFACtion:(UIButton *)PDF
{
    
}

//焦距加
- (void)AddButtonAction:(UIButton *)button
{
    if (button.selected == NO) {
    button.selected = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"FocusBtnActive"] forState:UIControlStateNormal];
    [button setTitleColor:kensenceColor forState:UIControlStateNormal];
    }else
    {
    button.selected = NO;
    [button setBackgroundImage:[UIImage imageNamed:@"FocusBtn"] forState:UIControlStateNormal];
    [button setTitleColor:kensenceColor forState:UIControlStateNormal];
    }
}

//焦距减
- (void)SubtracAction:(UIButton *)button
{
    if (button.selected == NO) {
        button.selected = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"FocusBtnActive"] forState:UIControlStateNormal];
        [button setTitleColor:kensenceColor forState:UIControlStateNormal];
    }else
    {   button.selected = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"FocusBtn"] forState:UIControlStateNormal];
        [button setTitleColor:kensenceColor forState:UIControlStateNormal];
    }
}

//移除界面
- (void)CanButtonAction:(UIButton *)button
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReCenter" object:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_IPtext resignFirstResponder];
    [_IPcametext resignFirstResponder];
    [_Resolution resignFirstResponder];
    [tabel removeFromSuperview];
    
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
