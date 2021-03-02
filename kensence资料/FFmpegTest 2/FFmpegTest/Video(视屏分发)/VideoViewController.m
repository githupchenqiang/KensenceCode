//
//  VideoViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/3/25.
//  Copyright © 2016年 times. All rights reserved.
//

#import "VideoViewController.h"
#import "DataHelp.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"
#import "CamerViewController.h"

#define View4Width self.view.frame.size.width
#define View4Height self.view.frame.size.height

@interface VideoViewController ()
{
    UIScrollView *ViewdeoScroller;
}
@property(nonatomic,strong)UIView *VideoView;
@property (nonatomic ,strong)NSMutableArray *mutArray;
@property(nonatomic,strong)NSMutableArray *DataArray;
@property (nonatomic ,assign)NSInteger inter;
@property (nonatomic ,strong)NSMutableSet *MutSetArray; //中间传值数组
@property (nonatomic ,assign)BOOL isSelect;
@property (nonatomic ,assign)NSInteger LineNumber;
@property (nonatomic ,strong)CamerViewController *CamearView;

@end

@implementation VideoViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [DataHelp shareData].SenceDistureArray = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景图
    UIView *BacView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BacView.backgroundColor = TabbleColor;
    [self.view addSubview:BacView];
    
    _mutArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    _DataArray = [NSMutableArray array];
    
    _VideoView = [[UIView alloc]init];
    _VideoView.frame = CGRectMake(50, 10,View4Width * 0.12, 100);
    _VideoView.layer.borderWidth = 1;
    _VideoView.layer.borderColor = [UIColor blackColor].CGColor;
    _VideoView.backgroundColor = TabbleColor;
    _VideoView.tag = 1919;
    [self.view addSubview:_VideoView];
    [_VideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(View4Height * 0.02);
        make.left.equalTo(self.view.mas_left).with.offset(25);
        make.width.mas_equalTo(View4Width * 0.12);
        make.height.mas_equalTo(View4Height * 0.13);
    }];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 60)];
    label.tag = 9797;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = Localized(@"输入源");
    label.numberOfLines = 0;
    [_VideoView addSubview:label];
    
    NSInteger spaceNumber;
    if ([DataHelp shareData].MeetingRnameArray.count > 10) {
        spaceNumber = 2;
    }else if ([DataHelp shareData].MeetingRnameArray.count/10 > 2)
    {
        spaceNumber = [DataHelp shareData].MeetingRnameArray.count / 10;
    }
    
    ViewdeoScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    ViewdeoScroller.bounces = NO;
    [ViewdeoScroller setContentSize:CGSizeMake(ViewdeoScroller.frame.size.width, View4Height * 0.16 *  spaceNumber)];
    [self.view addSubview:ViewdeoScroller];
    [ViewdeoScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(View4Width * 0.2);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
  
    if ([DataHelp shareData].MeetingRnameArray.count > 5 ){
        
        if ((CGFloat)([DataHelp shareData].MeetingRnameArray.count / 5)  >= 1) {
            _LineNumber = (NSInteger)([DataHelp shareData].MeetingRnameArray.count/5 + 1);
        }
        
        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < _LineNumber; j++) {
                NSString *Namestring;
                if (5* j + i < [DataHelp shareData].MeetingRnameArray.count) {
                    UIButton *RButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    RButton.frame = CGRectMake(0 +(View4Width * 0.12+20)*i, 10+(View4Height*0.04 + 20)*j, View4Width * 0.12,View4Height* 0.04);
                    RButton.tag = 7999 + 5 * j+i;
                    RButton.layer.cornerRadius = 8;
                    RButton.layer.borderColor = [UIColor blackColor].CGColor;
                    RButton.layer.borderWidth = 0.4;
                    RButton.layer.masksToBounds = YES;
                    RButton.selected = NO;
                   
                    NSString *NUmberString = [NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingRnameArray [5*j+i]];
                    RButton.titleEdgeInsets = UIEdgeInsetsMake(0,-20, -0,-RButton.imageView.frame.size.width+20);
                    UILongPressGestureRecognizer *RbuLong = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongAction:)];
                    
                    RbuLong.minimumPressDuration = 1;
                    [RButton addGestureRecognizer:RbuLong];
                    UIImage *buImage = [UIImage imageNamed:@"NoSele"];
                    buImage = [buImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    [RButton setImage:buImage forState:UIControlStateNormal];
                    RButton.imageEdgeInsets = UIEdgeInsetsMake((View4Height* 0.04 -20)/2,RButton.frame.size.width - 20, (View4Height* 0.04 -20)/2, 0);
                    [RButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [RButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    UIImage *BuBacImage = [UIImage imageNamed:@"video"];
                    BuBacImage = [BuBacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    [RButton setBackgroundImage:BuBacImage forState:UIControlStateNormal];
                    [RButton setBackgroundImage:BuBacImage forState:UIControlStateHighlighted];
                    [RButton setBackgroundImage:BuBacImage forState:UIControlStateSelected];
                    [RButton setBackgroundImage:BuBacImage forState:UIControlStateSelected | UIControlStateHighlighted];
                    
                    if (NUmberString.length > 6) {
                        Namestring = [NUmberString substringFromIndex:2];
                    }else
                    {
                        Namestring = NUmberString;
                    }
                    
                    [RButton setTitle:Namestring forState:UIControlStateNormal];
                    [RButton addTarget:self action:@selector(UserButtonAction:) forControlEvents:UIControlEventTouchDown];
                    [ViewdeoScroller addSubview:RButton];
                    
                }
        }
    }
        
    }else
    {
        for (int i = 0; i < [DataHelp shareData].MeetingRnameArray.count; i++) {
            UIButton *RButton = [UIButton buttonWithType:UIButtonTypeSystem];
            RButton.frame = CGRectMake(0 +(View4Width * 0.12+20)*i, 10 , View4Width * 0.12,View4Height* 0.04);
            RButton.tag = 7999 + i;
            RButton.layer.cornerRadius = 8;
            RButton.layer.borderColor = [UIColor blackColor].CGColor;
            RButton.layer.borderWidth = 0.4;
            RButton.layer.masksToBounds = YES;
            RButton.selected = NO;
            NSString *NUmberString = [NSString stringWithFormat:@"%@",[DataHelp shareData].MeetingRnameArray[i]];
            RButton.titleEdgeInsets = UIEdgeInsetsMake(0,-20, -0,-RButton.imageView.frame.size.width+20);
            UIImage *Buttonimage = [UIImage imageNamed:@"NoSele"];
            Buttonimage = [Buttonimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [RButton setImage:Buttonimage forState:UIControlStateNormal];
            RButton.imageEdgeInsets = UIEdgeInsetsMake((View4Height* 0.04 -20)/2,RButton.frame.size.width - 20, (View4Height* 0.04 -20)/2, 0);
            
        //派生到我的代码片
            UILongPressGestureRecognizer *LongButton = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongAction:)];
            LongButton.minimumPressDuration = 1.0;
            [RButton addGestureRecognizer:LongButton];
            [RButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [RButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            UIImage *BuBacImage = [UIImage imageNamed:@"video"];
            BuBacImage = [BuBacImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [RButton setBackgroundImage:BuBacImage forState:UIControlStateNormal];
            [RButton setBackgroundImage:BuBacImage forState:UIControlStateHighlighted];
            [RButton setBackgroundImage:BuBacImage forState:UIControlStateSelected];
            [RButton setBackgroundImage:BuBacImage forState:UIControlStateSelected | UIControlStateHighlighted];
            

            NSString *Namestring;
           
                Namestring = NUmberString;
//            }
            
            [RButton setTitle:Namestring forState:UIControlStateNormal];
            [RButton addTarget:self action:@selector(UserButtonAction:) forControlEvents:UIControlEventTouchDown];
            [ViewdeoScroller addSubview:RButton];
        }
    }
}

/**
 *  设备设置界面
 *
 *  @param Long 
 */
- (void)LongAction:(UILongPressGestureRecognizer *)Long
{
    if (Long.state == UIGestureRecognizerStateBegan) {
//        [DataHelp shareData].isViedeo = YES;
        [DataHelp shareData].ipString = [NSString stringWithFormat:@"%@",[DataHelp shareData].RIPArray[Long.view.tag -7999]];
        NSDictionary *dict = @{@"LongTag":[NSString stringWithFormat:@"%ld",(long)Long.view.tag]};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LongCamer" object:nil userInfo:dict];
    }
}

/**
 *  R设备选择
 *
 *  @param sender
 */
- (void)UserButtonAction:(UIButton *)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        self.inter = (NSInteger)(sender.tag - 7999);
        NSNumber *numStr = [NSNumber numberWithInteger:self.inter];
        [_DataArray addObject:numStr];
        UIImage *senderImage = [UIImage imageNamed:@"sele"];
        senderImage = [senderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:senderImage forState:UIControlStateNormal];
        _MutSetArray = [NSMutableSet setWithArray:_DataArray];//改了数组
        NSArray *array = [_MutSetArray allObjects];
        NSArray *sorted = [array sortedArrayUsingSelector:@selector(compare:)];
        _DataArray = [NSMutableArray arrayWithArray:sorted];
        [[DataHelp shareData].SenceDistureArray addObject:numStr];
    }else
    {
       
        UIImage *senderImage = [UIImage imageNamed:@"NoSele"];
        senderImage = [senderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [sender setImage:senderImage forState:UIControlStateNormal];
        sender.selected = NO;
        NSInteger inter = (NSInteger)(sender.tag - 7999);
        NSNumber *number = [NSNumber numberWithInteger:inter];
        [_DataArray removeObject:number];
        [[DataHelp shareData].SenceDistureArray removeObject:number];
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
