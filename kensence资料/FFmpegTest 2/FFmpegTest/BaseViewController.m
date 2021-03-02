//
//  BaseViewController.m
//  FFmpegTest
//
//  Created by chenq@kensence.com on 16/3/15.
//  Copyright © 2016年 times. All rights reserved.
//

#import "BaseViewController.h"
#import "Masonry.h"
#import "AllCamearArray.h"
#import "TypeViewController.h"
#import "VideoViewController.h"
#import "CamerViewController.h"
#import "FormViewController.h"
#import "LightViewController.h"
#import "VolumeViewController.h"
#import "KxMovieGLView.h"
#import "DecomeTable.h"
#import "KxMovieDecoder.h"
#import "KxMovieGLView.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/pixdesc.h"
#import "KxAudioManager.h"
#import "KxLogger.h"
#import "SplitViewController.h"
#import "DataHelp.h"
#import "KxMovieDecoder.h"
#import "LinkIPCamer.h"
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GCDAsyncSocket.h"
#import "BaseTableViewCell.h"
#import "UUIDShortener.h"
#import "NSObject+SBJSON.h"
#import "CustomData.h"
#import "SenceData.h"
#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "SeleDataManager.h"
#import "SplitViewController.h"
#import "BaseTableViewC.h"
#import "CollectionViewCell.h"


#define Width4SuperView self.view.frame.size.width
#define Height4SuperView self.view.frame.size.height

#define Width4scroller _scroller.frame.size.width
#define Height4scroller _scroller.frame.size.height

#define ViewWidth  _view.frame.size.width
#define ViewHeight _view.frame.size.height

#define  ScreenWith _BackScro.frame.size.width
#define  ScreenHeight _BackScro.frame.size.height
#define  LogMessage(level,...)  NSLog(__VA_ARGS__)
#define UserNameString [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"]

@interface BaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UISearchBarDelegate ,UIGestureRecognizerDelegate,GCDAsyncSocketDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    GLuint          _framebuffer;
    GLuint          _renderbuffer;
    GLint           _backingWidth;
    GLint           _backingHeight;
    GLuint          _program;
    GLint           _uniformMatrix;
    GLfloat         _vertices[19];
    
    UIScrollView *_scroller;
    UIView *_view;
    NSMutableArray *MutArray;
    NSInteger index;
    TypeViewController *_TypeView; //显示模式控制器
    VideoViewController *_VideoView; //视屏分发
    CamerViewController *_CamearView; //摄像头
    FormViewController *_formView; //显示格式
    LightViewController *_LightView; //灯光控制
    VolumeViewController *_VolumeView; //声音控制
    DecomeTable *_Decome; //修改选择解码器
    KxMovieGLView *GlView; //解码显示
    KxMovieDecoder      *_decoder; //解码
    AVCodecContext      *_videoCodecCtx;
    SplitViewController *splitViewControl; //隐藏的会场列表
    
    UIActivityIndicatorView *_activityIndicatorView;
      CGFloat             _moviePosition;
    dispatch_queue_t _dispatch_queue;
    NSMutableArray *AllClientArray;
    NSString *filePath;
    UIActionSheet *actionSheet;

 }
@property (nonatomic ,copy)UIView *VIew;
@property (nonatomic ,assign)NSInteger DecomeOrigionX;//自定义视图的X
@property (nonatomic ,assign)NSInteger DecomeOrigionY; //自定义视图的Y
@property (nonatomic ,strong)UISearchBar *search; //搜索框
@property (nonatomic ,strong)UIView *SearchCoveview; //搜索时的遮盖视图
@property (nonatomic ,strong) UIView *TestView; //测试的View
@property (nonatomic ,assign)NSInteger tag;
@property (nonatomic ,assign)NSInteger Tinte;
@property (nonatomic ,strong)UILabel *RtextString;

//折中方法的后添加的属性
@property (nonatomic ,strong)UIView *Cellview;
@property (nonatomic ,strong)UIImageView*panview;
@property (nonatomic ,strong)UILabel *DeLabel; //解码器名
@property (nonatomic ,strong)NSMutableArray *nameArray;
@property (nonatomic ,assign)NSInteger MeetingViewTag;//会场的tag
@property (nonatomic ,strong)NSMutableArray *RectstringArray; //保存RRect的值

@property (nonatomic ,strong)UIView *Blueview;

@property (nonatomic ,strong)NSMutableArray *XCountArray; //第几个X方向的方块
@property (nonatomic ,strong)NSMutableArray *YcountArray; //第几个Y方向的方块

@property (nonatomic ,assign)NSInteger XPanView; //平移X的位置
@property (nonatomic ,assign)NSInteger YPanView; //平移Y的位置
@property (nonatomic ,assign)BOOL SaveOrNo;
@property (nonatomic ,strong) UIView *BackBlue;
@property (nonatomic ,assign)NSInteger DeleNumber;
@property (nonatomic ,assign)BOOL SaveIsOFF;
@property (nonatomic ,assign)NSInteger DeletedPanView; //记录舍弃数
@property (nonatomic ,assign)BOOL SaveUse; //点击了保存事件
@property (nonatomic ,strong)NSMutableArray *SencePicTagarray;//添加场景列表的tag数组
@property (nonatomic ,strong)UIImageView *image;

@property (nonatomic ,strong)NSMutableArray * ViewtagArray; //暂存TViewTag
@property (nonatomic ,strong)NSMutableArray * TLinkTagArray; //暂存Ttag
@property (nonatomic ,strong)NSMutableArray * ViewRectArray; //暂存位置
@property (nonatomic ,strong)NSMutableArray * RNameArray; //暂存RName；
@property (nonatomic ,strong)NSMutableArray * DesVidArray; //暂存desv
@property (nonatomic ,strong)NSMutableArray * DeschArray; //暂存desc
@property (nonatomic ,strong)NSMutableArray * RectValue; //暂存Custom位置
@property (nonatomic ,strong)NSMutableArray * CustomTagNumber; //暂存CustomRtag
@property (nonatomic ,strong)NSMutableArray * CustomRname; //暂存R名称
@property (nonatomic ,strong)NSMutableArray * CustomDesc; //暂存desID；
@property (nonatomic ,strong)NSMutableArray * CustomDesv; //暂存desvID
@property (nonatomic ,assign)CGFloat lastScale;
@property (nonatomic ,assign)BOOL IsPan;
@property (nonatomic ,strong)NSMutableArray *RectArray;
@property (nonatomic ,strong)NSMutableArray *ReRectArr;
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)NSMutableArray *CustomCenter; //自定义View中心
@property (nonatomic ,assign)BOOL IsOk;
@property (nonatomic ,strong)NSMutableArray *MutSelsct;
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic ,assign)NSInteger heartTimeInterval;
@property (nonatomic ,assign)BOOL Isend;
@property (nonatomic ,assign)NSInteger Sencetag;
@property (nonatomic ,assign)NSInteger indexRow;

@property (nonatomic ,strong)UILabel *Sencelabel; //场景名称
@property (nonatomic ,strong)NSMutableArray *SenceNameArray;
@property (nonatomic ,assign)BOOL iscustom; //模式选择
@property (nonatomic ,strong)UIButton *SenceControl;
@property (nonatomic ,strong)UIButton *type;
@property (nonatomic ,strong)UIButton *video;
@property (nonatomic ,strong)UIButton *lightControl;
@property (nonatomic ,strong)UIImageView *MenuView;
@property (nonatomic ,assign)BOOL IsEngish; //语言
@property (nonatomic ,strong)UIImageView *CellImageView;
@property (nonatomic ,assign)NSInteger CellIndex; //点击的第几个图片
@property (nonatomic ,strong)NSString *ImagePath;

@property (nonatomic ,strong)UIView *BacView;
@property (nonatomic ,strong)UIImageView *AddImage;
@property (nonatomic ,strong)NSMutableArray *CellMutArray;

@property (nonatomic ,strong)UIButton *SetCamerButton;
@property (nonatomic ,assign)NSInteger CellCount; //记录第几次点击cell
@property (nonatomic ,assign)NSInteger isSame;
@property (nonatomic ,assign)BOOL isDesture;
@property (nonatomic ,strong)NSMutableArray *LinkArray;

@property (nonatomic ,strong)NSMutableArray *CurrentRLink;



@end

@implementation BaseViewController

static const NSString *TableSampleIdentifier = @"TableSampleIdentifier";

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[DataHelp shareData].ClientSocket disconnect];
//    [DataHelp shareData].ClientSocket = nil;
    [self removeFromParentViewController];
//     [self.navigationController removeFromParentViewController];
//    [[BaseViewController new]removeFromParentViewController];
    [NSTimer initialize];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[DataHelp shareData].ClientSocket disconnect];
    [[BaseViewController new] removeFromParentViewController];
    [[BaseViewController new].view removeFromSuperview];
    [[DataHelp shareData] cutConnect];
//    [self.navigationController.view removeFromSuperview];
//    self.navigationController.view = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([language isEqualToString:@"en"]) {
        _IsEngish = YES;
    }else
    {
        _IsEngish = NO;
    }
    
    for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
        NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",UserNameString,[DataHelp shareData].srcchanidArray[i]]];
        if (string != nil) {
            [SeleDataManager DeleteWithTemp:UserNameString Value:[DataHelp shareData].TAllArray[i]];
            [SeleDataManager InsertIntoTemp:UserNameString Value:string];
            [[DataHelp shareData].MutTXArray replaceObjectAtIndex:i withObject:string];
        }
    }
 
    [[DataHelp shareData].TAllArray removeAllObjects];
    _Leftindex = 0;

    self.view.backgroundColor = BakeSrcColor;
    UIImage *NavImage = [UIImage imageNamed:@"HeaderBg"];
    [self.navigationController.navigationBar setBackgroundImage:NavImage forBarMetrics:UIBarMetricsDefault];
    
    self.didSelect = 0;
    _OneDict = [NSMutableDictionary dictionary];
    _TwoDict = [NSMutableDictionary dictionary];
    _ThreeDict = [NSMutableDictionary dictionary];
    _FourDict = [NSMutableDictionary dictionary];
    _CurrentRLink = [NSMutableArray array];
    index = 0;
    _DeletedPanView = 0;
    _MeetingViewTag = 3000;
    _CustomMutDict = [NSMutableDictionary dictionary]; //存储自定义布局view的位置信息、
    self.NumberOfScreen = 1;  //程序启动默认为一分屏幕
    self.DecomeNumber = 0; //自定义选择的第几个解码器
    _DecomeMutArray = [NSMutableArray array];  //开辟解码器数组的空间
    _SenceTagArray = [NSMutableArray array]; // 场景的tag

    _MovViewArray = [NSMutableArray array];
    _MovViewdict = [NSMutableDictionary dictionary];
    
    _XCountArray = [NSMutableArray array];
    _YcountArray = [NSMutableArray array];
    
    _RectArray = [NSMutableArray array];
    _CustomCenter = [NSMutableArray array];
    NSMutableArray *arr =  [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
    if (arr != nil) {
    }
    //sence保存暂存开辟空间
    _ViewtagArray = [NSMutableArray array];
    _TLinkTagArray = [NSMutableArray array];
    _ViewRectArray = [NSMutableArray array];
    _RNameArray = [NSMutableArray array];
    _DesVidArray = [NSMutableArray array];
    _DeschArray = [NSMutableArray array];
    _LinkArray = [NSMutableArray array];
    
    //custom暂存
    _RectValue = [NSMutableArray array];
    _CustomTagNumber = [NSMutableArray array];
    _CustomRname = [NSMutableArray array];
    _CustomDesc = [NSMutableArray array];
    _CustomDesv = [NSMutableArray array];
    _ReRectArr = [NSMutableArray array];
    _array = [NSMutableArray array];
    _CellMutArray = [NSMutableArray array];
    
    [DataHelp shareData].mutData = [NSMutableData data];
    MutArray = [NSMutableArray arrayWithObjects: //解码地址
//                      @"rtsp://admin:admin123@192.168.1.188/camera.264",
                        @"rtsp://admin:admin123@192.168.1.65:554/ISAPI/streaming/channels/002.mp4",
//                      @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/101",
//                      @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/101",
//                        @"rtsp://admin:admin123@192.168.1.188/camera.264",
//                        @"rtsp://admin:admin123@192.168.1.188/camera.264",
                        @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/002.mov",
                        @"rtsp://admin:admin123@192.168.1.64:554/h264/ch1/sub/av_stream.mkv",
//                      @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.65:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.65:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.64:554/ISAPI/streaming/channels/102",
//                      @"http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4",
//                      @"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov",
//                      @"rtsp://admin:admin123@192.168.1.65:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.65:554/ISAPI/streaming/channels/102",
//                      @"rtsp://admin:admin123@192.168.1.65:554/ISAPI/streaming/channels/102",
//                      @"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov",
//                      @"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov",
//                      @"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov",
//                      @"http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4",
//                      @"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov",
//                      @"rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov",
                nil];
    
    UIImage *ImageData = [UIImage imageNamed:@"透明"];
    for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
        [_CellMutArray addObject:ImageData];
    }
    
    [DataHelp shareData].MeetingName = [DataHelp shareData].LocationArray[0][@"name"];
    [self CreatNavigationAction]; //添加功能控制视图
    [self CreatTableViewOfViewoView]; //添加T输入源视图
    [self CreatSearch]; //添加搜索框
   
//    [self SetUpview]; //添加模式选择视图
   [self DreawSplitScreen]; //添加隐藏视图
    [self BakeForRScreen]; //添加R的视图
    [self DreawMeeting]; //添加T滚动按钮
    self.PanviewTag = 0;//
    [self CreatSlipButton]; //隐藏视图的触发按钮
    [self SetMenu];
     [self drawView4Sence]; //添加场景列表
//  [self CreatVideoView];
    _SenceCount = 0; //默认会场的值
    [DataHelp shareData].MeetingNumber = 1;
    [_table reloadData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(decomeAction:) name:@"DecomeName" object:nil];  //注册解码器名字通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemoveView:) name:@"Remve" object:nil];   //注册通知隐藏view的通知

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetValueAction:) name:@"ViewName" object:nil];  //注册传值通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ImageDataAction:) name:@"ImageData" object:nil]; //注册Image的通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SliptMeeting:) name:@"SplitBackView" object:nil]; //注册会场列表
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DataSelect:) name:@"DataArray" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LostLogin:) name:@"LostUser" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeleteCustom:) name:@"DeleSence" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(REmoveBac:) name:@"ReCenter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RegistName:) name:@"RegistName" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RegistPuture:) name:@"RegistPuture" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LongCamer:) name:@"LongCamer" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWahiden:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  @param 将设置界面弹出
 *
 *  @param sender将设置界面弹出
 */

- (void)LongCamer:(NSNotification *)sender
{

    NSString *Valuestring= sender.userInfo[@"LongTag"];
    NSInteger ValueInter = Valuestring.integerValue;
    [DataHelp shareData].TapTagNumber = ValueInter;
    [DataHelp shareData].isTdecore = NO;
    [DataHelp shareData].RCamerIndx = ValueInter - 7999;
    [DataHelp shareData].camerIndexName = [DataHelp shareData].MeetingRnameArray[[DataHelp shareData].RCamerIndx];
    _CamearView = [CamerViewController new];
    _CamearView.Rindex = ValueInter - 7999;
    _CamearView.view.frame = CGRectMake(Width4SuperView * 0.3,Height4SuperView * 0.16, 580, 410);
    //        _CamearView.view.center = self.view.center;
    [self addChildViewController:_CamearView];
    [self.view addSubview:_CamearView.view];

}


/**
 *  修改图片提示框
 *
 *  @param notice 修改图片提示框1
 */
- (void)RegistPuture:(NSNotification *)notice
{
    [self actionSheet];
}
- (void)RegistName:(NSNotification *)notice
{
    if ([DataHelp shareData].TapTagNumber >= 100 && [DataHelp shareData].TapTagNumber < 1000) {
        if (_NumberOfScreen == 1) {
            if ([DataHelp shareData].TapTagNumber - 100 < [DataHelp shareData].MeetingRnameArray.count) {
                [self LongViewTag:[DataHelp shareData].TapTagNumber];
            }else
            {
                [self showMessage];
            }
            
        }else if (_NumberOfScreen == 2)
        {
            if ([DataHelp shareData].TapTagNumber - 102 < [DataHelp shareData].MeetingRnameArray.count) {
                [self LongViewTag:[DataHelp shareData].TapTagNumber];
            }else
            {
                [self showMessage];
            }
            
        }else if (_NumberOfScreen == 3)
        {
            if ([DataHelp shareData].TapTagNumber - 106 < [DataHelp shareData].MeetingRnameArray.count) {
                [self LongViewTag:[DataHelp shareData].TapTagNumber];
            }else
            {
                [self showMessage];
            }
            
        }else if (_NumberOfScreen == 4)
        {
            if ([DataHelp shareData].TapTagNumber - 120 < [DataHelp shareData].MeetingRnameArray.count) {
                [self LongViewTag:[DataHelp shareData].TapTagNumber];
            }else
            {
                [self showMessage];
            }
        }
        
    }else if ([DataHelp shareData].TapTagNumber >= 1000 && [DataHelp shareData].TapTagNumber < 2000)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"修改名称") message:nil preferredStyle:UIAlertControllerStyleAlert];
        //    [alert setValue:[UIColor grayColor] forKeyPath:@"titleTextColor"];
        alert.view.tintColor =[UIColor colorWithRed:42/255.0 green:50/255.0 blue:60/255.0 alpha:1];
        alert.view.backgroundColor = [UIColor colorWithRed:42/255.0 green:50/255.0 blue:60/255.0 alpha:1];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // 可以在这里对textfield进行定制，例如改变背景色
            //        textField.backgroundColor = [UIColor colorWithRed:42/255.0 green:50/255.0 blue:60/255.0 alpha:1];
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        }];
        UIAlertAction *Cancle = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *text = (UITextField *)alert.textFields.firstObject;
            if (text.text != nil) {
                if (_MutSelsct.count != 0) {
                    NSNumber *number = _MutSelsct[_CellIndex];
                    NSString *ValueString = [NSString stringWithFormat:@"%@",number];
                    UILabel *label = (UILabel *)[self.view viewWithTag:_CellIndex + 1000 + 212];
                    label.text = text.text;
                    [_MutSelsct replaceObjectAtIndex:_CellIndex withObject:text.text];
                    for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
                        NSNumber *number = [DataHelp shareData].TAllArray[i];
                        NSString *TallString = [NSString stringWithFormat:@"%@",number];
                        if ([ValueString isEqualToString:TallString]) {
                            [[DataHelp shareData].MutTXArray replaceObjectAtIndex:i withObject:text.text];
                            [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:[NSString stringWithFormat:@"%@%@",UserNameString,[DataHelp shareData].srcchanidArray[i]]];
                        }
                    }
                    [_table reloadData];
                    
                }else{
                    NSInteger tag = _CellIndex;
                    [[DataHelp shareData].MutTXArray replaceObjectAtIndex:tag withObject:text.text];
                    [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:[NSString stringWithFormat:@"%@%@",UserNameString,[DataHelp shareData].srcchanidArray[tag]]];
                    UILabel *label = (UILabel *)[self.view viewWithTag:_CellIndex + 1000 + 212];
                    label.text = text.text;
                    [_table reloadData];
                }
            }
        }];
        [alert addAction:Cancle];
        [alert addAction:Sure];
        [self presentViewController:alert animated:YES completion:nil];
    }else if ([DataHelp shareData].TapTagNumber >= 7999)
    {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"修改名称") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // 可以在这里对textfield进行定制，例如改变背景色
            //textField.backgroundColor = [UIColor orangeColor];
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
            
        }];
        UIAlertAction *Cancle = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        
        UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *text = (UITextField *)alert.textFields.firstObject;
            
//            NSString *string = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(Tag + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
//            [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            
            if (_NumberOfScreen == 1) {
                if ([DataHelp shareData].TapTagNumber - 7999 == 0) {
                    UILabel *label = (UILabel *)[self.view viewWithTag:([DataHelp shareData].TapTagNumber - 7999) + 500];
                    label.text = text.text;
                    NSString *Bcstring = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber - 7999) + 500),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                    [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:Bcstring];
                    for (int i = 0; i < _CurrentRLink.count; i++) {
                        if ([_CurrentRLink[i]isEqualToString:[NSString stringWithFormat:@"%ld",(long)([DataHelp shareData].TapTagNumber - 7999)]]) {
                            NSInteger TagInteger = [_ViewtagArray[i] integerValue];
                            UILabel *RLink = (UILabel *)[self.view viewWithTag:TagInteger+1000];
                            RLink.text = text.text;
                        }
                    }
                }
               
                UIButton *button = (UIButton *)[self.view viewWithTag:[DataHelp shareData].TapTagNumber];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:[DataHelp shareData].TapTagNumber - 7999 withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber - 7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[([DataHelp shareData].TapTagNumber - 7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
                
            }else if (_NumberOfScreen == 2)
                
            {
                if ([DataHelp shareData].TapTagNumber - 7999 < 4) {
                    UILabel *label = (UILabel *)[self.view viewWithTag:([DataHelp shareData].TapTagNumber - 7999) + 502];
                    label.text = text.text;
                    NSString *Bcstring = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber - 7999) + 502),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                    [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:Bcstring];
                    for (int i = 0; i < _CurrentRLink.count; i++) {
                        if ([_CurrentRLink[i]isEqualToString:[NSString stringWithFormat:@"%ld",(long)([DataHelp shareData].TapTagNumber - 7999)]]) {
                            NSInteger TagInteger = [_ViewtagArray[i] integerValue];
                            UILabel *RLink = (UILabel *)[self.view viewWithTag:TagInteger+1000];
                            RLink.text = text.text;
                        }
                    }
                }
                
                UIButton *button = (UIButton *)[self.view viewWithTag:[DataHelp shareData].TapTagNumber];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:([DataHelp shareData].TapTagNumber -7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber -7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[([DataHelp shareData].TapTagNumber -7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
                
            }else if (_NumberOfScreen == 3)
            {
                
                if ([DataHelp shareData].TapTagNumber - 7999 < 9) {
                    UILabel *label = (UILabel *)[self.view viewWithTag:([DataHelp shareData].TapTagNumber - 7999) + 506];
                    label.text = text.text;
                    NSString *Bcstring = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber - 7999) + 506),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                    [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:Bcstring];
                    for (int i = 0; i < _CurrentRLink.count; i++) {
                        if ([_CurrentRLink[i]isEqualToString:[NSString stringWithFormat:@"%ld",(long)([DataHelp shareData].TapTagNumber - 7999)]]) {
                            NSInteger TagInteger = [_ViewtagArray[i] integerValue];
                            UILabel *RLink = (UILabel *)[self.view viewWithTag:TagInteger+1000];
                            RLink.text = text.text;
                        }
                    }
                }
                
                
                UIButton *button = (UIButton *)[self.view viewWithTag:[DataHelp shareData].TapTagNumber];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:([DataHelp shareData].TapTagNumber -7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber -7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[([DataHelp shareData].TapTagNumber -7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
                
            }else if (_NumberOfScreen == 4)
            {
                if ([DataHelp shareData].TapTagNumber - 7999 < 16) {
                    UILabel *label = (UILabel *)[self.view viewWithTag:([DataHelp shareData].TapTagNumber - 7999) + 520];
                    label.text = text.text;
                    NSString *Bcstring = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber - 7999) + 520),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                    [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:Bcstring];
                    for (int i = 0; i < _CurrentRLink.count; i++) {
                        if ([_CurrentRLink[i]isEqualToString:[NSString stringWithFormat:@"%ld",(long)([DataHelp shareData].TapTagNumber - 7999)]]) {
                            NSInteger TagInteger = [_ViewtagArray[i] integerValue];
                            UILabel *RLink = (UILabel *)[self.view viewWithTag:TagInteger+1000];
                            RLink.text = text.text;
                        }
                    }
                }
                UIButton *button = (UIButton *)[self.view viewWithTag:[DataHelp shareData].TapTagNumber];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:([DataHelp shareData].TapTagNumber -7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber -7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[([DataHelp shareData].TapTagNumber -7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }else
            {
                UIButton *button = (UIButton *)[self.view viewWithTag:[DataHelp shareData].TapTagNumber];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:([DataHelp shareData].TapTagNumber -7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(([DataHelp shareData].TapTagNumber -7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[([DataHelp shareData].TapTagNumber -7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }
            
        }];
        
        [alert addAction:Cancle];
        [alert addAction:Sure];
        [self presentViewController:alert animated:YES completion:nil];
 
    }
    
    /*
    }else if([DataHelp shareData].isViedeo == YES )
    {
        
        /**
         *  video的按钮
         *
         *  @param @"修改名称"
         *
         *  @return
         /
  
        
        NSInteger numberIndex = [DataHelp shareData].TapTagNumber;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"修改名称") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // 可以在这里对textfield进行定制，例如改变背景色
            //textField.backgroundColor = [UIColor orangeColor];
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
            
        }];
        
        UIAlertAction *Cancle = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        
        UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UITextField *text = (UITextField *)alert.textFields.firstObject;
            UIButton *button = (UIButton *)[self.view viewWithTag:numberIndex];
            [button setTitle:text.text forState:UIControlStateNormal];
            
            NSInteger tagNumber;
            if (numberIndex - 7999 >= _NumberOfScreen * _NumberOfScreen) {
                if ( _NumberOfScreen == 1 && numberIndex - 7999 ==0) {
                    tagNumber = 100;
                }else if ( _NumberOfScreen == 2)
                {
                    tagNumber = 102 + (numberIndex - 7999);
                    
                }else if ( _NumberOfScreen == 3 )
                {
                    tagNumber = 106 + (numberIndex - 7999);
                }else if ( _NumberOfScreen == 4 )
                {
                    tagNumber = 120 + (numberIndex - 7999);
                }
                UILabel *label = (UILabel *)[self.view viewWithTag:tagNumber + 400];
                label.text = text.text;
                
                NSString *string = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(tagNumber + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];

            }else
            {
                if ( _NumberOfScreen == 1 ) {
                    tagNumber = 100 + numberIndex - 7999;
                }else if ( _NumberOfScreen == 2)
                {
                    tagNumber = 102 + (numberIndex - 7999);
                    
                }else if ( _NumberOfScreen == 3 )
                {
                    tagNumber = 106 + (numberIndex - 7999);
                }else if ( _NumberOfScreen == 4 )
                {
                    tagNumber = 120 + (numberIndex - 7999);
                }
                UILabel *label = (UILabel *)[self.view viewWithTag:tagNumber + 400];
                label.text = text.text;
                
                NSString *string = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(tagNumber + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }
            if (_NumberOfScreen == 1) {
            
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:(numberIndex - 7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)((numberIndex - 7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[(numberIndex - 7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }else if (_NumberOfScreen == 2)
            {
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:(numberIndex - 7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)((numberIndex - 7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[(numberIndex - 7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
                
            }else if (_NumberOfScreen == 3)
            {
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:(numberIndex - 7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)((numberIndex - 7999)+ 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[(numberIndex - 7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }else if (_NumberOfScreen == 4)
            {
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:(numberIndex - 7999) withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)((numberIndex - 7999) + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[(numberIndex - 7999)]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }
        }];
        
        [alert addAction:Cancle];
        [alert addAction:Sure];
        [self presentViewController:alert animated:YES completion:nil];
    
    }

    */
}

- (void)REmoveBac:(id)center
{
    UIView *cenView = (UIView *)[self.view viewWithTag:550505];
    [cenView removeFromSuperview];
    [_CamearView removeFromParentViewController];
    [_CamearView.view removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(start:) userInfo:nil repeats:NO];
}

- (void)start:(NSTimer *)tart
{
    [[DataHelp shareData] StartTimer];
    [tart invalidate];
}

//- (void)longConnectToSocket:(NSTimer *)timer
//{
//    static int i = 0;
//    NSDictionary *dict = @{@"message":@{@"function":@"device_get_all"}};
//    i += 20;
//    NSData *data = [[NSString stringWithFormat:@"%@\n",[dict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
//    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:600];
//    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:600];
//    
//}

-(NSMutableArray *)RectArray
{
    if (_RectArray == nil) {
        _RectArray = [NSMutableArray array];
    }
    return _RectArray;
}


- (void)DeleteCustom:(id)notice
{
    [DataHelp shareData].CustomeIsBool = NO;
    _NumberOfScreen = 1;
    [self lipButtonAction:_lipButton];
    [self BakeForRScreen];
}

- (void)LostLogin:(NSNotification *)notice
{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DataHelp shareData].ClientSocket disconnect];
            BaseViewController *bas = [BaseViewController new];
            LoginViewController *login =[LoginViewController new];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = login;
            [bas dismissViewControllerAnimated:YES completion:nil];
        });

}

- (void)DataSelect:(NSNotification *)notic
{   [_ViewtagArray removeAllObjects];
    [_ViewRectArray removeAllObjects];
    [_TLinkTagArray removeAllObjects];
    [_RNameArray removeAllObjects];
    [_DesVidArray removeAllObjects];
    [_DeschArray removeAllObjects];
    [self.SenceTagArray removeAllObjects];
    [self.MoveViewArray removeAllObjects];
    for (int i = 0; i < _NumberOfScreen * _NumberOfScreen ; i++) {
        UIView *view = (UIView *)[self.view viewWithTag:10001+i];
        [view removeFromSuperview];
    }
    
    NSMutableArray *Array = notic.userInfo[@"dataDict"];
    NSArray *senceNUmberData = [Array[1] valueForKey:@"senceNUmberData"];
    NSArray *SenceRArrayData = [Array[2] valueForKey:@"SenceRArrayData"];
    NSNumber *sencenumber = senceNUmberData[0];
    NSInteger senceNumberInteger = sencenumber.integerValue;
    
    NSNumber *senceRNumber = SenceRArrayData[0];
    NSInteger SenceRInteger = senceRNumber.integerValue;
    
    if (senceNumberInteger == 1)
    {
        [DataHelp shareData].CustomeIsBool = NO;
        _NumberOfScreen = SenceRInteger;
        
        [_BackScro removeFromSuperview];
        for (int i = 0; i < [DataHelp shareData].LocationArray.count; i++) {
            if ([[DataHelp shareData].LocationArray[i][@"name"]isEqualToString:[DataHelp shareData].MeetingIndex]) {
                _MeetingViewTag = 3000+i;
            }
        }
        
        [self BakeForRScreen];
    }else if (senceNumberInteger == 2)
    {
        _SenceCount = SenceRInteger;
        [DataHelp shareData].CustomeIsBool = YES;
        self.SenceBool = 0;
        self.SaveOrNo = 0;
        _NumberOfScreen = 1;
        
        if (_SaveUse == YES) {
            _SenceCount = SenceRInteger;
        }
        _SaveUse = NO;
        
        [_backRScreen removeFromSuperview]; //移除自定义View的视图，添加选中的会场
        for (int i = 0; i < [DataHelp shareData].LocationArray.count; i++) {
            if ([[DataHelp shareData].LocationArray[i][@"name"]isEqualToString:[DataHelp shareData].MeetingIndex]) {
                _MeetingViewTag = 3000+i;
            }
        }
        [self BakeForRScreen];
    }
    
    NSArray *TLinkTagArrayData = [Array[3] valueForKey:@"TLinkTagArrayData"];
    NSArray *ViewaRectArrayData = [Array[4] valueForKey:@"ViewaRectArrayData"];
    NSArray *RNamearrayData = [Array[5] valueForKey:@"RNamearrayData"];
//    NSArray *DictViewTag = [Array[0] valueForKey:@"DictViewTag"];
    NSArray *DesvidArrayData = [Array[6] valueForKey:@"DesvidArrayData"];
    NSArray *DeschArrayData = [Array[7] valueForKey:@"DeschArrayData"];
    
    NSInteger iscustom = 12;
    for (int i = 0; i < _RectArray.count; i++) {
        NSNumber *number = _RectArray[i];
        NSString *string = [NSString stringWithFormat:@"%@",number];
        NSNumber *RectNumber = ViewaRectArrayData[0];
        NSString *RectString = [NSString stringWithFormat:@"%@",RectNumber];
        
        if ([string isEqualToString:RectString]) {
            iscustom = i;
        }
    }
    if (senceNumberInteger == 1) {
        iscustom = 2;
    }
        if (iscustom != 12) {
            for (int i = 0; i < TLinkTagArrayData.count; i++) {
        _panview = [[UIImageView alloc]init];
        NSNumber *number = ViewaRectArrayData[i];
        NSString *RectString = [NSString stringWithFormat:@"%@",number];
        CGRect rect = CGRectFromString(RectString);
//        _PanviewTag = 10000+i+1;
        if (senceNumberInteger == 2) {
            NSInteger OrigionX = rect.origin.x;
            NSInteger OrigionY = rect.origin.y;
            NSInteger With = rect.size.width;
            NSInteger height = rect.size.height;
           _panview.frame = CGRectMake(OrigionX + _table.frame.size.width +6, OrigionY +CGRectGetMaxY(_BackView.frame)+ 6, With, height);
            
        }else if (senceNumberInteger == 1)
        {
            _panview.frame = rect;
        }
                
        index = 0;
        _panview.tag = 10001 + i;
        self.PanviewTag = 1 + i;
        _panview.backgroundColor = BacViewRGB;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [_panview addGestureRecognizer:pan];
        [self.view addSubview:_panview];
        
        NSNumber *TName = TLinkTagArrayData[i];
        NSInteger TNameinteger = TName.integerValue;
        self.Tinte = TNameinteger;
        UILabel *label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor colorWithRed:212/255.0 green:242/255.0 blue:232/255.0 alpha:1];
        label.frame = CGRectMake(0, 5, _panview.frame.size.width,_panview.frame.size.height/4);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [DataHelp shareData].TAllArray[TNameinteger];
        [self.panview addSubview:label];

        UILabel *Linklabel = [[UILabel alloc]init];
        Linklabel.text = Localized(@"连接");
        Linklabel.textAlignment = NSTextAlignmentCenter;
        Linklabel.frame = CGRectMake(0,CGRectGetMaxY(label.frame)+5, _panview.frame.size.width,_panview.frame.size.height/4);
        [self.panview addSubview:Linklabel];
        
        _RtextString = [[UILabel alloc]init];
        _RtextString.frame = CGRectMake(0, CGRectGetMaxY(Linklabel.frame) +5, _panview.frame.size.width,_panview.frame.size.height/4);
//        _RtextString.backgroundColor = [UIColor colorWithRed:212/255.0 green:242/255.0 blue:232/255.0 alpha:1];
        _RtextString.textAlignment = NSTextAlignmentCenter;
        _RtextString.tag = 11001 + i;
        _RtextString.text = RNamearrayData[i];
        [self.panview addSubview:_RtextString];
        NSNumber *srcchan = [DataHelp shareData].srcchanidArray[TNameinteger];
        NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
        NSNumber *srcdev = [DataHelp shareData].srcdevidArray[TNameinteger];
        NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
        NSString *destdevString = [NSString stringWithFormat:@"%@",DeschArrayData[i]];
        NSString *String = [NSString stringWithFormat:@"%@",DesvidArrayData[i]];
        
        NSUUID *uuid = [NSUUID UUID];
        NSString *uuidString = uuid.UUIDString;
//     [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
        NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                 @"destchanid":destdevString,
                                                                                                 @"destdevid":String,
                                                                                                 @"id":uuidString,
                                                                                                 @"srcchanid":srcchanString,
                                                                                                 @"srcdevid":srcdevString}]}};
        NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
        
        [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
        [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
        
        [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
        [_ViewRectArray addObject:ViewaRectArrayData[i]];
        [_TLinkTagArray addObject:TLinkTagArrayData[i]];
        [_RNameArray addObject:RNamearrayData[i]];
        [_DesVidArray addObject:DesvidArrayData[i]];
        [_DeschArray addObject:DeschArrayData[i]];
    }
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"场景应用失败") message:Localized(@"会场已被修改，连接失效") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"场景会场已不存在") message:Localized(@"是否将当前场景删除") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *SenceCancle = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *SenceSele = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteSence:_Sencetag];
                }];
                [alert addAction:SenceCancle];
                [alert addAction:SenceSele];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            [alert addAction:action];
            [alert addAction:OAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
}

#pragma mark   ******* 视图出现时加载场景********
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSArray *senceTagArr = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
    _SenceNameArray = [NSMutableArray array];
    _SenceNameArray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
   
    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@LocaTagArray",UserNameString]];
    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
    NSInteger integer = string.integerValue;
    for (int i = 1; i <= integer; i++) {
        if (senceTagArr.count != 0) {
        NSNumber *PicArr = arr[i - 1];
        NSString *PicString = [NSString stringWithFormat:@"%@",PicArr];
        NSInteger PicInteger = PicString.integerValue - 554;
        NSString *Key = [NSString stringWithFormat:@"%ld",(long)PicInteger];
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",UserNameString,Key]];
        UIImage *Image = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(6+ (180)*(i - 1),2,168,30);
            label.backgroundColor = SenceNameRGB;
//            label.layer.borderColor = [UIColor blackColor].CGColor;
//            label.layer.borderWidth = 0.2;
            label.text = _SenceNameArray[i - 1];
            label.textColor = WhiteColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.tag = 1699  + i;
            [_SenceSCroller addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-25 + (180)*(i - 1),17,200,Height4SuperView * 0.17)];
//            imageView.backgroundColor = [UIColor yellowColor];
        imageView.image = Image;
        imageView.tag = 555 + i - 1;
        imageView.userInteractionEnabled = YES;
        //点击应用
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageTapAction:)];
        tap.numberOfTapsRequired = 2;
        tap.delegate = self;
        [imageView addGestureRecognizer:tap];
        
        //长按手势删除保存
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(SaveIMageLongPressAction:)];
        longPress.minimumPressDuration = 0.5;
        longPress.delegate = self;
        [imageView addGestureRecognizer:longPress];
        [_SenceSCroller addSubview:imageView];
        }
    }
}
//会场列表选的通知事
- (void)SliptMeeting:(NSNotification *)notice
{
    [_CustomCenter removeAllObjects];
    [_RectValue removeAllObjects];
    [_CustomTagNumber removeAllObjects];
    [_CustomRname removeAllObjects];
    [_CustomDesc removeAllObjects];
    [_CustomDesv removeAllObjects];
    
    _NumberOfScreen = 1;
    self.DecomeNumber = 0;
    _DeletedPanView= 0;
    
    UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
    UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
    UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
    UIImage *OneImage = [UIImage imageNamed:@"SeleOne@2x"];
    OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [OneButton setImage:OneImage forState:UIControlStateNormal];
    
    UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
    UIImage *FourImage = [UIImage imageNamed:@"Two@2x"];
    FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [fourButton setImage:FourImage forState:UIControlStateNormal];
    
    UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
    UIImage *NineImage = [UIImage imageNamed:@"Three@2x"];
    NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Ninebutton setImage:NineImage forState:UIControlStateNormal];
    
    UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
    UIImage *SixImage = [UIImage imageNamed:@"Four@2x"];
    SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [SixButton setImage:SixImage forState:UIControlStateNormal];
    
 
    _iscustom = NO;
    
    CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [custombutton setImage:CustomImage forState:UIControlStateNormal];
    
    UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
    [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
    
    
    
    [DataHelp shareData].CustomeIsBool = NO;
    [self lipButtonAction:_lipButton];
    NSString *string = notice.userInfo[@"tag"];
    _MeetingViewTag = string.integerValue;
    
    UIView *view = (UIView *)[self.view viewWithTag:799];
    [view removeFromSuperview];
    [self BakeForRScreen];
    
}
//imageData的事件
- (void)ImageDataAction:(NSNotification*)notic
{
//    NSString *string = notic.userInfo[@"value"];
//    NSData *imagedata = [string dataUsingEncoding:NSUTF8StringEncoding];
//    UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:imagedata];
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
////    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    imageview.image = image;
//    imageview.backgroundColor = [UIColor redColor];
//    [_SenceSCroller addSubview:imageview];
}

//左滑的通知事件
- (void)RemoveView:(NSNotification*)center
{
    [self lipButtonAction:_lipButton];
}

    //接收手势点击View的tag值
- (void)SetValueAction:(NSNotification *)notic
{
    self.DecomeNumber = 0;
    UIView *view = (UIView *)[self.view viewWithTag:799];
    [view removeFromSuperview];
    //分屏改变移除数组元素
    [_ViewtagArray removeAllObjects];
    [_ViewRectArray removeAllObjects];
    [_TLinkTagArray removeAllObjects];
    [_RNameArray removeAllObjects];
    [_DesVidArray removeAllObjects];
    [_DeschArray removeAllObjects];
    
    [DataHelp shareData].CustomeIsBool = YES;
    UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
    UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
    UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
    UIImage *OneImage = [UIImage imageNamed:@"One@2x"];
    OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [OneButton setImage:OneImage forState:UIControlStateNormal];
    
    UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
    UIImage *FourImage = [UIImage imageNamed:@"Two@2x"];
    FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [fourButton setImage:FourImage forState:UIControlStateNormal];
    
    UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
    UIImage *NineImage = [UIImage imageNamed:@"Three@2x"];
    NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Ninebutton setImage:NineImage forState:UIControlStateNormal];
    
    UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
    UIImage *SixImage = [UIImage imageNamed:@"Four@2x"];
    SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [SixButton setImage:SixImage forState:UIControlStateNormal];
    
    
    _iscustom = NO;
    UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
    [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
    
    
    CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [custombutton setImage:CustomImage forState:UIControlStateNormal];
    NSString *string = notic.userInfo[@"value"];
    NSInteger count = string.integerValue;
    self.SenceBool = 0;
    self.SaveOrNo = 0;
    _NumberOfScreen = 1;
//    [DataHelp shareData].CustomeIsBool = YES;
    _SenceCount = count - 5999;
   
    
    if (_SaveUse == YES) {
        _SenceCount = _MeetingViewTag - 3000;
    }else
    {
         _MeetingViewTag = count - 2999;
    }
    _SaveUse = NO;
    
    [_backRScreen removeFromSuperview]; //移除自定义View的视图，添加选中的会场
    [self BakeForRScreen];
    
//    [CustomData SelectedMeeting:(int)_SenceCount];
}
//创建向左输出视图的按钮
- (void)CreatSlipButton
{
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(CGRectGetMaxX(_BackView.frame),65,Width4SuperView - CGRectGetMaxX(_BackView.frame),45);
    UIImage *image = [UIImage imageNamed:@"Left@x2"];
    _button.backgroundColor = WhiteColor;
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_button setImage:image forState:UIControlStateNormal];
//    _button.imageEdgeInsets = UIEdgeInsetsMake(20,20, 20, 30);
    _button.backgroundColor = TurnLeft;
//    _button.layer.borderColor = [UIColor blackColor].CGColor;
//    _button.layer.borderWidth = 0.5;
//    _button.layer.cornerRadius = 4;
//    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(slipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)slipButtonAction:(UIButton *)button
{
    UIView *view1 = [[UIView alloc]initWithFrame:self.view.bounds];
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.5;
    view1.hidden = YES;
    view1.tag = 1997;
    [self.view addSubview:view1];
    
    _lipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _lipButton.frame = CGRectMake(CGRectGetMaxX(_BackView.frame),64, Width4SuperView - CGRectGetMaxX(_BackView.frame),45);
    UIImage *lipimage = [UIImage imageNamed:@"向右"];
    _lipButton.layer.borderColor = [UIColor blackColor].CGColor;
    _lipButton.backgroundColor = TurnLeft;
    lipimage = [lipimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lipButton setImage:lipimage forState:UIControlStateNormal];
//    _lipButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 30);
    [_lipButton addTarget:self action:@selector(lipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lipButton];
    _button.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    UIImage *image = [UIImage imageNamed:@"向右"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_lipButton setImage:image forState:UIControlStateNormal];
    [_lipButton setFrame:CGRectMake(CGRectGetMaxX(_BackView.frame) - Width4SuperView * 0.2 - (Width4SuperView - CGRectGetMaxX(_BackView.frame)),64, Width4SuperView - CGRectGetMaxX(_BackView.frame), 45)];
    [UIView commitAnimations];
    UIView *view = (UIView *)[self.view viewWithTag:1997];
    view.hidden = NO;
    
    //将会场视图添加上来
    splitViewControl = [[SplitViewController alloc]init];
    splitViewControl.view.frame = CGRectMake(Width4SuperView,65, Width4SuperView*0.223, CGRectGetHeight(_table.frame) + 30);
    splitViewControl.view.layer.borderColor = [UIColor blackColor].CGColor;
    splitViewControl.view.layer.borderWidth = 0.7;
    splitViewControl.view.layer.cornerRadius = 3;
    splitViewControl.view.layer.masksToBounds = YES;
    [self addChildViewController:splitViewControl];
    [self.view addSubview:splitViewControl.view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [splitViewControl.view setFrame:CGRectMake(CGRectGetMaxX(_BackView.frame) - Width4SuperView * 0.2,64,  Width4SuperView*0.223, CGRectGetHeight(_table.frame) + 30)];
    [UIView commitAnimations];
        });
}

- (void)lipButtonAction:(UIButton *)button
{
      [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(ActionTimer:) userInfo:nil repeats:NO];
        UIView *view = (UIView *)[self.view viewWithTag:1997];
//    view.hidden = YES;
    [view removeFromSuperview];
    
    //将按钮移回最右边
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [button setFrame:CGRectMake(CGRectGetMaxX(_BackView.frame) ,64, Width4SuperView - CGRectGetMaxX(_BackView.frame),45)];
    [UIView commitAnimations];
    
    //将会场控制器移回
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [splitViewControl.view setFrame:CGRectMake(Width4SuperView - 10 ,64, Width4SuperView*0.223 , CGRectGetHeight(_table.frame) + 30)];
    [UIView commitAnimations];
}
    //动画结束移除视图
- (void)ActionTimer:(NSTimer *)timer
{
    [_lipButton removeFromSuperview];
    _button.hidden = NO;
    [splitViewControl removeFromParentViewController];
    [splitViewControl.view removeFromSuperview];
    [timer invalidate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.view.window == nil) {
        self.view = nil;
        
    }
}

//decome的通知事件
- (void)decomeAction:(NSNotification *)notice
{
    NSString *str = notice.userInfo[@"Decome"];
    UILabel *label = (UILabel *)[self.view viewWithTag:self.DecomeTag+100];
    label.text = str;
    UIView  *BacView = (UIView *)[self.view viewWithTag:self.DecomeTag];
    BacView.backgroundColor = [UIColor grayColor];
    
}

- (void)CreatNavigationAction
{
    UIButton *Switch = [UIButton buttonWithType:UIButtonTypeCustom];
    Switch.frame = CGRectMake(Width4SuperView * 0.94, 0, 70, 44);
    UIImage *Simage = [UIImage imageNamed:@"ToggleUser@x2"];
    Simage = [Simage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Switch setImage:Simage forState:UIControlStateNormal];
//    Switch.imageEdgeInsets = UIEdgeInsetsMake(0, 17, 20, Switch.titleLabel.bounds.size.width);
//    [Switch setTitle:Localized(@"退出") forState:UIControlStateNormal];
//    Switch.backgroundColor = [UIColor redColor];
    [Switch setTitleColor:WhiteColor forState:UIControlStateNormal];
    Switch.titleLabel.textAlignment = NSTextAlignmentCenter;
//    Switch.titleEdgeInsets = UIEdgeInsetsMake(20, -Switch.titleLabel.bounds.size.height - 20, 0, 0);
    [Switch addTarget:self action:@selector(SwitchMessage:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:Switch];
    
    /*
    UIButton *form = [UIButton buttonWithType:UIButtonTypeSystem];
    form.frame = CGRectMake(Width4SuperView * 0.92 - 80, 0, 70, 45);
    UIImage *formimage = [UIImage imageNamed:@"显示格式"];
    formimage = [formimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [form setImage:formimage forState:UIControlStateNormal];
    form.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, form.titleLabel.bounds.size.width);
    [form setTitle:@"显示格式" forState:UIControlStateNormal];
    [form setTitleColor:WhiteColor forState:UIControlStateNormal];
    form.titleLabel.textAlignment = NSTextAlignmentCenter;
    form.titleEdgeInsets = UIEdgeInsetsMake(20, -form.titleLabel.bounds.size.height - 20, 0, 0);
    [form addTarget:self action:@selector(FormBuutonAction:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:form];
    
    
    
    UIButton *lightControl = [UIButton buttonWithType:UIButtonTypeSystem];
    lightControl.frame = CGRectMake(Width4SuperView * 0.92 - 160, 0, 70, 45);
    UIImage *lightControlmimage = [UIImage imageNamed:@"灯光控制"];
    lightControlmimage = [lightControlmimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [lightControl setImage:lightControlmimage forState:UIControlStateNormal];
    lightControl.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, lightControl.titleLabel.bounds.size.width);
    [lightControl setTitle:@"灯光控制" forState:UIControlStateNormal];
    [lightControl setTitleColor:WhiteColor forState:UIControlStateNormal];
    lightControl.titleLabel.textAlignment = NSTextAlignmentCenter;
    lightControl.titleEdgeInsets = UIEdgeInsetsMake(20, -lightControl.titleLabel.bounds.size.height - 20, 0, 0);
    [lightControl addTarget:self action:@selector(LightButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:lightControl];
    
    
    UIButton *camera = [UIButton buttonWithType:UIButtonTypeSystem];
    camera.frame = CGRectMake(Width4SuperView * 0.92 - 240, 0, 70, 45);
    UIImage *cameraimage = [UIImage imageNamed:@"摄像头"];
    cameraimage = [cameraimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [camera setImage:cameraimage forState:UIControlStateNormal];
    camera.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, camera.titleLabel.bounds.size.width);
    [camera setTitle:@"摄像头" forState:UIControlStateNormal];
    [camera setTitleColor:WhiteColor forState:UIControlStateNormal];
    camera.titleLabel.textAlignment = NSTextAlignmentCenter;
    camera.titleEdgeInsets = UIEdgeInsetsMake(20, -camera.titleLabel.bounds.size.height - 20, 0, 0);
    [camera addTarget:self action:@selector(CameraButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:camera];
    
    
    
    UIButton *video = [UIButton buttonWithType:UIButtonTypeSystem];
    video.frame = CGRectMake(Width4SuperView * 0.92 - 320, 0, 70, 45);
    UIImage *videoimage = [UIImage imageNamed:@"视屏分发"];
    videoimage = [videoimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [video setImage:videoimage forState:UIControlStateNormal];
    video.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, video.titleLabel.bounds.size.width);
    [video setTitle:@"视屏分发" forState:UIControlStateNormal];
    [video setTitleColor:WhiteColor forState:UIControlStateNormal];
    video.titleLabel.textAlignment = NSTextAlignmentCenter;
    video.titleEdgeInsets = UIEdgeInsetsMake(20, -video.titleLabel.bounds.size.height - 20, 0, 0);
    [video addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:video];
    
    
    
    UIButton *volume = [UIButton buttonWithType:UIButtonTypeSystem];
    volume.frame = CGRectMake(Width4SuperView * 0.92 - 400, 0, 70, 45);
    UIImage *volumeimage = [UIImage imageNamed:@"音量控制"];
    volumeimage = [volumeimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [volume setImage:volumeimage forState:UIControlStateNormal];
    volume.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, volume.titleLabel.bounds.size.width);
    [volume setTitle:@"音量控制" forState:UIControlStateNormal];
    [volume setTitleColor:WhiteColor forState:UIControlStateNormal];
    volume.titleLabel.textAlignment = NSTextAlignmentCenter;
    volume.titleEdgeInsets = UIEdgeInsetsMake(20, -volume.titleLabel.bounds.size.height - 20, 0, 0);
    [volume addTarget:self action:@selector(volumeButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:volume];
    
    
    UIButton *type = [UIButton buttonWithType:UIButtonTypeSystem];
    type.frame = CGRectMake(Width4SuperView * 0.92 - 480, 0, 70, 45);
    UIImage *typeimage = [UIImage imageNamed:@"显示模式"];
    typeimage = [typeimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [type setImage:typeimage forState:UIControlStateNormal];
    type.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, type.titleLabel.bounds.size.width);
    [type setTitle:@"显示模式" forState:UIControlStateNormal];
    [type setTitleColor:WhiteColor forState:UIControlStateNormal];
    type.titleLabel.textAlignment = NSTextAlignmentCenter;
    type.titleEdgeInsets = UIEdgeInsetsMake(20, -type.titleLabel.bounds.size.height - 20, 0, 0);
    [type addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:type];
    */
    UIView *bacView = [[UIView alloc]init];
    bacView.frame = CGRectMake(0, 0,Width4SuperView *0.4, 44);
    bacView.backgroundColor = [UIColor clearColor];//colorWithRed:1.0 green:1.0 blue:210/255.0 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(17, 8, 150, 22);
    UIImage *image = [UIImage imageNamed:@"logo"];
    imageView.image = image;
    [bacView addSubview:imageView];
    
    UIImage *UserImage = [UIImage imageNamed:@"BorderUser"];
    UIImageView *UserView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Switch.frame)-2, 4, 2, 36)];
    UserView.image = UserImage;
    [self.navigationController.navigationBar addSubview:bacView];
    [bacView addSubview:UserView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(CGRectGetMinX(Switch.frame) - 60, 5, 60, 30);
    label.textColor = [UIColor colorWithRed:7/255.0 green:171/255.0 blue:229/255.0 alpha:1];
    label.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"];
    [bacView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bacView.mas_top).with.offset(0);
//        make.right.equalTo(Switch.mas_left).with.offset(- 80);
//        make.bottom.equalTo(bacView.mas_bottom).with.offset(-0);
//        make.width.mas_equalTo(60);
//    }];
}

- (void)SetMenu
{
    _MenuView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _MenuView.userInteractionEnabled = YES;
    _MenuView.backgroundColor = ScrollerColor;
//    view.backgroundColor = [UIColor orangeColor];
    UIImage *image = [UIImage imageNamed:@"TitleForBottom"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _MenuView.image = image;
    [self.view addSubview:_MenuView];
    [_MenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_table.mas_bottom).with.offset(32);
        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.bottom.equalTo(_SenceSCroller.mas_top).offset(-2);
        make.width.mas_equalTo(Width4SuperView - 4);
        make.height.mas_equalTo(41);
//      make.right.equalTo(self.view.mas_left).with.offset(-4);
    }];
    

    if (_IsEngish == YES) {
        
        _lightControl = [UIButton buttonWithType:UIButtonTypeSystem];
        _lightControl.tag = 1199;
        _lightControl.frame = CGRectMake(Width4SuperView * 0.92 - 160, 0, 70, Height4SuperView * 0.05);
        UIImage *lightControlmimage = [UIImage imageNamed:@"EngLight"];
        lightControlmimage = [lightControlmimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_lightControl setImage:lightControlmimage forState:UIControlStateNormal];
        //    _lightControl.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 10, _lightControl.titleLabel.bounds.size.width + 20);
        //    [_lightControl setTitle:Localized(@"灯光控制") forState:UIControlStateNormal];
        [_lightControl setTitleColor:WhiteColor forState:UIControlStateNormal];
        _lightControl.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _lightControl.titleEdgeInsets = UIEdgeInsetsMake(15, _lightControl.titleLabel.bounds.size.height - 20, 0, 0);
        [_lightControl addTarget:self action:@selector(LightButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:_lightControl];
        [_lightControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.left.equalTo(_MenuView.mas_left).with.offset(181 *3 - 67.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
        }];
        
        _video = [UIButton buttonWithType:UIButtonTypeSystem];
        _video.tag = 1198;
        _video.frame = CGRectMake(Width4SuperView * 0.92 - 320, 0, 70, 45);
        UIImage *videoimage = [UIImage imageNamed:@"EngDistribute"];
        videoimage = [videoimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_video setImage:videoimage forState:UIControlStateNormal];
        //     _video.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, _video.titleLabel.bounds.size.width);
        //     [_video setTitle:Localized(@"视屏分发") forState:UIControlStateNormal];
        [_video setTitleColor:WhiteColor forState:UIControlStateNormal];
        _video.titleLabel.textAlignment = NSTextAlignmentCenter;
        //     _video.titleEdgeInsets = UIEdgeInsetsMake(20, _video.titleLabel.bounds.size.height - 20, 0, 0);
        [_video addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:_video];
        [_video mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.right.equalTo(_lightControl.mas_left).with.offset(22.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
        }];
        
        
        UIButton *type = [UIButton buttonWithType:UIButtonTypeSystem];
        type.frame = CGRectMake(Width4SuperView * 0.92 - 480, 0, 70, Height4SuperView * 0.05);
        UIImage *typeimage = [UIImage imageNamed:@"EngShow"];
        type.tag = 1197;
        //    type.backgroundColor = [UIColor orangeColor];
        typeimage = [typeimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [type setImage:typeimage forState:UIControlStateNormal];
        //    type.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 13, type.titleLabel.bounds.size.width + 20);
        //    [type setTitle:Localized(@"显示模式") forState:UIControlStateNormal];
        [type setTitleColor:WhiteColor forState:UIControlStateNormal];
        type.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    type.titleEdgeInsets = UIEdgeInsetsMake(15,type.titleLabel.bounds.size.height - 20, 0, 0);
//        [type addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.right.equalTo(_video.mas_left).with.offset(22.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
        }];
        
        
        UIView *Bottomback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        Bottomback.backgroundColor = [UIColor grayColor];
        //    [view addSubview:Bottomback];
        //    [Bottomback mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(view.mas_bottom).with.offset(-1);
        //        make.left.equalTo(view.mas_left).with.offset(Height4SuperView * 0.015/cos(M_PI/12));
        //        make.width.mas_equalTo(130 * 4);
        //        make.height.mas_equalTo(1);
        //    }];
        _SenceControl = [UIButton buttonWithType:UIButtonTypeSystem];
        _SenceControl.frame = CGRectMake(10, 0, 130, 45);
        _SenceControl.tag = 1196;
        //    _SenceControl.backgroundColor = [UIColor orangeColor];
        UIImage *SenceControllmimage = [UIImage imageNamed:@"SeleEngSence"];
        SenceControllmimage = [SenceControllmimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_SenceControl setImage:SenceControllmimage forState:UIControlStateNormal];
        //    _SenceControl.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 10,_SenceControl.titleLabel.bounds.size.width + 20);
        //    [_SenceControl setTitle:Localized(@"场景列表") forState:UIControlStateNormal];
        [_SenceControl setTitleColor:WhiteColor forState:UIControlStateNormal];
        _SenceControl.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _SenceControl.titleEdgeInsets = UIEdgeInsetsMake(15, _SenceControl.titleLabel.bounds.size.height - 20, 0, 0);
        [_SenceControl setTitleColor:SenceSleleColor forState:UIControlStateNormal];
        [_SenceControl addTarget:self action:@selector(SenceControlAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:_SenceControl];
        [_SenceControl mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.right.equalTo(type.mas_left).with.offset(22.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
            make.height.mas_equalTo(41);
        }];
        
    }else
    {
        _lightControl = [UIButton buttonWithType:UIButtonTypeSystem];
        _lightControl.tag = 1199;
        _lightControl.frame = CGRectMake(Width4SuperView * 0.92 - 160, 0, 70, Height4SuperView * 0.05);
        UIImage *lightControlmimage = [UIImage imageNamed:@"Light@2x"];
        lightControlmimage = [lightControlmimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_lightControl setImage:lightControlmimage forState:UIControlStateNormal];
        //    _lightControl.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 10, _lightControl.titleLabel.bounds.size.width + 20);
        //    [_lightControl setTitle:Localized(@"灯光控制") forState:UIControlStateNormal];
        [_lightControl setTitleColor:WhiteColor forState:UIControlStateNormal];
        _lightControl.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _lightControl.titleEdgeInsets = UIEdgeInsetsMake(15, _lightControl.titleLabel.bounds.size.height - 20, 0, 0);
        [_lightControl addTarget:self action:@selector(LightButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:_lightControl];
        [_lightControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.left.equalTo(_MenuView.mas_left).with.offset(181 *3 - 67.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
        }];
        
        _video = [UIButton buttonWithType:UIButtonTypeSystem];
        _video.tag = 1198;
        _video.frame = CGRectMake(Width4SuperView * 0.92 - 320, 0, 70, 45);
        UIImage *videoimage = [UIImage imageNamed:@"distribute@2x"];
        videoimage = [videoimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_video setImage:videoimage forState:UIControlStateNormal];
        //     _video.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 20, _video.titleLabel.bounds.size.width);
        //     [_video setTitle:Localized(@"视屏分发") forState:UIControlStateNormal];
        [_video setTitleColor:WhiteColor forState:UIControlStateNormal];
        _video.titleLabel.textAlignment = NSTextAlignmentCenter;
        //     _video.titleEdgeInsets = UIEdgeInsetsMake(20, _video.titleLabel.bounds.size.height - 20, 0, 0);
        [_video addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:_video];
        [_video mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.right.equalTo(_lightControl.mas_left).with.offset(22.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
        }];
        
        
        UIButton *type = [UIButton buttonWithType:UIButtonTypeSystem];
        type.frame = CGRectMake(Width4SuperView * 0.92 - 480, 0, 70, Height4SuperView * 0.05);
        UIImage *typeimage = [UIImage imageNamed:@"Show@2x"];
        type.tag = 1197;
        //    type.backgroundColor = [UIColor orangeColor];
        typeimage = [typeimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [type setImage:typeimage forState:UIControlStateNormal];
        //    type.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 13, type.titleLabel.bounds.size.width + 20);
        //    [type setTitle:Localized(@"显示模式") forState:UIControlStateNormal];
        [type setTitleColor:WhiteColor forState:UIControlStateNormal];
        type.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    type.titleEdgeInsets = UIEdgeInsetsMake(15,type.titleLabel.bounds.size.height - 20, 0, 0);
//        [type addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.right.equalTo(_video.mas_left).with.offset(22.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
        }];
        
        
        UIView *Bottomback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        Bottomback.backgroundColor = [UIColor grayColor];
        //    [view addSubview:Bottomback];
        //    [Bottomback mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(view.mas_bottom).with.offset(-1);
        //        make.left.equalTo(view.mas_left).with.offset(Height4SuperView * 0.015/cos(M_PI/12));
        //        make.width.mas_equalTo(130 * 4);
        //        make.height.mas_equalTo(1);
        //    }];
        _SenceControl = [UIButton buttonWithType:UIButtonTypeSystem];
        _SenceControl.frame = CGRectMake(10, 0, 130, 45);
        _SenceControl.tag = 1196;
        //    _SenceControl.backgroundColor = [UIColor orangeColor];
        UIImage *SenceControllmimage = [UIImage imageNamed:@"SeleSence@2x"];
        SenceControllmimage = [SenceControllmimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_SenceControl setImage:SenceControllmimage forState:UIControlStateNormal];
        //    _SenceControl.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 10,_SenceControl.titleLabel.bounds.size.width + 20);
        //    [_SenceControl setTitle:Localized(@"场景列表") forState:UIControlStateNormal];
        [_SenceControl setTitleColor:WhiteColor forState:UIControlStateNormal];
        _SenceControl.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    _SenceControl.titleEdgeInsets = UIEdgeInsetsMake(15, _SenceControl.titleLabel.bounds.size.height - 20, 0, 0);
        [_SenceControl setTitleColor:SenceSleleColor forState:UIControlStateNormal];
        [_SenceControl addTarget:self action:@selector(SenceControlAction:) forControlEvents:UIControlEventTouchDown];
        [_MenuView addSubview:_SenceControl];
        [_SenceControl mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_MenuView.mas_top).with.offset(0);
            make.right.equalTo(type.mas_left).with.offset(22.5);
            make.bottom.equalTo(_MenuView.mas_bottom).offset(-0);
            make.width.mas_equalTo(181);
            make.height.mas_equalTo(41);
        }];

    }

//    NSLog(@"%f",CGRectGetHeight(view.frame));
//    for (int i = 0; i < 5; i++) {
//        UIView *transView = [[UIView alloc]init];
//        transView.frame = CGRectMake(10 + (130 * i), 0, 1,Height4SuperView * 0.014/sin(M_PI/12));
//        transView.backgroundColor = [UIColor grayColor];
//        transView.transform = CGAffineTransformMakeRotation(-M_PI/12);
//        [view addSubview:transView];
//    }

}

- (void)CreatSearch
{
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 65,  Width4SuperView*0.15, 45)];
    _search.searchBarStyle = UISearchBarStyleMinimal;//设置样式
    _search.backgroundColor = searchColor;
//    [_search setTintColor:[UIColor blackColor]];//设置边框颜色
    [_search setPlaceholder:@"Search"]; //检索框的占位符
    [_search setTranslucent:NO]; //设置是否透明
    _search.tag = 19997;
//    UITextField *searchField = [_search valueForKey:@"_searchField"];
//    searchField.textColor = WhiteColor;
    // Change search bar text color
//    _search.showsCancelButton = YES;
    [_search setSearchResultsButtonSelected:NO]; //设置搜索结果按钮是否选中
    _search.delegate = self; //代理事件
    [self.view addSubview:_search];
}

#pragma mark ===search的代理事件
//编辑改变的时候执行的方法(实时搜索)
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{

    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_MutSelsct removeAllObjects];
    _MutSelsct = [NSMutableArray array];
    [SeleDataManager CreatTable];
    [SeleDataManager SelectTemp:UserNameString Value:searchText];
    if (_MutSelsct.count != 0) {
        for (int i = 0; i < [DataHelp shareData].SelectArray.count; i++) {
            NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",UserNameString,[DataHelp shareData].srcchanidArray[i]]];
            if (string != nil) {
                [SeleDataManager DeleteWithTemp:UserNameString Value:[DataHelp shareData].TAllArray[i]];
                [SeleDataManager InsertIntoTemp:UserNameString Value:string];
                [[DataHelp shareData].SelectArray replaceObjectAtIndex:i withObject:string];
            }
        }
    
    }else
    {
        for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
            NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",UserNameString,[DataHelp shareData].srcchanidArray[i]]];
            if (string != nil) {
                [SeleDataManager DeleteWithTemp:UserNameString Value:[DataHelp shareData].TAllArray[i]];
                [SeleDataManager InsertIntoTemp:UserNameString Value:string];
                [[DataHelp shareData].MutTXArray replaceObjectAtIndex:i withObject:string];
            }
        }
    }
    
    _MutSelsct = [[DataHelp shareData].SelectArray mutableCopy];
    [_table reloadData];
    
//    [_search endEditing:YES];
  
}

//键盘中的search按下时执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *string = searchBar.text;
    NSInteger integer = string.integerValue;
    [_table setContentOffset:CGPointMake(0, ((Height4SuperView * 0.65)/4 ) * integer - 60) animated:YES];
}
    //创建tableView
- (void)CreatTableViewOfViewoView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _table = [[UICollectionView alloc]initWithFrame:CGRectMake(0,65, Width4SuperView*0.15,Height4SuperView * 0.66)  collectionViewLayout:flowLayout];
    _table.backgroundColor = TabbleColor;
    _table.delegate = self;
    _table.bounces = YES;
    _table.alwaysBounceVertical = YES;
    flowLayout.itemSize = CGSizeMake(_table.frame.size.width/2 - 3, 90);
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(47, 2, 2, 2);
    _table.dataSource = self;
    [_table registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:_table];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_MutSelsct.count != 0) {
    
        return _MutSelsct.count;
    }else
    {
        return [DataHelp shareData].TAllArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = CellRGB;
    
    
    if (_MutSelsct.count != 0) {
        
        cell.ItemLabel.text = _MutSelsct[indexPath.row];
        
    }else
    {
        cell.ItemLabel.text = [DataHelp shareData].TAllArray[indexPath.row];
    }
    
    NSData *ImageDaraArray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@CellImageData",UserNameString]];
    NSMutableArray *mutAtrray = [NSKeyedUnarchiver unarchiveObjectWithData:ImageDaraArray];
    if (indexPath.row < mutAtrray.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.ItemImageView.image = mutAtrray[indexPath.row];
                cell.ItemImageView.userInteractionEnabled = YES;
            });
        });
    }

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(MovieViewPan:)];
    pan.maximumNumberOfTouches = 1;
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressAction:)];
    LongPress.minimumPressDuration = 2;
    [cell addGestureRecognizer:LongPress];
    cell.tag = 1000 + indexPath.item;
    [cell addGestureRecognizer:pan];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _SetCamerButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _SetCamerButton.frame = CGRectMake(cell.frame.size.width - 25, 0, 25, 25);
//        _SetCamerButton.tag = 3999 + indexPath.item;
//        [_SetCamerButton setBackgroundImage:[UIImage imageNamed:@"CameraSetIcon"] forState:UIControlStateNormal];
        [_SetCamerButton addTarget:self action:@selector(SetCamerButton:) forControlEvents:UIControlEventTouchDown];
//        [cell.contentView addSubview:_SetCamerButton];
//    });
//    });
    
    return cell;
}

- (void)SetCamerButton:(UIButton *)button
{
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSame == indexPath.row) {
        _CellCount++;
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(Cancer:) userInfo:nil repeats:NO];
       
    }else
    {
        _isSame = indexPath.row;
    }
    if (_CellCount == 2) {
        [DataHelp shareData].isViedeo = NO;
        [DataHelp shareData].isTdecore = YES;
        [DataHelp shareData].TapTagNumber = 1000 + indexPath.item;
        [DataHelp shareData].TCamerIndex = indexPath.row;
        [DataHelp shareData].camerIndexName = [DataHelp shareData].TAllArray[indexPath.row];
        [DataHelp shareData].ipString = [NSString stringWithFormat:@"%@",[DataHelp shareData].TIPArray[indexPath.row]];
        UIView *bac = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        bac.backgroundColor = [UIColor clearColor];
        bac.alpha = 0.1;
        bac.tag = 550505;
        [self.view addSubview:bac];
        _CamearView = [CamerViewController new];
        _CamearView.TIndex = indexPath.item;
        _CamearView.view.frame = CGRectMake(Width4SuperView * 0.3,Height4SuperView * 0.16, 580, 410);
//        _CamearView.view.center = self.view.center;
        [self addChildViewController:_CamearView];
        [self.view addSubview:_CamearView.view];
        _CellIndex = indexPath.item;
        [DataHelp shareData].Tcamer = indexPath.item;
        _CellCount = 0;
    }
    
}

- (void)Cancer:(NSTimer *)timer
{
    _CellCount = 0;
    [timer invalidate];
}

- (void)actionSheet
{
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Localized(@"取消") destructiveButtonTitle:nil otherButtonTitles:Localized(@"打开相机"),Localized(@"从手机相册获取"),Localized(@"取消"),nil];
        actionSheet.backgroundColor = ScrollerColor;
        [actionSheet showInView:_CamearView.view];
        
//        UIView *Aview = [[UIView alloc]initWithFrame:CGRectMake(actionSheet.frame.origin.x, actionSheet.frame.origin.y, actionSheet.frame.size.width, actionSheet.frame.size.height)];
//        Aview.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:40/255.0 alpha:1];
//        [actionSheet insertSubview:Aview atIndex:0];
//        [actionSheet insertSubview:Aview atIndex:1];
 
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        switch (buttonIndex) {
        case 0:
                [_BacView removeFromSuperview];
                [self performSelector:@selector(takePhoto) withObject:nil afterDelay:0.3];
            break;
            case 1:
                
                 [_BacView removeFromSuperview];
                [DataHelp shareData].isLeft = 1;
                
                [self performSelector:@selector(LocaPhoto) withObject:nil afterDelay:0.3];
            break;
                
            case 2:
                 [_BacView removeFromSuperview];
        default:
            break;
    }
}


- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
//        BaseViewController *bace = [BaseViewController new];
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
      
    }
}

- (void)LocaPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
//    BaseViewController *bace = [BaseViewController new];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
     [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self compressImage:image toTargetWidth:0.5];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 0.5);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
            //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
        //关闭相册界面
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
////        
        NSData *ImageDaraArray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@CellImageData",UserNameString]];
        NSMutableArray *mutAtrray = [NSKeyedUnarchiver unarchiveObjectWithData:ImageDaraArray];
        for (int i = 0; i < mutAtrray.count; i++) {
            [_CellMutArray replaceObjectAtIndex:i withObject:mutAtrray[i]];
        }
       dispatch_async(dispatch_get_main_queue(), ^{
           [_CellMutArray replaceObjectAtIndex:_CellIndex withObject:image];
           NSData *IMageData;
           IMageData = [NSKeyedArchiver archivedDataWithRootObject:_CellMutArray];
           [[NSUserDefaults standardUserDefaults]setObject:IMageData forKey:[NSString stringWithFormat:@"%@CellImageData",UserNameString]];
           [_table reloadData];
       });
    }
}

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetHeight = (targetWidth /width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage *NewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return NewImage;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)addViewControllerToparentViewController:(UIViewController *)parentViewController
{

    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = [self.view viewWithTag:3999+indexPath.row];
    [button removeFromSuperview];
}


- (void)removeViewControllerFromParentViewController
{
    [_SetCamerButton removeFromSuperview];
    [_Cellview removeFromSuperview];

}

- (void)LongPressAction:(UILongPressGestureRecognizer *)Long
{
    
}

- (void)TimerRunLoop:(NSTimer *)timer
{
    [_TestView addSubview:GlView];
    [timer invalidate];

}

- (void)keyboardWahiden:(id)key
{
     _CamearView.view.frame = CGRectMake(Width4SuperView * 0.3,Height4SuperView * 0.16, 580, 410);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _CamearView.view.frame = CGRectMake(Width4SuperView * 0.3,Height4SuperView * 0.16, 580, 410);
    [_search resignFirstResponder];
    
}

#pragma mark===拖动出图=====
#pragma mark==warning ===pan.view.tag - 1000为T的值
- (void)MovieViewPan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (_Isend == NO) {
            _Isend = YES;
        self.PanviewTag ++;
        _VIew = (UIView *)[self.view viewWithTag:pan.view.tag];
            
        NSString *path = [DataHelp shareData].TAllArray[pan.view.tag - 1000];
        self.Tinte = pan.view.tag - 1000;
        NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
        if ([path.pathExtension isEqualToString:@"wmv"])
            parameters[KxMovieParameterMinBufferedDuration] = @(20.0);
        
        // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
            //创建视图
//        _move = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters]; //initWithContentPath:path parameters:parameters];
            if (_MutSelsct.count != 0) {
                NSNumber *number = _MutSelsct[_Tinte];
                NSString *ValueString = [NSString stringWithFormat:@"%@",number];
                for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
                    NSNumber *number = [DataHelp shareData].TAllArray[i];
                    NSString *TallString = [NSString stringWithFormat:@"%@",number];
                    if ([ValueString isEqualToString:TallString]) {
                        _Tinte = i;
                    }
                }
            }
            
        
        _panview = [[UIImageView alloc]init];
//        _move.view.tag = 10000+self.PanviewTag;
            _panview.userInteractionEnabled = YES;
            NSData *ImageDaraArray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@CellImageData",UserNameString]];
            NSMutableArray *mutAtrray = [NSKeyedUnarchiver unarchiveObjectWithData:ImageDaraArray];
        _panview.tag = 10000 + self.PanviewTag;
        //将新创建的视图Tag添加到数组中去
        NSNumber *number = [NSNumber numberWithInteger:_panview.tag];
        [_MoveViewArray addObject:number];
        
            if (_Tinte < mutAtrray.count) {
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutAtrray[_Tinte]) {
                        _panview.image = mutAtrray[_Tinte];
                        _panview.userInteractionEnabled = YES;
                    }else
                    {
                        _panview.userInteractionEnabled = YES;
                        
                    }
                });
                
            }
        // 获取点击的视图相对于window的位置
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[_VIew convertRect: _VIew.bounds toView:window];
//            _panview.frame = rect;
        _panview.frame = CGRectMake(rect.origin.x, rect.origin.y, Width4SuperView*0.15-2* 2,130);
            //给创建的视图添加平移手势
        UIPanGestureRecognizer *panView = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [_panview addGestureRecognizer:panView];
        _panview.backgroundColor = BacViewRGB;
        [self.view addSubview:_panview];
        UILabel *label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor colorWithRed:215/255.0 green:236/255.0 blue:241/255.0 alpha:1];
        label.frame = CGRectMake(0, 5, _panview.frame.size.width ,_panview.frame.size.height/4);
        label.textAlignment = NSTextAlignmentCenter;
     
            
            
        label.text = [DataHelp shareData].TAllArray[self.Tinte];
        label.tag = 7000 + self.PanviewTag;
        [_LinkArray addObject:[NSString stringWithFormat:@"%ld",(long)label.tag]];
        [self.panview addSubview:label];
        UILabel *Linklabel = [[UILabel alloc]init];
        Linklabel.text = Localized(@"连接");
        Linklabel.textAlignment = NSTextAlignmentCenter;
        Linklabel.frame = CGRectMake(0,CGRectGetMaxY(label.frame)+5, _panview.frame.size.width,_panview.frame.size.height/4);
        [self.panview addSubview:Linklabel];
        
        _RtextString = [[UILabel alloc]init];
        _RtextString.frame = CGRectMake(0, CGRectGetMaxY(Linklabel.frame) +5, _panview.frame.size.width,_panview.frame.size.height/4);
//        _RtextString.backgroundColor = [UIColor colorWithRed:212/255.0 green:242/255.0 blue:232/255.0 alpha:1];
        _RtextString.textAlignment = NSTextAlignmentCenter;
        _RtextString.tag = 11000 + self.PanviewTag;
        [self.panview addSubview:_RtextString];
    
        }
    }else if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (_Isend == YES) {
  
        UIView *Loca = (UIView *)[self.view viewWithTag:_panview.tag];
        CGPoint p1 = [pan translationInView:Loca];
        Loca.transform  = CGAffineTransformTranslate(Loca.transform,p1.x,p1.y);
         index = 0;
        self.CurrentWith = Loca.frame.origin.x;
        self.CurrentHeight = Loca.frame.origin.y;

        [pan setTranslation:CGPointZero inView:Loca];

        self.XPanView = Loca.frame.origin.x - Width4SuperView*0.15 - 4; //- Width4SuperView*0.83-7 - 4;
        self.YPanView = Loca.frame.origin.y - 45 - 60;
        }
        
        }else if (pan.state == UIGestureRecognizerStateEnded)
    {
 
        
        if (_isDesture == YES && _panview.frame.origin.y > _SenceSCroller.frame.origin.y &&  _panview.frame.origin.x + _panview.frame.size.width < Width4SuperView*0.15 + 50 && [DataHelp shareData].SenceDistureArray.count != 0) {
          
            [_LinkArray removeLastObject];
            for (int i = 0; i < [DataHelp shareData].SenceDistureArray.count; i++) {
             
               
                NSNumber *Number = [DataHelp shareData].SenceDistureArray[i];
                NSInteger indexnu = Number.integerValue;
                if (indexnu < _LinkArray.count) {
                    NSString *string = _LinkArray[indexnu];
                    UILabel *label = (UILabel *)[self.view viewWithTag:string.integerValue];
                    label.text = [DataHelp shareData].TAllArray[_Tinte];
                }
//                NSLog(@"%ld",(long)indexnu);
                NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[indexnu];
                NSString *String = [NSString stringWithFormat:@"%@",destch];
                
                NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[indexnu];
                NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                
                NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                NSUUID *uuid = [NSUUID UUID];
                NSString *uuidString = uuid.UUIDString;
                UIButton *senButton = [self.view viewWithTag:7999 + indexnu];
                UIImage *buImage = [UIImage imageNamed:@"link"];
                buImage = [buImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [senButton setImage:buImage forState:UIControlStateNormal];
                NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                         @"destchanid":destdevString,
                                                                                                         @"destdevid":String,
                                                                                                         @"id":uuidString,
                                                                                                         @"srcchanid":srcchanString,
                                                                                                         @"srcdevid":srcdevString}]}};
                NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
            }
            UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
            [view removeFromSuperview];
            self.PanviewTag = self.PanviewTag - 1;
            _Isend = NO;
            UILabel *label = (UILabel *)[self.view viewWithTag:9797];
            label.text = [DataHelp shareData].TAllArray[_Tinte];
            UIView *Baview = (UIView *)[self.view viewWithTag:1919];
            Baview.backgroundColor = BacViewRGB;
        }else if (_Isend == YES) {
            _Isend = NO;
        NSInteger inter  = 0;
        _IsPan = YES;
            //判断当前分屏类型
        if (self.TagNumber == 0) {
            switch (self.NumberOfScreen) {
                case 1:
                    inter = 100;
                    break;
                case 2:
                    inter = 102;
                    break;
                case 3:
                    inter = 106;
                    break;
                case 4:
                    inter = 120;
                    break;
                default:
                    break;
            }
            UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
            view.backgroundColor = BacViewRGB;
            int currentViewXCount = fabs(self.XPanView /((ScreenWith)/30 - 4 * (self.XPanView/(ScreenWith )/30)));
            int currentViewYCount = fabs(self.YPanView / ((ScreenHeight) / 20 - 4*(self.YPanView/(ScreenHeight -8)/20)));
            
            CGFloat currentX = fabs(self.XPanView / ((ScreenWith)/30 - 4 * (self.XPanView/(ScreenWith )/30)));
            CGFloat currentY = fabs(self.YPanView / ((ScreenHeight) / 20 - 4 *(self.YPanView/(ScreenHeight)/20)));
            
            currentViewXCount = abs(currentViewXCount);
            currentX = fabs(currentX);

            if ([DataHelp shareData].CustomeIsBool == YES) {
                //当进行了自定视图并应用拖动结束后将要在这执行事件
                NSInteger DataInteger = 0;
                if (self.SaveOrNo == 1) {
                     DataInteger = _MeetingViewTag - 3000;
             
                }else
                {
                    DataInteger = _SenceCount;
                }
               
                NSArray *Xarra = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@XCountArray%@",UserNameString,[DataHelp  shareData].LocationArray[DataInteger][@"name"]]];
                NSArray *Yarray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@YcountArray%@",UserNameString,[DataHelp shareData].LocationArray[DataInteger][@"name"]]];
                NSMutableArray *Origionmut = [NSMutableArray array];
                for (int i = 0; i < _ReRectArr.count; i++) {
                    NSNumber *number = _RectArray[i];
                    NSString *string = [NSString stringWithFormat:@"%@",number];
                    CGRect ReCgrect = CGRectFromString(string);
                    NSInteger inteWith = ReCgrect.origin.x;
                    [Origionmut addObject:[NSNumber numberWithInteger:inteWith]];
            
                }
                
                for (int i = 0; i < Origionmut.count - 1; i++) {
                    for (int j = 0; j < Origionmut.count - 1 - i; j++) {
                        if (Origionmut[j] > Origionmut[j+1]) {
                            NSNumber *number = Origionmut[j];
                            Origionmut[j] = Origionmut[j + 1];
                            Origionmut[j + 1] = number;
                            
                        }
                    }
                }
                
                NSString *VaStr = [NSString stringWithFormat:@"%@",Origionmut[0]];
                if ((view.frame.size.width + view.frame.origin.x) - Width4SuperView * 0.15 > VaStr.integerValue) {
                if (currentX - currentViewXCount >= 0.5 && currentY - currentViewYCount >= 0.5) {
                    int Xinte = currentViewXCount + 1;
                    NSInteger Yinte = currentViewYCount + 1;
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        }
                    }
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
                        }
                    }
            
                    view.frame = CGRectMake(_table.frame.size.width + 7  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  , CGRectGetMaxY(_BackView.frame) + 6+_Blueview.frame.size.height * YArraValue + 4 *YArraValue , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                   
//                    NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@RectValueInert%ld",UserNameString,(long)DataInteger]];
            
//                    BOOL contains = CGRectIntersectsRect(pan.view.frame, view.frame);
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,CGRectGetMaxY(_BackView.frame) + 2+_Blueview.frame.size.height * YArraValue + 4 *YArraValue - CGRectGetMaxY(_BackView.frame) , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
                    NSLog(@"1");
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    NSString *string = NSStringFromCGRect(Inrect);
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    NSInteger numberIndex = 119;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                            
                        }else
                        {
                       
                        }
                    }
                    
                    if (numberIndex == 119) {
                        UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                        [view removeFromSuperview];
                        [_LinkArray removeLastObject];
                        self.PanviewTag = self.PanviewTag - 1;
                        
                    }else{
                    
                    NSInteger DataInteger = 0;
                    if (self.SaveOrNo == 1) {
                        DataInteger = _MeetingViewTag - 2999;
                        
                    }else
                    {
                        DataInteger = _SenceCount;
                        DataInteger = _SenceCount ;
                    }
                        
                    [DataHelp shareData].CreatRView = NO;
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[DataInteger][@"name"]] CustomRct:string];
//                        if (_MutSelsct != nil) {
//                            NSNumber *number = _MutSelsct[_Tinte];
//                            NSString *ValueString = [NSString stringWithFormat:@"%@",number];
//                            for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
//                                NSNumber *number = [DataHelp shareData].TAllArray[i];
//                                NSString *TallString = [NSString stringWithFormat:@"%@",number];
//                                if ([ValueString isEqualToString:TallString]) {
//                                    _Tinte = i;
//                                }
//                            }
//                        }
                        
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    NSString *destdevString = [DataHelp shareData].destchanid;
                    NSString *String = [DataHelp shareData].destdevid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
//                    [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":String,
                                                                                                             @"destdevid":destdevString,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                   
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    
                    
                    int Index = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *Valuestring =  [NSString stringWithFormat:@"%@",number];
                        if ([Valuestring isEqualToString:String]) {
                            Index = i;
                    }
                    
                }
                    
                    if (Index != 100) {
                        
                        NSNumber *number = _ViewtagArray[Index];
                        NSInteger TagInteger = number.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:TagInteger];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:Index withObject:string];
                        [_RNameArray replaceObjectAtIndex:Index withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:Index withObject:destdevString];
                        [_DeschArray replaceObjectAtIndex:Index withObject:String];
                  
                    }else
                    {
                        
                        [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray addObject:string];
                        [_RNameArray addObject:RName];
                        [_DesVidArray addObject:destdevString];
                        [_DeschArray addObject:String];
                    }
              
                    UITextField *textField = (UITextField *)[self.view viewWithTag:10000 + self.PanviewTag + 1000];
                    textField.text = RName;
  }
                    view.backgroundColor = BacViewRGB;
                }else if (currentX - currentViewXCount >= 0.5 && currentY - currentViewYCount <= 0.5)
                {
                    int Xinte = currentViewXCount + 1;
                    NSInteger Yinte = currentViewYCount;
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        }
                    }
                    
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            
                            YArraValue = integer;
                            YArraNumber = i;
                        }
                    }
                   
                    view.frame = CGRectMake(_table.frame.size.width +7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  , CGRectGetMaxY(_BackView.frame) + 6 +_Blueview.frame.size.height * YArraValue + 4 *YArraValue , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
        
                    view.backgroundColor = BacViewRGB;
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,CGRectGetMaxY(_BackView.frame) + 2+_Blueview.frame.size.height * YArraValue + 4 *YArraValue - CGRectGetMaxY(_BackView.frame), ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    NSLog(@"2");
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    
                    NSString *string = NSStringFromCGRect(Inrect);
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 119;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                            
                        }else
                        {
                         
                        }
                    }
                    
                    
                    if (numberIndex != 119) {
                    
                    NSInteger DataInteger = 0;
                    if (self.SaveOrNo == 1) {
                        DataInteger = _MeetingViewTag - 2999;
                        
                    }else
                    {
                        DataInteger = _SenceCount;
                        DataInteger = _SenceCount;
                    }
                    
                    [DataHelp shareData].CreatRView = NO;
                    [CustomData CreatSenceTable];
                    
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[DataInteger][@"name"]] CustomRct:string];
                        
                    
//                        if (_MutSelsct != nil) {
//                            NSNumber *number = _MutSelsct[_Tinte];
//                            NSString *ValueString = [NSString stringWithFormat:@"%@",number];
//                            for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
//                                NSNumber *number = [DataHelp shareData].TAllArray[i];
//                                NSString *TallString = [NSString stringWithFormat:@"%@",number];
//                                if ([ValueString isEqualToString:TallString]) {
//                                    _Tinte = i;
//                                }
//                            }
//                        }
                        
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
//                    [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UITextField *textField = (UITextField *)[self.view viewWithTag:10000 + self.PanviewTag + 1000];
                    textField.text = RName;
                    /****************/
                    int Index = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *Valuestring =  [NSString stringWithFormat:@"%@",number];
                        if ([Valuestring isEqualToString:destdevString]) {
                            Index = i;
                        }
                    }
                    
                    if (Index != 100) {
                        NSNumber *number = _ViewtagArray[Index];
                        NSInteger TagInteger = number.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:TagInteger];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:Index withObject:string];
                        [_RNameArray replaceObjectAtIndex:Index withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:Index withObject:String];
                        [_DeschArray replaceObjectAtIndex:Index withObject:destdevString];
                    }else
                    {
                        [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray addObject:string];
                        [_RNameArray addObject:RName];
                        [_DesVidArray addObject:String];
                        [_DeschArray addObject:destdevString];
                    }
                  
                    }else
                    {
                        UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                        [view removeFromSuperview];
                        [_LinkArray removeLastObject];
                        self.PanviewTag = self.PanviewTag - 1;

                    }
                    
                    /***************/
                    
                    
//                    [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
//                    [_TLinkTagArray addObject:[NSNumber numberWithInteger:pan.view.tag - 1000]];
//                    [_ViewRectArray addObject:string];
//                    [_RNameArray addObject:RName];
//                    [_DesVidArray addObject:destdevString];
//                    [_DeschArray addObject:String];
                    
                }else if (currentX - currentViewXCount <= 0.5 && currentY - currentViewYCount <= 0.5)
                {
                    int Xinte = currentViewXCount;
                    NSInteger Yinte = currentViewYCount;
     
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        }
                    }
                    
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
                        }
                    }
        
                  
                  view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue *4  , CGRectGetMaxY(_BackView.frame) + 6+_Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
                  
                   
                    view.backgroundColor = BacViewRGB;
                    
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,CGRectGetMaxY(_BackView.frame) + 2+_Blueview.frame.size.height * YArraValue + 4 *YArraValue - CGRectGetMaxY(_BackView.frame) , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    NSLog(@"3");
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    
                    NSString *string = NSStringFromCGRect(Inrect);
                    
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 119;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                            
                        }else
                        {
                            
                            
                        }
                    }
                    
                    
                    if (numberIndex != 119) {
                    
                    [DataHelp shareData].CreatRView = NO;
                    NSInteger DataInteger = 0;
                    if (self.SaveOrNo == 1) {
                        DataInteger = _MeetingViewTag - 2999;
                        
                    }else
                    {
                        DataInteger = _SenceCount;
                        DataInteger = _SenceCount;
                    }
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[DataInteger][@"name"]] CustomRct:string];
                   
                    NSInteger MaxIndex = XArraNumber > YArraNumber ? XArraNumber:YArraNumber;
                    NSInteger MinIndex = XArraNumber < YArraNumber ? XArraNumber:YArraNumber;
                    
                    if (MinIndex == 1 && MaxIndex - MinIndex <= 1 && MaxIndex != MinIndex) {
                        MinIndex = 0;
                    }
              
//                        if (_MutSelsct != nil) {
//                            NSNumber *number = _MutSelsct[_Tinte];
//                            NSString *ValueString = [NSString stringWithFormat:@"%@",number];
//                            for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
//                                NSNumber *number = [DataHelp shareData].TAllArray[i];
//                                NSString *TallString = [NSString stringWithFormat:@"%@",number];
//                                if ([ValueString isEqualToString:TallString]) {
//                                    _Tinte = i;
//                                }
//                            }
//                        }
                        
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
//                    [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UITextField *textField = (UITextField *)[self.view viewWithTag:10000 + self.PanviewTag + 1000];
                    textField.text = RName;//[DataHelp shareData].RNamearray[MinIndex];
//
                    
                    /****************/
                    
                    
                    int Index = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *Valuestring =  [NSString stringWithFormat:@"%@",number];
                        if ([Valuestring isEqualToString:destdevString]) {
                            Index = i;
                            
                        }
                    }
                    
                    if (Index != 100) {
                        
                        NSNumber *number = _ViewtagArray[Index];
                        NSInteger TagInteger = number.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:TagInteger];
                        [Review removeFromSuperview];
                        
                        
                        [_ViewtagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:Index withObject:string];
                        [_RNameArray replaceObjectAtIndex:Index withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:Index withObject:String];
                        [_DeschArray replaceObjectAtIndex:Index withObject:destdevString];
                        
                       
                        
                        
                    }else
                    {
                        
                        [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray addObject:string];
                        [_RNameArray addObject:RName];
                        [_DesVidArray addObject:String];
                        [_DeschArray addObject:destdevString];
                    }
                    }else
                    {
                        
                        UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                        [view removeFromSuperview];
                        [_LinkArray removeLastObject];
                        self.PanviewTag--;
                        
                    }
                    
                        /***************/
//                    [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
//                    [_TLinkTagArray addObject:[NSNumber numberWithInteger:pan.view.tag - 1000]];
//                    [_ViewRectArray addObject:string];
//                    [_RNameArray addObject:RName];
//                    [_DesVidArray addObject:destdevString];
//                    [_DeschArray addObject:String];
                    
                }else if (currentX - currentViewXCount <= 0.5 && currentY - currentViewYCount >= 0.5)
                {
                    int Xinte = currentViewXCount;
                    NSInteger Yinte = currentViewYCount + 1;
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        }
                    }
                    
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
                        }
                    }
                 
                    view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,CGRectGetMaxY(_BackView.frame) + 6 +_Blueview.frame.size.height * YArraValue + 4 * YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
//                    NSLog(@"%@",NSStringFromCGRect(view.frame));
                    view.backgroundColor = BacViewRGB;
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,CGRectGetMaxY(_BackView.frame) + 2+_Blueview.frame.size.height * YArraValue + 4 * YArraValue - CGRectGetMaxY(_BackView.frame) , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    NSLog(@"4");
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    
                    NSString *string = NSStringFromCGRect(Inrect);
                    
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 119;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                        }
                    }
                    
                    
                    if (numberIndex != 119) {
                    
                    [DataHelp shareData].CreatRView = NO;
                    
                    NSInteger DataInteger = 0;
                    if (self.SaveOrNo == 1) {
                        DataInteger = _MeetingViewTag - 2999;
                        
                    }else
                    {
                        DataInteger = _SenceCount;
                        DataInteger = _SenceCount;
                    }
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[DataInteger][@"name"]] CustomRct:string];
                    
                    NSInteger MaxIndex = XArraNumber >YArraNumber ? XArraNumber:YArraNumber;
                    NSInteger MinIndex = XArraNumber < YArraNumber ? XArraNumber:YArraNumber;
                    
                    if (MinIndex == 1 && MaxIndex - MinIndex <= 1 && MaxIndex != MinIndex) {
                        MinIndex = 0;
                    }

                        
//                        if (_MutSelsct != nil) {
//                            NSNumber *number = _MutSelsct[_Tinte];
//                            NSString *ValueString = [NSString stringWithFormat:@"%@",number];
//                            for (int i = 0; i < [DataHelp shareData].TAllArray.count; i++) {
//                                NSNumber *number = [DataHelp shareData].TAllArray[i];
//                                NSString *TallString = [NSString stringWithFormat:@"%@",number];
//                                if ([ValueString isEqualToString:TallString]) {
//                                    _Tinte = i;
//                                }
//                            }
//                        }
                        
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
//                    [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                  
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UITextField *textField = (UITextField *)[self.view viewWithTag:10000 + self.PanviewTag + 1000];
                    textField.text = RName;//[DataHelp shareData].RNamearray[MinIndex];
                  
                    
                    /****************/
                    
                    
                    int Index = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *Valuestring =  [NSString stringWithFormat:@"%@",number];
                        if ([Valuestring isEqualToString:destdevString]) {
                            Index = i;
                            
                        }
                    }
                    
                    if (Index != 100) {
                        
                        NSNumber *number = _ViewtagArray[Index];
                        NSInteger TagInteger = number.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:TagInteger];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:Index withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:Index withObject:string];
                        [_RNameArray replaceObjectAtIndex:Index withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:Index withObject:String];
                        [_DeschArray replaceObjectAtIndex:Index withObject:destdevString];
             
                    }else
                    {
                        
                        [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                        [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray addObject:string];
                        [_RNameArray addObject:RName];
                        [_DesVidArray addObject:String];
                        [_DeschArray addObject:destdevString];
                    }
                    
                    }else
                    {
                        UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                        [view removeFromSuperview];
                        [_LinkArray removeObject:[NSString stringWithFormat:@"%ld",(long)_panview.tag]];
                        self.PanviewTag = self.PanviewTag - 1;
                    }
                    
                /***************/
                    
//                    [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
//                    [_TLinkTagArray addObject:[NSNumber numberWithInteger:pan.view.tag - 1000]];
//                    [_ViewRectArray addObject:string];
//                    [_RNameArray addObject:RName];
//                    [_DesVidArray addObject:destdevString];
//                    [_DeschArray addObject:String];
                    
                }
               
                }else
                {
                    
                    UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                    [view removeFromSuperview];
                    [_LinkArray removeObject:[NSString stringWithFormat:@"%ld",(long)_panview.tag]];
                    self.PanviewTag = self.PanviewTag - 1;

                }
            }else
            {
                _SelectedView = (UIView *)[self.view viewWithTag:_panview.tag];
                _BackViewScroller = (UIView *)[self.view viewWithTag:inter];
//                _BackViewScroller.backgroundColor = [UIColor redColor];
                CGFloat BackWith = _BackViewScroller.frame.size.width;
                CGFloat BackHeight = _BackViewScroller.frame.size.height;
                
                NSInteger Xinteger = fabs((self.CurrentWith - self.view.frame.size.width * 0.15 - view.frame.size.width/2)/BackWith);
                NSInteger Yinteger = fabs((self.CurrentHeight - 45 - 60 - view.frame.size.height/2)/BackHeight);
                
                CGFloat Xfloat = Xinteger + 0.5;
                CGFloat Yfloat = Yinteger + 0.5;
                
                CGFloat XpanCurrentIndext = fabs((self.CurrentWith - self.view.frame.size.width * 0.15 - view.frame.size.width/2)/BackWith);
                CGFloat YpanCurrentIndext = fabs((self.CurrentHeight - 45 - 60 - view.frame.size.height/2)/BackHeight);
                
                if (_NumberOfScreen == 1 && (XpanCurrentIndext > 0.5 || YpanCurrentIndext > 0.5)) {
                     [view removeFromSuperview];
                    [_LinkArray removeLastObject];
                }else
                {
#pragma mark ===panView=====
                    
            if ((self.CurrentWith + view.frame.size.width/2) <= Width4SuperView*0.15 ||  (self.CurrentHeight  + view.frame.size.width / 2)  >= Width4SuperView * 0.83 || self.CurrentHeight <=  20 || self.CurrentHeight  +  view.frame.size.height/2 >= Height4SuperView*0.71 || XpanCurrentIndext > _NumberOfScreen - 0.5 || YpanCurrentIndext > _NumberOfScreen - 0.5) {
                
                [view removeFromSuperview];
                [_LinkArray removeLastObject];
                
            }else if (XpanCurrentIndext >= Xfloat && YpanCurrentIndext <=Yfloat && Xfloat <= _NumberOfScreen - 0.5) {
                        
                        glViewport(0,0, BackWith,BackHeight);

                        _SelectedView.frame = CGRectMake((self.view.frame.size.width * 0.155)+ BackWith * (Xinteger+1) + 2*(Xinteger+1) ,(CGRectGetMaxY(_BackView.frame) + 6 +BackHeight*Yinteger)+2*Yinteger, BackWith, BackHeight);
                NSString *Rectstring = NSStringFromCGRect(_SelectedView.frame);
                        [self.view addSubview:_SelectedView];
                        NSInteger inte = _NumberOfScreen * (Yinteger) + (Xinteger+1);
                        
                        if ([DataHelp shareData].MeetingDestchanid.count > inte) {
                        NSInteger tagNumberKey = _Tinte;
                        NSString *dicValue = [NSString stringWithFormat:@"%ld",(long)tagNumberKey];
                        NSString *dicKey = [NSString stringWithFormat:@"%ld",(long)inte];
                        _MovViewdict = [NSMutableDictionary dictionaryWithObject:dicValue forKey:dicKey];
                        [_MovViewArray addObject:_MovViewdict];
                        
                        NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[inte];
                        NSString *String = [NSString stringWithFormat:@"%@",destch];
                        
                        NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[inte];
                        NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                        
                        NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                        NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                        
                        NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                        NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                        NSUUID *uuid = [NSUUID UUID];
                        NSString *uuidString = uuid.UUIDString;
//                        [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                        NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                                 @"destchanid":destdevString,
                                                                                                                 @"destdevid":String,
                                                                                                                 @"id":uuidString,
                                                                                                                 @"srcchanid":srcchanString,
                                                                                                                 @"srcdevid":srcdevString}]}};
                        NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                      
                        [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                        [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                            int Inte = 100;
                            for (int i = 0; i < _DeschArray.count; i++) {
                                if ([_DeschArray[i] isEqualToString:destdevString]) {
                                    Inte = i;
                                }
                            }
                            
                            if (Inte != 100) {
                                NSNumber *TAgNUmber = _ViewtagArray[Inte];
                                NSInteger NUmbTag = TAgNUmber.integerValue;
                                UIView *view = (UIView *)[self.view viewWithTag:NUmbTag];
                                [view removeFromSuperview];
                                [_CurrentRLink replaceObjectAtIndex:Inte withObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                                _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray replaceObjectAtIndex:Inte withObject:Rectstring];
                                [_DeschArray replaceObjectAtIndex:Inte withObject:destdevString];
                                [_DesVidArray replaceObjectAtIndex:Inte withObject:String];
                                [_RNameArray replaceObjectAtIndex:Inte withObject:_RtextString.text];
                        
                                
                            }else
                            {
                                _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray addObject:Rectstring];
                                [_RNameArray addObject:_RtextString.text];
                                [_DeschArray addObject:destdevString];
                                [_DesVidArray addObject:String];
                                [_CurrentRLink addObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                            }
                            
                     
                            
                        }else
                        {
                            UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                            [view removeFromSuperview];
                            self.PanviewTag = self.PanviewTag - 1;
                            [_LinkArray removeLastObject];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                                mbp.mode = MBProgressHUDModeText;
                                 mbp.label.text = Localized(@"解码器不存在");
                                mbp.margin = 10.0f; //提示框的大小
                                [mbp setOffset:CGPointMake(10, 100)];//提示框的位置
                                mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                                [mbp hideAnimated:YES afterDelay:1.2]; //多久后隐藏
                                });
//                                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];

                         
                        }
                            
//                        UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
               
                    }else if (XpanCurrentIndext >= Xfloat &&  YpanCurrentIndext >=Yfloat && Xfloat <= _NumberOfScreen - 0.5)
                    {
                        _SelectedView.frame = CGRectMake((self.view.frame.size.width * 0.155)+ BackWith * (Xinteger+1) + 2*(Xinteger+1) ,CGRectGetMaxY(_BackView.frame) + 6 + BackHeight *(Yinteger+1)  + 2 * (Yinteger+1) , BackWith, BackHeight);
                        NSString *Rectstring = NSStringFromCGRect(_SelectedView.frame);

                        [self.view addSubview:_SelectedView];
                        NSInteger inte = _NumberOfScreen * (Yinteger+1) + (Xinteger+1);
                        
                        if (inte < [DataHelp shareData].MeetingDestchanid.count) {
                        NSString *ValueString = [NSString stringWithFormat:@"%ld",_Tinte];
                        NSString *Keystring = [NSString stringWithFormat:@"%ld",(long)inte];
                        _MovViewdict = [NSMutableDictionary dictionaryWithObject:ValueString forKey:Keystring];
                        [_MovViewArray addObject:_MovViewdict];
                        
                    
                        NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[inte];
                        NSString *String = [NSString stringWithFormat:@"%@",destch];
                        
                        NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[inte];
                        NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                        
                        NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                        NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                        
                        NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                        NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                        NSUUID *uuid = [NSUUID UUID];
                        NSString *uuidString = uuid.UUIDString;
//                        [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                        NSDictionary *Linkdict = @{@"message":
                                                            @{@"function":@"medialink_add",@"medialinks":
                                                             @[@{
                                                                                                                 @"destchanid":destdevString,
                                                                                                                 @"destdevid":String,
                                                                                                                 @"id":uuidString,
                                                                                                                 @"srcchanid":srcchanString,
                                                                                                                 @"srcdevid":srcdevString}]}};
                        NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                        [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                        [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                            int Inte = 100;
                            for (int i = 0; i < _DeschArray.count; i++) {
                                if ([_DeschArray[i] isEqualToString:destdevString]) {
                                    Inte = i;
                                }
                            }
                            
                            if (Inte != 100) {
                                NSNumber *TAgNUmber = _ViewtagArray[Inte];
                                NSInteger NUmbTag = TAgNUmber.integerValue;
                                UIView *view = (UIView *)[self.view viewWithTag:NUmbTag];
                                [view removeFromSuperview];
                                
                                _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray replaceObjectAtIndex:Inte withObject:Rectstring];
                                [_DeschArray replaceObjectAtIndex:Inte withObject:destdevString];
                                [_DesVidArray replaceObjectAtIndex:Inte withObject:String];
                                [_RNameArray replaceObjectAtIndex:Inte withObject:_RtextString.text];
                                [_CurrentRLink replaceObjectAtIndex:Inte withObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                         
                            }else
                            {
                                _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray addObject:Rectstring];
                                [_RNameArray addObject:_RtextString.text];
                                [_DeschArray addObject:destdevString];
                                [_DesVidArray addObject:String];
                                [_CurrentRLink addObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                            
                            }
                            
                        }else
                        {
                            UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                            [view removeFromSuperview];
                            self.PanviewTag = self.PanviewTag - 1;
                            [_LinkArray removeLastObject];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                                                                mbp.mode = MBProgressHUDModeText;
                                                                 mbp.label.text = Localized(@"解码器不存在");
                                                                mbp.margin = 10.0f; //提示框的大小
                                                                [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                                                                mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                                                                [mbp hideAnimated:YES afterDelay:1]; //多久后隐藏
                              
                                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];
                                
                            });
                            
                        }
//                        UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
            
                    }else if (XpanCurrentIndext <= Xfloat &&  YpanCurrentIndext >=Yfloat && Yfloat <= _NumberOfScreen - 0.5)
                        
                    {
                        
                  
                        _SelectedView.frame = CGRectMake((self.view.frame.size.width * 0.155)+ BackWith * Xinteger + 2*Xinteger ,CGRectGetMaxY(_BackView.frame) + 6 +BackHeight * (Yinteger+1) + 2 * (Yinteger+1) , BackWith, BackHeight);
                        NSString *Rectstring = NSStringFromCGRect(_SelectedView.frame);

                        [self.view addSubview:_SelectedView];
                        NSInteger inte = _NumberOfScreen * (Yinteger+1) +Xinteger;
                        if (inte < [DataHelp shareData].MeetingDestchanid.count) {
                            
                        NSString *ValueDtring = [NSString stringWithFormat:@"%ld",(long)_Tinte];
                        NSString *KeyString = [NSString stringWithFormat:@"%ld",(long)inte];
                        _MovViewdict = [NSMutableDictionary dictionaryWithObject:ValueDtring forKey:KeyString];
                        [_MovViewArray addObject:_MovViewdict];
                       
                        NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[inte];
                        NSString *String = [NSString stringWithFormat:@"%@",destch];
                        
                        NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[inte];
                        NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                        
                        NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                        NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                        
                        NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                        NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                        NSUUID *uuid = [NSUUID UUID];
                        NSString *uuidString = uuid.UUIDString;
//                            [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                        NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                                 @"destchanid":destdevString,
                                                                                                                 @"destdevid":String,
                                                                                                                 @"id":uuidString,
                                                                                                                 @"srcchanid":srcchanString,
                                                                                                                 @"srcdevid":srcdevString}]}};
                        
                        NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                        [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                        [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                            int Inte = 100;
                            for (int i = 0; i < _DeschArray.count; i++) {
                                if ([_DeschArray[i] isEqualToString:destdevString]) {
                                    Inte = i;
                                }
                            }
                            
                            if (Inte != 100) {
                                NSNumber *TAgNUmber = _ViewtagArray[Inte];
                                NSInteger NUmbTag = TAgNUmber.integerValue;
                                UIView *view = (UIView *)[self.view viewWithTag:NUmbTag];
                                [view removeFromSuperview];
                                
                                _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray replaceObjectAtIndex:Inte withObject:Rectstring];
                                [_DeschArray replaceObjectAtIndex:Inte withObject:destdevString];
                                [_DesVidArray replaceObjectAtIndex:Inte withObject:String];
                                [_RNameArray replaceObjectAtIndex:Inte withObject:_RtextString.text];
                                [_CurrentRLink replaceObjectAtIndex:Inte withObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                          
                                
                            }else
                            {
                                _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray addObject:Rectstring];
                                [_RNameArray addObject:_RtextString.text];
                                [_DeschArray addObject:destdevString];
                                [_DesVidArray addObject:String];
                                [_CurrentRLink addObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                            }
                            
                            
                        }else
                        {
                            UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                            [view removeFromSuperview];
                            self.PanviewTag = self.PanviewTag - 1;
                            [_LinkArray removeLastObject];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                                                                mbp.mode = MBProgressHUDModeText;
                                                                 mbp.label.text = Localized(@"解码器不存在");                                                                mbp.margin = 10.0f; //提示框的大小
                                                                [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                                                                mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                                                                [mbp hideAnimated:YES afterDelay:1]; //多久后隐藏
                           
                                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];

                            });
                        }
                        
//                        UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
                 
                    }else if (XpanCurrentIndext <= Xfloat &&  YpanCurrentIndext <=Yfloat)
                    {
                      
                        _SelectedView.frame = CGRectMake((self.view.frame.size.width * 0.155)+ BackWith * Xinteger + 2* Xinteger ,CGRectGetMaxY(_BackView.frame) + 6 + BackHeight * Yinteger + 2 * Yinteger , BackWith, BackHeight);
                        NSString *Rectstring = NSStringFromCGRect(_SelectedView.frame);

                        [self.view addSubview:_SelectedView];
                        NSInteger inte = _NumberOfScreen *Yinteger +Xinteger;
                        if (inte < [DataHelp shareData].MeetingRnameArray.count) {
                    
                        NSString *valuestring = [NSString stringWithFormat:@"%ld",(long)_Tinte];
                        NSString *KeyString = [NSString stringWithFormat:@"%ld",(long)inte];
                        NSDictionary *dict = [NSDictionary dictionaryWithObject:valuestring forKey:KeyString];
                        NSString *string = [NSString stringWithFormat:@"%ld",(long)_SelectedView.tag];
                        [_MovViewdict setObject:dict forKey:string];
                  

                        NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[inte];
                        NSString *String = [NSString stringWithFormat:@"%@",destch];
                        
                        NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[inte];
                        NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                        
                        NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                        NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                        
                        NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                        NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                        NSUUID *uuid = [NSUUID UUID];
                        NSString *uuidString = uuid.UUIDString;
//                        [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)_panview.tag]];
                        NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                                 @"destchanid":destdevString,
                                                                                                                 @"destdevid":String,
                                                                                                                 @"id":uuidString,
                                                                                                                 @"srcchanid":srcchanString,
                                                                                                                 @"srcdevid":srcdevString}]}};
                        
                        NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                        [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                        [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                        
                            int Inte = 100;
                            for (int i = 0; i < _DeschArray.count; i++) {
                                if ([_DeschArray[i] isEqualToString:destdevString]) {
                                    Inte = i;
                                }
                            }
                            
                            if (Inte != 100) {
                                NSNumber *TAgNUmber = _ViewtagArray[Inte];
                                NSInteger NUmbTag = TAgNUmber.integerValue;
                                UIView *view = (UIView *)[self.view viewWithTag:NUmbTag];
                                [view removeFromSuperview];
                                
                                 _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray replaceObjectAtIndex:Inte withObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray replaceObjectAtIndex:Inte withObject:Rectstring];
                                [_DeschArray replaceObjectAtIndex:Inte withObject:destdevString];
                                [_DesVidArray replaceObjectAtIndex:Inte withObject:String];
                                [_RNameArray replaceObjectAtIndex:Inte withObject:_RtextString.text];
                                [_CurrentRLink replaceObjectAtIndex:Inte withObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                            }else
                            {
                                 _RtextString.text = [DataHelp shareData].MeetingRnameArray[inte];
                                [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
                                [_TLinkTagArray addObject:[NSNumber numberWithInteger:_Tinte]];
                                [_ViewRectArray addObject:Rectstring];
                                [_RNameArray addObject:_RtextString.text];
                                [_DeschArray addObject:destdevString];
                                [_DesVidArray addObject:String];
                                [_CurrentRLink addObject:[NSString stringWithFormat:@"%ld",(long)inte]];
                            }
                            
                            
//                            
//                        if (inte < [DataHelp shareData].RNamearray.count) {
//                            _RtextString.text = [DataHelp shareData].RNamearray[inte];
//                            [_ViewtagArray addObject:[NSNumber numberWithInteger:_panview.tag]];
//                            [_TLinkTagArray addObject:[NSNumber numberWithInteger:pan.view.tag - 1000]];
//                            [_ViewRectArray addObject:Rectstring];
//                            [_RNameArray addObject:_RtextString.text];
//                            [_DeschArray addObject:destdevString];
//                            [_DesVidArray addObject:String];
//                        }
                           
                            
                        }else
                        {
                            UIView *view = (UIView *)[self.view viewWithTag:_panview.tag];
                            [view removeFromSuperview];
                            self.PanviewTag = self.PanviewTag - 1;
                            [_LinkArray removeLastObject];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                                                                mbp.mode = MBProgressHUDModeText;
                                                                mbp.label.text = Localized(@"解码器不存在");
                                                                mbp.margin = 10.0f; //提示框的大小
                                                                [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                                                                mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                                                                [mbp hideAnimated:YES afterDelay:1]; //多久后隐藏
                             
                                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];
                                
                                
                                
                            });
                        }
                        
//                        UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                        view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
                
                    }
                    
                }

            }
        }
        
        
        
         }
  
    }
}

- (void)TimerAction:(NSTimer *)timer
{
    [timer invalidate];
    
}

#pragma mark === cell的点击事件

    //cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (Height4SuperView * 0.65+55)/3.8;;//(Height4SuperView * 0.65+55)/3.8;
}

//创建的videoView
- (void)CreatVideoView
{
    NSString *path;
    
    _scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0,55, Width4SuperView*0.15,Height4SuperView * 0.65)];
    _scroller.contentSize = CGSizeMake(Width4SuperView*0.15,Height4SuperView*0.65*MutArray.count);
    _scroller.showsVerticalScrollIndicator = NO;
    _scroller.showsHorizontalScrollIndicator = NO;
    _scroller.backgroundColor = [UIColor grayColor];
    _scroller.scrollEnabled = YES;
    
    [self.view addSubview:_scroller];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    for (int i = 0 ; i< MutArray.count; i++) {
        NSString *path = MutArray[i];
        _view = [[UIView alloc]init];
        _view.frame = CGRectMake(1,140*i-55, Width4SuperView*0.15-2, 130);
        _view.tag = 100+i;
        _view.backgroundColor = [UIColor cyanColor];
        
        _kxMovie = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters];
        _kxMovie.view.backgroundColor = [UIColor orangeColor];
        _kxMovie.view.frame = CGRectMake(0,0, Width4SuperView*0.15, 105);
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)];
        Tap.numberOfTapsRequired = 1;
        Tap.numberOfTouchesRequired = 1;
        _kxMovie.view.tag = 215+i;
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0,CGRectGetMaxY(_kxMovie.view.frame),Width4SuperView*0.15, 25);
        NSString *text = [NSString stringWithFormat:@"摄像头%d",i];
        label.text = text;
        
        label.textAlignment = NSTextAlignmentCenter;
        [_view addSubview:label];
        [_kxMovie.view addGestureRecognizer:Tap];
        [_scroller addSubview:_view];
        [_view addSubview:_kxMovie.view];
        [self addChildViewController:_kxMovie];
    }
    
}


//场景列表
- (void)drawView4Sence
{
//    UILabel *label = [[UILabel alloc]init];
//    label.frame = CGRectMake(2,CGRectGetMaxY(_table.frame)+Height4SuperView * 0.03, 20,Width4SuperView*0.08);
//    label.text = Localized(@"场\n景\n列\n表");
//    label.numberOfLines = [label.text length];
//    label.backgroundColor = [UIColor colorWithRed:93/255.0 green:164/255.0 blue:213/255.0 alpha:1];
//    [self.view addSubview:label];
//    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_table.mas_bottom).with.offset(90);
//        make.left.equalTo(self.view.mas_left).with.offset(2);
//        //        make.right.equalTo(self.view.mas_bottom).with.offset(-3);
//        make.width.mas_equalTo( 20);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
//    }];
    
    _SenceSCroller = [[UIScrollView alloc]init];
    _SenceSCroller.frame = CGRectMake(CGRectGetWidth(self.view.frame)+3, CGRectGetMaxY(_table.frame)+33, Width4SuperView*0.15+Width4SuperView*0.83-29,Width4SuperView - 4);
    _SenceSCroller.contentSize = CGSizeMake((Width4SuperView - 22)*2, Width4SuperView * 0.08);
    _SenceSCroller.layer.borderWidth = 0.2;
//    _SenceSCroller.backgroundColor = [UIColor orangeColor];
    _SenceSCroller.layer.borderColor = [UIColor orangeColor].CGColor;
    _SenceSCroller.bounces = NO;
    _SenceSCroller.backgroundColor = TabbleColor;
    _SenceSCroller.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_SenceSCroller];
    [_SenceSCroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_MenuView.mas_bottom).with.offset(2);
        make.left.equalTo(self.view.mas_left).with.offset(2);
        make.width.mas_equalTo(Width4SuperView - 4);
//        make.height.mas_equalTo(Height4SuperView * 0.16);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
    }];
//    NSLog(@"%@",NSStringFromCGRect(_SenceSCroller.frame));
    
//    for (int i = 0; i < 5; i++) {
//        NSString *NameKey = [NSString stringWithFormat:@"SenceImage%d",i];
////        NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:NameKey];
//       
//    }
}

#pragma mark === 模式选择 ======
//模式界面
- (void)SetUpview
{
    _Aview = [[UIView alloc]init];
    _Aview.frame = CGRectMake(2, CGRectGetMaxY(_SenceSCroller.frame)+2, Width4SuperView - 4,Height4SuperView * 0.13);
    _Aview.layer.borderColor = [UIColor blackColor].CGColor;
    _Aview.backgroundColor = MotifyColor;
    _Aview.layer.borderColor = WhiteColor.CGColor;
    _Aview.layer.borderWidth = 0.4;
    [self.view addSubview:_Aview];
    
    [_Aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SenceSCroller.mas_bottom).with.offset(2);
        make.left.equalTo(self.view.mas_left).with.offset(2);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
        make.width.mas_equalTo( Width4SuperView*0.15 + Width4SuperView *0.83 - 7);

    }];

    //应急模式
    UIButton *Emergencybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Emergencybutton.frame = CGRectMake(Width4SuperView*0.14,Height4SuperView * 0.011,Width4SuperView * 0.09,Height4SuperView * 0.11);
    UIImage *emergency = [UIImage imageNamed:@"应急"];
    emergency = [emergency imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Emergencybutton setImage:emergency forState:UIControlStateNormal];
    Emergencybutton.imageEdgeInsets = UIEdgeInsetsMake(2, 17,30,Emergencybutton.titleLabel.bounds.size.width);
    [Emergencybutton setTitle:Localized(@"应急模式") forState:UIControlStateNormal];
    CGSize Emergencysize = [Emergencybutton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [Emergencybutton setFrame:CGRectMake(Width4SuperView*0.14,Height4SuperView * 0.011, Emergencysize.width, Height4SuperView * 0.11)];
    Emergencybutton.imageView.center = Emergencybutton.center;
    [Emergencybutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    Emergencybutton.titleLabel.font = [UIFont systemFontOfSize:19];
//    Emergencybutton.titleLabel.center = Emergencybutton.center;
    Emergencybutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Emergencybutton.titleEdgeInsets = UIEdgeInsetsMake(50,-Emergencybutton.titleLabel.bounds.size.width - 20, 0, 0);
    

    [Emergencybutton addTarget:self action:@selector(EmergencyAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_Aview addSubview:Emergencybutton];
    

    
    UIButton *commandbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    commandbutton.frame = CGRectMake(Width4SuperView*0.29,Height4SuperView * 0.011,Width4SuperView * 0.09,Height4SuperView * 0.11);
    [commandbutton setImage:[UIImage imageNamed:@"指挥模式"] forState:UIControlStateNormal];
    commandbutton.imageView.center = commandbutton.center;
    commandbutton.imageEdgeInsets = UIEdgeInsetsMake(2, 10,30,commandbutton.titleLabel.bounds.size.width);
    [commandbutton setTitle:Localized(@"指挥模式") forState:UIControlStateNormal];
    [commandbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    CGSize commandbuttonsize = [commandbutton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [commandbutton setFrame:CGRectMake(Width4SuperView*0.29,Height4SuperView * 0.011, commandbuttonsize.width, Height4SuperView * 0.11)];
    commandbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    commandbutton.titleEdgeInsets = UIEdgeInsetsMake(50,-commandbutton.titleLabel.bounds.size.width - 75, 0, 0);
    [commandbutton addTarget:self action:@selector(CommandAction:) forControlEvents:UIControlEventTouchDown];
//    [_Aview addSubview:commandbutton];
    
    
    //
    UIButton *Roundbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Roundbutton.frame = CGRectMake(Width4SuperView * 0.43,Height4SuperView * 0.011,Width4SuperView * 0.09,Height4SuperView * 0.11);
    [Roundbutton setImage:[UIImage imageNamed:@"循环模式"] forState:UIControlStateNormal];
    Roundbutton.imageEdgeInsets = UIEdgeInsetsMake(2, 16,30,Roundbutton.titleLabel.bounds.size.width);
    Roundbutton.imageView.center = Roundbutton.center;
    [Roundbutton setTitle:Localized(@"轮巡模式") forState:UIControlStateNormal];
    [Roundbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    CGSize Roundbuttonsize = [Roundbutton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [Roundbutton setFrame:CGRectMake(Width4SuperView * 0.43,Height4SuperView * 0.011, Roundbuttonsize.width, Height4SuperView * 0.11)];
    Roundbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Roundbutton.titleEdgeInsets = UIEdgeInsetsMake(50,-Roundbutton.titleLabel.bounds.size.width - 75, 0, 0);
    [Roundbutton addTarget:self action:@selector(RoundAction:) forControlEvents:UIControlEventTouchDown];
    
//    [_Aview addSubview:Roundbutton];
   
    //
    UIButton *Controlbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Controlbutton.frame = CGRectMake(Width4SuperView * 0.57,Height4SuperView * 0.011,Width4SuperView * 0.09,Height4SuperView * 0.11);
    
    [Controlbutton setImage:[UIImage imageNamed:@"监控模式"] forState:UIControlStateNormal];
    Controlbutton.imageEdgeInsets = UIEdgeInsetsMake(2, 16,30,Controlbutton.titleLabel.bounds.size.width);
    Controlbutton.imageView.center = Controlbutton.center;
    [Controlbutton setTitle:Localized(@"监控模式") forState:UIControlStateNormal];
    [Controlbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    CGSize Controlbuttonsize = [Controlbutton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [Controlbutton setFrame:CGRectMake(Width4SuperView * 0.57,Height4SuperView * 0.011, Controlbuttonsize.width, Height4SuperView * 0.11)];
    Controlbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Controlbutton.titleEdgeInsets = UIEdgeInsetsMake(50,-Controlbutton.titleLabel.bounds.size.width - 75, 0, 0);
    [Controlbutton addTarget:self action:@selector(ControlAction:) forControlEvents:UIControlEventTouchDown];
//    [_Aview addSubview:Controlbutton];
    
    //
    UIButton *Meetingbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Meetingbutton.frame = CGRectMake(Width4SuperView * 0.71,Height4SuperView * 0.011,Width4SuperView * 0.09,Height4SuperView * 0.11);
    [Meetingbutton setImage:[UIImage imageNamed:@"会议模式"] forState:UIControlStateNormal];
    Meetingbutton.imageEdgeInsets = UIEdgeInsetsMake(2, 16,30,Meetingbutton.titleLabel.bounds.size.width);
    Meetingbutton.imageView.center = Controlbutton.center;
    [Meetingbutton setTitle:Localized(@"会议模式") forState:UIControlStateNormal];
    [Meetingbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    CGSize Meetingbuttonsize = [Meetingbutton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [Meetingbutton setFrame:CGRectMake(Width4SuperView * 0.71,Height4SuperView * 0.011, Meetingbuttonsize.width, Height4SuperView * 0.11)];
    Meetingbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
    Meetingbutton.titleEdgeInsets = UIEdgeInsetsMake(50,-Meetingbutton.titleLabel.bounds.size.width - 75, 0, 0);
    [Roundbutton addTarget:self action:@selector(MeetingAction:) forControlEvents:UIControlEventTouchDown];
//    [_Aview addSubview:Meetingbutton];
}
//会场列表
- (void)DreawMeeting
{
#pragma mark === 左右列表=====
    //左边T摄像头控制滚动
    UIButton *Scrollerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [Scrollerbutton addTarget:self action:@selector(CameraSeltButtonAction:) forControlEvents:UIControlEventTouchDown];
    UIImage *Scrollerimage = [UIImage imageNamed:@"向下"];
    Scrollerimage = [Scrollerimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Scrollerbutton.layer.masksToBounds = YES;
    Scrollerbutton.layer.cornerRadius = 2;
    Scrollerbutton.layer.borderColor = [UIColor blackColor].CGColor;
    Scrollerbutton.layer.borderWidth = 0.3;
    [Scrollerbutton setImage:Scrollerimage forState:UIControlStateNormal];
    Scrollerbutton.imageEdgeInsets = UIEdgeInsetsMake(0,Width4SuperView * 0.055, 0,Width4SuperView * 0.055);
    Scrollerbutton.backgroundColor = ScrollerColor;
    [self.view addSubview:Scrollerbutton];
    [Scrollerbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_table.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.width.mas_equalTo(Width4SuperView*0.15/2 + 1);
//        make.bottom.equalTo(_SenceSCroller.mas_top).with.offset(-2);
        make.height.mas_equalTo(30);
    }];
 
    
    UIButton *Rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [Rightbutton addTarget:self action:@selector(CameraUPButtonAction:) forControlEvents:UIControlEventTouchDown];
    UIImage *Rightimage = [UIImage imageNamed:@"向上"];
    Rightimage = [Rightimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Rightbutton.layer.masksToBounds = YES;
    Rightbutton.layer.cornerRadius = 2;
    Rightbutton.layer.borderColor = [UIColor blackColor].CGColor;
    Rightbutton.layer.borderWidth = 0.3;
    [Rightbutton setImage:Rightimage forState:UIControlStateNormal];
    Rightbutton.imageEdgeInsets = UIEdgeInsetsMake(0,Width4SuperView * 0.055, 0,Width4SuperView * 0.055);
    Rightbutton.backgroundColor = ScrollerColor;
    [self.view addSubview:Rightbutton];
    [Rightbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_table.mas_bottom).with.offset(0);
        make.left.equalTo(Scrollerbutton.mas_right).with.offset(-2);
        make.width.mas_equalTo(Width4SuperView*0.15/2+1);
        //        make.bottom.equalTo(_SenceSCroller.mas_top).with.offset(-2);
        make.height.mas_equalTo(30);
    }];

}

#pragma mark===分屏按钮=====
//分屏按钮
- (void)DreawSplitScreen
{
    
    _BackView = [[UIView alloc]init];
    _BackView.frame = CGRectMake(CGRectGetMaxX(_table.frame)+2,65,Width4SuperView*0.83-7,45);
    _BackView.backgroundColor = TurnLeft;
    [self.view addSubview:_BackView];
//    NSLog(@"%@",NSStringFromCGRect(_BackView.frame));
    
    //主屏
    _OneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *OneImage = [UIImage imageNamed:@"SeleOne@2x"];
    OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_OneButton setImage:OneImage forState:UIControlStateNormal];
    _OneButton.frame = CGRectMake(Width4SuperView * 0.3, Height4SuperView*0.5, Width4scroller*0.05, Height4SuperView*0.7);
//    _OneButton.layer.borderWidth = 0.4;
//    _OneButton.layer.borderColor = [UIColor blackColor].CGColor;
    _OneButton.layer.masksToBounds = YES;
    _OneButton.layer.cornerRadius = 4;
    _OneButton.tag = 1009;
    [_OneButton addTarget:self action:@selector(OneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:_OneButton];
    
    [_OneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BackView.mas_top).with.offset(5);
        make.left.equalTo(_BackView.mas_left).with.offset(40);
        make.bottom.equalTo(_BackView.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(_BackView.frame.size.width * 0.05);
    }];
    
    //四分屏
    _FourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_FourButton setImage:[UIImage imageNamed:@"Two@2x"] forState:UIControlStateNormal];
//    _FourButton.layer.borderWidth = 0.4;
//    _FourButton.layer.borderColor = [UIColor blackColor].CGColor;
    _FourButton.layer.masksToBounds = YES;
    _FourButton.layer.cornerRadius = 4;
    _FourButton.tag = 1010;
    [_FourButton addTarget:self action:@selector(FourButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:_FourButton];
    
    [_FourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BackView.mas_top).with.offset(5);
        make.left.equalTo(_OneButton.mas_right).with.offset(40);
        make.bottom.equalTo(_BackView.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(_BackView.frame.size.width * 0.05);
    }];
    
    //九分屏
    _NineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *NIneImage = [UIImage imageNamed:@"Three@2x"];
    NIneImage = [NIneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [_NineButton setBackgroundImage:NIneImage forState:UIControlStateNormal];
    [_NineButton setImage:[UIImage imageNamed:@"Three@2x"] forState:UIControlStateNormal];
//    _NineButton.backgroundColor = WhiteColor;
//    _NineButton.layer.borderWidth = 0.4;
//    _NineButton.layer.borderColor = [UIColor blackColor].CGColor;
    _NineButton.layer.masksToBounds = YES;
    _NineButton.layer.cornerRadius = 4;
    [_NineButton addTarget:self action:@selector(NineButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _NineButton.tag = 1011;
    [_BackView addSubview:_NineButton];
    
    [_NineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_BackView.mas_top).with.offset(5);
        make.left.equalTo(_FourButton.mas_right).with.offset(40);
        make.bottom.equalTo(_BackView.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(_BackView.frame.size.width * 0.05);
        
    }];
    
    //十六分屏
    _sixthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sixthButton setImage:[UIImage imageNamed:@"Four@2x"] forState:UIControlStateNormal];
//    _sixthButton.backgroundColor = WhiteColor;
//    _sixthButton.layer.borderWidth = 0.4;
//    _sixthButton.layer.borderColor = [UIColor blackColor].CGColor;
    _sixthButton.layer.masksToBounds = YES;
    _sixthButton.layer.cornerRadius = 4;
    [_sixthButton addTarget:self action:@selector(sixthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _sixthButton.tag = 1012;
    [_BackView addSubview:_sixthButton];
    
    [_sixthButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BackView.mas_top).with.offset(5);
        make.left.equalTo(_NineButton.mas_right).with.offset(40);
        make.bottom.equalTo(_BackView.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(_BackView.frame.size.width * 0.05);
    }];
    //保存场景
    _SaveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _SaveButton.frame = CGRectMake(300, 0, 40, 40);
    _SaveButton.backgroundColor = [UIColor colorWithRed:6/255.0 green:172/255.0 blue:230/255.0 alpha:1];
    _SaveButton.layer.masksToBounds = YES;
    _SaveButton.layer.cornerRadius = 4;
    _SaveButton.tag = 1014;
    [_SaveButton setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
    [_SaveButton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_SaveButton addTarget:self action:@selector(SaveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:_SaveButton];
    [_SaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BackView.mas_top).with.offset(5);
        make.right.equalTo(_BackView.mas_right).with.offset(-30);
        make.bottom.equalTo(_BackView.mas_bottom).with.offset(-5);
        CGSize Meetingbuttonsize = [_SaveButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
        make.width.mas_equalTo(Meetingbuttonsize.width);
    }];
    //自定义屏幕按钮
    _CustomButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    _CustomButton.backgroundColor = WhiteColor;
    _CustomButton.layer.masksToBounds = YES;
    _CustomButton.layer.cornerRadius = 4;
//    _CustomButton.layer.borderWidth = 0.4;
//    _CustomButton.layer.borderColor = [UIColor blackColor].CGColor;
//    [_CustomButton setTitle:@"自定义" forState:UIControlStateNormal];
//    [_CustomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImage *customimage = [UIImage imageNamed:@"Custom@2x"];
    customimage = [customimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_CustomButton setImage:customimage forState:UIControlStateNormal];
    [_CustomButton addTarget:self action:@selector(CustomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _CustomButton.tag = 1013;
    [_BackView addSubview:_CustomButton];
//    [_CustomButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_BackView.mas_top).with.offset(5);
//        make.left.equalTo(_sixthButton.mas_right).with.offset(40);
//        make.bottom.equalTo(_BackView.mas_bottom).offset(-5);
//        make.width.mas_equalTo(_BackView.frame.size.width * 0.07);
//    }];
        [_CustomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_BackView.mas_top).with.offset(5);
            make.left.equalTo(_sixthButton.mas_right).with.offset(20);
            make.bottom.equalTo(_BackView.mas_bottom).offset(-5);
            make.width.mas_equalTo(64);
        }];
    
    //保存于应用自定义的场景
    _SaveSence = [UIButton buttonWithType:UIButtonTypeSystem];
//    _SaveSence.backgroundColor = WhiteColor;
    _SaveSence.layer.masksToBounds = YES;
    _SaveSence.layer.cornerRadius = 4;
//    [_SaveSence setTitle:Localized(@"保存并应用") forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"Custom@2x"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_SaveSence setImage:image forState:UIControlStateNormal];
    CGSize SaveSenceSize = [_SaveSence.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    [_SaveSence setFrame:CGRectMake(0,0, SaveSenceSize.width, 20)];
    [_SaveSence setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_SaveSence addTarget:self action:@selector(SaveSenceAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_BackView addSubview:_SaveSence];
//    [_SaveSence mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_BackView.mas_top).with.offset(5);
//        make.left.equalTo(_sixthButton.mas_right).with.offset(20);
//        make.bottom.equalTo(_BackView.mas_bottom).offset(-5);
//        make.width.mas_equalTo(50);
//    }];
    
}


- (void)CustomButtonAction:(UIButton *)button
{
   
    if (_iscustom == NO && [DataHelp shareData].MeetingRnameArray.count > 0) {
        UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
        [Savebuttom setTitle:Localized(@"应用会场") forState:UIControlStateNormal];
        _iscustom = YES;
        UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
        UIImage *OneImage = [UIImage imageNamed:@"One@2x"];
        OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [OneButton setImage:OneImage forState:UIControlStateNormal];
        
        UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
        UIImage *FourImage = [UIImage imageNamed:@"Two@2x"];
        FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fourButton setImage:FourImage forState:UIControlStateNormal];
        
        UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
        UIImage *NineImage = [UIImage imageNamed:@"Three@2x"];
        NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Ninebutton setImage:NineImage forState:UIControlStateNormal];
        
        UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
        UIImage *SixImage = [UIImage imageNamed:@"Four@2x"];
        SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [SixButton setImage:SixImage forState:UIControlStateNormal];
        
        UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
        UIImage *CustomImage = [UIImage imageNamed:@"SeleCustom@2x"];
        CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [custombutton setImage:CustomImage forState:UIControlStateNormal];
        [self CustomButtonAction];
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"无解码器 不可操作");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            //            mbp.dimBackground = NO;
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
        });
    }
}

#pragma mark===R分屏位置===
- (void)BakeForRScreen
{   [_CurrentRLink removeAllObjects];
    [_LinkArray removeAllObjects];
    self.DecomeNumber = 0;
    for (int i = 1; i <= self.PanviewTag; i++) {
      UIView *TReview  = (UIView *)[self.view viewWithTag:10000 + i];
        [TReview removeFromSuperview];
    }
    [_backRScreen  removeFromSuperview];
    [_BackScro removeFromSuperview];
    
    [_ViewtagArray removeAllObjects];
    [_ViewRectArray removeAllObjects];
    [_TLinkTagArray removeAllObjects];
    [_RNameArray removeAllObjects];
    [_DesVidArray removeAllObjects];
    [_DeschArray removeAllObjects];
    
    _backRScreen = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_table.frame) + 2 ,CGRectGetMaxY(_BackView.frame)+ 2, Width4SuperView - Width4SuperView*0.15 - 4,CGRectGetHeight(_table.frame) - 15)];
    _backRScreen.layer.borderWidth = 0.5;
    _backRScreen.layer.borderColor = [UIColor blackColor].CGColor;
    _backRScreen.layer.cornerRadius = 3;
    _backRScreen.layer.masksToBounds = YES;
    _backRScreen.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_backRScreen];

    _BackScro = [[UIView alloc]init];
    _BackScro.frame = CGRectMake(0, 0, Width4SuperView - Width4SuperView*0.15 - 4,CGRectGetHeight(_table.frame) - 15);
//    _BackScro.contentSize = CGSizeMake(_BackScro.frame.size.width, _BackScro.frame.size.height);
//    _BackScro.pagingEnabled = YES;
    _BackScro.backgroundColor = BakeSrcColor;
//    _BackScro.delegate = self;
    _BackScro.userInteractionEnabled = YES;
//    _BackScro.bounces = NO;
    [_backRScreen addSubview:_BackScro];
    
    NSInteger Reindex = 0;
    if (_SenceCount == 0) {
        Reindex = 0;
        
    }else
    {
        Reindex = _SenceCount;
    }
    for (int i= 0 ;i < [DataHelp shareData].MeetingRnameArray.count ; i++) {
        NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%d%@%@",UserNameString,400+i,[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[DataHelp shareData].MeetingDestchanid[i]]];
        if (string != nil) {
            [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:i withObject:string];
        }
    }
    if ([DataHelp shareData].CustomeIsBool == YES && self.SenceBool == 0) {
        //创建预置位置
        
        _BackBlue = [[UIView alloc]init];
        _BackBlue.frame = CGRectMake(4, 4,ScreenWith - 8, ScreenHeight - 8);
        _BackBlue.backgroundColor = ScrollerColor;
        [_BackScro addSubview:_BackBlue];
        for (int i = 0 ; i < 30; i++) {
            for (int j = 0; j < 20; j++) {
                _Blueview = [[UIView alloc]initWithFrame:CGRectMake(2 + ((_BackBlue.frame.size.width)/30)*i , 2+((_BackBlue.frame.size.height) /20)*j ,(_BackBlue.frame.size.width)/30 - 4, (_BackBlue.frame.size.height) / 20 - 4)];
//                _Blueview.backgroundColor = [UIColor cyanColor];
                [_BackBlue addSubview:_Blueview];
            }
        }
            NSString *Key = [NSString stringWithFormat:@"%@arrayValue%@",UserNameString,[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[_SenceCount][@"name"]]];
            NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:Key];
        
//            _BackScro.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
        
            [_ReRectArr removeAllObjects];
            [_RectArray removeAllObjects];
            for (int i = 0; i < array.count; i ++) {
                
                NSString *string1 = [NSString stringWithFormat:@"%@CustomMessage%@",UserNameString,[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[_SenceCount][@"name"]]];
                NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:string1];
                
                NSNumber *number = array[i];
                NSInteger integer = number.integerValue;
                NSString *string = [NSString stringWithFormat:@"%ld",(long)integer];
                
                NSString *FrameStr = [dict objectForKey:string];
                CGRect rect = CGRectFromString(FrameStr);
                [_ReRectArr addObject:FrameStr];
                [_RectArray addObject:FrameStr];
                int MeetingCount = (int)_SenceCount;
                [DataHelp shareData].CreatRView = YES;
                [CustomData CreatSenceTable];
                [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[MeetingCount][@"name"]] CustomRct:FrameStr];

                //将位置添加到数组中
//              [_RectstringArray addObject:FrameStr];
               
                UIView *view = [[UIView alloc]init];
                view.frame =  rect;
                
                CGFloat width = view.frame.size.width;
                NSNumber *Widthnumber = [NSNumber numberWithFloat:width];
                [_WidthCountArray addObject:Widthnumber];
                
                CGFloat height = view.frame.size.height;
                NSNumber *HeightNumber = [NSNumber numberWithFloat:height];
                [_HeightArray addObject:HeightNumber];
                
                CGFloat x = view.frame.origin.x;
                NSNumber *Xnumber = [NSNumber numberWithFloat:x];
                [_OrgionX addObject:Xnumber];
                
                
                CGFloat y = view.frame.origin.y;
                NSNumber *YNumber = [NSNumber numberWithFloat:y];
                [_OrigionY addObject:YNumber];
 
                view.backgroundColor = CustomPancolor;
                [_BackBlue addSubview:view];
                
                UILabel *Namelabe = [[UILabel alloc]init];
                Namelabe.frame = CGRectMake(0, view.frame.size.height/3, view.frame.size.width, view.frame.size.height/3);
                NSString *Namestring = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@RNameData",UserNameString]];
                NSString *LabelTag = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@tagNumber",UserNameString]];
                Namelabe.text = Namestring;
                Namelabe.textColor = WhiteColor;
                Namelabe.tag = LabelTag.integerValue;
                Namelabe.textAlignment = NSTextAlignmentCenter;
                [view addSubview:Namelabe];
                _NumberOfScreen = 5;
      
        }
        
//        NSLog(@"")
        
        

    }else
    {
    
    for (int i = 0; i < self.NumberOfScreen; i++) {
        for (int j = 0; j < self.NumberOfScreen; j++) {
            
            if (self.NumberOfScreen == 1) {
                    _Oneview = [[UIView alloc]init];
                    _Oneview.frame = CGRectMake(4, 4, ScreenWith - 8, ScreenHeight - 8);
                    _Oneview.backgroundColor = ScrollerColor;
                    _Oneview.tag = 100+i;
                
                //将view的tag值添加到数组中
                    NSNumber *OneNumber = [NSNumber numberWithInteger:_Oneview.tag];
                    [self.SenceTagArray addObject:OneNumber];
                
                 //添加长按手势修改解码器名称
                UILongPressGestureRecognizer *OneLong = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(TwoLongAction:)];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RSetAction:)];
                    tapGesture.numberOfTapsRequired = 2;
                    OneLong.minimumPressDuration = 0.2;
                    [_Oneview addGestureRecognizer:tapGesture];
                    [_Oneview addGestureRecognizer:OneLong];
                    [_BackScro addSubview:_Oneview];
                
                    _DeLabel = [[UILabel alloc]init];
                    _DeLabel.textColor = WhiteColor;
                    _DeLabel.frame = CGRectMake(0, 30, ScreenWith - 8, 40);
                    _DeLabel.textAlignment = NSTextAlignmentCenter;
                    _DeLabel.tag = 500 + i;
                if (_SenceCount == 0) {
                    _SenceCount = 1;
                }
                
                NSString *textString;
                if ([DataHelp shareData].MeetingRnameArray.count != 0) {
                    NSString *TextString = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)_DeLabel.tag,[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingRnameArray[_SenceCount - 1]]]];
                    textString = TextString;
               
               }
                if (i + 1 * j < [DataHelp shareData].MeetingRnameArray.count && textString == nil) {
                    _DeLabel.text = [DataHelp shareData].MeetingRnameArray[i];
                    
                }else if (i + 1 * j < [DataHelp shareData].MeetingRnameArray.count && textString != nil){
                    _DeLabel.text = textString;
                    
                }else
                {
//                  _DeLabel.text = Localized(@"无解码器");
                }
                
                [_Oneview addSubview:_DeLabel];

                    //添加label用于显示徐改后的解码器名称
                    _decomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_Oneview.frame.size.width/2 - 50, _Oneview.frame.size.height/2- 20, 90, 40)];
                    _decomeLabel.textAlignment = NSTextAlignmentCenter;
                    _decomeLabel.tag = 100+i+100;
                    _decomeLabel.font = [UIFont systemFontOfSize:24];
                    [_Oneview addSubview:_decomeLabel];
                
                }else if (self.NumberOfScreen == 2)
                {
                    
                UIView *Twoview = [[UIView alloc]init];
                    Twoview.frame = CGRectMake(4+((ScreenWith/2) - 2)*i, 4+ (ScreenHeight/2-2)*j,(ScreenWith - 10)/2, (ScreenHeight - 10) / 2);
                    Twoview.backgroundColor = ScrollerColor;
                    Twoview.tag = 102+2*j+i;
                    NSNumber *Twonumber = [NSNumber numberWithInteger:Twoview.tag];
                    [self.SenceTagArray addObject:Twonumber];
                UILongPressGestureRecognizer *TwoLong = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(TwoLongAction:)];
                UITapGestureRecognizer *TwoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RSetAction:)];
                    TwoTap.numberOfTapsRequired = 2;
                    TwoLong.numberOfTouchesRequired = 1;
                    TwoLong.minimumPressDuration = 0.2;
                    [Twoview addGestureRecognizer:TwoLong];
                    [Twoview addGestureRecognizer:TwoTap];
                    [_BackScro addSubview:Twoview];
                    
                    _DeLabel = [[UILabel alloc]init];
                    _DeLabel.frame = CGRectMake(0, 30, ScreenWith/2 - 5, 40);
                    _DeLabel.textAlignment = NSTextAlignmentCenter;
                    _DeLabel.tag = 502 + 2 *j +i;
                    
                    if (_SenceCount == 0) {
                        _SenceCount = 1;
                    }
                    
                    NSString *textString;
                    if ([DataHelp shareData].MeetingRnameArray.count != 0) {
                       NSString *Textstring = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%d%@",UserNameString,502 + 2 * j +i,[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingRnameArray[_SenceCount - 1]]]];
                        textString = Textstring;
                        
                    }
                    
                    if (i + 2 * j < [DataHelp shareData].MeetingRnameArray.count && textString == nil) {
                      
                       _DeLabel.text = [DataHelp shareData].MeetingRnameArray[i+2*j];
                        
                    }else if (i + 2 * j < [DataHelp shareData].MeetingRnameArray.count && textString != nil){
                        _DeLabel.text = textString;
                        
                    }else
                    {
//                        _DeLabel.text = Localized(@"无解码器");
 
                    }
                    
                        [Twoview addSubview:_DeLabel];
                        _decomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Twoview.frame.size.width/2 - 50, Twoview.frame.size.height/2- 20, 90, 40)];
                        _DeLabel.textColor = WhiteColor;
                        _decomeLabel.textAlignment = NSTextAlignmentCenter;
                        _decomeLabel.tag = 102+2*i+j+100;
//                    decomeLabel.backgroundColor = [UIColor orangeColor];
                        _decomeLabel.text = @"";
                    
                        _decomeLabel.font = [UIFont systemFontOfSize:24];
                        [Twoview addSubview:_decomeLabel];
            }
            
           else if (self.NumberOfScreen == 3) {
                UIView *view = [[UIView alloc]init];
                view.frame = CGRectMake(4+(ScreenWith/3 - 2)*i, 4 + (ScreenHeight/3 -2)*j, ScreenWith/3 - 4, ScreenHeight/3 - 4);
                view.backgroundColor = ScrollerColor;
                view.tag = 106+3*j+i;
                NSNumber *number = [NSNumber numberWithInteger:view.tag];
                [self.SenceTagArray addObject:number];
              
            UILongPressGestureRecognizer *TwoLong = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(TwoLongAction:)];
            UITapGestureRecognizer *ThreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RSetAction:)];
               ThreeTap.numberOfTapsRequired = 2;
               TwoLong.minimumPressDuration = 0.5;
               [view addGestureRecognizer:TwoLong];
               [view addGestureRecognizer:ThreeTap];
               [_BackScro addSubview:view];
               
                _DeLabel = [[UILabel alloc]init];
                _DeLabel.textColor = WhiteColor;
                _DeLabel.frame = CGRectMake(0, 30, ScreenWith/3 - 5, 40);
                _DeLabel.textAlignment = NSTextAlignmentCenter;
                _DeLabel.tag = 506 + 3*j + i;
               
               if (_SenceCount == 0) {
                   _SenceCount = 1;
               }
               NSString *textString;
               if ([DataHelp shareData].MeetingRnameArray.count != 0) {
                   NSString *Textstring = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%d%@",UserNameString,502 + 2 * j +i,[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingRnameArray[_SenceCount - 1]]]];
                   textString = Textstring;
                   
               }
               if (i + 3 * j < [DataHelp shareData].MeetingRnameArray.count && textString == nil) {
                   
                  _DeLabel.text = [DataHelp shareData].MeetingRnameArray[i + 3*j];
                   
               }else if (i + 3 * j < [DataHelp shareData].MeetingRnameArray.count && textString != nil){
                    _DeLabel.text = textString;
               }else{
//                   _DeLabel.text = Localized(@"无解码器");
               }
                [view addSubview:_DeLabel];
               
                _decomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 50, view.frame.size.height/2- 20, 90, 40)];
                _decomeLabel.textAlignment = NSTextAlignmentCenter;
                _decomeLabel.tag = 106+3*j+i+100;
                _decomeLabel.font = [UIFont systemFontOfSize:24];
                [view addSubview:_decomeLabel];

            }else if (self.NumberOfScreen == 4)
            {
                UIView *sixView = [[UIView alloc]init];
                sixView.frame = CGRectMake(4 + (((ScreenWith - 16)/4)*i + 2 * i), 4 + (((ScreenHeight - 16)/4)*j + 2 * j), (ScreenWith - 16)/4,  (ScreenHeight - 16)/4);
                sixView.backgroundColor = ScrollerColor;
                sixView.tag = 120+4*j+i;
                NSNumber *number = [NSNumber numberWithInteger:sixView.tag];
                [self.SenceTagArray addObject:number];
              
                UILongPressGestureRecognizer *TwoLong = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(TwoLongAction:)];
                UITapGestureRecognizer *FourTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RSetAction:)];
                FourTap.numberOfTapsRequired = 2;
                TwoLong.minimumPressDuration = 0.5;
                [sixView addGestureRecognizer:TwoLong];
                [sixView addGestureRecognizer:FourTap];
                [_BackScro addSubview:sixView];
                
                _DeLabel = [[UILabel alloc]init];
                _DeLabel.textColor = WhiteColor;
                _DeLabel.frame = CGRectMake(0, 30 , ScreenWith/4 - 5, 40);
                _DeLabel.textAlignment = NSTextAlignmentCenter;
                _DeLabel.tag = 520 + 4*j+i;
//                NSLog(@"%ld",sixView.tag);
                
                if (_SenceCount == 0) {
                    _SenceCount = 1;
                }
                
                NSString *textString;
                if ([DataHelp shareData].MeetingRnameArray.count != 0) {
                    NSString *Textstring = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%d%@",UserNameString,502 + 2 * j +i,[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingRnameArray[_SenceCount - 1]]]];
                    textString = Textstring;
                    
                }
            
                if (i + 4 * j < [DataHelp shareData].MeetingRnameArray.count && textString == nil) {
                    
                    _DeLabel.text = [DataHelp shareData].MeetingRnameArray[i + 4*j];
                }else if (i + 4 * j < [DataHelp shareData].MeetingRnameArray.count && textString != nil){
                    _DeLabel.text = textString;
                
                }else {
//                    _DeLabel.text = Localized(@"无解码器");
                }
                [sixView addSubview:_DeLabel];
        
                _decomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(sixView.frame.size.width/2 - 50, sixView.frame.size.height/2- 20, 90, 40)];
                _decomeLabel.textAlignment = NSTextAlignmentCenter;
                _decomeLabel.tag = 120+4*j+i+100;
                
                _decomeLabel.font = [UIFont systemFontOfSize:24];
                [sixView addSubview:_decomeLabel];
            }
      
        }
        
    }
        
 }
    
}


#pragma mark === R设置====
- (void)RSetAction:(UITapGestureRecognizer *)tap
{
    [DataHelp shareData].isViedeo = NO;
    [DataHelp shareData].TapTagNumber = tap.view.tag;
    NSInteger tagNumber = 30;
    if (_NumberOfScreen == 1) {
        if (tap.view.tag - 100 < [DataHelp shareData].MeetingRnameArray.count) {
            if (tap.state == UIGestureRecognizerStateEnded) {
                tagNumber = tap.view.tag - 100;
            }
        }
        
    }else if (_NumberOfScreen == 2)
    {
        if (tap.view.tag - 102 < [DataHelp shareData].MeetingRnameArray.count) {
            if (tap.state == UIGestureRecognizerStateEnded) {
                tagNumber = tap.view.tag - 102;
            }
        }

    }else if (_NumberOfScreen == 3)
    {
        if (tap.view.tag - 106 < [DataHelp shareData].MeetingRnameArray.count) {
            if (tap.state == UIGestureRecognizerStateEnded) {
                tagNumber = tap.view.tag - 106;
            }
        }

    }else if (_NumberOfScreen == 4)
    {
        if (tap.view.tag - 120 < [DataHelp shareData].MeetingRnameArray.count) {
            if (tap.state == UIGestureRecognizerStateEnded) {
                tagNumber = tap.view.tag - 120;
            }
        }
    }

    if (tagNumber != 30 ) {
        
        [DataHelp shareData].IsRDecoder = YES;
        [DataHelp shareData].isTdecore = NO;
        [DataHelp shareData].RCamerIndx = tagNumber;
        [DataHelp shareData].camerIndexName = [DataHelp shareData].MeetingRnameArray[tagNumber];
        [DataHelp shareData].ipString = [NSString stringWithFormat:@"%@",[DataHelp shareData].RIPArray[tagNumber]];
        UIView *bac = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        bac.tag = 550505;
        [self.view addSubview:bac];
        _CamearView = [CamerViewController new];
        _CamearView.Rindex = tagNumber;
        _CamearView.view.frame = CGRectMake(Width4SuperView * 0.3,Height4SuperView * 0.16, 580, 410);
//        _CamearView.view.center = self.view.center;
        [self addChildViewController:_CamearView];
        [self.view addSubview:_CamearView.view];
        
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"无解码器 不可操作");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            //            mbp.dimBackground = NO;
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
            
        });
    }
}

#pragma mark ===解码器位置选择=====
- (void)TwoLongAction:(UILongPressGestureRecognizer*)Long
{
    
//    NSLog(@"%ld",Long.view.tag);
    
//    if (_NumberOfScreen == 1) {
//        if (Long.view.tag - 100 < [DataHelp shareData].MeetingRnameArray.count) {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                [self LongViewTag:Long.view.tag];
//               
//            }
//  
//        }else
//        {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//            
//            [self showMessage];
//            }
//        }
//        
//    }else if (_NumberOfScreen == 2)
//    {
//        if (Long.view.tag - 102 < [DataHelp shareData].MeetingRnameArray.count) {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                [self LongViewTag:Long.view.tag];
//                
//            }
//        }else
//        {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                
//                [self showMessage];
//            }
//        }
//        
//        
//    }else if (_NumberOfScreen == 3)
//    {
//        if (Long.view.tag - 106 < [DataHelp shareData].MeetingRnameArray.count) {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                [self LongViewTag:Long.view.tag];
//                
//            }
//        }else
//        {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                
//                [self showMessage];
//            }
//        }
//        
//        
//    }else if (_NumberOfScreen == 4)
//    {
//        if (Long.view.tag - 120 < [DataHelp shareData].MeetingRnameArray.count) {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                [self LongViewTag:Long.view.tag];
//                
//            }
//        }else
//        {
//            if (Long.state == UIGestureRecognizerStateBegan) {
//                [self showMessage];
//            }
//        }
//    }
        }



- (void)showMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"无解码器，修改不可操作") message:Localized(@"继续使用") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:OAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)LongViewTag:(NSInteger)Tag
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"修改名称") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //textField.backgroundColor = [UIColor orangeColor];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        
    }];
    UIAlertAction *Cancle = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //取消将解码器选择位置返回原样
        UIView *view = (UIView *)[self.view viewWithTag:Tag];
        
        view.backgroundColor = ScrollerColor;
        
        UILabel *label = (UILabel *)[self.view viewWithTag:Tag+100 + 400];
        label.text = @"";
        
    }];
    
    UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *text = (UITextField *)alert.textFields.firstObject;
            UILabel *label = (UILabel *)[self.view viewWithTag:Tag + 400];
            label.text = text.text;
        
        NSString *string = [NSString stringWithFormat:@"%@%ld%@",UserNameString,(long)(Tag + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
        
        if (_NumberOfScreen == 1) {
            UIButton *button = (UIButton *)[self.view viewWithTag:Tag + 7899];
            [button setTitle:text.text forState:UIControlStateNormal];
            
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:Tag - 100 withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(Tag - 100 + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[Tag - 100]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];

            
        }else if (_NumberOfScreen == 2)
            
        {
                UIButton *button = (UIButton *)[self.view viewWithTag:Tag + 7897];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:Tag - 102 withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(Tag - 102 + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[Tag - 102]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
    
        }else if (_NumberOfScreen == 3)
        {
                UIButton *button = (UIButton *)[self.view viewWithTag:Tag + 7893];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:Tag - 106 withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(Tag - 106 + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[Tag - 106]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
           
        }else if (_NumberOfScreen == 4)
        {
                UIButton *button = (UIButton *)[self.view viewWithTag:Tag + 7879];
                [button setTitle:text.text forState:UIControlStateNormal];
                [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:Tag - 120 withObject:text.text];
                NSString *string = [NSString stringWithFormat:@"%@%ld%@%@",UserNameString,(long)(Tag - 120 + 400),[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingDestchanid[Tag - 120]]];
                [[NSUserDefaults standardUserDefaults]setObject:text.text forKey:string];
            }
    }];
    
    [alert addAction:Cancle];
    [alert addAction:Sure];
    [self presentViewController:alert animated:YES completion:nil];
    
}



/*
    //保存后的视图
- (void)CustomAfter
{
    _backRScreen = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_table.frame) + 2 , 65, Width4SuperView*0.83-7, Height4SuperView*0.63-6)];
    _backRScreen.layer.borderWidth = 0.3;
    _backRScreen.layer.borderColor = [UIColor blackColor].CGColor;
    _backRScreen.layer.cornerRadius = 3;
    _backRScreen.layer.masksToBounds = YES;
    _backRScreen.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_backRScreen];
 
    _BackScro = [[UIScrollView alloc]init];
    _BackScro.frame = CGRectMake(0, 0, Width4SuperView*0.83-7,Height4SuperView*0.63-6);
    _BackScro.contentSize = CGSizeMake(_BackScro.frame.size.width, _BackScro.frame.size.height);
    
    _BackScro.pagingEnabled = YES;
    _BackScro.backgroundColor = WhiteColor;
    //    _BackScro.delegate = self;
    _BackScro.userInteractionEnabled = YES;
    _BackScro.bounces = NO;
    [_backRScreen addSubview:_BackScro];
 
    UIView *Bacview = [[UIView alloc]init];
    Bacview.frame = CGRectMake(4, 4, ScreenWith - 8, ScreenHeight - 8);
    [_BackScro addSubview:Bacview];
    
        for (int i = 0 ; i < 30; i++) {
            for (int j = 0; j < 20; j++) {
                _Blueview = [[UIView alloc]initWithFrame:CGRectMake(2 + ((Bacview.frame.size.width)/30)*i , 2+((Bacview.frame.size.height) /20)*j ,_BackScro.frame.size.width/30 - 4, _BackScro.frame.size.height / 20 - 4)];
//                _Blueview.backgroundColor = [UIColor cyanColor];
                [Bacview addSubview:_Blueview];
            }
        }
    
    if ([DataHelp shareData].CustomeIsBool == YES && self.SenceBool == 0) {
        
        NSString *Key = [NSString stringWithFormat:@"%@arrayValue%ld",UserNameString,(long)_MeetingViewTag - 2999];
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:Key];
        _BackScro.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];

    for (int i = 0; i < array.count; i ++) {
    
    NSString *string1 = [NSString stringWithFormat:@"%@CustomMessage%ld",UserNameString,(long)_MeetingViewTag - 2999];
    
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:string1];
    NSNumber *number = array[i];
    NSInteger integer = number.integerValue;
    NSString *string = [NSString stringWithFormat:@"%@%ld",UserNameString,(long)integer];
    NSString *FrameStr = [dict objectForKey:string];
    CGRect rect = CGRectFromString(FrameStr);
    UIView *view = [[UIView alloc]init];
    view.frame =  rect;
    
        int MeetingCount = (int)(_MeetingViewTag - 2999);
        
        [CustomData CreatSenceTable];
        [CustomData SelectName:UserNameString Meeting:MeetingCount CustomRct:FrameStr];
       
    CGFloat width = view.frame.size.width;
    NSNumber *Widthnumber = [NSNumber numberWithFloat:width];
    [_WidthCountArray addObject:Widthnumber];
    
    CGFloat height = view.frame.size.height;
    NSNumber *HeightNumber = [NSNumber numberWithFloat:height];
    [_HeightArray addObject:HeightNumber];
    
    CGFloat x = view.frame.origin.x;
    NSNumber *Xnumber = [NSNumber numberWithFloat:x];
    [_OrgionX addObject:Xnumber];
    
    CGFloat y = view.frame.origin.y;
    NSNumber *YNumber = [NSNumber numberWithFloat:y];
    [_OrigionY addObject:YNumber];
    
    view.backgroundColor = [UIColor orangeColor];
    [Bacview addSubview:view];

        UILabel *Namelabe = [[UILabel alloc]init];
        Namelabe.frame = CGRectMake(0, view.frame.size.height/3, view.frame.size.width, view.frame.size.height/3);
        NSString *Namestring = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@RNameData",UserNameString]];
        NSString *LabelTag = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@tagNumber",UserNameString]];
        Namelabe.text = Namestring;
        Namelabe.tag = LabelTag.integerValue;
        Namelabe.textAlignment = NSTextAlignmentCenter;
        [view addSubview:Namelabe];
    }
        }

}

*/

//滚动视图的代理事件 R输出视屏的
#pragma mark === 滚动视图的代理事件====
/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.ScrollerCurrentIndex = self.BackScro.contentOffset.x/self.view.frame.size.width;
   
    if (self.ScrollerCurrentIndex <= 1 && self.ScrollerCurrentIndex > 0 ) {
        self.ScrollerCurrentIndex = 1;
    }else if (self.ScrollerCurrentIndex > 1){
        self.ScrollerCurrentIndex = self.ScrollerCurrentIndex+1;
        
    }else
    {
        self.ScrollerCurrentIndex = 0;
    }
//    self.BackScro.backgroundColor = [UIColor yellowColor];
}
 */
#pragma mark ===分屏点击事件======
//1分屏按钮
- (void)OneButtonAction:(UIButton *)OneButton
{
    if (self.NumberOfScreen == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"当前已经是你想要的屏幕了") message:Localized(@"继续使用") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    
        [alert addAction:action];
        [alert addAction:OAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        
        for (int i = 0; i<_PanviewTag; i++) {
            UIView *view = (UIView *)[self.view viewWithTag:10001+i];
            [view removeFromSuperview];
        }
        UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
        UIImage *OneImage = [UIImage imageNamed:@"SeleOne@2x"];
        OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [OneButton setImage:OneImage forState:UIControlStateNormal];
        
        UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
        UIImage *FourImage = [UIImage imageNamed:@"Two@2x"];
        FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fourButton setImage:FourImage forState:UIControlStateNormal];
        
        UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
        UIImage *NineImage = [UIImage imageNamed:@"Three@2x"];
        NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Ninebutton setImage:NineImage forState:UIControlStateNormal];
        
        UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
        UIImage *SixImage = [UIImage imageNamed:@"Four@2x"];
        SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [SixButton setImage:SixImage forState:UIControlStateNormal];
        
        UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
        UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
        CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [custombutton setImage:CustomImage forState:UIControlStateNormal];
        
        if (_iscustom == YES) {
            UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
            [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
            _iscustom = NO;
        }
        
        [_RectValue removeAllObjects];
        [_CustomTagNumber removeAllObjects];
        [_CustomRname removeAllObjects];
        [_CustomDesc removeAllObjects];
        [_CustomDesv removeAllObjects];
        
        UIView *shut = (UIView *)[self.view viewWithTag:799];
        [shut removeFromSuperview];
        [_ViewtagArray removeAllObjects];
        [_ViewRectArray removeAllObjects];
        [_TLinkTagArray removeAllObjects];
        [_RNameArray removeAllObjects];
        [_DesVidArray removeAllObjects];
        [_DeschArray removeAllObjects];
        self.PanviewTag = 0;
        
        //改变分屏样式移除数组的值
        [self.SenceTagArray removeAllObjects];
        [DataHelp shareData].CustomeIsBool = NO;
        self.NumberOfScreen = 1;
        [_backRScreen removeFromSuperview];
        [_BackScro removeFromSuperview];
        [_BackBlue removeFromSuperview];
    
        for (int i = 0; i < _ViewtagArray.count; i++) {
            NSNumber *TagNumber = _ViewtagArray[i];
            NSInteger TagInteger = TagNumber.integerValue;
            UIView *Tagview = (UIView *)[self.view viewWithTag:TagInteger];
            [Tagview removeFromSuperview];
        }
        
        [self BakeForRScreen];
        
            //移除视图后移除数组元素
        [self.MoveViewArray removeAllObjects];
        
    }
}

//四分屏事件
- (void)FourButtonAction:(UIButton *)OneButton
{
    if (self.NumberOfScreen == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"当前已经是你想要的屏幕了") message:Localized(@"继续使用") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:OAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
       
        for (int i = 0; i<_PanviewTag; i++) {
            UIView *view = (UIView *)[self.view viewWithTag:10001+i];
            [view removeFromSuperview];
        }
        
        UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
        UIImage *OneImage = [UIImage imageNamed:@"One@2x"];
        OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [OneButton setImage:OneImage forState:UIControlStateNormal];
        
        UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
        UIImage *FourImage = [UIImage imageNamed:@"SeleTwo@2x"];
        FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fourButton setImage:FourImage forState:UIControlStateNormal];
        
        UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
        UIImage *NineImage = [UIImage imageNamed:@"Three@2x"];
        NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Ninebutton setImage:NineImage forState:UIControlStateNormal];
        
        UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
        UIImage *SixImage = [UIImage imageNamed:@"Four@2x"];
        SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [SixButton setImage:SixImage forState:UIControlStateNormal];
        
        UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
        UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
        CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [custombutton setImage:CustomImage forState:UIControlStateNormal];
        
        if (_iscustom == YES) {
            UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
            [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
            _iscustom = NO;
        }
        
        [_RectValue removeAllObjects];
        [_CustomTagNumber removeAllObjects];
        [_CustomRname removeAllObjects];
        [_CustomDesc removeAllObjects];
        [_CustomDesv removeAllObjects];
        
        
        UIView *shut = (UIView *)[self.view viewWithTag:799];
        [shut removeFromSuperview];
            //分屏改变移除数组元素
        [_ViewtagArray removeAllObjects];
        [_ViewRectArray removeAllObjects];
        [_TLinkTagArray removeAllObjects];
        [_RNameArray removeAllObjects];
        [_DesVidArray removeAllObjects];
        [_DeschArray removeAllObjects];
        
        self.PanviewTag = 0;
        
        [self.SenceTagArray removeAllObjects];
        self.NumberOfScreen = 2;
        [_backRScreen removeFromSuperview];
        [_BackScro removeFromSuperview];
        [_BackBlue removeFromSuperview];
        
        
        
        [DataHelp shareData].CustomeIsBool = NO;
        
        for (int i = 0; i < _ViewtagArray.count; i++) {
            NSNumber *TagNumber = _ViewtagArray[i];
            NSInteger TagInteger = TagNumber.integerValue;
            UIView *Tagview = (UIView *)[self.view viewWithTag:TagInteger];
            [Tagview removeFromSuperview];
        }
        
        [self BakeForRScreen];

        //移除视图后移除数组元素
        [self.MoveViewArray removeAllObjects];
    }
   
}

//九分屏事件
- (void)NineButtonAction:(UIButton *)OneButton
{
    if (self.NumberOfScreen == 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"当前已经是你想要的屏幕了") message:Localized(@"继续使用") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:OAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        for (int i = 0; i<_PanviewTag; i++) {
            UIView *view = (UIView *)[self.view viewWithTag:10001+i];
            [view removeFromSuperview];
        }
       
        UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
        UIImage *OneImage = [UIImage imageNamed:@"One@2x"];
        OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [OneButton setImage:OneImage forState:UIControlStateNormal];
        
        UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
        UIImage *FourImage = [UIImage imageNamed:@"Two@2x"];
        FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fourButton setImage:FourImage forState:UIControlStateNormal];
        
        UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
        UIImage *NineImage = [UIImage imageNamed:@"SeleThree@2x"];
        NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Ninebutton setImage:NineImage forState:UIControlStateNormal];
                
        UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
        UIImage *SixImage = [UIImage imageNamed:@"Four@2x"];
        SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [SixButton setImage:SixImage forState:UIControlStateNormal];
        
        UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
        UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
        CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [custombutton setImage:CustomImage forState:UIControlStateNormal];
        
        if (_iscustom == YES) {
            UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
            [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
            _iscustom = NO;
        }
        
        [_RectValue removeAllObjects];
        [_CustomTagNumber removeAllObjects];
        [_CustomRname removeAllObjects];
        [_CustomDesc removeAllObjects];
        [_CustomDesv removeAllObjects];
        
        
        UIView *shut = (UIView *)[self.view viewWithTag:799];
        [shut removeFromSuperview];
        
        //分屏改变移除数组元素
        [_ViewtagArray removeAllObjects];
        [_ViewRectArray removeAllObjects];
        [_TLinkTagArray removeAllObjects];
        [_RNameArray removeAllObjects];
        [_DesVidArray removeAllObjects];
        [_DeschArray removeAllObjects];
        self.PanviewTag = 0;
        
        [self.SenceTagArray removeAllObjects];
        self.NumberOfScreen = 3;
        [_backRScreen removeFromSuperview];
        [_BackScro removeFromSuperview];
        [_BackBlue removeFromSuperview];
        
        for (int i = 0; i < _ViewtagArray.count; i++) {
            NSNumber *TagNumber = _ViewtagArray[i];
            NSInteger TagInteger = TagNumber.integerValue;
            UIView *Tagview = (UIView *)[self.view viewWithTag:TagInteger];
            [Tagview removeFromSuperview];
        }
        
        
        [DataHelp shareData].CustomeIsBool = NO;
        [self BakeForRScreen];

        //移除视图后移除数组元素
        [self.MoveViewArray removeAllObjects];
    }
}

//十六分屏事件
- (void)sixthButtonAction:(UIButton *)OneButton
{
    if (self.NumberOfScreen == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"当前已经是你想要的屏幕了") message:Localized(@"继续使用") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:OAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        for (int i = 0; i<_PanviewTag; i++) {
            UIView *view = (UIView *)[self.view viewWithTag:10001+i];
            [view removeFromSuperview];
        }
        
        
        UIButton *OneButton = (UIButton *)[self.view viewWithTag:1009];
        UIImage *OneImage = [UIImage imageNamed:@"One@2x"];
        OneImage = [OneImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [OneButton setImage:OneImage forState:UIControlStateNormal];
        
        UIButton *fourButton = (UIButton *)[self.view viewWithTag:1010];
        UIImage *FourImage = [UIImage imageNamed:@"Two@2x"];
        FourImage = [FourImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fourButton setImage:FourImage forState:UIControlStateNormal];
        
        UIButton *Ninebutton = (UIButton *)[self.view viewWithTag:1011];
        UIImage *NineImage = [UIImage imageNamed:@"Three@2x"];
        NineImage = [NineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Ninebutton setImage:NineImage forState:UIControlStateNormal];
        
        UIButton *SixButton = (UIButton *)[self.view viewWithTag:1012];
        UIImage *SixImage = [UIImage imageNamed:@"SeleFour@2x"];
        SixImage = [SixImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [SixButton setImage:SixImage forState:UIControlStateNormal];
        
        UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
        UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
        CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [custombutton setImage:CustomImage forState:UIControlStateNormal];
        
        if (_iscustom == YES) {
            UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
            [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
            _iscustom = NO;
        }
       
        [_RectValue removeAllObjects];
        [_CustomTagNumber removeAllObjects];
        [_CustomRname removeAllObjects];
        [_CustomDesc removeAllObjects];
        [_CustomDesv removeAllObjects];
        
        self.PanviewTag = 0;
        UIView *shut = (UIView *)[self.view viewWithTag:799];
        [shut removeFromSuperview];
        //分屏改变移除数组元素
        [_ViewtagArray removeAllObjects];
        [_ViewRectArray removeAllObjects];
        [_TLinkTagArray removeAllObjects];
        [_RNameArray removeAllObjects];
        [_DesVidArray removeAllObjects];
        [_DeschArray removeAllObjects];
     
        [self.SenceTagArray removeAllObjects];
        [DataHelp shareData].CustomeIsBool = NO;
    self.NumberOfScreen = 4;
        
    [_backRScreen removeFromSuperview];
    [_BackScro removeFromSuperview];
    [_BackBlue removeFromSuperview];
     
        for (int i = 0; i < _ViewtagArray.count; i++) {
            NSNumber *TagNumber = _ViewtagArray[i];
            NSInteger TagInteger = TagNumber.integerValue;
            UIView *Tagview = (UIView *)[self.view viewWithTag:TagInteger];
            [Tagview removeFromSuperview];
        }
      
    [self BakeForRScreen];
        //移除视图后移除数组元素
        [self.MoveViewArray removeAllObjects];
    }
}

#pragma mark ===保存应用自定义布局===
    //保存应用场景事件
- (void)SaveSenceAction:(UIButton *)button
{
    
    if (_SenceBool == 1  && [DataHelp shareData].CustomeIsBool == YES && _CustomTagNumber.count > 0 ) {
//        保存场景并进行布局与保存数据
        UIView *shut = (UIView *)[self.view viewWithTag:799];
        [shut removeFromSuperview];
        _SenceBool = 0;
          self.SaveOrNo = 1;
        _DeletedPanView = 0;
        self.DecomeNumber = 0;
            NSString *string = [NSString stringWithFormat:@"%@CustomMessage%@",UserNameString,[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[_MeetingViewTag - 3000][@"name"]]];
            
            UIView *view = (UIView *)[self.view viewWithTag:110];
            [view removeFromSuperview];
            
            [[NSUserDefaults standardUserDefaults]setObject:_CustomMutDict forKey:string];
            [_CustomMutDict removeAllObjects];
            [self imageView:[UIApplication sharedApplication].keyWindow atFrame:CGRectMake(CGRectGetMaxX(_table.frame) + 2,CGRectGetMaxY(_BackView.frame) + 2,Width4SuperView - Width4SuperView *0.15 - 4,Height4SuperView * 0.61 + 28)];
            
            //回调sence
            [_backRScreen removeFromSuperview];
//            NSString *countString = [NSString stringWithFormat:@"%ld",(long)_MeetingViewTag - 2999];
//            [[NSUserDefaults standardUserDefaults]setObject:countString forKey:[NSString stringWithFormat:@"%@SenceCount",UserNameString]];
            NSString *ArrayKey = [NSString stringWithFormat:@"%@arrayValue%@",UserNameString,[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[_MeetingViewTag - 3000][@"name"]]];
            
            [[NSUserDefaults standardUserDefaults]setObject:_CustomTagNumber forKey:ArrayKey];
//            [[DataHelp shareData].SenceCountView removeAllObjects];
            self.NumberOfScreen = 1;
        
        for (int i = 0; i < _RectValue.count;i++) {
            NSNumber *Rectnumber = _RectValue[i];
            NSNumber *cusTagNumber = _CustomTagNumber[i];
            NSNumber *customRname = _CustomRname[i];
            NSNumber *customDesc = _CustomDesc[i];
            NSNumber *customdev = _CustomDesv[i];
            NSString *Rectstring = [NSString stringWithFormat:@"%@",Rectnumber];
            NSInteger tagNUmber = cusTagNumber.integerValue;
            NSString *Rname = [NSString stringWithFormat:@"%@",customRname];
            NSString *desc = [NSString stringWithFormat:@"%@",customDesc];
            NSString *desv = [NSString stringWithFormat:@"%@",customdev];
            NSInteger MeetingTag = _MeetingViewTag - 3000;
            NSString *MeetingName = [NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[MeetingTag][@"name"]];
            [CustomData CreatSenceTable];
            [CustomData InsertIntoUserName:UserNameString Meeting:MeetingName ViewDict:Rectstring tagNumber:(int)tagNUmber RName:Rname destchanid:desv destdevid:desc];
        }
            [[NSUserDefaults standardUserDefaults]setObject:_RectValue forKey:[NSString stringWithFormat:@"%@RectValueInert%ld",UserNameString,(long)(_MeetingViewTag - 3000)]];
            [[NSUserDefaults standardUserDefaults]setObject:_XCountArray forKey:[NSString stringWithFormat:@"%@XCountArray%@",UserNameString,[DataHelp shareData].LocationArray[(_MeetingViewTag - 3000)][@"name"]]];
            [[NSUserDefaults standardUserDefaults]setObject:_YcountArray forKey:[NSString stringWithFormat:@"%@YcountArray%@",UserNameString,[DataHelp shareData].LocationArray[(_MeetingViewTag - 3000)][@"name"]]];
        
            [_XCountArray removeAllObjects];
            [_YcountArray removeAllObjects];
            _SaveUse = YES;
            [DataHelp shareData].CustomeIsBool = YES;
        
        self.DecomeNumber = 0;
//        [self CustomAfter];
//        _ReRectArr = [_RectValue mutableCopy];
            [_RectValue removeAllObjects];
            [_CustomTagNumber removeAllObjects];
            [_CustomRname removeAllObjects];
            [_CustomDesc removeAllObjects];
            [_CustomDesv removeAllObjects];
      
        
            NSNotification *notiCenter =[NSNotification notificationWithName:@"ViewName" object:nil];
            [self SetValueAction:notiCenter];
    }else
    
    {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"操作有误") message:Localized(@"未进行自定义不可操作")  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        }];
            [alert addAction:Action];
            [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark ==自定义分屏事件=====
//@"解码器"
- (void)CustomButtonAction
{
    for (UIView *view in [_backRScreen subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 1; i <= self.PanviewTag; i++) {
        UIView *TReview  = (UIView *)[self.view viewWithTag:10000 + i];
        [TReview removeFromSuperview];
    }
    
    
    for (int i= 0 ;i < [DataHelp shareData].MeetingRnameArray.count ; i++) {
        NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%d%@%@",UserNameString,400+i,[NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingName],[DataHelp shareData].MeetingDestchanid[i]]];
        if (string != nil) {
            [[DataHelp shareData].MeetingRnameArray replaceObjectAtIndex:i withObject:string];
        }
    }
    
    UIView *ShutterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width4SuperView *0.15,CGRectGetHeight(_table.frame) - 15)];
        ShutterView.tag = 799;
        [self.view addSubview:ShutterView];

        [DataHelp shareData].CustomeIsBool = YES;
        [_CustomMutDict removeAllObjects];
        _SenceBool = 1;
        _NumberOfScreen = 5;
        [_BackScro removeFromSuperview];
        [_backRScreen removeFromSuperview];
        _backRScreen = [[UIView alloc]init];
    
        _backRScreen.layer.borderWidth = 0.3;
        _backRScreen.layer.borderColor = [UIColor blackColor].CGColor;
        _backRScreen.backgroundColor = [UIColor orangeColor];
        _backRScreen.layer.cornerRadius = 3;
        _backRScreen.layer.masksToBounds = YES;
    [self.view addSubview:_backRScreen];
    [_backRScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BackView.mas_bottom).with.offset(2);
        make.left.equalTo(_table.mas_right).with.offset(2);
        make.right.equalTo(self.view.mas_right).with.offset(-2);
        make.height.mas_equalTo(CGRectGetHeight(_table.frame) - 15);
    }];
        _BackScro = [[UIView alloc]init];
        _BackScro.frame = CGRectMake(0, 0, Width4SuperView - Width4SuperView*0.15 - 4,CGRectGetHeight(_table.frame) - 15);
//    _BackScro.contentSize = CGSizeMake(_BackScro.frame.size.width, _BackScro.frame.size.height);
        _BackScro.backgroundColor = ScrollerColor;
//    _BackScro.pagingEnabled = YES;
        _BackScro.userInteractionEnabled = YES;
//    _BackScro.bounces = NO;
        [_backRScreen addSubview:_BackScro];
    for (int i = 0; i < _MoveViewArray.count; i++) {
        NSNumber *number = _MoveViewArray[i];
        NSInteger integer = number.integerValue;
        UIView *view = (UIView *)[self.view viewWithTag:integer];
        [view removeFromSuperview];
        [_move removeFromParentViewController];
    }
    
    _CustomView = [UIView new];
    _CustomView.frame = CGRectMake(4, 4,ScreenWith - 8, ScreenHeight - 8);
    _CustomView.backgroundColor = ScrollerColor;
//    _CustomView.backgroundColor = [UIColor orangeColor];
    [_BackScro addSubview:_CustomView];
    for (int i = 0 ; i < 30; i++) {
        for (int j = 0; j < 20; j++) {
            _Blueview = [[UIView alloc]initWithFrame:CGRectMake(2 + (_CustomView.frame.size.width/30)*i , 2+(_CustomView.frame.size.height /20)*j ,_CustomView.frame.size.width/30 - 4, _CustomView.frame.size.height / 20 - 4)];
//            _Blueview.backgroundColor = [UIColor cyanColor];
            [_CustomView addSubview:_Blueview];
        }
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        view.backgroundColor = CusstomLabelColor;
    UIPanGestureRecognizer *Labelpan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(LabelPanAction:)];
        view.tag = 110;
        [view addGestureRecognizer:Labelpan];
        [_CustomView addSubview:view];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 120,60)];
        label.text = [DataHelp shareData].MeetingRnameArray[0];
        label.numberOfLines = 0;
        label.textColor = CustomPancolor;
//    CGSize commandbuttonsize = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
//    [view setFrame:CGRectMake(0,0, commandbuttonsize.width, 100)];
//    [label setFrame:CGRectMake(0,30, commandbuttonsize.width, 30)];
    
//    label.numberOfLines = 2;
        label.tag = 998;
        label.backgroundColor = CusstomLabelColor;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        _NumberOfScreen = 5;
    
}
//自定义选择解码器的位置平移事件
- (void)LabelPanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan)
    {
         if ([DataHelp shareData].MeetingRnameArray.count != 0 ) {
        
        if  (self.DecomeNumber < [DataHelp shareData].MeetingRnameArray.count) {
            self.DecomeNumber++;
            UILabel *label = [self.view viewWithTag:998];
            UIView *Decomeview = [self.view viewWithTag:110];
            if (_DecomeNumber < [DataHelp shareData].MeetingRnameArray.count) {
                 label.text = [DataHelp shareData].MeetingRnameArray[self.DecomeNumber];
                label.textColor = CustomPancolor;
            }else
            {
                label.text = Localized(@"无解码器");
            }
//            CGSize commandbuttonsize = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
//            [Decomeview setFrame:CGRectMake(0, 0,commandbuttonsize.width, 100)];
//            [label setFrame:CGRectMake(0,30, commandbuttonsize.width, 30)];
            
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16 )];
        view.backgroundColor = CusstomLabelColor;
        UIPanGestureRecognizer *RebuildPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(RebuildpanAction:)];
        RebuildPanGesture.delegate = self;
        //长按手势
        UILongPressGestureRecognizer *CustomGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(CustomLongAction:)];
        CustomGesture.minimumPressDuration = 1.5;
        CustomGesture.delegate = self;
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(PinchAction:)];
            UISwipeGestureRecognizer *swipeGesture;
        swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeAction:)];
        [RebuildPanGesture requireGestureRecognizerToFail:swipeGesture];
        swipeGesture.numberOfTouchesRequired = 1;
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        swipeGesture.delegate = self;
        pinchGesture.delegate = self;
//        [view addGestureRecognizer:swipeGesture];
        swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeAction:)];
            [RebuildPanGesture requireGestureRecognizerToFail:swipeGesture];
            swipeGesture.numberOfTouchesRequired = 1;
            swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//            [view addGestureRecognizer:swipeGesture];
            
            swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeAction:)];
            [RebuildPanGesture requireGestureRecognizerToFail:swipeGesture];
            swipeGesture.numberOfTouchesRequired = 1;
            swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
//            [view addGestureRecognizer:swipeGesture];
            
            swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeAction:)];
            [RebuildPanGesture requireGestureRecognizerToFail:swipeGesture];
            swipeGesture.numberOfTouchesRequired = 1;
            swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
//         [view addGestureRecognizer:swipeGesture];
//        [view addGestureRecognizer:pinchGesture];
            view.tag = 2324 + self.DecomeNumber;
            [view addGestureRecognizer:RebuildPanGesture];
    
            
        [self.CustomView addSubview:view];
        UILabel *CLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30,view.frame.size.width, 30)];
            CLabel.text = [DataHelp shareData].MeetingRnameArray[self.DecomeNumber - 1];
            CLabel.textColor = CustomPancolor;
            CLabel.textAlignment = NSTextAlignmentCenter;
//            Label.tag =
            
            [CLabel adjustsFontSizeToFitWidth];
            [view addSubview:CLabel];
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:Localized(@"解码器达到上限不可在编辑") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
          
            [alert addAction:Action];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
        }else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:Localized(@"当前无解码器") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:Action];
            [self presentViewController:alert animated:YES completion:nil];
            
//            return;
            
            
        }
 
        
    }else if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.DecomeNumber < [DataHelp shareData].MeetingRnameArray.count + 1) {
            
        UIView *view = (UIView *)[self.view viewWithTag:2324+self.DecomeNumber];
        CGPoint p1 = [pan translationInView:view];
        view.transform  = CGAffineTransformTranslate(view.transform,p1.x,p1.y);
        [pan setTranslation:CGPointZero inView:view];
        
        self.DecomeOrigionX = view.frame.origin.x;
        self.DecomeOrigionY = view.frame.origin.y;
      
             }
    }else if (pan.state == UIGestureRecognizerStateEnded)
    {
        
        if (_DeleNumber < [DataHelp shareData].MeetingRnameArray.count) {
        
        
        int currentViewXCount = self.DecomeOrigionX /(_CustomView.frame.size.width/30 - 4 * (self.DecomeOrigionX/_CustomView.frame.size.width/30));
        int currentViewYCount = self.DecomeOrigionY / (_CustomView.frame.size.height / 20 - 4*(self.DecomeOrigionY/_CustomView.frame.size.height/20));
        CGFloat currentX = self.DecomeOrigionX / (_CustomView.frame.size.width/30 - 4 * (self.DecomeOrigionX/_CustomView.frame.size.width/30));
        CGFloat currentY = self.DecomeOrigionY / (_CustomView.frame.size.height / 20 - 4 *(self.DecomeOrigionY/_CustomView.frame.size.height/20));
      
        UIView *view = (UIView *)[self.view viewWithTag:2324 + self.DecomeNumber];
        if (view.frame.origin.x < 0 || (view.frame.origin.x + view.frame.size.width) > _backRScreen.frame.size.width ||view.frame.origin.y < 0 || (view.frame.origin.y + view.frame.size.height) > _backRScreen.frame.size.height) {

            [view removeFromSuperview];
            
            _DeletedPanView++;
    
        }else{
          
            if (currentX - currentViewXCount > 0.5 && currentY - currentViewYCount > 0.5) {
                
                int Xinteger = currentViewXCount + 1;
                int Yinteger = currentViewYCount + 1;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                
                CGPoint point = CGPointMake((view.frame.origin.x + view.frame.size.width)/2, (view.frame.origin.y + view.frame.size.height)/2);
                [_CustomCenter addObject:NSStringFromCGPoint(point)];
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                
                NSString *str = NSStringFromCGRect(Inrect);
                
                NSMutableArray *mut = [NSMutableArray array];
                
                [mut addObject:str];
                
                NSString *DictKey = [NSString stringWithFormat:@"%ld",(long)view.tag];
                
                NSString *dictValue = NSStringFromCGRect(Inrect);
                
                [_CustomMutDict setValue:dictValue forKey:DictKey];
                NSString *desc = [DataHelp shareData].MeetingDestchanid[self.DecomeNumber - 1];
                NSString *desv = [DataHelp shareData].MeetingDestdevid[self.DecomeNumber - 1];
                
                int integer = (int)(2324 + self.DecomeNumber);
                
//                [_CustomCenter addObject:]
                [_RectValue addObject:dictValue];
                [_CustomTagNumber addObject:[NSNumber numberWithInteger:integer]];
                [_CustomRname addObject:[DataHelp shareData].MeetingRnameArray[self.DecomeNumber - 1]];
                [_CustomDesc addObject:desc];
                [_CustomDesv addObject:desv];
                [_XCountArray addObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray addObject:[NSNumber numberWithInt:Yinteger]];
                
                NSLog(@"1");
                
            }else if (currentX - currentViewXCount > 0.5 && currentY - currentViewYCount < 0.5)
            {
                int Xinteger = currentViewXCount + 1;
                int Yinteger = currentViewYCount;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);

//                  NSLog(@"%@",NSStringFromCGPoint(view.center));
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                
                NSString *str = NSStringFromCGRect(Inrect);
                
                NSMutableArray *mut = [NSMutableArray array]; 
                
                [mut addObject:str];

            
                NSString *DictKey = [NSString stringWithFormat:@"%ld",(long)view.tag];
                
                NSString *dictValue = NSStringFromCGRect(Inrect);
                
                [_CustomMutDict setValue:dictValue forKey:DictKey];
                
                NSString *desc = [DataHelp shareData].MeetingDestchanid[self.DecomeNumber - 1];
                NSString *desv = [DataHelp shareData].MeetingDestdevid[self.DecomeNumber - 1];
                
                int integer = (int)(2324 + self.DecomeNumber);
                
                CGPoint point = CGPointMake((view.frame.origin.x + view.frame.size.width)/2, (view.frame.origin.y + view.frame.size.height)/2);
                [_CustomCenter addObject:NSStringFromCGPoint(point)];
                
                [_RectValue addObject:dictValue];
                [_CustomTagNumber addObject:[NSNumber numberWithInteger:integer]];
                [_CustomRname addObject:[DataHelp shareData].MeetingRnameArray[self.DecomeNumber - 1]];
                [_CustomDesc addObject:desc];
                [_CustomDesv addObject:desv];
                
                [_XCountArray addObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray addObject:[NSNumber numberWithInt:Yinteger]];
                 NSLog(@"2");
            }else if (currentX - currentViewXCount < 0.5 && currentY - currentViewYCount < 0.5)
            {
                int Xinteger = currentViewXCount;
                int Yinteger = currentViewYCount;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                

                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
               
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                
                NSString *str = NSStringFromCGRect(Inrect);
                
                NSMutableArray *mut = [NSMutableArray array];

                [mut addObject:str];
                
                NSString *DictKey = [NSString stringWithFormat:@"%ld",(long)view.tag];
                
                NSString *dictValue = NSStringFromCGRect(Inrect);
                
                [_CustomMutDict setValue:dictValue forKey:DictKey];
                
                NSString *desc = [DataHelp shareData].MeetingDestchanid[self.DecomeNumber - 1];
                NSString *desv = [DataHelp shareData].MeetingDestdevid[self.DecomeNumber - 1];
                
                int integer = (int)(2324 + self.DecomeNumber);
                CGPoint point = CGPointMake((view.frame.origin.x + view.frame.size.width)/2, (view.frame.origin.y + view.frame.size.height)/2);
                [_CustomCenter addObject:NSStringFromCGPoint(point)];
                [_RectValue addObject:dictValue];
                [_CustomTagNumber addObject:[NSNumber numberWithInteger:integer]];
                [_CustomRname addObject:[DataHelp shareData].MeetingRnameArray[self.DecomeNumber - 1]];
                [_CustomDesc addObject:desc];
                [_CustomDesv addObject:desv];
                
                [_XCountArray addObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray addObject:[NSNumber numberWithInt:Yinteger]];
                 NSLog(@"3");
            }else if (currentX - currentViewXCount < 0.5 && currentY - currentViewYCount > 0.5)
            {
                int Xinteger = currentViewXCount;
                int Yinteger = currentViewYCount + 1;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                
//                  NSLog(@"%@",NSStringFromCGPoint(view.center));
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
            
                NSString *str = NSStringFromCGRect(Inrect);
                
                NSMutableArray *mut = [NSMutableArray array];
                
                [mut addObject:str];
//                 NSLog(@"======%@",NSStringFromCGPoint(view.center));
                NSString *DictKey = [NSString stringWithFormat:@"%ld",(long)view.tag];
              
                NSString *dictValue = NSStringFromCGRect(Inrect);
                
                [_CustomMutDict setValue:dictValue forKey:DictKey];
                
                NSString *desc = [DataHelp shareData].MeetingDestchanid[self.DecomeNumber - 1];
                NSString *desv = [DataHelp shareData].MeetingDestdevid[self.DecomeNumber - 1];
                
                int integer = (int)(2324 + self.DecomeNumber);
                CGPoint point = CGPointMake((view.frame.origin.x + view.frame.size.width)/2, (view.frame.origin.y + view.frame.size.height)/2);
                [_CustomCenter addObject:NSStringFromCGPoint(point)];
                [_RectValue addObject:dictValue];
                [_CustomTagNumber addObject:[NSNumber numberWithInteger:integer]];
                [_CustomRname addObject:[DataHelp shareData].MeetingRnameArray[self.DecomeNumber - 1]];
                [_CustomDesc addObject:desc];
                [_CustomDesv addObject:desv];
                
                
                [_XCountArray addObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray addObject:[NSNumber numberWithInt:Yinteger]];
                NSLog(@"4");
            }
    
        }
        
    }

    }
}


- (void)SwipeAction:(UISwipeGestureRecognizer *)Swipe
{
    UIView *SwipeView = (UIView *)Swipe.view;
    
    if (Swipe.state == UIGestureRecognizerStateBegan) {
        
    }else if (Swipe.state  ==  UIGestureRecognizerStateChanged) {

        CGPoint point = [Swipe locationInView:SwipeView];
 
    }else if (Swipe.state == UIGestureRecognizerStateEnded)
    {
        
    }

    if (Swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        SwipeView.frame = CGRectMake(SwipeView.frame.origin.x, SwipeView.frame.origin.y, SwipeView.frame.size.width+(_Blueview.frame.size.width + 4), SwipeView.frame.size.height);
    }else if (Swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        SwipeView.frame = CGRectMake(SwipeView.frame.origin.x, SwipeView.frame.origin.y, SwipeView.frame.size.width-(_Blueview.frame.size.width + 4), SwipeView.frame.size.height);
    }else if (Swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        SwipeView.frame = CGRectMake(SwipeView.frame.origin.x, SwipeView.frame.origin.y, SwipeView.frame.size.width, SwipeView.frame.size.height + (_Blueview.frame.size.width + 4));
    }else if (Swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        SwipeView.frame = CGRectMake(SwipeView.frame.origin.x, SwipeView.frame.origin.y, SwipeView.frame.size.width, SwipeView.frame.size.height - (_Blueview.frame.size.width + 4));
    }
    
    
    
    }


- (void)CustomLongAction:(UILongPressGestureRecognizer *)action
{
    if (action.state == UIGestureRecognizerStateEnded) {
//        UIView *view = (UIView *)[self.view viewWithTag:action.view.tag];
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:Localized(@"删除场景") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"删除") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        }];
        //
        [alert addAction:Action];
        [alert addAction:Sure];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

//手势的代理事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}
//缩放手势事件
- (void)PinchAction:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateChanged) {
    
        UIView *view = (UIView *)pinch.view;
//        CGFloat with = view.frame.size.width * pinch.scale;
//        CGFloat Height = view.frame.size.height * pinch.scale;
    }else if (pinch.state == UIGestureRecognizerStateEnded) {
        
        UIView *view = (UIView *)pinch.view;
        NSString *KeyString = [NSString stringWithFormat:@"%ld",pinch.view.tag];
        NSString *valueString = NSStringFromCGRect(view.frame);
        [_CustomMutDict setObject:valueString forKey:KeyString];
    }
}

 //创建后的解码器平移事件
- (void)RebuildpanAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan)
    {
       
        
    }else if (pan.state == UIGestureRecognizerStateChanged)
    {
        UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
        CGFloat XCount = view.frame.origin.x;
        CGFloat YCount = view.frame.origin.y;
        CGFloat With = view.frame.size.width;
        CGFloat Height = view.frame.size.height;
        self.DecomeOrigionX = view.frame.origin.x;
        self.DecomeOrigionY = view.frame.origin.y;
        if (XCount + With <= _CustomView.frame.size.width) {
            
        CGPoint point = [pan translationInView:view];
        view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
        [pan setTranslation:CGPointZero inView:view];
        }else
        {
           pan.cancelsTouchesInView = YES;
            view.frame = CGRectMake(_CustomView.frame.size.width - view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        
        if (With - XCount <= With ) {
            
            CGPoint point = [pan translationInView:view];
            view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
            [pan setTranslation:CGPointZero inView:view];
            
        }else
        {
            pan.cancelsTouchesInView = YES;
            
            view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        
        if (YCount + Height <= _CustomView.frame.size.height)
        {
            CGPoint point = [pan translationInView:view];
            view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
            [pan setTranslation:CGPointZero inView:view];
        }else
        {
            pan.cancelsTouchesInView = YES;
            view.frame = CGRectMake(XCount,_CustomView.frame.size.height - Height, view.frame.size.width, view.frame.size.height);
        }
        
        if (Height - YCount <= Height) {
            
            CGPoint point = [pan translationInView:view];
            view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
            [pan setTranslation:CGPointZero inView:view];
        }else
        {
            pan.cancelsTouchesInView = YES;
            view.frame = CGRectMake(XCount, 0, view.frame.size.width, view.frame.size.height);
        }
   
    }else if (pan.state == UIGestureRecognizerStateEnded)
    
    {
        int currentViewXCount = self.DecomeOrigionX /(_CustomView.frame.size.width/30 - 4 * (self.DecomeOrigionX/_CustomView.frame.size.width/30));
        int currentViewYCount = self.DecomeOrigionY / (_CustomView.frame.size.height / 20 - 4*(self.DecomeOrigionY/_CustomView.frame.size.height/20));
       
        CGFloat currentX = self.DecomeOrigionX / (_CustomView.frame.size.width/30 - 4 * (self.DecomeOrigionX/_CustomView.frame.size.width/30));
        CGFloat currentY = self.DecomeOrigionY / (_CustomView.frame.size.height / 20 - 4 *(self.DecomeOrigionY/_CustomView.frame.size.height/20));
 
         UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
//        if (view.frame.origin.x < 0 || (view.frame.origin.x + view.frame.size.width) > _backRScreen.frame.size.width ||view.frame.origin.y < 0 || (view.frame.origin.y + view.frame.size.height) > _backRScreen.frame.size.height) {
//            
//            [view removeFromSuperview];
//            
//        }else{
        
            if (currentX - currentViewXCount > 0.5 && currentY - currentViewYCount > 0.5) {
                
                int Xinteger = currentViewXCount + 1;
                int Yinteger = currentViewYCount + 1;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                
                
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                
                NSString *KeyString = [NSString stringWithFormat:@"%ld",pan.view.tag];
                
                NSString *valueString = NSStringFromCGRect(Inrect);
                [_CustomMutDict setObject:valueString forKey:KeyString];
//                int Meeting = (int)(_MeetingViewTag - 3000);
//                int viewtag = (int)pan.view.tag;
                NSInteger ArrayNumber = pan.view.tag - (2324 + _DeletedPanView);
//                NSString *destchanid = [DataHelp shareData].destchanidArray[ArrayNumber -1];
//                NSString *destdevid = [DataHelp shareData].destdevidArray[ArrayNumber - 1];
             
//                [CustomData DeleteWithMeeting:Meeting tagNumber:viewtag];
//                [CustomData CreatSenceTable];
//                [CustomData InsertIntoMeeting:Meeting ViewDict:valueString tagNumber:viewtag RName:[DataHelp shareData].RNamearray[ArrayNumber - 1] destchanid:destchanid destdevid:destdevid];
//
                
                [_RectValue replaceObjectAtIndex:(ArrayNumber - 1) withObject:valueString];
//                [_CustomTagNumber replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:viewtag]];
//                [_CustomRname replaceObjectAtIndex:(ArrayNumber - 1) withObject:[DataHelp shareData].RNamearray[ArrayNumber - 1]];
//                [_CustomDesc replaceObjectAtIndex:(ArrayNumber - 1) withObject:destchanid];
//                [_CustomDesv replaceObjectAtIndex:(ArrayNumber - 1) withObject:destdevid];
                [_XCountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Yinteger]];
              
            }else if (currentX - currentViewXCount > 0.5 && currentY - currentViewYCount < 0.5)
            {
                int Xinteger = currentViewXCount + 1;
                int Yinteger = currentViewYCount;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                
                
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                NSString *KeyString = [NSString stringWithFormat:@"%ld",pan.view.tag];
                NSString *valueString = NSStringFromCGRect(Inrect);
                [_CustomMutDict setObject:valueString forKey:KeyString];
//                int Meeting = (int)(_MeetingViewTag - 3000);
//                int viewtag = (int)pan.view.tag;
                NSInteger ArrayNumber = pan.view.tag - (2324 + _DeletedPanView);
//                NSString *destchanid = [DataHelp shareData].destchanidArray[ArrayNumber -1];
//                NSString *destdevid = [DataHelp shareData].destdevidArray[ArrayNumber - 1];
                
//                [CustomData CreatSenceTable];
//                [CustomData DeleteWithMeeting:Meeting tagNumber:viewtag];
//                
//                [CustomData InsertIntoMeeting:Meeting ViewDict:valueString tagNumber:viewtag RName:[DataHelp shareData].RNamearray[ArrayNumber - 1] destchanid:destchanid destdevid:destdevid];
//                
           
                [_RectValue replaceObjectAtIndex:(ArrayNumber - 1) withObject:valueString];
//                [_CustomTagNumber replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:viewtag]];
//                [_CustomRname replaceObjectAtIndex:(ArrayNumber - 1) withObject:[DataHelp shareData].RNamearray[ArrayNumber - 1]];
//                [_CustomDesc replaceObjectAtIndex:(ArrayNumber - 1) withObject:destchanid];
//                [_CustomDesv replaceObjectAtIndex:(ArrayNumber - 1) withObject:destdevid];
                
                
                [_XCountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Yinteger]];
            }else if (currentX - currentViewXCount < 0.5 && currentY - currentViewYCount < 0.5)
            {
                int Xinteger = currentViewXCount;
                int Yinteger = currentViewYCount;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
              
                NSString *KeyString = [NSString stringWithFormat:@"%ld",pan.view.tag];
                NSString *valueString = NSStringFromCGRect(Inrect);
                [_CustomMutDict setObject:valueString forKey:KeyString];
//                int Meeting = (int)(_MeetingViewTag - 3000);
//                int viewtag = (int)pan.view.tag;
                NSInteger ArrayNumber = pan.view.tag - (2324 + _DeletedPanView);
//                NSString *destchanid = [DataHelp shareData].destchanidArray[ArrayNumber -1];
//                NSString *destdevid = [DataHelp shareData].destdevidArray[ArrayNumber - 1];
//                [CustomData CreatSenceTable];
//                [CustomData DeleteWithMeeting:Meeting tagNumber:viewtag];
//                
//                [CustomData InsertIntoMeeting:Meeting ViewDict:valueString tagNumber:viewtag RName:[DataHelp shareData].RNamearray[ArrayNumber - 1] destchanid:destchanid destdevid:destdevid];
//
                [_RectValue replaceObjectAtIndex:(ArrayNumber - 1) withObject:valueString];
//                [_CustomTagNumber replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:viewtag]];
//                [_CustomRname replaceObjectAtIndex:(ArrayNumber - 1) withObject:[DataHelp shareData].RNamearray[ArrayNumber - 1]];
//                [_CustomDesc replaceObjectAtIndex:(ArrayNumber - 1) withObject:destchanid];
//                [_CustomDesv replaceObjectAtIndex:(ArrayNumber - 1) withObject:destdevid];
                
                [_XCountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Yinteger]];
                
            }else if (currentX - currentViewXCount < 0.5 && currentY - currentViewYCount > 0.5)
            {
                int Xinteger = currentViewXCount;
                int Yinteger = currentViewYCount + 1;
                
                CGFloat XBulue = _Blueview.frame.size.width;
                CGFloat Yblue = _Blueview.frame.size.height;
                view.frame = CGRectMake(2+ (XBulue + 4) * Xinteger,2+ Yinteger * (Yblue + 4 ),(_CustomView.frame.size.width/10 - 4)*2 + 4,( _CustomView.frame.size.height / 20 - 4)*5 + 16);
                
                NSInteger rigenIntegr = view.frame.origin.x;
                NSInteger originY = view.frame.origin.y;
                NSInteger With = view.frame.size.width;
                NSInteger Height = view.frame.size.height;
                CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                
                NSString *KeyString = [NSString stringWithFormat:@"%ld",pan.view.tag];
                NSString *valueString = NSStringFromCGRect(Inrect);
                [_CustomMutDict setObject:valueString forKey:KeyString];
//                int Meeting = (int)(_MeetingViewTag - 3000);
//                int viewtag = (int)pan.view.tag;
                NSInteger ArrayNumber = pan.view.tag - (2324 + _DeletedPanView);
//                NSString *destchanid = [DataHelp shareData].destchanidArray[ArrayNumber -1];
//                NSString *destdevid = [DataHelp shareData].destdevidArray[ArrayNumber - 1];
//                [CustomData CreatSenceTable];
//                [CustomData DeleteWithMeeting:Meeting tagNumber:viewtag];
//                
//                [CustomData InsertIntoMeeting:Meeting ViewDict:valueString tagNumber:viewtag RName:[DataHelp shareData].RNamearray[ArrayNumber - 1] destchanid:destchanid destdevid:destdevid];
//
                
                [_RectValue replaceObjectAtIndex:(ArrayNumber - 1) withObject:valueString];
//                [_CustomTagNumber replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:viewtag]];
//                [_CustomRname replaceObjectAtIndex:(ArrayNumber - 1) withObject:[DataHelp shareData].RNamearray[ArrayNumber - 1]];
//                [_CustomDesc replaceObjectAtIndex:(ArrayNumber - 1) withObject:destchanid];
//                [_CustomDesv replaceObjectAtIndex:(ArrayNumber - 1) withObject:destdevid];
                [_XCountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Xinteger]];
                [_YcountArray replaceObjectAtIndex:(ArrayNumber - 1) withObject:[NSNumber numberWithInt:Yinteger]];
            }

        }
    }
//}

#pragma mark **********保存场景列表***************
//保存
- (void)SaveButtonAction:(UIButton *)SaveButton
{
    if (_ViewtagArray.count != 0 && _iscustom == NO ) {
        
        [self imageFromView:[UIApplication sharedApplication].keyWindow atFrame:CGRectMake(CGRectGetMaxX(_table.frame),CGRectGetMaxY(_BackView.frame) + 2,Width4SuperView - Width4SuperView * 0.15 -4,Height4SuperView * 0.61 + 28)];

    }else if (_iscustom == YES)
    {
        [self SaveSenceAction:SaveButton];
        UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
        UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
        _iscustom = NO;
        CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [custombutton setImage:CustomImage forState:UIControlStateNormal];

    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"保存失败") message:Localized(@"无连接操作") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:OAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//截屏方法
- (UIImageView *)imageFromView: (UIView *) theView atFrame:(CGRect)r
{
        NSString *numberSaveString = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
        NSInteger numberSave = numberSaveString.integerValue;
        _SaveIsOFF = YES;
        _NUmberSave = numberSave;
        _NUmberSave ++;
        UIGraphicsBeginImageContext(theView.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        UIRectClip(r);
        [theView.layer renderInContext:context];
        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _image = [[UIImageView alloc]init];
        _image.frame = CGRectMake(- 25 + (180)*(_NUmberSave - 1),17,200, Height4SuperView * 0.17);
//    _image.backgroundColor = [UIColor cyanColor];
        _image.userInteractionEnabled = YES;
        _image.image = theImage;
    
        _Sencelabel = [[UILabel alloc]init];
        _Sencelabel.frame = CGRectMake(6 + (180)*(_NUmberSave - 1),2,168,30);
        _Sencelabel.backgroundColor = CellRGB;
        _Sencelabel.textAlignment = NSTextAlignmentCenter;
        _Sencelabel.textColor = WhiteColor;
        _Sencelabel.tag = 1700 + (_NUmberSave - 1);
    
    
        [_SenceSCroller addSubview:_Sencelabel];
    
    NSString *Number = [NSString stringWithFormat:@"%ld",(long)_NUmberSave];
        [[NSUserDefaults standardUserDefaults]setObject:Number forKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
    
    //轻点手势应用场景
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageTapAction:)];
        tap.numberOfTapsRequired = 2;
        tap.delegate = self;
        [_image addGestureRecognizer:tap];
    
    //长按手势删除保存
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(SaveIMageLongPressAction:)];
        longPress.minimumPressDuration = 2;
        longPress.delegate = self;
        [_image addGestureRecognizer:longPress];
        [_SenceSCroller addSubview:_image];
    //保存截屏图片
//    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:@"senceAarray"];
        NSData *Imagedata;
        _image.tag = 555+(_NUmberSave - 1);
        NSNumber *number = [NSNumber numberWithInteger:_image.tag];
    
        _SencePicTagarray = [NSMutableArray array];
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
    if (arr != nil) {
        _SencePicTagarray = [arr mutableCopy];
    }
    
        [_SencePicTagarray addObject:number];
        [[NSUserDefaults standardUserDefaults]setObject:_SencePicTagarray forKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        [[NSUserDefaults standardUserDefaults]setObject:_SencePicTagarray forKey:[NSString stringWithFormat:@"%@LocaTagArray",UserNameString]];
        Imagedata = [NSKeyedArchiver archivedDataWithRootObject:theImage];
        [[NSUserDefaults standardUserDefaults]setObject:Imagedata forKey:[NSString stringWithFormat:@"%@%@",UserNameString,Number]];
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)_NumberOfScreen] forKey:[NSString stringWithFormat:@"%@%ld",UserNameString,(long)_NUmberSave + 100]];
//    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
 
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"请输入场景名称") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //textField.backgroundColor = [UIColor orangeColor];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        
    }];
    
    UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _SenceNameArray = [NSMutableArray array];
        
        UITextField *text = (UITextField *)alert.textFields.firstObject;
        NSMutableArray *senceName = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
        if (senceName != nil) {
            _SenceNameArray = [senceName mutableCopy];
        }
        UILabel *labe = (UILabel *)[self.view viewWithTag:1700 + (_NUmberSave - 1)];
        labe.font = [UIFont systemFontOfSize:13];
        if (text.text.length >7) {
            labe.text = [text.text substringToIndex:7];
            [_SenceNameArray addObject:[text.text substringToIndex:7]];
        }else
        {
            labe.text = text.text;
            [_SenceNameArray addObject:text.text];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:_SenceNameArray forKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
        
    }];
    

    [alert addAction:Sure];
    [self presentViewController:alert animated:YES completion:nil];
    
    //将信息保存到数据库
    NSInteger temp = 0;
    NSInteger SenceR = 0;
    if ([DataHelp shareData].CustomeIsBool == YES && _SenceBool == 0) {
        temp = 2;
        SenceR = _SenceCount;
        
        
    }else
    {
        temp = 1;
        SenceR = _NumberOfScreen;
        
    }
    
    [SenceData CreatSenceTable];
    NSString *Viewstring = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
    NSInteger Viewtag = Viewstring.integerValue;
    [SenceData UserName:UserNameString DeleteViewTag:(int)Viewtag];
    for (int i = 0; i < _ViewtagArray.count; i++) {
        NSNumber *ViewtagNumber = _ViewtagArray[i];
        NSNumber *TLinkNumber = _TLinkTagArray[i];
        NSString *ViewRectNumber = _ViewRectArray[i];
        NSString *RNameNumber = _RNameArray[i];
        NSString *DeschNumber = _DeschArray[i];
        NSString *DesVidNumber = _DesVidArray[i];
        NSInteger ViewtagInteger = ViewtagNumber.integerValue;
        NSInteger TlinkInteger = TLinkNumber.integerValue;
        
        
        NSInteger MeetingTag = _MeetingViewTag - 3000;
        NSString *MeetingName = [NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[MeetingTag][@"name"]];

   
        [SenceData InsertIntoUserName:UserNameString ViewTag:(Viewtag) Meeting:MeetingName TViewtage:ViewtagInteger Temp:temp SenceR:SenceR Ttag:TlinkInteger Rect:ViewRectNumber RName:RNameNumber DesVid:DesVidNumber Desch:DeschNumber];
    }
    //保存截屏到本地
    NSData *data;
    data = [NSKeyedArchiver archivedDataWithRootObject:theImage];
    return  _image;
}


//会场不存在删除场景
- (void)deleteSence:(NSInteger)senceNumber
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        arr = [array mutableCopy];
    
    NSMutableArray *search = [NSMutableArray array];
    _SenceNameArray = [NSMutableArray array];
    search = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
    _SenceNameArray = [search mutableCopy];
    [_SenceNameArray removeObjectAtIndex:senceNumber - 555];

    [[NSUserDefaults standardUserDefaults]setObject:_SenceNameArray forKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@LocaTagArray",UserNameString]];
        UIView *view = (UIView *)[self.view viewWithTag:senceNumber];
        UILabel *labe = (UILabel *)[self.view viewWithTag:senceNumber + 1145];
        [labe removeFromSuperview];
        [view removeFromSuperview];
        _DeleNumber = senceNumber - 554;
        [arr removeObjectAtIndex:_DeleNumber - 1];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        
        NSMutableArray *Dearray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        //删除数据
        [SenceData CreatSenceTable];
        [SenceData UserName:UserNameString DeleteViewTag:(int)_DeleNumber];
        //        [SenceData UserName:UserNameString SelectViewTag:_DeleNumber];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@%ld",UserNameString,senceNumber]];
        NSString *numberSaveString = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
        NSInteger numberSave = numberSaveString.integerValue;
        if (_SaveIsOFF == NO) {
            _NUmberSave = numberSave;
        }
        
        NSMutableArray *mut = [NSMutableArray array];
        for (int j = 1;j < _DeleNumber ; j++) {
            [mut addObject:Dearray[j-1]];
        }
        for (int i = (int)_DeleNumber; i < _NUmberSave; i++) {
            UIImageView *scroller = (UIImageView *)[self.view viewWithTag:555 + i];
            scroller.frame = CGRectMake(-25 + (180)*(i - 1),17,200, Height4SuperView * 0.17);
            scroller.tag = i + 555 -1;
            UILabel *labe = (UILabel *)[self.view viewWithTag:1700 + i];
            labe.frame = CGRectMake(6 + (180)*(i - 1),2,165, 30);
            labe.tag = 1700 + i - 1;
            [mut addObject:[NSNumber numberWithInteger:scroller.tag]];
            
            [_scroller addSubview:scroller];
            NSString *string = [NSString stringWithFormat:@"%@%d",UserNameString,i + 1];
            NSData *dataManager = [[NSUserDefaults standardUserDefaults]objectForKey:string];
            if (i > 0) {
                NSString *KeyString = [NSString stringWithFormat:@"%@%d",UserNameString,i];
                [[NSUserDefaults standardUserDefaults]setObject:dataManager forKey:KeyString];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:mut forKey:[NSString stringWithFormat:@"%@LocaTagArray",UserNameString]];
        //        [[NSUserDefaults standardUserDefaults]setObject:mut forKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        
    
        _DeleNumber = _DeleNumber - 1;
        _NUmberSave  = _NUmberSave - 1;
        NSString *Number = [NSString stringWithFormat:@"%ld",(long)(_NUmberSave)];
        if (_NUmberSave < 0) {
            _NUmberSave = 0;
        }
        [[NSUserDefaults standardUserDefaults]setObject:Number forKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
        
}

//保存的图片的长按手势事件
- (void)SaveIMageLongPressAction:(UILongPressGestureRecognizer *)Long
{
    if (Long.state ==  UIGestureRecognizerStateBegan) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        arr = [array mutableCopy];
//        NSNumber *number = [NSNumber numberWithInteger:Long.view.tag];
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"场景编辑") message:Localized(@"删除将不可恢复") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"删除场景") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *search = [NSMutableArray array];
        _SenceNameArray = [NSMutableArray array];
        search = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
        _SenceNameArray = [search mutableCopy];
        [_SenceNameArray removeObjectAtIndex:Long.view.tag - 555];
//        NSLog(@"%ld",Long.view.tag);
        
        [[NSUserDefaults standardUserDefaults]setObject:_SenceNameArray forKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@LocaTagArray",UserNameString]];
        UIView *view = (UIView *)[self.view viewWithTag:Long.view.tag];
        UILabel *labe = (UILabel *)[self.view viewWithTag:Long.view.tag + 1145];
        [labe removeFromSuperview];
        [view removeFromSuperview];
        _DeleNumber = Long.view.tag - 554;
        [arr removeObjectAtIndex:_DeleNumber - 1];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        
        NSMutableArray *Dearray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        //删除数据
        [SenceData CreatSenceTable];
        [SenceData UserName:UserNameString DeleteViewTag:(int)_DeleNumber];
//        [SenceData UserName:UserNameString SelectViewTag:_DeleNumber];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@%ld",UserNameString,Long.view.tag]];
        NSString *numberSaveString = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
        NSInteger numberSave = numberSaveString.integerValue;
        if (_SaveIsOFF == NO) {
            _NUmberSave = numberSave;
        }
        
        NSMutableArray *mut = [NSMutableArray array];
        for (int j = 1;j < _DeleNumber ; j++) {
            [mut addObject:Dearray[j-1]];
        }
        for (int i = (int)_DeleNumber; i < _NUmberSave; i++) {
            UIImageView *scroller = (UIImageView *)[self.view viewWithTag:555 + i];
              scroller.frame = CGRectMake(-25 + (180)*(i - 1),17,200, Height4SuperView * 0.17);
                scroller.tag = i + 555 -1;
            
            UILabel *labe = (UILabel *)[self.view viewWithTag:1700 + i];
            labe.frame = CGRectMake(5 + (180)*(i - 1),2,165, 30);
            labe.tag = 1700 + i - 1;
            [mut addObject:[NSNumber numberWithInteger:scroller.tag]];
            
            [_scroller addSubview:scroller];
            NSString *string = [NSString stringWithFormat:@"%@%d",UserNameString,i + 1];
            NSData *dataManager = [[NSUserDefaults standardUserDefaults]objectForKey:string];
            if (i > 0) {
                NSString *KeyString = [NSString stringWithFormat:@"%@%d",UserNameString,i];
                [[NSUserDefaults standardUserDefaults]setObject:dataManager forKey:KeyString];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:mut forKey:[NSString stringWithFormat:@"%@LocaTagArray",UserNameString]];
//        [[NSUserDefaults standardUserDefaults]setObject:mut forKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];

        _DeleNumber = _DeleNumber - 1;
        _NUmberSave  = _NUmberSave - 1;
        NSString *Number = [NSString stringWithFormat:@"%ld",(long)(_NUmberSave)];
        if (_NUmberSave < 0) {
            _NUmberSave = 0;
        }
        [[NSUserDefaults standardUserDefaults]setObject:Number forKey:[NSString stringWithFormat:@"%@SenceNumber",UserNameString]];
        
    }];
    
    UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"修改名称") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"请输入场景名称") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // 可以在这里对textfield进行定制，例如改变背景色
            //textField.backgroundColor = [UIColor orangeColor];
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
            
        }];
        
        UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            _SenceNameArray = [NSMutableArray array];
            
            UITextField *text = (UITextField *)alert.textFields.firstObject;
            NSMutableArray *senceName = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
            if (senceName != nil) {
                _SenceNameArray = [senceName mutableCopy];
            }
            UILabel *labe = (UILabel *)[self.view viewWithTag:1700 + (Long.view.tag - 555)];
            labe.font = [UIFont systemFontOfSize:13];
            if (text.text.length >7) {
                labe.text = [text.text substringToIndex:7];
                [_SenceNameArray replaceObjectAtIndex:Long.view.tag - 555 withObject:[text.text substringToIndex:7]];
            }else
            {
                labe.text = text.text;
                [_SenceNameArray replaceObjectAtIndex:Long.view.tag - 555 withObject:text.text];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:_SenceNameArray forKey:[NSString stringWithFormat:@"%@SenceNameSave",UserNameString]];
            
        }];
        
        
        UIAlertAction *Cancle = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:Cancle];
        [alert addAction:Sure];
        [self presentViewController:alert animated:YES completion:nil];
        
      
    }];
//
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleCancel handler:nil];
    
        
    [alert addAction:Action];
    [alert addAction:Sure];
    [alert addAction:cancleAction];
    dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
 }
 
}

#pragma mark===场景列表点击事件********
//场景保存到手势点击事件
- (void)saveImageTapAction:(UITapGestureRecognizer *)tap
{
    [DataHelp shareData].CustomeIsBool = NO;
    UIButton *custombutton = (UIButton *)[self.view viewWithTag:1013];
    UIImage *CustomImage = [UIImage imageNamed:@"Custom@2x"];
    _iscustom = NO;
    
    UIButton *Savebuttom = (UIButton *)[self.view viewWithTag:1014];
    [Savebuttom setTitle:Localized(@"保存场景") forState:UIControlStateNormal];
    
    CustomImage = [CustomImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [custombutton setImage:CustomImage forState:UIControlStateNormal];
    if ([DataHelp shareData].MeetingRnameArray.count != 0) {
        UIView *view = [self.view viewWithTag:779];
        [view removeFromSuperview];
        [_backRScreen removeFromSuperview];
        NSInteger integer = tap.view.tag - 555;
        _Sencetag = tap.view.tag;
        self.DecomeNumber = 0;
        //    NSString *Valuew = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%ld",integer + 100]];
        //    NSLog(@"%@",Valuew);
        NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@senceAarray",UserNameString]];
        NSNumber *number = arr[integer];
        [SenceData CreatSenceTable];
        NSInteger datatag = number.integerValue;
        NSInteger seleTag = datatag - 554;
        [SenceData UserName:UserNameString SelectViewTag:seleTag];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"无解码器 不可操作");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 100)];//提示框的位置
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.2]; //多久后隐藏
//            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];
        });
    }
//    DataHelp *datahelp = [DataHelp new];
//NSLog(@"%@",DataHelp.SenceNumberArray);
//
}

- (UIImage *)imageView: (UIView *)from atFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(from.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [from.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData;
    
    imageData = [NSKeyedArchiver archivedDataWithRootObject:theImage];

        NSString *string = [NSString stringWithFormat:@"%@image%@",UserNameString,[DataHelp shareData].LocationArray[_MeetingViewTag - 3000][@"name"]];
        
            [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:string];
  
    return theImage;
}

- (void)image:(UIImage *)image didFinishSaveWitherror:(NSError *)error  contextInfo:(void *)contextInfo
{
    
    if (error == nil) {
    
        NSLog(@"成功");
    }else
    {
        
        NSLog(@"失败");
    }
}


//保存图片的点击事件
- (void)TapImageAction:(UITapGestureRecognizer *)imageTap
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"场景应用") message:Localized(@"应用还是删除") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"删除") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    UIAlertAction *Sure = [UIAlertAction actionWithTitle:Localized(@"应用") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:Action];
    [alert addAction:Sure];
    [self presentViewController:alert animated:YES completion:nil];

}

//会场列表下一页
- (void)MeetingButtonAction:(UIButton *)MeetiongButton
{
    _RightIndex++;
    [_MeetingScroller setContentOffset:CGPointMake(Width4SuperView*0.17, 200 * _RightIndex)];
 
}

//T摄像头输入向下按钮
- (void)CameraSeltButtonAction:(UIButton *)CamerSele
{
    _Leftindex++;
    if (90 * [DataHelp shareData].TAllArray.count < Height4SuperView * 0.65) {
        _Leftindex = 0;
    }

    [_table setContentOffset:CGPointMake(0,Height4SuperView * 0.65 * _Leftindex) animated:YES];
}

-  (void)CameraUPButtonAction:(UIButton *)UpButton
{
    
    if (_Leftindex > 0) {
        _Leftindex--;
    }else
    {
        _Leftindex = 0;
    }
    
     [_table setContentOffset:CGPointMake(0,Height4SuperView * 0.65 * _Leftindex) animated:YES];
    
}

//会议
- (void)MeetingAction:(UIButton *)Meeting

{
   // NSLog(@"这是会议模式");
    
}

//监控模式
- (void)ControlAction:(UIButton *)Control

{
   // NSLog(@"这是监控模式");
}

//轮巡
- (void)RoundAction:(UIButton *)Round
{
    
 
    
}

//指挥
- (void)CommandAction:(UIButton *)Command
{
    //NSLog(@"这是指挥模式");
}

//应急
- (void)EmergencyAction:(UIButton *)sender
{
   // NSLog(@"这是应急模式");
}


#pragma mark ====Tview的平移事件====
//平移
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) //开始
    {
 
    }else if (pan.state == UIGestureRecognizerStateChanged) //平移
    {
        UIView *view = (UIView *)pan.view;
        
        CGPoint p1 = [pan translationInView:view];
        
        view.backgroundColor = [UIColor cyanColor];
        view.transform  = CGAffineTransformTranslate(view.transform,p1.x,p1.y);
        self.CurrentWith = view.frame.origin.x;
        self.CurrentHeight = view.frame.origin.y;
        index = 0;
        [pan setTranslation:CGPointZero inView:view];
        
        
        self.XPanView = view.frame.origin.x - _table.frame.size.width - 4;
        self.YPanView = view.frame.origin.y  - 45 - 64;

    }else if (pan.state == UIGestureRecognizerStateEnded) //平移结束
  
    {

        NSInteger inter  = 0;
        
        //判断当前分屏类型
        if (self.TagNumber == 0) {
            switch (self.NumberOfScreen) {
                case 1:
                    
                    inter = 100;
                    break;
                case 2:
                    inter = 102;
                    break;
                case 3:
                    inter = 106;
                    break;
                case 4:
                    inter = 120;
                    break;
                    
                default:
                    break;
            }
            
            UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
            view.backgroundColor = BacViewRGB;
            int currentViewXCount = fabs(self.XPanView /((ScreenWith - 8)/30 - 4 * (self.XPanView/(ScreenWith -8)/30)));
            int currentViewYCount = fabs(self.YPanView / ((ScreenHeight -8) / 20 - 4*(self.YPanView/(ScreenHeight -8)/20)));
            
            CGFloat currentX = fabs(self.XPanView / ((ScreenWith - 8)/30 - 4 * (self.XPanView/(ScreenWith - 8)/30)));
            CGFloat currentY = fabs(self.YPanView / ((ScreenHeight -8) / 20 - 4 *(self.YPanView/(ScreenHeight -8)/20)));
            
            if ([DataHelp shareData].CustomeIsBool == YES) {
                //当进行了自定视图并应用拖动结束后将要在这执行事件
                NSInteger inter = 0;
                if (self.SaveOrNo == 1) {
                    inter = _MeetingViewTag - 3000;
                    
                }else
                {
                    inter = _SenceCount;
                }
                
                NSArray *Xarra = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@XCountArray%@",UserNameString,[DataHelp shareData].LocationArray[inter][@"name"]]];
                NSArray *Yarray = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@YcountArray%@",UserNameString,[DataHelp shareData].LocationArray[inter][@"name"]]];
               
                if (self.CurrentWith + view.frame.size.width /2 <= Width4SuperView*0.15 ||  self.CurrentWith >= Width4SuperView * 0.83|| self.CurrentHeight <= 30 ||self.CurrentHeight >= (Height4SuperView*0.71 - view.frame.size.height/2)) {
                   
//                    [view removeFromSuperview];
//                    NSString *LinkString = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"MediaLink%ld",pan.view.tag]];
//                    NSDictionary *dict = @{@"message":@{@"function":@"medialink_delete",@"medialinks":@[@{@"id":LinkString}]}};
//                    NSData *data = [[NSString stringWithFormat:@"%@\n",[dict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
//                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:400];
//                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:400];
                    
                    NSInteger inter = 0;
                    for (int i = 0; i < _ViewtagArray.count; i++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger inte = number.integerValue;
                        if (inte == pan.view.tag) {
                            inter = i;
                          
                        }
                    }
                
                    [_ViewtagArray removeObjectAtIndex:inter];
                    [_TLinkTagArray removeObjectAtIndex:inter];
                    [_ViewRectArray removeObjectAtIndex:inter];
                    [_RNameArray removeObjectAtIndex:inter];
                    [_DeschArray removeObjectAtIndex:inter];
                    [_DesVidArray removeObjectAtIndex:inter];
                  
                    UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
                    [view removeFromSuperview];
                    [_LinkArray removeObject:[NSString stringWithFormat:@"%ld",(long)pan.view.tag -3000]];
                
                }else{
                    
                if (currentX - currentViewXCount >= 0.5 && currentY - currentViewYCount >= 0.5) {
                    int Xinte = currentViewXCount + 1;
                    NSInteger Yinte = currentViewYCount + 1;
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        
                        }
                        
                    }
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
                        }
                    }
            
                    CGRect rect = CGRectMake(4 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,4 + _Blueview.frame.size.height * YArraValue + 4 *YArraValue , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    NSString *string = NSStringFromCGRect(Inrect);
                    
                    
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 120;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                          
                        }
                    }
                    NSLog(@"1");
                    if (numberIndex != 120) {
                        view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  , 6+CGRectGetMaxY(_BackView.frame) + _Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                        
                        
                    [DataHelp shareData].CreatRView = NO;
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[(_SenceCount)][@"name"]] CustomRct:string];
                        
                        for (int i = 0; i < _DeschArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger TadInteger = number.integerValue;
                            if (TadInteger == pan.view.tag) {
                                NSNumber *TLin = _TLinkTagArray[i];
                                _Tinte = TLin.integerValue;
                            }
                        }
                        
                    view.backgroundColor = BacViewRGB;
                    
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UITextField *textField = (UITextField *)[self.view viewWithTag:pan.view.tag + 1000];
                    textField.text = RName;
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                          
                        }
                    }
                    
                    /********************/
                    NSNumber *ValuNumber = _DeschArray[arrCount];
                    NSString *Valustring = [NSString stringWithFormat:@"%@",ValuNumber];
                    
                    if ([Valustring isEqualToString:destdevString]) {
                        
                    }else
                    {
                   
                    int ValueNumber = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *numberValue = _DeschArray[i];
                        NSString *ValString =[NSString stringWithFormat:@"%@",numberValue];
                        if ([ValString isEqualToString:destdevString]) {
                            ValueNumber = i;
                        
                        }
                    }
                    
                    
                    if (ValueNumber != 100) {
                        NSNumber *Indenumber = _ViewtagArray[ValueNumber];
                        NSInteger ReViewInteger = Indenumber.integerValue;
                        UIView *Review = (UIView*)[self.view viewWithTag:ReViewInteger];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:ValueNumber withObject:string];
                        [_RNameArray replaceObjectAtIndex:ValueNumber withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:ValueNumber withObject:String];
                        [_DeschArray replaceObjectAtIndex:ValueNumber withObject:destdevString];
                        
                        [_ViewtagArray removeObjectAtIndex:arrCount];
                        [_TLinkTagArray removeObjectAtIndex:arrCount];
                        [_ViewRectArray removeObjectAtIndex:arrCount];
                        [_RNameArray removeObjectAtIndex:arrCount];
                        [_DeschArray removeObjectAtIndex:arrCount];
                        [_DesVidArray removeObjectAtIndex:arrCount];
                
                    }else
                    {
                    
                    [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                    [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                    [_ViewRectArray replaceObjectAtIndex:arrCount withObject:string];
                    [_RNameArray replaceObjectAtIndex:arrCount withObject:RName];
                    [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                    [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                  
                    }
                      
                    }
                    
                    }else
                    {
                        NSInteger inte = pan.view.tag;
                        for (int i = 0; i < _ViewtagArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger inteTag = number.integerValue;
                            if (inte == inteTag) {
                                NSNumber *number  = _ViewRectArray[i];
                                NSString *Rectstr = [NSString stringWithFormat:@"%@",number];
                                
                                CGRect rect = CGRectFromString(Rectstr);
                                UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
                                CGFloat RorigionX = rect.origin.x;
                                CGFloat ROrigionY = rect.origin.y;
                                CGFloat With = rect.size.width;
                                CGFloat height = rect.size.height;
                                view.frame = CGRectMake(_table.frame.size.width + 6 + RorigionX, CGRectGetMaxY(_BackView.frame) + 6 + ROrigionY, With, height);
                            }
                        }
                     
                    }
                    /*********************/
             
                }else if (currentX - currentViewXCount >= 0.5 && currentY - currentViewYCount <= 0.5)
                {
                    int Xinte = currentViewXCount + 1;
                    NSInteger Yinte = currentViewYCount;
                    
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        
                        }
                    }
                    
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
                          
                        }
                    }
                    
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,_Blueview.frame.size.height * YArraValue + 4 *YArraValue + 2 , ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    NSString *string = NSStringFromCGRect(Inrect);
                    
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 120;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                         
                        }
                    }
                    
                     NSLog(@"2");
                    if (numberIndex != 120) {
                        view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  , 6 + CGRectGetMaxY(_BackView.frame) + _Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                                                
                    [DataHelp shareData].CreatRView = NO;
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[(_SenceCount)][@"name"]] CustomRct:string];
                    
                        
                        for (int i = 0; i < _DeschArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger TadInteger = number.integerValue;
                            if (TadInteger == pan.view.tag) {
                                NSNumber *TLin = _TLinkTagArray[i];
                                _Tinte = TLin.integerValue;
                            }
                        }
                        
                    
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
//                    [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)pan.view.tag]];
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UITextField *textField = (UITextField *)[self.view viewWithTag:pan.view.tag + 1000];
                    textField.text = RName;
                    
                    
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                        
                        }
                    }
                    
                    
                    
                    /********************/
                    
                    NSNumber *ValuNumber = _DeschArray[arrCount];
                    NSString *Valustring = [NSString stringWithFormat:@"%@",ValuNumber];
                    
                    if ([Valustring isEqualToString:destdevString]) {
                        
                        
                    }else
                    {

                    
                    int ValueNumber = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *numberValue = _DeschArray[i];
                        NSString *ValString =[NSString stringWithFormat:@"%@",numberValue];
                        if ([ValString isEqualToString:destdevString]) {
                            ValueNumber = i;
                          
                            
                        }
                    }
                    if (ValueNumber != 100) {
                        NSNumber *Indenumber = _ViewtagArray[ValueNumber];
                        NSInteger ReViewInteger = Indenumber.integerValue;
                        UIView *Review = (UIView*)[self.view viewWithTag:ReViewInteger];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:ValueNumber withObject:string];
                        [_RNameArray replaceObjectAtIndex:ValueNumber withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:ValueNumber withObject:String];
                        [_DeschArray replaceObjectAtIndex:ValueNumber withObject:destdevString];
                        
                        [_ViewtagArray removeObjectAtIndex:arrCount];
                        [_TLinkTagArray removeObjectAtIndex:arrCount];
                        [_ViewRectArray removeObjectAtIndex:arrCount];
                        [_RNameArray removeObjectAtIndex:arrCount];
                        [_DeschArray removeObjectAtIndex:arrCount];
                        [_DesVidArray removeObjectAtIndex:arrCount];
                        
                    }else
                    {
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:string];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                
                    }
                   
                    
                    }
                
                    }else
                    {
                        NSInteger inte = pan.view.tag;
                        for (int i = 0; i < _ViewtagArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger inteTag = number.integerValue;
                            if (inte == inteTag) {
                                NSNumber *number  = _ViewRectArray[i];
                                NSString *Rectstr = [NSString stringWithFormat:@"%@",number];
                                
                                CGRect rect = CGRectFromString(Rectstr);
                                UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
                                CGFloat RorigionX = rect.origin.x;
                                CGFloat ROrigionY = rect.origin.y;
                                CGFloat With = rect.size.width;
                                CGFloat height = rect.size.height;
                                view.frame = CGRectMake(_table.frame.size.width + 6 + RorigionX, CGRectGetMaxY(_BackView.frame) + 6 + ROrigionY, With, height);
                            }
                        }
                 
                    }
                    /*********************/
                    
//                    [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
//                    [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
//                    [_ViewRectArray replaceObjectAtIndex:arrCount withObject:string];
//                    [_RNameArray replaceObjectAtIndex:arrCount withObject:RName];
//                    [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
//                    [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                }else if (currentX - currentViewXCount <= 0.5 && currentY - currentViewYCount <= 0.5)
                {
                    int Xinte = currentViewXCount;
                    NSInteger Yinte = currentViewYCount;
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                      
                        }
                    }
                    
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
              
                        }
                    }
               
                   view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,CGRectGetMaxY(_BackView.frame) + 4 + _Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    view.backgroundColor = BacViewRGB;
                    
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  , 2 + _Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    NSString *string = NSStringFromCGRect(Inrect);
                    
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 120;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                       
                        }
                    }
                    
                      NSLog(@"3");
                    if (numberIndex != 120) {
                        view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,6 + CGRectGetMaxY(_BackView.frame)+_Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                       
                        view.backgroundColor = BacViewRGB;
                    [DataHelp shareData].CreatRView = NO;
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[(_SenceCount)][@"name"]] CustomRct:string];
                    
                        for (int i = 0; i < _DeschArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger TadInteger = number.integerValue;
                            if (TadInteger == pan.view.tag) {
                                NSNumber *TLin = _TLinkTagArray[i];
                                _Tinte = TLin.integerValue;
                            }
                        }
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    
                    UITextField *textField = (UITextField *)[self.view viewWithTag:pan.view.tag + 1000];
                    textField.text = RName;
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                      
                        }
                    }
                    
                    /********************/
                    
                    NSNumber *ValuNumber = _DeschArray[arrCount];
                    NSString *Valustring = [NSString stringWithFormat:@"%@",ValuNumber];
                    
                    if ([Valustring isEqualToString:destdevString]) {
                    
                    }else
                    {

                    int ValueNumber = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *numberValue = _DeschArray[i];
                        NSString *ValString =[NSString stringWithFormat:@"%@",numberValue];
                        if ([ValString isEqualToString:destdevString]) {
                            ValueNumber = i;
               
                        }
                    }
                    
                    if (ValueNumber != 100) {
                        NSNumber *Indenumber = _ViewtagArray[ValueNumber];
                        NSInteger ReViewInteger = Indenumber.integerValue;
                        UIView *Review = (UIView*)[self.view viewWithTag:ReViewInteger];
                        [Review removeFromSuperview];
                        [_ViewtagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:ValueNumber withObject:string];
                        [_RNameArray replaceObjectAtIndex:ValueNumber withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:ValueNumber withObject:String];
                        [_DeschArray replaceObjectAtIndex:ValueNumber withObject:destdevString];
                        
                        [_ViewtagArray removeObjectAtIndex:arrCount];
                        [_TLinkTagArray removeObjectAtIndex:arrCount];
                        [_ViewRectArray removeObjectAtIndex:arrCount];
                        [_RNameArray removeObjectAtIndex:arrCount];
                        [_DeschArray removeObjectAtIndex:arrCount];
                        [_DesVidArray removeObjectAtIndex:arrCount];
               
                    }else
                    {
                        
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:string];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                     
                    }
                    }
                        
                    }else
                    {
                        NSInteger inte = pan.view.tag;
                        for (int i = 0; i < _ViewtagArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger inteTag = number.integerValue;
                            if (inte == inteTag) {
                                NSNumber *number  = _ViewRectArray[i];
                                NSString *Rectstr = [NSString stringWithFormat:@"%@",number];
                                
                                CGRect rect = CGRectFromString(Rectstr);
                                UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
                                CGFloat RorigionX = rect.origin.x;
                                CGFloat ROrigionY = rect.origin.y;
                                CGFloat With = rect.size.width;
                                CGFloat height = rect.size.height;
                                view.frame = CGRectMake(_table.frame.size.width + 6 + RorigionX, CGRectGetMaxY(_BackView.frame) + 6 + ROrigionY, With, height);
                            }
                        }
                        
                      
                
                    }
                    /*********************/
                    
//                    [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
//                    [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
//                    [_ViewRectArray replaceObjectAtIndex:arrCount withObject:string];
//                    [_RNameArray replaceObjectAtIndex:arrCount withObject:RName];
//                    [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
//                    [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                    
                    
                }else if (currentX - currentViewXCount <= 0.5 && currentY - currentViewYCount >= 0.5)
                {
                    int Xinte = currentViewXCount;
                    NSInteger Yinte = currentViewYCount + 1;
                    
                    NSNumber *Xnumber = Xarra[0];
                    NSNumber *Ynumber = Yarray[0];
                    NSInteger Xinteger = Xnumber.integerValue;
                    NSInteger Yinteger = Ynumber.integerValue;
                    NSInteger XAbs = labs(Xinteger - (NSInteger)Xinte);
                    NSInteger YAbs = labs(Yinteger - Yinte);
                    
                    NSInteger XArraValue = 0;
                    NSInteger XArraNumber = 0;
                    
                    NSInteger YArraValue = 0;
                    NSInteger YArraNumber = 0;
                    
                    for (int i = 0; i < Xarra.count; i++) {
                        NSNumber *number = Xarra[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Xinte) <= XAbs) {
                            XAbs = labs(integer - Xinte);
                            XArraValue = integer;
                            XArraNumber = i;
                        
                            
                        }
                    }
                    
                    for (int i = 0; i < Yarray.count; i++) {
                        NSNumber *number = Yarray[i];
                        NSInteger integer = number.integerValue;
                        if (labs(integer - Yinte) <= YAbs) {
                            YAbs = labs(integer - Yinte);
                            YArraValue = integer;
                            YArraNumber = i;
                     
                            
                        }
                    }
                    
               
                   view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,4 + CGRectGetMaxY(_BackView.frame)+_Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
                    
                    CGRect rect = CGRectMake(2  + _Blueview.frame.size.width * XArraValue + XArraValue * 4  , 2 + _Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                    
                    NSInteger rigenIntegr = rect.origin.x;
                    NSInteger originY = rect.origin.y;
                    NSInteger With = view.frame.size.width;
                    NSInteger Height = view.frame.size.height;
                    
                    CGRect Inrect = CGRectMake(rigenIntegr, originY, With, Height);
                    NSString *string = NSStringFromCGRect(Inrect);
                    NSString *RectString = NSStringFromCGRect(Inrect);
                    
                    NSInteger numberIndex = 120;
                    for (int i = 0; i < _RectArray.count; i++) {
                        NSString *string = [NSString stringWithFormat:@"%@",_RectArray[i]];
                        if ([RectString isEqualToString:string]) {
                            numberIndex = i;
                        
                            
                            
                        }
                    }
                   
                    if (numberIndex != 120) {
                        view.frame = CGRectMake(_table.frame.size.width + 7 + _Blueview.frame.size.width * XArraValue + XArraValue * 4  ,6+ CGRectGetMaxY(_BackView.frame) + _Blueview.frame.size.height * YArraValue + 4 *YArraValue, ((ScreenWith - 8)/10 - 4)*2 + 4, ((ScreenHeight - 8)/ 20 - 4)*5 + 16);
                       
                    view.backgroundColor = BacViewRGB;
                    [DataHelp shareData].CreatRView = NO;
                    [CustomData CreatSenceTable];
                    [CustomData SelectName:UserNameString Meeting:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[(_SenceCount)][@"name"]] CustomRct:string];
               
                        
                        for (int i = 0; i < _DeschArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger TadInteger = number.integerValue;
                            if (TadInteger == pan.view.tag) {
                                NSNumber *TLin = _TLinkTagArray[i];
                                _Tinte = TLin.integerValue;
                            }
                        }
                        
                    view.backgroundColor = BacViewRGB;
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    
                    NSString *destdevString = [DataHelp shareData].destdevid;
                    NSString *String = [DataHelp shareData].destchanid;
                    NSString *RName = [DataHelp shareData].RnameData;
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;

                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UITextField *textField = (UITextField *)[self.view viewWithTag:pan.view.tag + 1000];
                    textField.text = RName;
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
   
                            
                        }
                    }
                    
                    /********************/
                    NSNumber *ValuNumber = _DeschArray[arrCount];
                    NSString *Valustring = [NSString stringWithFormat:@"%@",ValuNumber];

                    if ([Valustring isEqualToString:destdevString]) {
                       
                    }else
                    {

                    int ValueNumber = 100;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *numberValue = _DeschArray[i];
                        NSString *ValString =[NSString stringWithFormat:@"%@",numberValue];
                        if ([ValString isEqualToString:destdevString]) {
                            ValueNumber = i;
  
                        }
                    }
                    
                    if (ValueNumber != 100) {
                        NSNumber *Indenumber = _ViewtagArray[ValueNumber];
                        NSInteger ReViewInteger = Indenumber.integerValue;
                        UIView *Review = (UIView*)[self.view viewWithTag:ReViewInteger];
                        [Review removeFromSuperview];
                        
                        
                        [_ViewtagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:ValueNumber withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:ValueNumber withObject:string];
                        [_RNameArray replaceObjectAtIndex:ValueNumber withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:ValueNumber withObject:String];
                        [_DeschArray replaceObjectAtIndex:ValueNumber withObject:destdevString];
                        
                        [_ViewtagArray removeObjectAtIndex:arrCount];
                        [_TLinkTagArray removeObjectAtIndex:arrCount];
                        [_ViewRectArray removeObjectAtIndex:arrCount];
                        [_RNameArray removeObjectAtIndex:arrCount];
                        [_DeschArray removeObjectAtIndex:arrCount];
                        [_DesVidArray removeObjectAtIndex:arrCount];
                
                    }else
                    {
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:string];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:RName];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                    }
                    }
                    }else
                    {
                        NSInteger inte = pan.view.tag;
                        for (int i = 0; i < _ViewtagArray.count; i++) {
                            NSNumber *number = _ViewtagArray[i];
                            NSInteger inteTag = number.integerValue;
                            if (inte == inteTag) {
                                NSNumber *number  = _ViewRectArray[i];
                                NSString *Rectstr = [NSString stringWithFormat:@"%@",number];
                                
                                CGRect rect = CGRectFromString(Rectstr);
                                UIView *view = (UIView *)[self.view viewWithTag:pan.view.tag];
                                CGFloat RorigionX = rect.origin.x;
                                CGFloat ROrigionY = rect.origin.y;
                                CGFloat With = rect.size.width;
                                CGFloat height = rect.size.height;
                                view.frame = CGRectMake(_table.frame.size.width + 6 + RorigionX, CGRectGetMaxY(_BackView.frame) + 6 + ROrigionY, With, height);
                            }
                        }
                   
                        
                    }

                }
                    
                }
            }else{
                _SelectedView = (UIView *)[self.view viewWithTag:pan.view.tag];
                _BackViewScroller = (UIView *)[self.view viewWithTag:inter];
                CGFloat BackWith = _BackViewScroller.frame.size.width;
                CGFloat BackHeight = _BackViewScroller.frame.size.height;
                
                NSInteger Xinteger = fabs((self.CurrentWith - Width4SuperView * 0.156)/BackWith);
                NSInteger Yinteger = fabs((self.CurrentHeight - Height4SuperView * 0.0898)/BackHeight);
                
                CGFloat Xfloat = Xinteger + 0.5;
                CGFloat Yfloat = Yinteger + 0.5;
                CGFloat XpanCurrentIndext = fabs((self.CurrentWith - self.view.frame.size.width * 0.156)/BackWith);
                CGFloat YpanCurrentIndext = fabs((self.CurrentHeight - self.view.frame.size.height * 0.0898 )/BackHeight);
             
                

            if (self.CurrentWith  <= Width4SuperView * 0.15/2 || self.CurrentWith + view.frame.size.width/2 >= Width4SuperView * 0.8|| self.CurrentHeight <= 30 || self.CurrentHeight >= Height4SuperView * 0.71 - view.frame.size.height/2 ) {
                
                [view removeFromSuperview];
                [_LinkArray removeObject:[NSString stringWithFormat:@"%ld",(long)view.tag -3000]];
                NSString *string = [NSString stringWithFormat:@"%ld",(long)pan.view.tag];
                [_MovViewdict removeObjectForKey:string];
                [_MovViewdict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)view.tag]];
                [_move removeFromParentViewController];
                
                NSMutableArray *arr = [_ViewtagArray mutableCopy];
                NSInteger inter = 0;
                for (int i = 0; i < arr.count; i++) {
                    NSNumber *number = arr[i];
                    NSInteger inte = number.integerValue;
                    if (inte == pan.view.tag) {
                        inter = i;
                    }
                }
               
                [_ViewtagArray removeObjectAtIndex:inter];
                [_TLinkTagArray removeObjectAtIndex:inter];
                [_ViewRectArray removeObjectAtIndex:inter];
                [_RNameArray removeObjectAtIndex:inter];
                [_DeschArray removeObjectAtIndex:inter];
                [_DesVidArray removeObjectAtIndex:inter];
                [_CurrentRLink removeObjectAtIndex:inter];
                
                
            }else if (XpanCurrentIndext >= Xfloat && YpanCurrentIndext <=Yfloat && Xfloat <= _NumberOfScreen - 0.5 && YpanCurrentIndext >= 0) {
                
                _SelectedView.frame = CGRectMake((CGRectGetMaxX(_table.frame) + 6)+ BackWith * (Xinteger+1) + 2 * (Xinteger+1) ,CGRectGetMaxY(_BackView.frame)+ 6 + BackHeight*Yinteger + 2 * Yinteger, BackWith, BackHeight);
                NSString *RectString = NSStringFromCGRect(_SelectedView.frame);
                [self.view addSubview:_SelectedView];
                
                NSInteger sendRNumber = _NumberOfScreen * (Yinteger) + (Xinteger +1);
                
                if (sendRNumber < [DataHelp shareData].MeetingDestchanid.count) {
                
                //改变移动字典中对应的键值对
                NSString *string = [NSString stringWithFormat:@"%ld",(long)pan.view.tag];
                NSMutableDictionary *mutDict = [_MovViewdict objectForKey:string];
                NSArray *arr = [mutDict allValues];
                NSNumber *num = arr[0];
                NSString *value = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:value forKey:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                [_MovViewdict setObject:dict forKey:string];
              
                NSUUID *uuid = [NSUUID UUID];
                NSString *uuidString = uuid.UUIDString;
                    
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger TadInteger = number.integerValue;
                        if (TadInteger == pan.view.tag) {
                            NSNumber *TLin = _TLinkTagArray[i];
                            _Tinte = TLin.integerValue;
                        }
                    }
                
                NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[sendRNumber];
                NSString *String = [NSString stringWithFormat:@"%@",destch];
                
                NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[sendRNumber];
                NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                
                NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                
                NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
//                [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)pan.view.tag]];
                NSDictionary *Linkdict = @{@"message":
                                                    @{@"function":
                                                    @"medialink_add",
                                                    @"medialinks":@[@{
                                                     @"id":uuidString,
                                                    @"destchanid":destdevString,
                                                    @"destdevid":String,
                                                    @"srcchanid":srcchanString,
                                                    @"srcdevid":srcdevString}]}};
                
                NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
        
                    UILabel *label = (UILabel *)[self.view viewWithTag:pan.view.tag + 1000];
                    if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                        
                        label.text = [DataHelp shareData].MeetingRnameArray[sendRNumber];
                        
                    }
                    
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                        }
                    }
                    
                    NSNumber *Valunumber = _DeschArray[arrCount];
                    NSString *VAlustring = [NSString stringWithFormat:@"%@",Valunumber];
                    if ([VAlustring isEqualToString:destdevString]) {
                        
                    }else
                    {
                    int IndexNumber = 110;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *NumberString = [NSString stringWithFormat:@"%@",number];
                        
                        if ([NumberString isEqualToString:destdevString]) {
                            IndexNumber = i;
                        }
                        
                    }
                    
                    
                    if (IndexNumber != 110) {
                        NSNumber *Renumber = _ViewtagArray[IndexNumber];
                        NSInteger ReInder = Renumber.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:ReInder];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[sendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                        [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                       
                        [_ViewtagArray  removeObject:Renumber];
                        [_TLinkTagArray removeObjectAtIndex:IndexNumber];
                        [_ViewRectArray removeObjectAtIndex:IndexNumber];
                        [_RNameArray removeObjectAtIndex:IndexNumber];
                        [_DeschArray removeObjectAtIndex:IndexNumber];
                        [_DesVidArray removeObjectAtIndex:IndexNumber];
                        [_CurrentRLink removeObjectAtIndex:IndexNumber];
                        
         
                        
                    }else if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[sendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                        [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                     
                    }
                    }
                }
  
//                UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
                
            }else if (XpanCurrentIndext >= Xfloat &&  YpanCurrentIndext >=Yfloat && Xfloat <= _NumberOfScreen - 0.5 && Yfloat <=_NumberOfScreen - 0.5)
            {
                _SelectedView.frame = CGRectMake((CGRectGetMaxX(_table.frame) + 6)+ BackWith * (Xinteger+1) + 2 * (Xinteger+1) ,CGRectGetMaxY(_BackView.frame) + 6 + BackHeight * (Yinteger+1)  + 2 * (Yinteger+1) , BackWith, BackHeight);
                 NSString *RectString = NSStringFromCGRect(_SelectedView.frame);
                [self.view addSubview:_SelectedView];
                
                NSInteger sendRNumber = _NumberOfScreen * (Yinteger+1) + (Xinteger+1);
        
                if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
              
                //改变移动字典中对应的键值对
                NSString *string = [NSString stringWithFormat:@"%ld",(long)pan.view.tag];
                NSMutableDictionary *mutDict = [_MovViewdict objectForKey:string];
                NSArray *arr = [mutDict allValues];
                NSNumber *num = arr[0];
                NSString *value = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:value forKey:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                [_MovViewdict setObject:dict forKey:string];
               
                NSUUID *uuid = [NSUUID UUID];
                NSString *uuidString = uuid.UUIDString;
                
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger TadInteger = number.integerValue;
                        if (TadInteger == pan.view.tag) {
                            NSNumber *TLin = _TLinkTagArray[i];
                            _Tinte = TLin.integerValue;
                        }
                    }
                    
                NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[sendRNumber];
                NSString *String = [NSString stringWithFormat:@"%@",destch];
        
                NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[sendRNumber];
                NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                
                NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                
                NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
//                [[NSUserDefaults standardUserDefaults]setObject:uuidString forKey:[NSString stringWithFormat:@"MediaLink%ld",(long)pan.view.tag]];
                NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                         @"destchanid":destdevString,
                                                                                                         @"destdevid":String,
                                                                                                         @"id":uuidString,
                                                                                                         @"srcchanid":srcchanString,
                                                                                                         @"srcdevid":srcdevString}]}};
                NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                [[DataHelp shareData].ClientSocket writeData:data
                                                 withTimeout:-1 tag:300];
                [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                
                    UILabel *label = (UILabel *)[self.view viewWithTag:pan.view.tag + 1000];
                if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                    label.text = [DataHelp shareData].MeetingRnameArray[sendRNumber];
                    
                }
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                        }
                    }
                    
                    
                    NSNumber *Valunumber = _DeschArray[arrCount];
                    NSString *VAlustring = [NSString stringWithFormat:@"%@",Valunumber];
                    if ([VAlustring isEqualToString:destdevString]) {
                        
                    }else
                    {
                    
                    int IndexNumber = 110;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *NumberString = [NSString stringWithFormat:@"%@",number];
                        
                        if ([NumberString isEqualToString:destdevString]) {
                            IndexNumber = i;
                        }
                        
                    }
                    
                    
                    if (IndexNumber != 110) {
                        NSNumber *Renumber = _ViewtagArray[IndexNumber];
                        NSInteger ReInder = Renumber.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:ReInder];
                        [Review removeFromSuperview];
                        
                        
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[sendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                        
                        
                            [_ViewtagArray  removeObject:Renumber];
                            [_TLinkTagArray removeObjectAtIndex:IndexNumber];
                            [_ViewRectArray removeObjectAtIndex:IndexNumber];
                            [_RNameArray removeObjectAtIndex:IndexNumber];
                            [_DeschArray removeObjectAtIndex:IndexNumber];
                            [_DesVidArray removeObjectAtIndex:IndexNumber];
                      
                        [_CurrentRLink removeObjectAtIndex:IndexNumber];
                        [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                        
                    }else if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[sendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                        [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                        
                    }
                        
                        
                    }
                }
           
            
//                UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
                
            }else if (XpanCurrentIndext <= Xfloat &&  YpanCurrentIndext >=Yfloat && Yfloat <= _NumberOfScreen -0.5 && XpanCurrentIndext >= 0)
                
            {
                _SelectedView.frame = CGRectMake((CGRectGetMaxX(_table.frame) + 6)+ BackWith * Xinteger + 2 * Xinteger ,CGRectGetMaxY(_BackView.frame) + 6 +BackHeight * (Yinteger+1) + 2 * (Yinteger+1) , BackWith, BackHeight);
                 NSString *RectString = NSStringFromCGRect(_SelectedView.frame);
                NSInteger sendRNumber = _NumberOfScreen * (Yinteger+1) + (Xinteger);
                
                if (sendRNumber < [DataHelp shareData].MeetingDestchanid.count) {
                   
                    //改变移动字典中对应的键值对
                    NSString *string = [NSString stringWithFormat:@"%ld",(long)pan.view.tag];
                    NSMutableDictionary *mutDict = [_MovViewdict objectForKey:string];
                    NSArray *arr = [mutDict allValues];
                    NSNumber *num = arr[0];
                    NSString *value = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:value forKey:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                    [_MovViewdict setObject:dict forKey:string];
                    
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
                    
                    
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger TadInteger = number.integerValue;
                        if (TadInteger == pan.view.tag) {
                            NSNumber *TLin = _TLinkTagArray[i];
                            _Tinte = TLin.integerValue;
                        }
                    }
                    
                    NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[sendRNumber];
                    NSString *String = [NSString stringWithFormat:@"%@",destch];
                    
                    NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[sendRNumber];
                    NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                    
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destdevString,
                                                                                                             @"destdevid":String,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    [self.view addSubview:_SelectedView];
                    UILabel *label = (UILabel *)[self.view viewWithTag:pan.view.tag + 1000];
                    if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                        label.text = [DataHelp shareData].MeetingRnameArray[sendRNumber];
                        
                    }
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                        }
                    }
                    
                    NSNumber *Valunumber = _DeschArray[arrCount];
                    NSString *VAlustring = [NSString stringWithFormat:@"%@",Valunumber];
                    if ([VAlustring isEqualToString:destdevString]) {
                       

                    }else
                    {
                    int IndexNumber = 110;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *NumberString = [NSString stringWithFormat:@"%@",number];
                        
                        if ([NumberString isEqualToString:destdevString]) {
                            IndexNumber = i;
                        }
                        
                    }
                    
                    
                    if (IndexNumber != 110) {
                        NSNumber *Renumber = _ViewtagArray[IndexNumber];
                        NSInteger ReInder = Renumber.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:ReInder];
                        [Review removeFromSuperview];
                        
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[sendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                        [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                        if (_IsPan == YES) {
                            
                            [_ViewtagArray  removeObject:Renumber];
                            [_TLinkTagArray removeObjectAtIndex:IndexNumber];
                            [_ViewRectArray removeObjectAtIndex:IndexNumber];
                            [_RNameArray removeObjectAtIndex:IndexNumber];
                            [_DeschArray removeObjectAtIndex:IndexNumber];
                            [_DesVidArray removeObjectAtIndex:IndexNumber];
                           
                            [_CurrentRLink removeObjectAtIndex:IndexNumber];
                          
                            
                        }
                  
                        
                    }else if (sendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                    [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                    [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                    [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                    [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[sendRNumber]];
                    [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                    [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                    [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)sendRNumber]];
                     }
                    }
                }
                
//                UIView *view = (UIView *)[self.view viewWithTag:self.OldOrNew];
//                view.backgroundColor = [UIColor colorWithRed:111/255.0 green:206/255.0 blue:250/255.0 alpha:1];
                
            }else if (XpanCurrentIndext <= Xfloat &&  YpanCurrentIndext <=Yfloat &&  Yfloat <= _NumberOfScreen - 0.5 && YpanCurrentIndext >= 0 && XpanCurrentIndext >= 0 )
            {
                _SelectedView.frame = CGRectMake((CGRectGetMaxX(_table.frame) + 6)+ BackWith * Xinteger + 2 * Xinteger ,CGRectGetMaxY(_BackView.frame) + 6 +BackHeight * Yinteger + 2 * Yinteger , BackWith, BackHeight);
                 NSString *RectString = NSStringFromCGRect(_SelectedView.frame);
                //对应的R值
                NSInteger SendRNumber = _NumberOfScreen * Yinteger + Xinteger;
                
                NSString *destchanid ;
                NSString *destevid;
                
                if (SendRNumber < [DataHelp shareData].MeetingDestchanid.count  ) {
                    NSNumber  *destch = [DataHelp shareData].MeetingDestdevid[SendRNumber];
                    NSString *String = [NSString stringWithFormat:@"%@",destch];
                    destevid = String;
                    
                    NSNumber *destdev = [DataHelp shareData].MeetingDestchanid[SendRNumber];
                    NSString *destdevString = [NSString stringWithFormat:@"%@",destdev];
                     destchanid = destdevString;
                    [self.view addSubview:_SelectedView];
                    
                    //改变移动字典中对应的键值对
                    NSString *string = [NSString stringWithFormat:@"%ld",(long)pan.view.tag];
                    NSMutableDictionary *mutDict = [_MovViewdict objectForKey:string];
                    NSArray *arr = [mutDict allValues];
                    NSNumber *num = arr[0];
                    NSString *value = [NSString stringWithFormat:@"%ld",(long)num.integerValue];
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:value forKey:[NSString stringWithFormat:@"%ld",(long)SendRNumber]];
                    [_MovViewdict setObject:dict forKey:string];
                   
                    //生成UUID
                    NSUUID *uuid = [NSUUID UUID];
                    NSString *uuidString = uuid.UUIDString;
                    
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger TadInteger = number.integerValue;
                        if (TadInteger == pan.view.tag) {
                            NSNumber *TLin = _TLinkTagArray[i];
                            _Tinte = TLin.integerValue;
                        }
                    }
                    
                    NSNumber *srcchan = [DataHelp shareData].srcchanidArray[_Tinte];
                    NSString *srcchanString = [NSString stringWithFormat:@"%@",srcchan];
                    NSNumber *srcdev = [DataHelp shareData].srcdevidArray[_Tinte];
                    NSString *srcdevString = [NSString stringWithFormat:@"%@",srcdev];
                    //消息json
                    NSDictionary *Linkdict = @{@"message":@{@"function":@"medialink_add",@"medialinks":@[@{
                                                                                                             @"destchanid":destchanid,
                                                                                                             @"destdevid":destevid,
                                                                                                             @"id":uuidString,
                                                                                                             @"srcchanid":srcchanString,
                                                                                                             @"srcdevid":srcdevString}]}};
                    NSData *data = [[NSString stringWithFormat:@"%@\n",[Linkdict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
                    [[DataHelp shareData].ClientSocket writeData:data withTimeout:-1 tag:300];
                    [[DataHelp shareData].ClientSocket readDataWithTimeout:-1 tag:300];
                    UILabel *label = (UILabel *)[self.view viewWithTag:pan.view.tag + 1000];
                    if (SendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                        label.text = [DataHelp shareData].MeetingRnameArray[SendRNumber];
                        
                    }
              
                    NSInteger arrCount = 0;
                    for (int i = 0; i < _ViewtagArray.count; i ++) {
                        NSNumber *number = _ViewtagArray[i];
                        NSInteger ArrayNumber = number.integerValue;
                        if (ArrayNumber == pan.view.tag) {
                            arrCount = i;
                        }
                    }
                    
                    NSNumber *Valunumber = _DeschArray[arrCount];
                    NSString *VAlustring = [NSString stringWithFormat:@"%@",Valunumber];
                    if ([VAlustring isEqualToString:destchanid]) {
                       
                    }else
                    {
                    int IndexNumber = 110;
                    for (int i = 0; i < _DeschArray.count; i++) {
                        NSNumber *number = _DeschArray[i];
                        NSString *NumberString = [NSString stringWithFormat:@"%@",number];
                        
                        if ([NumberString isEqualToString:destdevString]) {
                            IndexNumber = i;
                        }
                        
                    }
                    
                    
                    if (IndexNumber != 110) {
                        NSNumber *Renumber = _ViewtagArray[IndexNumber];
                        NSInteger ReInder = Renumber.integerValue;
                        UIView *Review = (UIView *)[self.view viewWithTag:ReInder];
                        [Review removeFromSuperview];
                    
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[SendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                        
                        [_ViewtagArray  removeObject:Renumber];
                        [_TLinkTagArray removeObjectAtIndex:IndexNumber];
                        [_ViewRectArray removeObjectAtIndex:IndexNumber];
                        [_RNameArray removeObjectAtIndex:IndexNumber];
                        [_DeschArray removeObjectAtIndex:IndexNumber];
                        [_DesVidArray removeObjectAtIndex:IndexNumber];
                        
                        [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)SendRNumber]];
                        [_CurrentRLink removeObjectAtIndex:IndexNumber];
                       
                   
                        
                    }else if (SendRNumber < [DataHelp shareData].MeetingRnameArray.count) {
                        [_ViewtagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:pan.view.tag]];
                        [_TLinkTagArray replaceObjectAtIndex:arrCount withObject:[NSNumber numberWithInteger:_Tinte]];
                        [_ViewRectArray replaceObjectAtIndex:arrCount withObject:RectString];
                        [_RNameArray replaceObjectAtIndex:arrCount withObject:[DataHelp shareData].MeetingRnameArray[SendRNumber]];
                        [_DesVidArray replaceObjectAtIndex:arrCount withObject:String];
                        [_DeschArray replaceObjectAtIndex:arrCount withObject:destdevString];
                         [_CurrentRLink replaceObjectAtIndex:arrCount withObject:[NSString stringWithFormat:@"%ld",(long)SendRNumber]];
                    }
                        
                    }
                    
                }

                
            }
                
            }
            
        }

    }

}



#pragma mark == tap事件======
- (void)TapAction:(UITapGestureRecognizer *)sender
{
   
    self.TagNumber = sender.view.tag;
    self.TapCount = 9;

}


- (void)Tap2Action:(UITapGestureRecognizer *)sender
{

    
}

//一键退出程序
- (void)SwitchMessage:(UIButton *)Switch
{
  

    UIAlertController *Alert = [UIAlertController alertControllerWithTitle:Localized(@"确定要退出吗") message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *CancleAction = [UIAlertAction actionWithTitle:Localized(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [DataHelp shareData].ClientSocket.userData = 0;
        [[DataHelp shareData].ClientSocket disconnect];
        [DataHelp shareData].ClientSocket.userData = SocketOffLineByUser;
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"LostUser" object:nil userInfo:nil];
        
        [DataHelp shareData].MutTXArray = nil;
        [DataHelp shareData].TAllArray = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DataHelp shareData].ClientSocket disconnect];
            BaseViewController *bas = [BaseViewController new];
            LoginViewController *login =[LoginViewController new];
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            window.rootViewController = login;
            [self dismissViewControllerAnimated:YES completion:^{
                [bas removeFromParentViewController];
                [bas.view removeFromSuperview];
            }];
       

//            AppDelegate *appDelegate =
//            (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate toMain];
        });

    }];
    [Alert addAction:action];
    [Alert addAction:CancleAction];
    [self presentViewController:Alert animated:YES completion:nil];
 
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(1);
        
    }
    
}

#pragma mark===控制按钮=====

//
- (void)SenceControlAction:(UIButton *)button
{
    [DataHelp shareData].isfast = NO;
    [DataHelp shareData].isViedeo = NO;
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    _isDesture = NO;
    if (_IsEngish == YES) {
      
        UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
        UIImage *SenceImage = [UIImage imageNamed:@"SeleEngSence"];
        [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
        
        
        UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
        UIImage *TypeImage = [UIImage imageNamed:@"EngShow"];
        [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Typebutton setImage:TypeImage forState:UIControlStateNormal];
        
        
        UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
        UIImage *VideoImage = [UIImage imageNamed:@"EngDistribute"];
        [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Videobutton setImage:VideoImage forState:UIControlStateNormal];
        
        
        UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
        UIImage *LightImage = [UIImage imageNamed:@"EngLight"];
        [Lightbutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
        LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Lightbutton setImage:LightImage forState:UIControlStateNormal];
        
    }else
    {
    
    UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
    UIImage *SenceImage = [UIImage imageNamed:@"SeleSence@2x"];
    [Sencebutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
    SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
    
    UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
    UIImage *TypeImage = [UIImage imageNamed:@"Show@2x"];
    [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Typebutton setImage:TypeImage forState:UIControlStateNormal];
    
    UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
    UIImage *VideoImage = [UIImage imageNamed:@"distribute@2x"];
    [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Videobutton setImage:VideoImage forState:UIControlStateNormal];
    
    UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
    UIImage *LightImage = [UIImage imageNamed:@"Light@2x"];
    [Lightbutton setTitleColor:WhiteColor
                      forState:UIControlStateNormal];
    LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Lightbutton setImage:LightImage forState:UIControlStateNormal];
    }
}

//灯光控制
- (void)LightButtonAction:(UIButton *)Light
{_isDesture = NO;
    [DataHelp shareData].isfast = NO;
    [DataHelp shareData].isViedeo = NO;
    if (_IsEngish == YES) {
        
        UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
        UIImage *SenceImage = [UIImage imageNamed:@"EngSence"];
        [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
        
        
        UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
        UIImage *TypeImage = [UIImage imageNamed:@"EngShow"];
        [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Typebutton setImage:TypeImage forState:UIControlStateNormal];
        
        
        UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
        UIImage *VideoImage = [UIImage imageNamed:@"EngDistribute"];
        [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Videobutton setImage:VideoImage forState:UIControlStateNormal];
        
        
        UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
        UIImage *LightImage = [UIImage imageNamed:@"SeleEngLight"];
        [Lightbutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
        LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Lightbutton setImage:LightImage forState:UIControlStateNormal];
        
    }else
    {
    UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
    UIImage *SenceImage = [UIImage imageNamed:@"Sence@2x"];
    [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Sencebutton setImage:SenceImage forState:UIControlStateNormal];

    
    UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
    UIImage *TypeImage = [UIImage imageNamed:@"Show@2x"];
    [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Typebutton setImage:TypeImage forState:UIControlStateNormal];
    
    
    UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
    UIImage *VideoImage = [UIImage imageNamed:@"distribute@2x"];
    [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Videobutton setImage:VideoImage forState:UIControlStateNormal];

    
    UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
    UIImage *LightImage = [UIImage imageNamed:@"SeleLight@2x"];
    [Lightbutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
    LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Lightbutton setImage:LightImage forState:UIControlStateNormal];
    
    }
    
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    
    _LightView= [LightViewController new];
    _LightView.view.frame = CGRectMake(0, Height4SuperView*0.84, Width4SuperView, Height4SuperView*0.16);
    _LightView.view.layer.cornerRadius = 5;
    _LightView.view.layer.masksToBounds = YES;
    _LightView.view.layer.borderColor = [UIColor blackColor].CGColor;
    _LightView.view.layer.shadowRadius = 2;
    _LightView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_LightView.view];
    [self addChildViewController:_LightView];
    [_LightView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SenceSCroller.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(2);
        //        make.right.equalTo(self.view.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(Width4SuperView - 4);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
    }];
}

//显示格式
- (void)FormBuutonAction:(UIButton *)form
{
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    
    
    _formView= [FormViewController new];
    _formView.view.frame = CGRectMake(50, Height4SuperView*0.8, Width4SuperView-100, Height4SuperView*0.2);
    _formView.view.layer.cornerRadius = 5;
    _formView.view.layer.masksToBounds = YES;
    _formView.view.layer.borderColor = [UIColor blackColor].CGColor;
    _formView.view.layer.shadowRadius = 2;
    _formView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_formView.view];
    [self addChildViewController:_formView];
    [_LightView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SenceSCroller.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(2);
        //        make.right.equalTo(self.view.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(Width4SuperView - 4);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
    }];
}

//摄像头
- (void)CameraButtonAction:(UIButton *)camer
{
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    
     _CamearView= [CamerViewController new];
    _CamearView.view.frame = CGRectMake(0, Height4SuperView*0.8, Width4SuperView, Height4SuperView*0.2);
    _CamearView.view.layer.cornerRadius = 5;
    _CamearView.view.layer.masksToBounds = YES;
    _CamearView.view.layer.borderColor = [UIColor blackColor].CGColor;
    _CamearView.view.layer.shadowRadius = 2;
    _CamearView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_CamearView.view];
    [self addChildViewController:_CamearView];
}

//视屏分发
- (void)videoButtonAction:(UIButton *)video
{
    [DataHelp shareData].isfast = YES;
    [DataHelp shareData].isViedeo = YES;
    _isDesture = YES;
    
    if (_IsEngish == YES) {
        UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
        UIImage *SenceImage = [UIImage imageNamed:@"EngSence"];
        [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
        
        
        UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
        UIImage *TypeImage = [UIImage imageNamed:@"EngShow"];
        [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Typebutton setImage:TypeImage forState:UIControlStateNormal];
        
        
        UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
        UIImage *VideoImage = [UIImage imageNamed:@"SeleEngDistribute"];
        [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Videobutton setImage:VideoImage forState:UIControlStateNormal];
        
        
        UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
        UIImage *LightImage = [UIImage imageNamed:@"EngLight"];
        [Lightbutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
        LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Lightbutton setImage:LightImage forState:UIControlStateNormal];
        
    }else
    {
    UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
    UIImage *SenceImage = [UIImage imageNamed:@"Sence@2x"];
    SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
    
    
    UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
    UIImage *TypeImage = [UIImage imageNamed:@"Show@2x"];
    TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [Typebutton setImage:TypeImage forState:UIControlStateNormal];
    
    
    UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
    UIImage *VideoImage = [UIImage imageNamed:@"SeleDistribute@2x"];
    [Videobutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
    VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Videobutton setImage:VideoImage forState:UIControlStateNormal];
    

    UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
    UIImage *LightImage = [UIImage imageNamed:@"Light@2x"];
    [Lightbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Lightbutton setImage:LightImage forState:UIControlStateNormal];
    }
    
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    
    _VideoView = [VideoViewController new];
    _VideoView.view.frame = CGRectMake(0, Height4SuperView*0.84, Width4SuperView, Height4SuperView*0.16);
    _VideoView.view.layer.cornerRadius = 5;
    _VideoView.view.layer.masksToBounds = YES;
    _VideoView.view.layer.borderColor = [UIColor blackColor].CGColor;
    _VideoView.view.layer.shadowRadius = 2;
    _VideoView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_VideoView.view];
    [self addChildViewController:_VideoView];

    [_VideoView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SenceSCroller.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(2);
        // make.right.equalTo(self.view.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(Width4SuperView - 4);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
    }];
}

//音量控制
- (void)volumeButtonAction:(UIButton *)Volume
{
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    
    
    _VolumeView = [VolumeViewController new];
    _VolumeView.view.frame = CGRectMake(50, Height4SuperView*0.8, Width4SuperView-100, Height4SuperView*0.2);
    _VolumeView.view.layer.cornerRadius = 5;
    _VolumeView.view.layer.masksToBounds = YES;
    _VolumeView.view.layer.borderColor = [UIColor blackColor].CGColor;
    _VolumeView.view.layer.shadowRadius = 2;
    _VolumeView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_VolumeView.view];
//    [self addChildViewController:_VolumeView];
}


//显示模式
- (void)typeButtonAction:(UIButton *)type
{   [DataHelp shareData].isfast = NO;
    [DataHelp shareData].isViedeo = NO;
    _isDesture = NO;
    
    if (_IsEngish == YES) {
    
        UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
        UIImage *SenceImage = [UIImage imageNamed:@"EngSence"];
        [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
        
        
        UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
        UIImage *TypeImage = [UIImage imageNamed:@"SeleEngShow"];
        [Typebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Typebutton setImage:TypeImage forState:UIControlStateNormal];
        
        
        UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
        UIImage *VideoImage = [UIImage imageNamed:@"EngDistribute"];
        [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
        VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Videobutton setImage:VideoImage forState:UIControlStateNormal];
        
        
        UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
        UIImage *LightImage = [UIImage imageNamed:@"EngLight"];
        [Lightbutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
        LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [Lightbutton setImage:LightImage forState:UIControlStateNormal];
    
}else
{
    
    UIButton *Sencebutton = (UIButton *)[self.view viewWithTag:1196];
    UIImage *SenceImage = [UIImage imageNamed:@"Sence@2x"];
    [Sencebutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    SenceImage = [SenceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Sencebutton setImage:SenceImage forState:UIControlStateNormal];
    
    UIButton *Typebutton = (UIButton *)[self.view viewWithTag:1197];
    UIImage *TypeImage = [UIImage imageNamed:@"SeleShow@2x"];
    [Typebutton setTitleColor:SenceSleleColor forState:UIControlStateNormal];
    TypeImage = [TypeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Typebutton setImage:TypeImage forState:UIControlStateNormal];
    
    UIButton *Videobutton = (UIButton *)[self.view viewWithTag:1198];
    UIImage *VideoImage = [UIImage imageNamed:@"distribute@2x"];
    VideoImage = [VideoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Videobutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    [Videobutton setImage:VideoImage forState:UIControlStateNormal];
    
    UIButton *Lightbutton = (UIButton *)[self.view viewWithTag:1199];
    UIImage *LightImage = [UIImage imageNamed:@"Light@2x"];
    [Lightbutton setTitleColor:WhiteColor forState:UIControlStateNormal];
    LightImage = [LightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [Lightbutton setImage:LightImage forState:UIControlStateNormal];
}
    
    [_formView.view removeFromSuperview];
    [_LightView.view removeFromSuperview];
    [_CamearView.view removeFromSuperview];
    [_VideoView.view removeFromSuperview];
    [_VolumeView.view removeFromSuperview];
    [_TypeView.view removeFromSuperview];
    
    _TypeView = [TypeViewController new];
    _TypeView.view.frame = CGRectMake(0, Height4SuperView*0.84, Width4SuperView, Height4SuperView*0.16);
    _TypeView.view.layer.cornerRadius = 5;
    _TypeView.view.layer.masksToBounds = YES;
    _TypeView.view.layer.borderColor = [UIColor blackColor].CGColor;
    _TypeView.view.layer.shadowRadius = 2;
    _TypeView.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_TypeView.view];
    [self addChildViewController:_TypeView];

    [_TypeView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SenceSCroller.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(2);
        //        make.right.equalTo(self.view.mas_bottom).with.offset(-3);
        make.width.mas_equalTo(Width4SuperView - 4);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
    }];
    
   
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
////     UITouch *touch = [touches anyObject];
//    [_search resignFirstResponder];
//    [_SearchCoveview removeFromSuperview];
//    _search.text = @"";
//    
// 
//    
//}


//懒加载初始化数组
- (NSMutableArray *)WidthCountArray
{
    if (_WidthCountArray == nil) {
        _WidthCountArray = [NSMutableArray array];
    }
    return _WidthCountArray;
}

- (NSMutableArray *)HeightArray
{
    if (_HeightArray == nil) {
        _HeightArray = [NSMutableArray array];
    }
    return _HeightArray;
}


- (NSMutableArray *)OrigionY
{
    if (_OrgionX == nil) {
        _OrgionX = [NSMutableArray array];
    }
    return _OrgionX;
}

- (NSMutableArray *)OrgionX
{
    if (_OrgionX == nil) {
        _OrgionX = [NSMutableArray array];
    }
    return _OrgionX;
    
}

//  懒加载新创建的视图控制器数组
- (NSMutableArray *)MoveViewArray
{
    if (_MoveViewArray == nil) {
        _MoveViewArray = [NSMutableArray array];
        
    }
    return _MoveViewArray;
    
}

@end
