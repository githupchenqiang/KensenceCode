//
//  SplitViewController.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/4/21.
//  Copyright © 2016年 times. All rights reserved.
//
#import "SplitViewController.h"
#import "BaseViewController.h"
#import "DataHelp.h"
#import "CustomData.h"
#import "MBProgressHUD+MJ.h"


#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

#define UserNameString [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"]



@interface SplitViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIAlertController *alert;
}
@property (nonatomic ,assign)NSInteger LongViewTag;
@property (nonatomic ,assign)NSInteger TapMeeting;
@end

@implementation SplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TabbleColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,2, WIDTH *0.223, 45)];
    label.backgroundColor = [UIColor colorWithRed:33/255.0 green:39/255.0 blue:50/255.0 alpha:1];
    label.text = Localized(@"会场列表");
    label.textColor = [UIColor colorWithRed:150/255.0 green:154/255.0 blue:163/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.MeetingScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 42, WIDTH * 0.223,HEIGHT *0.67)];
    self.MeetingScroller.contentSize = CGSizeMake(WIDTH * 0.223, 210 * [DataHelp shareData].LocationArray.count + 60 * [DataHelp shareData].LocationArray.count);
    self.MeetingScroller.backgroundColor = [UIColor clearColor];
    self.MeetingScroller.bounces = NO;
    [self.view addSubview:self.MeetingScroller];
    
    
    for (int i = 0;i < [DataHelp shareData].LocationArray.count; i++) {
        NSDictionary *LocaDict = [DataHelp shareData].LocationArray[i];
        if ([[LocaDict valueForKey:@"name"]isEqualToString:@"默认"]) {
            [[DataHelp shareData].LocationArray insertObject:[DataHelp shareData].LocationArray[i] atIndex:0];
            [[DataHelp shareData].LocationArray removeObjectAtIndex:i+1];
        }
    }
    
    //创建会场View
    for (int i = 0; i < 1; i++) {
        for (int j = 0; j < [DataHelp shareData].LocationArray.count; j++) {
            UIView *View = [[UIView alloc]initWithFrame:CGRectMake(15, 60 +  (WIDTH * 0.22 * 0.56688654 + 60) * j , WIDTH * 0.22 - 30, WIDTH * 0.22 *0.56688654)];
            View.layer.borderColor = [UIColor blackColor].CGColor;
            View.layer.borderWidth = 0.7;
            View.layer.cornerRadius = 2;
            View.layer.masksToBounds = YES;
//            View.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1];
            View.tag = 3000 + j;
             View.backgroundColor = ScrollerColor;
            UILongPressGestureRecognizer *Long = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongAction:)];
            Long.delegate = self;
            [View addGestureRecognizer:Long];
            UITapGestureRecognizer *viewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapMeetingAction:)];
            viewtap.numberOfTapsRequired = 2;
            viewtap.delegate = self;
            [View addGestureRecognizer:viewtap];
        
            [_MeetingScroller addSubview:View];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 20+ (WIDTH * 0.22 *0.56688654 + 60) * j, WIDTH * 0.22 - 30, 40)];
            
            NSDictionary *LocaDict = [DataHelp shareData].LocationArray[j];
            label.text = [LocaDict valueForKey:@"name"];
            if ([[LocaDict valueForKey:@"name"] isEqualToString:[DataHelp shareData].MeetingIndex]) {
            label.backgroundColor = MeetingNameColor;
            label.textColor = WhiteColor;
            }else
            {
                label.textColor = CustomPancolor;
                label.backgroundColor = Meetingcolor;
            }
            label.tag = 3010+j;
            label.textAlignment = NSTextAlignmentCenter;
            [_MeetingScroller addSubview:label];
            
//            for (NSDictionary *LocaDict in [DataHelp shareData].LocationArray) {
//            }
        }
    }
    
    if ([DataHelp shareData].MeetingIndex == nil) {
        UILabel *label = [self.view viewWithTag:3010];
        label.backgroundColor = MeetingNameColor;
        label.textColor = WhiteColor;
    }
    
    
 
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"CustomMessage"];
    
//    for (int i = 0; i < 5; i ++) {
    
//        BaseViewController *Base = [[BaseViewController alloc]init];
//        NSInteger count =  Base.SenceCount;
    
    for (int i = 0; i < [DataHelp shareData].LocationArray.count; i++) {
        
        UIView *bacview = (UIView *)[self.view viewWithTag:3000+i];
        NSData *imageData;
        NSString *string = [NSString stringWithFormat:@"%@image%@",UserNameString,[DataHelp shareData].LocationArray[i][@"name"]];
        imageData = [[NSUserDefaults standardUserDefaults]objectForKey:string];
        if (imageData != nil) {
            UIImage  *imag= [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
            imag = [imag imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-31,-15, WIDTH * 0.24 - 33, WIDTH * 0.22 * 0.75688654)];
            imageView.userInteractionEnabled = YES;
            imageView.image = imag;
            UITapGestureRecognizer *request = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RequestAction:)];
            request.numberOfTapsRequired = 1;
            request.delegate = self;

            [imageView addGestureRecognizer:request];
            imageView.tag = 5999+i;
            [bacview addSubview:imageView];
        }
    }
}
- (void)TapMeetingAction:(UITapGestureRecognizer *)Tap
{
    NSMutableArray *channel = [[NSMutableArray alloc]init];
    [DataHelp shareData].MeetingDestchanid = [NSMutableArray array];
    [DataHelp shareData].MeetingDestdevid = [NSMutableArray array];
    [DataHelp shareData].MeetingRnameArray = [NSMutableArray array];
    [[DataHelp shareData].RIPArray removeAllObjects];
    [DataHelp shareData].MeetingIndex = [DataHelp shareData].LocationArray[Tap.view.tag - 3000][@"name"];
    for (NSDictionary *device in [DataHelp shareData].DeviceArray) {
        if ([device[@"type"]isEqualToString:@"RX"] && [device[@"location"][@"id"] isEqualToString:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[Tap.view.tag - 3000][@"id"]]]) {
            [[DataHelp shareData].MeetingDestdevid addObject:device[@"id"]];
            [[DataHelp shareData].MeetingRnameArray addObject:device[@"name"]];
             [[DataHelp shareData].RIPArray addObject:[device[@"net"] valueForKey:@"ip"]];
            channel = device[@"channels"];
            for (NSDictionary *Dict in channel) {
                [[DataHelp shareData].MeetingDestchanid addObject:Dict[@"id"]];
            }
        }
    }
   [DataHelp shareData].MeetingName = [DataHelp shareData].LocationArray[Tap.view.tag - 3000][@"name"];
  
    NSInteger tapTag = Tap.view.tag;
    [DataHelp shareData].MeetingNumber = tapTag - 2999;
    _TapMeeting = tapTag;
    NSDictionary *dict = @{@"tag":[NSString stringWithFormat:@"%ld",(long)tapTag]};
    
    if ([DataHelp shareData].destchanidArray.count != 0) {
        //创建通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SplitBackView" object:nil userInfo:dict];
    }else{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"无解码器 不可操作");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 100)];//提示框的位置
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.2]; //多久后隐藏
            //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];
            
        });
    }
 

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
    
}

- (void)TapCustom:(UITapGestureRecognizer *)tap
{
    
}
    //选取会场列表的手势事件
- (void)RequestAction:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
    
        if ([DataHelp shareData].destchanidArray.count != 0) {
            NSMutableArray *channel = [[NSMutableArray alloc]init];
            [[DataHelp shareData].RIPArray removeAllObjects];
            [DataHelp shareData].MeetingDestchanid = [NSMutableArray array];
            [DataHelp shareData].MeetingDestdevid = [NSMutableArray array];
            [DataHelp shareData].MeetingRnameArray = [NSMutableArray array];
            
            for (NSDictionary *device in [DataHelp shareData].DeviceArray) {
                if ([device[@"type"]isEqualToString:@"RX"] && [device[@"location"][@"id"] isEqualToString:[NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[tap.view.tag - 5999][@"id"]]]) {
                    [[DataHelp shareData].MeetingDestdevid addObject:device[@"id"]];
                    [[DataHelp shareData].MeetingRnameArray addObject:device[@"name"]];
                    channel = device[@"channels"];
                    [[DataHelp shareData].RIPArray addObject:[device[@"net"] valueForKey:@"ip"]];
                    for (NSDictionary *Dict in channel) {
                        [[DataHelp shareData].MeetingDestchanid addObject:Dict[@"id"]];
                    }
                }
            }
            
            [DataHelp shareData].MeetingName = [DataHelp shareData].LocationArray[tap.view.tag - 5999][@"name"];
            //创建通知将手势事件发送出去
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Remve" object:nil userInfo:nil];
            NSString *string = [NSString stringWithFormat:@"%ld",(long)tap.view.tag];
           
            //创建通知将点击的View的标记值发送出去
            NSDictionary *dict = @{@"value":string};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ViewName" object:nil userInfo:dict];
            
            //选择会场模式将状态标记为yes
            [DataHelp shareData].CustomeIsBool = YES;
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                mbp.mode = MBProgressHUDModeText;
                mbp.label.text = Localized(@"当前会场无在线解码器 请检查设备状态");
                mbp.margin = 10.0f; //提示框的大小
                [mbp setOffset:CGPointMake(10, 100)];//提示框的位置
                mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                [mbp hideAnimated:YES afterDelay:1.2]; //多久后隐藏
                //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerAction:) userInfo:nil repeats:NO];
            });
        }
    }
    [DataHelp shareData].MeetingNumber = tap.view.tag - 5998;
  
}

//长按修改会场列表
- (void)LongAction:(UILongPressGestureRecognizer *)Long
{
    if (Long.state == UIGestureRecognizerStateBegan) {
        [DataHelp shareData].TapTagNumber = Long.view.tag;
        if ([DataHelp shareData].destchanidArray.count != 0) {
            _LongViewTag = Long.view.tag;
            
            alert= [UIAlertController alertControllerWithTitle:nil message:Localized(@"是否删除当前会场布局") preferredStyle:UIAlertControllerStyleAlert];
            //    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            //        // 可以在这里对textfield进行定制，例如改变背景色
            //        //textField.backgroundColor = [UIColor orangeColor];
            //        textField.delegate = self;
            //        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
            //
            //    }];
            UIAlertAction *Action = [UIAlertAction actionWithTitle:Localized(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction *twoAc = [UIAlertAction actionWithTitle:Localized(@"删除") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //        //修改会场列表的名称
                //        UILabel *label = (UILabel *)[self.view viewWithTag:Long.view.tag + 10];
                //        UITextField *string = (UITextField *)alert.textFields.firstObject;
                //        label.text  = string.text;
                //        NSLog(@"%@",string.text);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleSence" object:nil userInfo:nil];
                UIImageView *imageView = (UIImageView *)[self.view viewWithTag:_LongViewTag + 2999];
                [imageView removeFromSuperview];
                NSString *imaString = [NSString stringWithFormat:@"%@image%@",UserNameString,[DataHelp shareData].LocationArray[_LongViewTag - 3000][@"name"]];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:imaString];
                
            [CustomData deleteName:UserNameString Meeting: [NSString stringWithFormat:@"%@",[DataHelp shareData].LocationArray[_LongViewTag - 3000]]];
//                [CustomData SelectedName:UserNameString Meeting:(int)_LongViewTag - 2999];
            }];
            [alert addAction:Action];
            [alert addAction:twoAc];
            [self presentViewController:alert animated:YES completion:nil];
        }
       
        }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
