//
//  AppDelegate.m
//  FFmpegTest
//
//  Created by chenhairong on 15/5/3.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "AppDelegate.h"

//#import ""
#import "KxMovieViewController.h"
#import "BaseViewController.h"
#import "ViewController.h"
#import "DataHelp.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
//    KxMovieViewController *VC = [KxMovieViewController movieViewControllerWithContentPath:@"rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov" parameters:parameters];
    
//    ViewController *view = [[ViewController alloc]init];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        NSArray *langusges = [NSLocale preferredLanguages];
        NSString *language = [langusges objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            
        }    }

    
 

    
//    BaseViewController *baseVC = [[BaseViewController alloc]init];
//    self.window.backgroundColor = WhiteColor;
//
//    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:baseVC
//                                   ];
//    [Nav.navigationBar setBackgroundColor:MotifyColor];
    LoginViewController *Login = [[LoginViewController alloc]init];
    self.window.rootViewController = Login;
    [self.window makeKeyAndVisible];
    
    //注册APNS
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

+ (UIViewController*) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                            coder:(NSCoder *)coder {
    LoginViewController *Login;
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    if (sb) {
        Login = (LoginViewController*)[sb instantiateViewControllerWithIdentifier:@"Login"];
        Login.restorationIdentifier = [identifierComponents lastObject];
        Login.restorationClass = [LoginViewController class];
    }
    return Login;
}

-(void)toMain
{
    self.Login = [LoginViewController new];
    self.window.rootViewController = self.Login;
}

- (void)changeMain
{
    self.Base = [BaseViewController new];
    self.window.rootViewController = self.Base;
    
}


-(void)showWindowHome:(NSString *)windowType{
    
    if([windowType isEqualToString:@"logout"]){
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        loginVC.restorationIdentifier = [identifierComponents lastObject];
        self.window.rootViewController = loginVC;
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([DataHelp shareData].isLeft == 1) {
        [DataHelp shareData].isLeft = 0;
        return UIInterfaceOrientationMaskAll;
    }else
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
        NSLog(@"%@",token);
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}



- (void)applicationWillResignActive:(UIApplication *)application {

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
