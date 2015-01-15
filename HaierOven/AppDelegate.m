//
//  AppDelegate.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
        
    [[UINavigationBar appearance] setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor]  forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:YES forKey:@"hadDevice"];
    [accountDefaults synchronize];
//    
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [self startUSdk];
    
    [self initUmengSdk];
    
    return YES;
}

- (void)startUSdk
{
    [[OvenManager sharedManager] startSdkWithResult:^(BOOL result) {
        if (result) {
            NSLog(@"uSDK开启成功");
        } else {
            NSLog(@"uSDK开启失败");
        }
    }];
}

- (void)stopUSdk
{
    [[OvenManager sharedManager] stopSdkWithResult:^(BOOL result) {
        if (result) {
            NSLog(@"uSDK关闭成功");
        } else {
            NSLog(@"uSDK关闭失败");
        }

    }];
}

- (void)initUmengSdk
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMengAppKey];
    
    // QQ
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    // 微博
    [UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    // 微信 朋友圈
    [UMSocialWechatHandler setWXAppId:@"wxd135c736264fd98d" appSecret:@"8296da588aa8e35ebf2ab09f0baf10ff" url:@"http://weibo.com/origheart"];
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return result;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //程序没有被杀掉，用户点击通知时
    NSLog(@"didReceiveLocalNotification");
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
    NSDictionary* userInfo = notification.userInfo;
    NSLog(@"name:%@", userInfo[@"name"]);
    NSLog(@"age:%@", userInfo[@"age"]);
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
    
    [self stopUSdk];
    
}

@end
