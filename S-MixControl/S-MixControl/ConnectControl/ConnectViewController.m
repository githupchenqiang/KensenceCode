//
//  ConnectViewController.m
//  S-MixControl
//
//  Created by aa on 15/12/1.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "ConnectViewController.h"
#import "LoginViewController.h"

//整个页面的尺寸宏
#define KscreenWidth self.view.frame.size.width
#define KscreenHeight  self.view.frame.size.height
#define WhithColor [UIColor whiteColor]

@interface ConnectViewController ()<UIWebViewDelegate>

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor blackColor];
    UIView *view  = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
   view .backgroundColor = [UIColor colorWithRed:24/255.0 green:33/255.0 blue:40/255.0 alpha:1];
   [self.view addSubview:view];
    
    UIImageView *LogImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, KscreenHeight /4, 400, 400)];
    UIImage *logImage = [UIImage imageNamed:@"LOg"];
    LogImageView.image = logImage;
    [self.view addSubview:LogImageView];
    
    
    //产品类型
    UILabel *Ductlabel = [[UILabel alloc]init];
    Ductlabel.frame = CGRectMake(KscreenWidth/2, KscreenHeight/4, KscreenWidth/1.5, KscreenHeight/14);
    Ductlabel.text = NSLocalizedString(@"product name：Control platform",@"");
    Ductlabel.textColor = [UIColor colorWithRed:153/255.0 green:156/255.0 blue:158/255.0 alpha:1];
    Ductlabel.textAlignment = NSTextAlignmentLeft;
    
    //版本号
    UILabel *version = [[UILabel alloc]init];
    version.frame = CGRectMake(KscreenWidth/2, CGRectGetMaxY(Ductlabel.frame)+10, KscreenWidth/1.5,  KscreenHeight/14);
    version.text =NSLocalizedString(@"Version：1.0.1.64",@"");
    version.textColor = [UIColor colorWithRed:153/255.0 green:156/255.0 blue:158/255.0 alpha:1];
    version.textAlignment = NSTextAlignmentLeft;
    
    //电话
    UILabel *Telephone = [[UILabel alloc]init];
    Telephone.frame = CGRectMake(KscreenWidth/2, CGRectGetMaxY(version.frame)+10,  KscreenWidth/1.5,  KscreenHeight/14);
    Telephone.textColor = [UIColor colorWithRed:153/255.0 green:156/255.0 blue:158/255.0 alpha:1];
    Telephone.textAlignment = NSTextAlignmentLeft;
    Telephone.text = NSLocalizedString(@"Phone：+86-01082275130",@"");
    
    
    //邮件地址
    UILabel *Mail = [[UILabel alloc]init];
    Mail.frame = CGRectMake(KscreenWidth/2, CGRectGetMaxY(Telephone.frame)+10,  KscreenWidth/1.5, KscreenHeight/14);
    Mail.textColor = [UIColor colorWithRed:153/255.0 green:156/255.0 blue:158/255.0 alpha:1];
    Mail.text = NSLocalizedString(@"E-Mail：info@kensence.com",@"");
    Mail.textAlignment = NSTextAlignmentLeft;
    
    //主页
    UIButton *mainPage = [UIButton buttonWithType:UIButtonTypeSystem];
    mainPage.frame = CGRectMake(KscreenWidth/2 -20, CGRectGetMaxY(Mail.frame)+10, KscreenWidth/1.5, KscreenHeight/14);
    [mainPage setTitle:NSLocalizedString(@"MainPage：www.kensence.com",@"") forState:UIControlStateNormal];
    [mainPage setTitleColor:KensColor forState:UIControlStateNormal];
    [mainPage addTarget:self action:@selector(MainAction:) forControlEvents:UIControlEventTouchDown];
    //地址
    CGSize size = [mainPage.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    mainPage.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0,mainPage.frame.size.width - size.width);
//    mainPage.backgroundColor = [UIColor cyanColor];
    UILabel *Adress = [[UILabel alloc]init];
    Adress.frame = CGRectMake(KscreenWidth/2, CGRectGetMaxY(mainPage.frame)+10, KscreenWidth/1.5, KscreenHeight/14);
    Adress.textColor = [UIColor colorWithRed:153/255.0 green:156/255.0 blue:158/255.0 alpha:1];
    Adress.text = NSLocalizedString(@"Address：ShengZhengBaoAnQuShiYanRoad",@"");
    Adress.textAlignment = NSTextAlignmentLeft;

    [self.view addSubview:Ductlabel];
    [self.view addSubview:version];
    [self.view addSubview:Telephone];
    [self.view addSubview:Mail];
    [self.view addSubview:mainPage];
    [self.view addSubview:Adress];
}

- (void)MainAction:(UIButton *)button
{

      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kensence.com"]];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSURL *url = [NSURL URLWithString:@"http://www.kensence.com"];
    
    [[UIApplication sharedApplication] openURL:url];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
