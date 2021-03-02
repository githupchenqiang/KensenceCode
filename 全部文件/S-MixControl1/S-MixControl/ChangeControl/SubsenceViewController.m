//
//  SubsenceViewController.m
//  S-MixControl
//
//  Created by aa on 15/12/10.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "SubsenceViewController.h"
#import "SignalValue.h"
#define KScreenWith self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height
#define ScrollerWith  self.OutScroller.frame.size.width
#define ScrollerHeight self.OutScroller.frame.size.height
#define BackScrollerHight self.BackScroller.frame.size.height
#define BackSrollerWith   self.BackScroller.frame.size.width

@interface SubsenceViewController ()
@property (nonatomic ,strong)UILabel *Inlabel;
@property (nonatomic ,strong)UIScrollView *OutScroller;
@property (nonatomic ,strong)UIScrollView *BackScroller;
@property (nonatomic ,strong)NSMutableArray *labelArrat;
@property (nonatomic ,strong)NSMutableArray *mutArray;
@property (nonatomic ,strong)NSString *string;
@end

@implementation SubsenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self SetUpScroller];
    [self SetUpLabel];
}

- (void)SetUpLabel
{
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        for (int j = 0; j < 1; j++) {
            UILabel *Inlabel = [[UILabel alloc]initWithFrame:CGRectMake(0+BackSrollerWith/300*j,BackScrollerHight/20+ BackScrollerHight/9.5*i,BackSrollerWith/7,BackScrollerHight/13)];
            Inlabel.backgroundColor = [UIColor whiteColor];
            Inlabel.layer.masksToBounds = YES;
            Inlabel.layer.cornerRadius = 5;
            Inlabel.tag = 5000+i;
            Inlabel.layer.borderColor = [UIColor blackColor].CGColor;
            Inlabel.layer.borderWidth = 0.50f;
            Inlabel.font = [UIFont systemFontOfSize:19];
            Inlabel.textAlignment = NSTextAlignmentCenter;
            _OutScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_Inlabel.frame) * j +120, KScreenHeight/18 + KScreenHeight/10.6*i,KScreenWith/2,40)];
            
            _OutScroller.contentSize = CGSizeMake(ScrollerWith*[SignalValue ShareValue].Integer /5.4, ScrollerHeight);
            _OutScroller.layer.borderColor = [UIColor blackColor].CGColor;
            _OutScroller.layer.borderWidth = 0.50f;
            _OutScroller.layer.masksToBounds = YES;
            _OutScroller.layer.cornerRadius = 3;
            _OutScroller.showsVerticalScrollIndicator = YES;
            _OutScroller.scrollEnabled = YES;
            _OutScroller.tag = 500+i;
            [_BackScroller addSubview:_OutScroller];
            [_BackScroller addSubview:Inlabel];
 
        }
    }
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
  
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 5, ScrollerWith*[SignalValue ShareValue].Integer/5, 30);
        label.tag = 3000+i;
        UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:500+i];
        [scroller addSubview:label];
  
    }
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData:) name:@"Sence" object:nil];

    NSString *str = @"";
    _string  = [SignalValue ShareValue].GetMessage[0];
    for (int i = 0; i <[SignalValue ShareValue].GetMessage.count; i++) {
        NSNumber *number = [SignalValue ShareValue].GetMessage[i];
        NSInteger integer = number.integerValue;
        UILabel *text = [self.view viewWithTag:3000 + integer - 1];
        NSString *string = [NSString stringWithFormat:@"%d",i +1];
        NSString *strVale = [NSString stringWithFormat:@"%ld",(long)(i+599+1+[SignalValue ShareValue].Integer/9*145+144)];
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

}

//创建最底层的滚动视图
- (void)SetUpScroller
{
    _BackScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(KScreenWith/240, KScreenHeight/20, KScreenWith/1.5,KScreenHeight -  KScreenHeight/10 - 5)];
    _BackScroller.contentSize = CGSizeMake(BackSrollerWith,BackScrollerHight * [SignalValue ShareValue].Integer/9);
    _BackScroller.showsVerticalScrollIndicator = YES;

    [self.view addSubview:_BackScroller];
    
}

- (void)reloadData:(NSNotification *)notic
{
    _mutArray = notic.userInfo[@"array"];
    
    //数据加载回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *str = @"";
        _string  = _mutArray[0];
        for (int i = 0; i <_mutArray.count; i++) {
            NSNumber *number = _mutArray[i];
            NSInteger integer = number.integerValue;
            UILabel *text = [self.view viewWithTag:3000 + integer - 1];
            NSString *string = [NSString stringWithFormat:@"%d",i +1];
            if (_string == _mutArray[i]) {
                str = [NSString stringWithFormat:@"%@ %@,",str ,string];
                text.text = str;
            }else
            {
                _string = _mutArray[i];
            
                NSString *stringwe = text.text;
                str = [NSString stringWithFormat:@"%@ %@",stringwe ,string];
                text.text = str;
            }
        }
        
    });
    NSLog(@"%@",_mutArray);
}

- (NSMutableArray *)mutArray
{
    if (_mutArray == nil) {
        _mutArray = [NSMutableArray array];
        
    }
    
    return _mutArray;
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
