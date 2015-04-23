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
#import <uSDKFramework/uSDKConst.h>
#import "OHPlayAudio.h"

#define SUPPORT_IOS8 1

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize orientationState = _orientationState;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //NSLog(@"开始加载。。。");
    UInt64 start=[[NSDate date]timeIntervalSince1970]*1000;
    
    // 统计crash日志
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
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
    
    //[[UITableView appearance] setTableFooterView:[[UIView alloc] init]];
    
    // 初始化uAnalytics统计功能
    [uAnalysisManager startManagerWithAppId:AppId AndAppKey:AppKey AndClientId:[DataCenter sharedInstance].clientId];
    
    // app启动日志
    [uAnalysisManager onAppStartEvent:@USDK_CLIENT_VERSION withAppVsersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    // 不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self startUSdk];
    
    [self initUmengSdk];
    
    [self initGoogleAnalytics];
    
    [self initNotification];
    
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
    [self checkLoginExpired];
    
    [self autoLogin];
    
    //NSLog(@"加载结束...");
    UInt64 end=[[NSDate date]timeIntervalSince1970]*1000;
    
    // 统计加载耗时
    [uAnalysisManager onAppLoadOverEvent:((long)(end-start))];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [uAnalysisManager onAppCrashEvent:exception
                       withSdkVersion:[NSString stringWithFormat:@"%@", @USDK_CLIENT_VERSION]
                        withTimestamp:[NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]]];
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
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    NSInteger seconds = 1;
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
//    localNotification.alertBody = @"hello";
//    localNotification.alertAction = @"alertAction";
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotification.applicationIconBadgeNumber = 1;
//    localNotification.userInfo = @{@"name": @"sansang", @"age": @99}; //給将来的此程序传参
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
    
    // QQ  APPKEY可能issue
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:@"4hyK6cWsLYMuv2tQ" url:@"http://www.umeng.com/social"];
    
    // 微博
#warning 设置安全域名和回调页
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    
    // 微信 朋友圈
    [UMSocialWechatHandler setWXAppId:@"wx925a3b8264b54390" appSecret:@"5b389c8a123c4e0981ad9fe1431006eb" url:@"http://weibo.com/origheart"];
    
    // 友盟统计
    [MobClick startWithAppkey:UMengAppKey reportPolicy:SEND_INTERVAL channelId:@"App Store"];
    [MobClick setLogSendInterval:600.]; //10分钟发送一次
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    
}

- (void)initGoogleAnalytics
{
     // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingId];
    
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
        // app登录耗时
        UInt64 startLogin=[[NSDate date]timeIntervalSince1970]*1000;
        
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
                                                            
                                                            UInt64 endLogin=[[NSDate date]timeIntervalSince1970]*1000;
                                                            [uAnalysisManager onAppLoginEvent:((long)(endLogin-startLogin))];
                                                            
                                                            //[[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                                                            
                                                            
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
    
    self.hadTappedNotification = YES;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive || [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ReceivedLocalNotification object:nil];
    }
    
    
}



//#if SUPPORT_IOS8
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    //register to receive notifications
//    [application registerForRemoteNotifications];
//    
//    NSLog(@"didRegisterUserNotificationSettings");
//    
//}
//#endif
//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
//    
//}
//
//// 必须,如果正确调用了 setDelegate,在 bindChannel 之后,结果在这个回调中返回。 若绑定失败,请进行重新绑定,确保至少绑定成功一次
//- (void)onMethod:(NSString*)method response:(NSDictionary*)data {
//    
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    
//    NSLog(@"didReceiveRemoteNotification");
//}

- (InterfaceOrientationState)orientationState
{
    if (!_orientationState) {
        _orientationState = InterfaceOrientationStatePortraitOnly;
    }
    return _orientationState;
}

- (void)setOrientationState:(InterfaceOrientationState)orientationState
{
    switch (orientationState) {
        case InterfaceOrientationStateLandscapeOnly:
            [UIApplication sharedApplication].statusBarOrientation = UIDeviceOrientationLandscapeLeft;
            break;
            
        case InterfaceOrientationStatePortraitOnly:
            [UIApplication sharedApplication].statusBarOrientation = UIDeviceOrientationPortrait;
            break;
            
        case InterfaceOrientationStateNormal:
            [UIApplication sharedApplication].statusBarOrientation = UIDeviceOrientationUnknown;
            break;
            
        default:
            break;
    }
    _orientationState = orientationState;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //    NSLog(@"supportedInterfaceOrientationsForWindow");
    
    switch (self.orientationState) {
        case InterfaceOrientationStateLandscapeOnly:
            return UIInterfaceOrientationMaskLandscape;
            break;
            
        case InterfaceOrientationStatePortraitOnly:
            return UIInterfaceOrientationMaskPortrait;
            break;
            
        case InterfaceOrientationStateNormal:
            return UIInterfaceOrientationMaskAll;
            break;
            
        default:
            
            return UIInterfaceOrientationMaskPortrait;
            
            break;
    }
    
    
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
    
    
    //  后台操作的申请
    //  1.  向操作系统请求后台运行，并获取后台运行任务码
    self.bgTaskIdentifier =
    [application beginBackgroundTaskWithExpirationHandler:^{
        //  在后台运行任务到期时运行这个代码块
        //  4.  处理在时间结束后，后台任务仍然没有做完的情况
//        [application endBackgroundTask:self.bgTaskIdentifier];
//        self.bgTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    //  2.  使用另外一个线程，执行后台运行代码
    dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //  后台运行的代码写在这里
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(tik) userInfo:nil repeats:YES];
        //  3.  告知操作系统后台任务执行结束
//        [application endBackgroundTask:self.bgTaskIdentifier];
//        self.bgTaskIdentifier = UIBackgroundTaskInvalid;
    });
    
}

- (void)tik
{
    
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
        
        // 播放无声音乐
        [[OHPlayAudio sharedAudioPlayer] playFuck];
        
        self.bgTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //[self stopUSdk];
    
}

@end
