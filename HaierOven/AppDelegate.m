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

#define SUPPORT_IOS8 1

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
        
    [[UINavigationBar appearance] setBackgroundImage:[MyTool createImageWithColor:GlobalOrangeColor]  forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:IMAGENAMED(@"clear.png")];
    
    NSDictionary* textAttributes = @{
                                UITextAttributeTextColor : [UIColor whiteColor],
                                UITextAttributeFont : [UIFont fontWithName:GlobalTitleFontName size:15],
                                UITextAttributeTextShadowColor : [UIColor clearColor],
                                UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(1, 1)]
                                };
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    [self startUSdk];
    
    [self initUmengSdk];
    
    [self initNotification];
    
    [self checkLoginExpired];
    
    [self autoLogin];
    
    return YES;
}

- (void)initNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSInteger seconds = 2;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotification.alertBody = @"hello";
    localNotification.alertAction = @"alertAction";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotification.applicationIconBadgeNumber = 1;
//    localNotification.userInfo = @{@"name": @"sansang", @"age": @99}; //給将来的此程序传参
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
    //追爱行动 AppKey:1162620904 App Secret:08006bb891e3d8b8a4e303399f61dbe4
    [UMSocialSinaHandler openSSOWithRedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    // 微信 朋友圈
    [UMSocialWechatHandler setWXAppId:@"wxd135c736264fd98d" appSecret:@"8296da588aa8e35ebf2ab09f0baf10ff" url:@"http://weibo.com/origheart"];
    
    
}

- (void)checkLoginExpired
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate* lastLoginTime = [userDefaults valueForKey:@"lastLoginTime"];
    if (lastLoginTime == nil) {
        return;
    }
    NSTimeInterval inteval = [[NSDate date] timeIntervalSinceDate:lastLoginTime];
    
    if (inteval >  20 * 24 * 60 * 60 ) {  //是否超过20天
        [userDefaults setBool:NO forKey:@"isLogin"];
    }
    
}

- (void)autoLogin
{
    if (IsLogin) {
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* loginId = [userDefaults valueForKey:@"loginId"];
        NSString* password = [userDefaults valueForKey:@"password"];
        
        LoginType loginType;
        if ([MyTool validateEmail:loginId]) {
            loginType = LoginTypeEmail;
        } else {
            loginType = LoginTypeMobile;
        }
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddhhmmss";
        NSString* sequence = [formatter stringFromDate:[NSDate date]];
        sequence = [sequence stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        [[InternetManager sharedManager] loginWithSequenceId:sequence
                                                  andAccType:AccTypeHaier
                                                  andloginId:loginId
                                                 andPassword:password
                                          andThirdpartyAppId:nil
                                    andThirdpartyAccessToken:nil
                                                andLoginType:loginType
                                                    callBack:^(BOOL success, id obj, NSError *error) {
                                                        
                                                        if (success) {
                                                            NSLog(@"自动登录成功");
                                                        
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                                                            
                                                            
                                                        } else {
                                                            NSLog(@"自动登录失败");
                                                        }
                                                        
                                                        
                                                    }];
        
    }
    
    
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

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
    
    NSLog(@"didRegisterUserNotificationSettings");
    
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    
}

// 必须,如果正确调用了 setDelegate,在 bindChannel 之后,结果在这个回调中返回。 若绑定失败,请进行重新绑定,确保至少绑定成功一次
- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"didReceiveRemoteNotification");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    OvenManager* ovenManager = [OvenManager sharedManager];
//    if (ovenManager.subscribedDevice != nil) {
//        [ovenManager unSubscribeAllNotifications:ovenManager.subscribedDevice];
//    }
    
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
