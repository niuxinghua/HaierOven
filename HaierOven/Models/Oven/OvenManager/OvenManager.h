//
//  OvenManager.h
//  HaierOven
//
//  Created by 刘康 on 14/12/19.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <uSDKFramework/BaseMessage.h>
#import <uSDKFramework/uSDKBusinessMessage.h>
#import <uSDKFramework/uSDKConstantInfo.h>
#import <uSDKFramework/uSDKDevice.h>
#import <uSDKFramework/uSDKDeviceConfigInfo.h>
#import <uSDKFramework/uSDKDeviceManager.h>
#import <uSDKFramework/uSDKManager.h>
#import <uSDKFramework/uSDKNotificationCenter.h>

@interface OvenManager : NSObject

typedef void (^completion) (id obj, NSError* error);

typedef void (^result) (BOOL result);

/**
 *  管理烤箱工具的单例
 *
 *  @return 烤箱管理实例
 */
+ (OvenManager*)sharedManager;

#pragma mark - 开启和关闭sdk：uSDKManager

/**
 *  开启uSDK
 *
 *  @param result 是否开启成功
 */
- (void)startSdkWithResult:(result)result;

/**
 *  关闭uSDK，一般在关闭APP时调用
 *
 *  @param result 是否关闭成功
 */
- (void)stopSdkWithResult:(result)result;

#pragma mark - 设备绑定流程：uSDKDeviceManager

/**
 *  smartLink连接方式，构建设备配置信息
 *
 *  @param ssid     WiFi SSID
 *  @param password WiFi密码
 *
 *  @return 配置信息实例
 */
- (uSDKDeviceConfigInfo*)getDeviceConfigInfoWithSsid:(NSString*)ssid andApPassword:(NSString*)password;

/**
 *  通过uSDKDeviceConfigInfo绑定设备 CONFIG_MODE_SMARTCONFIG方式绑定
 *
 *  @param configInfo 绑定信息
 */
- (void)bindDeviceWithDeviceConfigInfo:(uSDKDeviceConfigInfo*)configInfo bindResult:(result)result;




#pragma mark - usdk订阅通知流程：uSDKNotificationCenter

/**
 *  订阅设备消息，设备处于任何状态都可以进行订阅
 */
- (void)subscribeDevice;

/**
 *  订阅设备列表变化
 */
- (void)subscribeDeviceListChanged;

/**
 *  订阅内部错误
 */
- (void)subscribeInnerError;

/**
 *  订阅业务数据上报
 */
- (void)subscribeBusinessMessage;

/**
 *  取消订阅设备
 */
- (void)unSubscribeDevice;

/**
 *  取消订阅设备列表变化
 */
- (void)unSubscribeDeviceListChanged;

/**
 *  取消订阅内部错误
 */
- (void)unSubscribeInnerError;

/**
 *  取消订阅业务数据变化
 */
- (void)unSubscribeBusinessMeassage;


#pragma mark - 命令执行流程

/**
 *  发送执行命令
 *
 *  @param commands     命令组，可以是一条指令
 *  @param device       接受命令的设备
 *  @param cmdsn        命令操作序号，如果为0表示不关心命令执行顺序
 *  @param groupCmdName 如果执行的是组命令，组命令名称请查询对应的设备ID文档，如果执行的是单命令，可以传null或""。
 */
- (void)executeCommands:(NSMutableArray*)commands
               toDevice:(uSDKDevice*)device
           andCommandSN:(int)cmdsn
    andGroupCommandName:(NSString*)groupCmdName
              andResult:(result)result;






#pragma mark -




#pragma mark -


@end



