//
//  AppDelegate.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    ViewController *Root = [[ViewController alloc]init];
    LoginViewController *login = [[LoginViewController alloc]init];
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"first"]) {
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"first"];
//        self.window.rootViewController = [self generateThirdDemoVC];
//        
//    }else{
         self.window.rootViewController = login;
//   }
//
//    
// application.statusBarStyle = UIStatusBarStyleLightContent;
//    
   
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupNormalRootViewController {
    // create whatever your root view controller is going to be, in this case just a simple view controller
    // wrapped in a navigation controller
    self.window.rootViewController = [[ViewController alloc]init];
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
