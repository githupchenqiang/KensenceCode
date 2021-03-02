//
//  ProSetView.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/19.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "ProSetView.h"
#define KscWith    self.view.frame.size.width
#define KscHeight  self.view.frame.size.height
@interface ProSetView ()

- (IBAction)ratio4Action:(id)sender;//分辨率

- (IBAction)Space4Action:(id)sender;//色彩空间
- (IBAction)LightAdd4Action:(id)sender; //亮度加
- (IBAction)LightCut4Action:(id)sender; //亮度减
- (IBAction)contrast4Action:(id)sender; //对比度加
- (IBAction)contrastCut4Action:(id)sender; //对比度减

- (IBAction)SaturationAdd4Action:(id)sender; //饱和度加
- (IBAction)SaturationCut4Action:(id)sender; //饱和度减
- (IBAction)chromaAdd4Action:(id)sender; //色度加
- (IBAction)chromaCut4Action:(id)sender; //色度减
- (IBAction)ZoomAdd4Action:(id)sender; //缩放加
- (IBAction)ZoomCut4Action:(id)sender; //缩放减
- (IBAction)ErectImageAction:(id)sender; //正像

- (IBAction)InvertedImageAction:(id)sender; //倒像

- (IBAction)Reset4Action:(id)sender;  //复位
- (IBAction)NamingAction:(id)sender; //命名

- (IBAction)Nametext:(id)sender; //输入框
@property (weak, nonatomic) IBOutlet UITextField *textfield;

- (IBAction)CancleAction:(id)sender; //取消

@end

@implementation ProSetView

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        ProSetView *proSet = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ProSet"];
        self = proSet;

    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:191/255.0 green:219/255.0 blue:255/255.0 alpha:1];
    


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


- (IBAction)ratio4Action:(id)sender {
}

- (IBAction)Space4Action:(id)sender {
}

- (IBAction)LightAdd4Action:(id)sender {
}

- (IBAction)LightCut4Action:(id)sender {
}

- (IBAction)contrast4Action:(id)sender {
}
- (IBAction)contrastCut4Action:(id)sender {
}

- (IBAction)SaturationAdd4Action:(id)sender {
}
- (IBAction)SaturationCut4Action:(id)sender {
}
- (IBAction)chromaAdd4Action:(id)sender {
}

- (IBAction)chromaCut4Action:(id)sender {
}

- (IBAction)ZoomAdd4Action:(id)sender {
}

- (IBAction)ZoomCut4Action:(id)sender {
}

- (IBAction)ErectImageAction:(id)sender {
}

- (IBAction)InvertedImageAction:(id)sender {
}

- (IBAction)Reset4Action:(id)sender {
}

- (IBAction)NamingAction:(id)sender {
}

- (IBAction)Nametext:(id)sender {
}

- (IBAction)CancleAction:(id)sender {
    
    [super dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
@end
