//
//  ProInSet.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/20.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "ProInSet.h"
#import "DataBaseHelp.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
#import "SignalViewController.h"
#import "ProConnect.h"
#import "ProInTableViewController.h"
#import "Masonry.h"
#import "DataSqlite.h"

#define KscWith    self.view.frame.size.width
#define KscHeight  self.view.frame.size.height
#define WhitColor [UIColor whiteColor]
@interface ProInSet ()<UITextFieldDelegate,GCDAsyncUdpSocketDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
    
}

@property (nonatomic ,strong)UIButton *ratioButton;
@property (nonatomic ,strong)UIButton *Spacebutton;
@property (nonatomic ,strong)UIButton *LightAdd;
@property (nonatomic ,strong)UIButton *LightCut;
@property (nonatomic ,strong)UIButton *contrastadd;
@property (nonatomic ,strong)UIButton *contrastCut;
@property (nonatomic ,strong)UIButton *chromaCut;
@property (nonatomic ,strong)UIButton *chromaAdd;
@property (nonatomic ,strong)UIButton *Saturation;
@property (nonatomic ,strong)UIButton *SaturationCut;
@property (nonatomic ,strong)UIButton *ZoomAdd;
@property (nonatomic ,strong)UIButton *ZoomCut;
@property (nonatomic ,strong)UIButton *ErectImage;
@property (nonatomic ,strong)UIButton *InvertedImage;
@property (nonatomic ,strong)UIButton *Reset;
@property (nonatomic ,strong)UIButton *Naming;
@property (nonatomic ,strong)UITextField *Nametext;
@property (nonatomic ,strong)UIButton *Cancle;
@property (nonatomic ,strong)NSString *Namestring;
@property (nonatomic ,strong)NSArray *InGroups;
@property (nonatomic ,strong)UITableView *table;
@property (nonatomic ,strong)NSString *Intext;
@property (nonatomic ,assign)BOOL isYes;
@property (nonatomic ,strong)UIView *InAview;
@property (nonatomic ,strong)UITextField *IPText;
@property (nonatomic ,strong)UITextField *valeText;




@property (nonatomic ,strong)ProInTableViewController *ProInTable;


@end

@implementation ProInSet



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SignalValue ShareValue].IPstring = nil;
    [SignalValue ShareValue].ValueString = nil;
    [SignalValue ShareValue].isConnect = NO;
    NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].InArray[0]];
    NSInteger key = NumberKey.integerValue;
    [DataSqlite CreatDataSource];
    [DataSqlite SelectByType:1 numberKey:key];
    
    _InGroups = @[@"720x480i60",@" 720x576i50",@" 720x480p60",@" 720x576p50",@" 1280x720p60",@" 1280x720p59",@" 1280x720p30",@" 1280x720p25",@" 1280x720p24",@" 1920x1080i60",@" 1920x1080i59",@" 1920x1080i50",@" 1920x1080p60",@" 1920x1080p59",@" 1920x1080p50",@" 1920x1080p30",@" 1920x1080p25",@" 1920x1080p24",@" 640x480p60",@" 640x480p75",@" 800x600p60",@" 800x600p75",@" 1024x768p60",@" 1024x768p75",@" 1280x1024p60",@" 1280x1024p75",@" 1360x768p60",@" 1366x768p60",@" 1400x1050p60",@" 1600x1200p60",@" 1440x900p60",@" 1440x900p75",@" 1680x150p60",@" 1680x1050pRB",@" 1920x1080pRB",@" 1920x1200pRB",@" 1280x800p60"];
    

    self.preferredContentSize = CGSizeMake(KscWith/1.7, KscHeight/1.4);
    _InAview = [[UIView alloc]init];
    _InAview.frame = CGRectMake(0, 0, KscWith, KscHeight);
    [self.view addSubview:_InAview];
  
    self.view.backgroundColor = [UIColor colorWithRed:41/255.0 green:51/255.0 blue:61/255.0 alpha:1];
    
    
    UIView *HeaderView = [[UIView alloc]init];
    HeaderView.frame = CGRectMake(0, 0, KscWith, 50);
    HeaderView.backgroundColor = [UIColor colorWithRed:31/255.0 green:39/255.0 blue:49/255.0 alpha:1];
    [_InAview addSubview:HeaderView];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(15, KscHeight/12 + 30, KscWith/17, KscHeight/19);
    label.text = @"分辨率";
    label.textColor = WhitColor;
    [_InAview addSubview:label];
 
    UILabel *Inlabel = [[UILabel alloc]init];
    Inlabel.frame = CGRectMake(5, 5, KscWith/8, 30);
//    Inlabel.backgroundColor = [UIColor orangeColor];
    Inlabel.text = [NSString stringWithFormat:@"%@ %@",@"InPut : ",[SignalValue ShareValue].InArray[0]];
    Inlabel.textColor = WhitColor;
    [_InAview addSubview:Inlabel];
    
    
    UILabel *space = [[UILabel alloc]init];
    space.frame = CGRectMake(15,CGRectGetMaxY(label.frame) +20, KscWith/15, KscHeight/19);
    space.text = @"色彩空间";
    space.textColor = WhitColor;
    [_InAview addSubview:space];
    
    _ratioButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _ratioButton.frame = CGRectMake(KscWith/9, KscHeight/14, KscWith/4, 40);
    _ratioButton.layer.borderColor = [UIColor blackColor].CGColor;
    _ratioButton.layer.borderWidth = 0.5f;
    [_ratioButton setTitle:@"分辨率" forState:UIControlStateNormal];
    [_ratioButton setTitleColor:WhitColor forState:UIControlStateNormal];
    UIImageView *FEnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *FENameimage = [UIImage imageNamed:@"TextBac"];
    FENameimage = [FENameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FEnameImageView.image = FENameimage;
    FEnameImageView.userInteractionEnabled = YES;
    [_InAview addSubview:FEnameImageView];
    [FEnameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    [_ratioButton addTarget:self action:@selector(ratioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_ratioButton];
    [_ratioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    UIImageView *RGCDnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *RGBNameimage = [UIImage imageNamed:@"TextBac"];
    RGBNameimage = [RGBNameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RGCDnameImageView.image = RGBNameimage;
    RGCDnameImageView.userInteractionEnabled = YES;
    [_InAview addSubview:RGCDnameImageView];
    [RGCDnameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(space.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    _Spacebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _Spacebutton.frame = CGRectMake(KscWith/9, CGRectGetMinY(space.frame), KscWith/4, 40);
    _Spacebutton.layer.borderColor = [UIColor blackColor].CGColor;
    _Spacebutton.layer.borderWidth = 0.5f;
    _Spacebutton.tag = 355555;
    [_Spacebutton setTitle:@"RGB" forState:UIControlStateNormal];
    [_Spacebutton setTitleColor:WhitColor forState:UIControlStateNormal];
    [_Spacebutton addTarget:self action:@selector(SpacebuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Spacebutton];
    [_Spacebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(space.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];

    
    
    
    
    UILabel *light = [[UILabel alloc]init];
    light.frame = CGRectMake(15,CGRectGetMaxY(space.frame) +15, KscWith/15, KscHeight/19);
    light.text = @"亮度";
    light.textColor = WhitColor;
    [_InAview addSubview:light];
    
    UILabel *dui = [[UILabel alloc]init];
    dui.frame = CGRectMake(15,CGRectGetMaxY(light.frame) +15, KscWith/15, KscHeight/19);
    dui.text = @"对比度";
    dui.textColor = WhitColor;
    [_InAview addSubview:dui];
    
    UILabel *baohe = [[UILabel alloc]init];
    baohe.frame = CGRectMake(15,CGRectGetMaxY(dui.frame) +15, KscWith/15, KscHeight/19);
    baohe.text = @"饱和度";
    baohe.textColor = WhitColor;
    [_InAview addSubview:baohe];
    
    UILabel *color = [[UILabel alloc]init];
    color.frame = CGRectMake(15,CGRectGetMaxY(baohe.frame) +15, KscWith/15, KscHeight/19);
    color.text = @"色度";
    color.textColor = WhitColor;
    [_InAview addSubview:color];

    

    
    _LightAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _LightAdd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(space.frame)+15, KscWith/15, KscHeight/19);
    UIImage *imagelight = [UIImage imageNamed:@"ADD"];
    imagelight = [imagelight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_LightAdd setImage:imagelight forState:UIControlStateNormal];
    [_LightAdd addTarget:self action:@selector(LightAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_LightAdd];
    
    _LightCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _LightCut.frame = CGRectMake(CGRectGetMaxX(_LightAdd.frame)+10, CGRectGetMaxY(space.frame)+15, KscWith/15, KscHeight/19);
    UIImage *LightCut = [UIImage imageNamed:@"Remove"];
    LightCut = [LightCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_LightCut setImage:LightCut forState:UIControlStateNormal];
    [_LightCut addTarget:self action:@selector(LightCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_LightCut];
    
    _contrastadd = [UIButton buttonWithType:UIButtonTypeSystem];
    _contrastadd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(light.frame)+15, KscWith/15, KscHeight/19);
    UIImage *contrastadd = [UIImage imageNamed:@"ADD"];
    contrastadd = [contrastadd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_contrastadd setImage:contrastadd forState:UIControlStateNormal];
    [_contrastadd addTarget:self action:@selector(contrastaddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_contrastadd];
    
    
    _contrastCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _contrastCut.frame = CGRectMake(CGRectGetMaxX(_LightAdd.frame)+10, CGRectGetMaxY(light.frame)+15, KscWith/15, KscHeight/19);
    UIImage *contrastCut = [UIImage imageNamed:@"Remove"];
    contrastCut = [contrastCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_contrastCut setImage:contrastCut forState:UIControlStateNormal];
    [_contrastCut addTarget:self action:@selector(contrastCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_contrastCut];
    
    
    _Saturation = [UIButton buttonWithType:UIButtonTypeSystem];
    _Saturation.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(dui.frame)+15, KscWith/15, KscHeight/19);
    UIImage *Saturation = [UIImage imageNamed:@"ADD"];
    Saturation = [Saturation imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Saturation setImage:Saturation forState:UIControlStateNormal];
    [_Saturation addTarget:self action:@selector(SaturationAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Saturation];
    
    
    
    _SaturationCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _SaturationCut.frame = CGRectMake(CGRectGetMaxX(_Saturation.frame)+10, CGRectGetMaxY(dui.frame)+15, KscWith/15, KscHeight/19);
    UIImage *SaturationCut = [UIImage imageNamed:@"Remove"];
    SaturationCut = [SaturationCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_SaturationCut setImage:SaturationCut forState:UIControlStateNormal];
    [_SaturationCut addTarget:self action:@selector(SaturationCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_SaturationCut];
    
    
    _chromaAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _chromaAdd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(baohe.frame)+15, KscWith/15, KscHeight/19);
    UIImage *chromaAdd = [UIImage imageNamed:@"ADD"];
    chromaAdd = [chromaAdd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chromaAdd setImage:chromaAdd forState:UIControlStateNormal];
    [_chromaAdd addTarget:self action:@selector(chromaAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_chromaAdd];
    
    
    _chromaCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _chromaCut.frame = CGRectMake(CGRectGetMaxX(_chromaAdd.frame) + 10, CGRectGetMaxY(baohe.frame)+15, KscWith/15, KscHeight/19);
    UIImage *chromaCut = [UIImage imageNamed:@"Remove"];
    chromaCut = [chromaCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chromaCut setImage:chromaCut forState:UIControlStateNormal];
    [_chromaCut addTarget:self action:@selector(chromaCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_chromaCut];
    
    
    UIImageView *IpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *Ipimage = [UIImage imageNamed:@"TextBac"];
    Ipimage = [Ipimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    IpImageView.image = Ipimage;
    IpImageView.userInteractionEnabled = YES;
    [_InAview addSubview:IpImageView];
    [IpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(light.mas_top).with.offset(0);
        make.left.equalTo(_Spacebutton.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    _IPText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _IPText.placeholder = @"H323Ip";
    _IPText.text = [SignalValue ShareValue].IPstring;
    [_IPText setValue:[UIColor colorWithRed:42/255.0 green:50/255.0 blue:62/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_IPText setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _IPText.textColor = WhitColor;
    [IpImageView addSubview:_IPText];
    [_IPText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IpImageView.mas_top).with.offset(0);
        make.left.equalTo(IpImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    
    
    UIImageView *VAlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    UIImage *Valueimage = [UIImage imageNamed:@"TextBac"];
//    Valueimage = [Valueimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VAlueImageView.image = Ipimage;
    VAlueImageView.userInteractionEnabled = YES;
    [_InAview addSubview:VAlueImageView];
    [VAlueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dui.mas_top).with.offset(0);
        make.left.equalTo(_Spacebutton.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    _valeText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _valeText.placeholder = @"带宽 256 ~ 4000";
    _valeText.text =[SignalValue ShareValue].ValueString;
    [_valeText setValue:[UIColor colorWithRed:42/255.0 green:50/255.0 blue:62/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_valeText setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _valeText.textColor = WhitColor;
    [VAlueImageView addSubview:_valeText];
    [_valeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(VAlueImageView.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    UIButton *Callbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [Callbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if ([SignalValue ShareValue].isConnect == 0) {
            UIImage *CallImge = [UIImage imageNamed:@"Call"];
            CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [Callbutton setBackgroundImage:CallImge forState:UIControlStateNormal];
         [Callbutton setTitle:@"Call" forState:UIControlStateNormal];
    }else
    {
         [Callbutton setTitle:@"Hang up" forState:UIControlStateNormal];
        UIImage *CallImge = [UIImage imageNamed:@"Clear"];
        CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Callbutton setBackgroundImage:CallImge forState:UIControlStateNormal];

    }
   
    [Callbutton addTarget:self action:@selector(CallAction:) forControlEvents:UIControlEventTouchDown];
    [_InAview addSubview:Callbutton];
    [Callbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baohe.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];

    
    _Reset = [UIButton buttonWithType:UIButtonTypeSystem];
    _Reset.frame = CGRectMake(CGRectGetMaxX(_chromaCut.frame)+30, CGRectGetMaxY(color.frame)+10, KscWith/12, KscHeight/17);
    UIImage *Reset = [UIImage imageNamed:@"ButBack"];
    Reset = [Reset imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Reset setBackgroundImage:Reset forState:UIControlStateNormal];
    [_Reset addTarget:self action:@selector(ResetAction:) forControlEvents:UIControlEventTouchUpInside];
    [_Reset setTitle:@"Reset" forState:UIControlStateNormal];
    [_Reset setTitleColor:WhitColor forState:UIControlStateNormal];
    [_InAview addSubview:_Reset];
    [_Reset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(color.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.051);
    }];
    
    UIImageView *nameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIImage *Nameimage = [UIImage imageNamed:@"TextBac"];
    Nameimage = [Nameimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nameImageView.image = Nameimage;
    nameImageView.userInteractionEnabled = YES;
    [_InAview addSubview:nameImageView];
    [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(color.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(_chromaCut.mas_right).with.offset(0);
        make.height.mas_equalTo(KscHeight * 0.06);
    }];
    
    _Nametext = [UITextField new];
    _Nametext.frame = CGRectMake(KscWith/15, CGRectGetMaxY(baohe.frame)+20, KscWith/5, 50);
    _Nametext.layer.borderColor = [UIColor blackColor].CGColor;
    _Nametext.layer.borderWidth = 0.5f;
    _Nametext.tag = 133333;
    _Nametext.delegate = self;
    _Nametext.placeholder = @"Modify the name";
    [_Nametext setValue:[UIColor colorWithRed:42/255.0 green:50/255.0 blue:62/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_Nametext setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _Nametext.textColor = WhitColor;
    [_InAview addSubview:_Nametext];
    [_Nametext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(color.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(_chromaCut.mas_right).with.offset(0);
        make.height.mas_equalTo(KscHeight * 0.06);
    }];
    
    _Naming = [UIButton buttonWithType:UIButtonTypeSystem];
    _Naming.frame = CGRectMake(CGRectGetMaxX(_Nametext.frame)+10, CGRectGetMaxY(baohe.frame)+25, KscWith/15, KscHeight/19);
    UIImage *image1 = [UIImage imageNamed:@"ButBack"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Naming setBackgroundImage:image1  forState:UIControlStateNormal];
    [_Naming addTarget:self action:@selector(NamingAction:) forControlEvents:UIControlEventTouchDown];
    [_Naming setTitleColor:WhitColor forState:UIControlStateNormal];
    [_Naming setTitle:@"Named" forState:UIControlStateNormal];
    [_InAview addSubview:_Naming];
    [_Naming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_Nametext.mas_top).with.offset(0);
        make.left.equalTo(VAlueImageView.mas_left).with.offset(0);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight * 0.06);
    }];

    
    _Cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    _Cancle.frame = CGRectMake(0, 5, 40, 40);
    UIImage *cancleImage = [UIImage imageNamed:@"Cancle"];
    cancleImage = [cancleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Cancle setBackgroundImage:cancleImage forState:UIControlStateNormal];

    [_Cancle addTarget:self action:@selector(CancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Cancle];
    [_Cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(5);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    

    _table = [[UITableView alloc]initWithFrame:CGRectMake(KscWith/9, CGRectGetMaxY(_ratioButton.frame), _ratioButton.frame.size.width, KscHeight/1.9) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InCell"];
    _table.hidden = YES;
    [_InAview addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ratioButton.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(KscWith/4);
        make.height.mas_equalTo(KscHeight/1.9);
    }];
    
   //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAction:) name:@"load" object:nil];

}

//呼叫事件
- (void)CallAction:(UIButton *)button
{
    if (![self isValidateIP:_IPText.text]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.margin = 10.0f; //提示框的大小
            mbp.label.text = NSLocalizedString(@"IP input incorrect",@"");
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
        
    }else if([self isValidateIP:_IPText.text] && [self isRangeValue:_valeText.text.integerValue])
    {
        NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].InArray[0]];
        NSInteger key = NumberKey.integerValue;
        [DataSqlite SelectByType:1 numberKey:key];
        
        if ([SignalValue ShareValue].isConnect == NO) {
            NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].InArray[0]];
            NSInteger key = NumberKey.integerValue;
            [DataSqlite DeleteByType:1 numberKey:key];
            udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            unsigned char buf[1024] = {0};
            NSString *str = _valeText.text;
            unsigned short utfString = [str integerValue];
            NSString *DataString = [NSString stringWithFormat:@"echo \"<c><m>d</m><n>%@</n><b>%d</b></c>\" | socat - TCP:127.0.0.1:45678\r\n",_IPText.text,utfString];
            NSLog(@"%@",DataString);
            unsigned char bufData[1024];
            memcpy(bufData, [DataString cStringUsingEncoding:NSASCIIStringEncoding], 2*[DataString length]);
            NSInteger length = make_ctr_pack_5555(METHOD_SET, CARD_INPUT,[[SignalValue ShareValue].InArray[0] integerValue],DataString.length,bufData,buf);
            NSData *data = [NSData dataWithBytes:(void *)&buf length:length];
            NSLog(@"ip:%@ port:%hu",[SignalValue ShareValue].SignalIpStr,[SignalValue ShareValue].SignalPort);
            [udpSocket sendData:data toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
            
            [DataSqlite InsertIntoType:1 NumberKey:key isConnect:1 IPString:_IPText.text valueWidth:_valeText.text];
            
            [button setTitle:NSLocalizedString(@"Hang up",@"") forState:UIControlStateNormal];
            UIImage *CallImge = [UIImage imageNamed:@"Clear"];
            CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [button setBackgroundImage:CallImge forState:UIControlStateNormal];
        }else
        {
            
            NSString *NumberKey = [NSString stringWithFormat:@"%@",[SignalValue ShareValue].InArray[0]];
            NSInteger key = NumberKey.integerValue;
            udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            unsigned char buf[1024] = {0};
            NSString *DataString = @"echo \"<c><m>h</m></c>\" | socat - TCP:127.0.0.1:45678\r\n";
            unsigned char bufData[1024];
            memcpy(bufData, [DataString cStringUsingEncoding:NSASCIIStringEncoding], 2*[DataString length]);
            NSInteger length = make_ctr_pack_5555(METHOD_SET,CARD_INPUT,[[SignalValue ShareValue].InArray[0]integerValue],DataString.length,bufData,buf);
            NSData *data = [NSData dataWithBytes:(void *)&buf length:length];
            [udpSocket sendData:data toHost:[SignalValue ShareValue].SignalIpStr port:4000 withTimeout:60 tag:544];
            UIImage *CallImge = [UIImage imageNamed:@"Call"];
            CallImge = [CallImge imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [button setBackgroundImage:CallImge forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"Call",@"") forState:UIControlStateNormal];
            [DataSqlite DeleteByType:1 numberKey:key];
            [DataSqlite InsertIntoType:1 NumberKey:key isConnect:0 IPString:_IPText.text valueWidth:_valeText.text];
            NSLog(@"%@",[SignalValue ShareValue].InArray[0]);
        }
        
    }
}

//判断是否是Ip格式
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
            mbp.label.text = NSLocalizedString(@"输入带宽值过小 请输入512~4000",@"");
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
            mbp.label.text = NSLocalizedString(@"输入带宽超出最大值 请输入512~4000",@"");
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

- (void)reloadAction:(NSNotification *)notice
{
    _ProInTable.view.hidden = YES;
    _Spacebutton.selected = NO;

    NSString *string = notice.userInfo[@"string"];
    [_Spacebutton setTitle:string forState:UIControlStateNormal];
    _Spacebutton.titleLabel.font = [UIFont systemFontOfSize:21];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _InGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InCell"];
    cell.textLabel.text = _InGroups[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    NSNumber *number = _InGroups[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",number];
   
    [_ratioButton setTitle:string forState:UIControlStateNormal];
    _ratioButton.titleLabel.font = [UIFont systemFontOfSize:23];
    _ratioButton.tintColor  = [UIColor blackColor];
    _table.hidden = YES;
    _ratioButton.selected = NO;
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
  
    NSNumber *Anumber= [SignalValue ShareValue].InArray[0];
    NSInteger integer = Anumber.integerValue;
    int a = (int)integer;
   
    NSInteger inte = indexPath.row;
    unsigned char bull = (unsigned char)inte;
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_RESOLUTION_OUTPUT, 1,&bull , buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
 
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)CancleAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//分辨率
- (void)ratioButtonAction:(UIButton *)button
{
     _ProInTable.view.hidden = YES;
    if (button.selected == NO) {
        _table.hidden = NO;
       
        button.selected = YES;
    }else
    {
        _table.hidden = YES;
        button.selected = NO;
    }
    
    
    
}


//色彩空间
- (void)SpacebuttonAction:(UIButton *)button
{
    _table.hidden = YES;
    _ratioButton.selected = NO;
    if (button.selected == NO) {
        self.ProInTable = [ProInTableViewController new];
        _ProInTable.view.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(_Spacebutton.frame), _Spacebutton.frame.size.width, KscHeight/2.8);
        [self.view addSubview:_ProInTable.view];
        [self addChildViewController:_ProInTable];
        button.selected = YES;
        
    }else
    {
        _ProInTable.view.hidden = YES;
        button.selected = NO;
        
    }
    
}


//命名
- (void)NamingAction:(UIButton *)button
{
    _Namestring = @"";
    UITextField *text = (UITextField *)[self.view viewWithTag:133333];
    NSString *Instring = text.text;
   
    [[SignalValue ShareValue].InArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *num = obj;
        NSInteger integer = num.integerValue;
        UIButton *button = [self.view viewWithTag:89999+115*[SignalValue ShareValue].ProCount+integer];
        
        NSString *string = [NSString stringWithFormat:@"%ld",(long)integer+89999 +115*[SignalValue ShareValue].ProCount];
        
        [[SignalValue ShareValue].InArray removeAllObjects];
        
        if (Instring.length <= 0) {
            
            NSString *title = [NSString stringWithFormat:@"%ld",(long)integer];
            [button setTitle:title forState:UIControlStateNormal];
            [[SignalValue ShareValue].InArray removeObject:num];
            button.backgroundColor = [UIColor whiteColor];
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            _Namestring = title;
            
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:title];
   
            
        }else if (Instring.length >= 5){
            
            NSString *str = [Instring substringToIndex:5];
            button.titleLabel.text = str;
            
            _Namestring = str;
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:str];
            [DataBaseHelp SelectTemp:integer Type:tage];
            [DataBaseHelp SelectTemp:integer Type:tage];
   
            
        }else if (Instring.length < 5 &&Instring.length > 0)
        {
            [button setTitle:Instring forState:UIControlStateNormal];
            
            _Namestring = Instring;
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:Instring];
            
        }
    }];
    [[SignalValue ShareValue].InArray removeAllObjects];
    
    //创建通知
    NSDictionary *dict = @{@"ProIn":_Namestring};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ProInNot" object:nil userInfo:dict];

    [self dismissViewControllerAnimated:YES completion:nil];
    [[SignalViewController new]reloadInputViews];
    
}
    

//亮度加
- (void)LightAddAction:(UIButton *)button
{
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;

    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_BRIGHTNESS_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
    
    
}

//亮度减
- (void)LightCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
 
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_BRIGHTNESS_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//对比度减
- (void)contrastCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;

    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_CONTRAST_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//对比度加
- (void)contrastaddAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
  
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_CONTRAST_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//饱和度加
- (void)SaturationAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_SATURATION_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//饱和度减
- (void)SaturationCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer; 
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_SATURATION_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//色度加
- (void)chromaAddAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_HUE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//色度减
- (void)chromaCutAction:(UIButton *)button
{
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
 
    unsigned char cardid =(unsigned char)a;

    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_HUE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
}

//复位
- (void)ResetAction:(UIButton *)button
{
    
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0x01;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
     int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;

    
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,C_SYSTEM_RESET, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
}



#pragma mark ===创建socket=====
- (void)ShowUdpSocket
{
    //初始化对象，使用全局队列
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}


#pragma mark === udpSocket执行的代理方法=======
//发送成功34
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 544) {
        NSLog(@"标记为200的数据发送完成了");
    }
}
//发送失败
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag,error);
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _InAview.frame = CGRectMake(_InAview.frame.origin.x, _InAview.frame.origin.y - 158, _InAview.frame.size.width, _InAview.frame.size.height);
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _InAview.frame = CGRectMake(_InAview.frame.origin.x, _InAview.frame.origin.y+158, _InAview.frame.size.width, _InAview.frame.size.height);
   
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
