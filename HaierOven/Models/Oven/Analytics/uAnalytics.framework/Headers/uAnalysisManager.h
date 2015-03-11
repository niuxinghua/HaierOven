//
//  uAnalysisManager.h
//  uAnalyticsFramework
//
//  Created by Zono on 14-8-11.
//  Copyright (c) 2014年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANALYSIZE_FRAMEWORK_VERSION     @"1.1"
/**
 *	@brief	功能描述：<br>
 *   用户行为统计管理类，提供行为统计的api。
 */
@interface uAnalysisManager : NSObject

/**
 *	@brief	功能描述：<br>
 *  初始化管理类实例。
 *  @param 	AppId       app的id
 *  @param 	AppKey      app的key
 *  @param 	ClientId    client的id
 *  @return void
 */
+(void)startManagerWithAppId:(NSString*)_appid AndAppKey:(NSString*)_appkey AndClientId:(NSString*)_clientid;

/**
 *	@brief	功能描述：<br>
 *  app启动时统计。
 *  @param 	sdkVersion          sdk版本
 *  @param 	appVersion          app版本
 *  @return void
 */
+ (void)onAppStartEvent:(NSString*)sdkVersion withAppVsersion:(NSString*)appVersion;

/**
 *	@brief	功能描述：<br>
 *  app启动耗时。
 *  @param 	duration          app启动用的时间
 *  @return void
 */
+ (void)onAppLoadOverEvent:(long)duration;

/**
 *	@brief	功能描述：<br>
 *  app登录耗时。
 *  @param 	duration          app登陆用的时间
 *  @return void
 */
+ (void)onAppLoginEvent:(long)duration;

/**
 *	@brief	功能描述：<br>
 *  app页面加载耗时。
 *  @param 	duration          页面加载用的时间
 *  @param 	moduleId          页面标示
 *  @return void
 */
+ (void)onActivityResumeEvent:(long)duration withModuleId:(NSString*)moduleId;

/**
 *	@brief	功能描述：<br>
 *  设备离线上报。
 *  @param 	errorNum           错误码
 *  @param 	deviceMac          设备mac
 *  @param 	timePoint          时间
 *  @return void
 */
+(void)onDeviceOnlineChangeEvent:(NSString*)errorNum withDeviceMac:(NSString*)deviceMac;

/**
 *	@brief	功能描述：<br>
 *  app崩溃异常上报。
 *  @param 	exception          要上报的异常
 *  @param 	sdkVersion         sdk版本
 *  @param 	timestamp          时间戳
 *  @return void
 */
+ (void)onAppCrashEvent:(NSException*)exception withSdkVersion:(NSString*)sdkVersion withTimestamp:(NSString*)timestamp;

/**
 *	@brief	功能描述：<br>
 *  用户登录时长统计 --- 用户登录成功后调用。
 *  @param 	userId 登录云平台成功后获取到的用户id。
 *  @return void
 */
+ (void)onUserLogin:(NSString*)userId;

/**
 *	@brief	功能描述：<br>
 *  用户登录时长统计 --- 用户注销后调用。
 *  @return void
 */
+ (void)onUserLogout;

@end
