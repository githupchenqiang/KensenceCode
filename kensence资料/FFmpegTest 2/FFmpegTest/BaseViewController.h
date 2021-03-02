//
//  BaseViewController.h
//  FFmpegTest
//
//  Created by chenq@kensence.com on 16/3/15.
//  Copyright © 2016年 times. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "KxMovieViewController.h"
@interface BaseViewController : UIViewController

@property (nonatomic ,strong)UICollectionView *table; //T输入控制器
@property (nonatomic ,strong)NSString *TextString;//解码器的名字
//@property (nonatomic ,strong)KxMovieDecoder  *_decoder;
@property (nonatomic ,copy)KxMovieViewController *kxMovie;
@property (nonatomic ,strong)NSNumber *temp;
@property (nonatomic ,assign)NSInteger LongPressCount;
@property (nonatomic ,strong)NSMutableArray  *WidthCountArray; //自定义R的With
@property (nonatomic ,strong)NSMutableArray *HeightArray; //自定义R的height
@property (nonatomic ,strong)NSMutableArray *OrgionX; //自定义R的X
@property (nonatomic ,strong)NSMutableArray *OrigionY; //自定义R的Y
@property (nonatomic ,strong)UIScrollView  *SenceSCroller;//场景列表
@property (nonatomic ,strong)UIView  *Aview;
@property (nonatomic ,strong)UIScrollView *MeetingScroller; //会场列表
@property (nonatomic ,strong)UIButton  *OneButton; //单屏
@property (nonatomic ,strong)UIButton  *FourButton; //四屏
@property (nonatomic ,strong)UIButton *NineButton;//九屏
@property (nonatomic ,strong)UIButton *sixthButton;//十六屏
@property (nonatomic ,strong)UIButton *SaveButton;//保存按钮
@property (nonatomic ,strong)UIButton *CustomButton; //自定义分屏
@property (nonatomic ,strong)UIView *BackView;//分屏背景
@property (nonatomic ,strong)NSMutableArray *RScreenArray; //分屏数
@property (nonatomic ,assign)NSInteger NumberOfScreen;//记录分屏数
@property (nonatomic ,strong)UIView *BackScro;//分屏的滚动视图
@property (nonatomic ,strong)UIView *backRScreen;//分屏最底层图
@property (nonatomic ,assign)NSInteger Leftindex;//左边向下按钮
@property (nonatomic ,assign)NSInteger RightIndex; //右边向下按钮
@property (nonatomic ,assign)NSInteger NUmberSave;//记录用户第几次截屏；
@property (nonatomic ,assign)CGPoint indexPlace; //记录点击的位置
@property (nonatomic ,strong)UIView *Vie;
@property (nonatomic ,assign)NSInteger TagNumber; //当前点击view的tag值
@property (nonatomic ,copy)KxMovieViewController *move; //点击cell创建的视屏
@property (nonatomic ,assign)NSInteger allowScrpller; //记录
@property (nonatomic ,strong)UIView *Oneview; //单屏
@property (nonatomic ,assign)CGFloat RemoveFloat; //记录最后一次移动的位置
@property (nonatomic ,assign)CGFloat CurrentWith; //记录移动的X位置
@property (nonatomic ,assign)CGFloat CurrentHeight; //记录移动的Y位置
@property (nonatomic ,strong)UIView *SelectedView; //点击生成的Video
@property (nonatomic ,strong)UIView *BackViewScroller; //当前展示屏的视图
@property (nonatomic ,assign)CGFloat ScrollerCurrentIndex; //Scroller当前的page
@property (nonatomic ,strong)NSMutableDictionary *OneDict; //存储单屏数据
@property (nonatomic ,strong)NSMutableDictionary *TwoDict; //存储2屏数据
@property (nonatomic ,strong)NSMutableDictionary *ThreeDict; //存储3屏数据
@property (nonatomic ,strong)NSMutableDictionary *FourDict; //存储4屏数据
@property (nonatomic ,assign)NSInteger Pantime; //点击生成视图记录生成后是不是第一次pan
@property (nonatomic ,assign)NSInteger didSelect;//记录点击的cell的次数
@property (nonatomic ,assign)NSInteger TapCount;//是否点击了
@property (nonatomic ,assign)NSInteger DecomeTag; // 解码器的标记
@property (nonatomic ,strong)NSMutableArray *DecomeMutArray; //将点击过的解码器存放到数组
@property (nonatomic ,strong)UILabel *decomeLabel; //屏中位置解码器的名字
@property (nonatomic ,strong)NSMutableArray *SenceTagArray; //输出场景的tag数组
@property (nonatomic ,assign)NSInteger PanviewTag; //标记值
@property (nonatomic ,assign)NSInteger OldOrNew; //最后一次经过R的tag
@property (nonatomic ,strong)NSMutableArray *MoveViewArray; //存储后创建的视图控制器的Tag
@property (nonatomic ,assign)NSInteger DecomeNumber;//自定义选择的第几个解码器
@property (nonatomic ,strong)UIView *CustomView; //分屏画布
@property (nonatomic ,strong)NSMutableArray *CustomMutarray;//
@property (nonatomic ,strong)NSMutableDictionary *CustomMutDict;//存储自定义布局view的位置信息、
@property (nonatomic ,strong)UIButton *SaveSence; //应用自定义的的画面
@property (nonatomic ,assign)NSInteger SenceBool; //是否进行了自定义布局
@property (nonatomic ,assign)BOOL isbool; //是否调用会场列表
@property (nonatomic ,strong)UIButton *button;//向左按钮
@property (nonatomic ,strong)UIButton *lipButton;//返回按钮
//@property (nonatomic ,strong)NSMutableArray *SenceCountView; //自定义场景View的个数
@property (nonatomic ,assign)NSInteger SenceCount; //会场列表
@property (nonatomic ,strong)UIImageView *ImageView;
@property (nonatomic ,strong)NSMutableDictionary *MovViewdict; //保存T和R
@property (nonatomic ,strong)NSMutableArray *MovViewArray; //保存连接状态
@property (nonatomic ,copy)NSMutableArray *SaveSenceArray; //接受保存查询的数据



@end
