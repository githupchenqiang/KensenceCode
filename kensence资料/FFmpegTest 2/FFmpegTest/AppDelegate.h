//
//  AppDelegate.h
//  FFmpegTest
//
//  Created by chenhairong on 15/5/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "BaseViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) LoginViewController *Login;
@property (nonatomic ,strong) BaseViewController *Base;
- (void)toMain;
- (void)changeMain;

@end

