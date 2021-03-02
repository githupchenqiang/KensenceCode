//
//  VideoViewController.m
//  FFmpegStudy
//
//  Created by chenq@kensence.com on 2017/8/25.
//  Copyright © 2017年 chenq@kensence.com. All rights reserved.
//

#import "VideoViewController.h"
#import "KxMovieViewController.h"
#import "KxMovieGLView.h"
#import "KxMovieDecoder.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = @"rtsp://192.168.2.33:80/c0a80203138a138c";//@"http://2000.liveplay.myqcloud.com/live/2000_4eb4da7079af11e69776e435c87f075e.flv";// ;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([path.pathExtension isEqualToString:@"m3u8"])
        parameters[KxMovieParameterMinBufferedDuration] = @(1.0);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters];
    vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        KxMovieGLView *glview = [[KxMovieGLView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) decoder:vc.decoder];
//        glview.backgroundColor = [UIColor cyanColor];
//        [view addSubview:glview];

//        KxVideoFrame *frame;
//        [glview render:frame];
//    });
    
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
