//
//  ViewController.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "ViewController.h"
#import "SignalViewController.h"
#import "ChangeViewController.h"
#import "ConseverViewController.h"
#import "ConnectViewController.h"
#import "SignalValue.h"
@interface ViewController ()
{
    SignalViewController *_Signal;
    ChangeViewController *_Change;
    ConseverViewController *_Consever;
    ConnectViewController *_Connect;
    
    
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegMent;
@property (weak, nonatomic) IBOutlet UIImageView *HeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *ProductName;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        ViewController *aView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Root"];
        self = aView;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置分段控制器名称
    
    _SegMent.frame = CGRectMake(0, 0, 300, 40);
    
    [_SegMent setTitle:NSLocalizedString(@"SceneSwitch",@"") forSegmentAtIndex:1];
    [_SegMent setTitle:NSLocalizedString(@"SceneSave",@"") forSegmentAtIndex:0];
//    信号切换
    [_SegMent setTitle:NSLocalizedString(@"SignalSwitch",@"") forSegmentAtIndex:2];
    
//    关于我们
    [_SegMent setTitle:NSLocalizedString(@"About",@"") forSegmentAtIndex:3];
    [_SegMent setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:36/255.0 green:173/255.0 blue:228/255.0 alpha:1]} forState:UIControlStateSelected];
    [_SegMent setBackgroundColor:[UIColor colorWithRed:32/255.0 green:40/255.0 blue:49/255.0 alpha:1]];
    [_SegMent setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
     // 根据内容调整视图的大小
    _SegMent.apportionsSegmentWidthsByContent = YES;
    
    // 设置点击事件
    [_SegMent addTarget:self action:@selector(ChangePage:) forControlEvents:UIControlEventValueChanged];
    
    // 初始化视图控制器；
    _Signal = [[SignalViewController alloc]init];
    _Change = [[ChangeViewController alloc]init];
    _Consever = [[ConseverViewController alloc]init];
    _Connect = [[ConnectViewController alloc]init];
    
      //将视图添加上来
    [self.view addSubview:_Consever.view];
//    [self.view addSubview:_Change.view];
//    [self.view addSubview:_Consever.view];
//    [self.view addSubview:_Connect.view];
// 
    // 延长视图的生命周期
    [self addChildViewController:_Consever];
//    [self addChildViewController:_Change];
//    [self addChildViewController:_Consever];
//    [self addChildViewController:_Connect];
//    
    // 设置默认选中
    _SegMent.selectedSegmentIndex = 0;

    //将视图添加上来
    [self.view addSubview:_SegMent];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ( [SignalValue ShareValue].ProCount == 2) {
            _ProductName.text = @"ModularMatrixPro";
//            _ProductName.font = [u];
            _ProductName.textColor = KensColor;
            
        }else
        {
            _ProductName.text = @"ModularMatrix";
//            _ProductName.font = ProductFont;
            _ProductName.textColor = KensColor;
        }
    });

}

- (void)ChangePage:(UISegmentedControl *)seg
{
        //添加视图Signal
    if (_SegMent.selectedSegmentIndex == 0) {
        [_Signal.view removeFromSuperview];
        [_Change.view removeFromSuperview];
        [_Connect.view removeFromSuperview];
        [self.view insertSubview:_Consever.view atIndex:0];
        
        // 添加视图Change
    }else if (_SegMent.selectedSegmentIndex == 1){
        [_Signal.view removeFromSuperview];
        [_Consever.view removeFromSuperview];
        [_Connect.view removeFromSuperview];
        [self.view insertSubview:_Change.view atIndex:0];
        
        //添加视图Consever
    }else if (_SegMent.selectedSegmentIndex == 2){
        [_Consever.view removeFromSuperview];
        [_Change.view removeFromSuperview];
        [_Connect.view removeFromSuperview];
        [self.view insertSubview:_Signal.view atIndex:0];
        
        //添加视图Connect
    }else if (_SegMent.selectedSegmentIndex == 3){
        [_Signal.view removeFromSuperview];
        [_Consever.view removeFromSuperview];
        [_Change.view removeFromSuperview];
        [self.view insertSubview:_Connect.view atIndex:0];
    }
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
