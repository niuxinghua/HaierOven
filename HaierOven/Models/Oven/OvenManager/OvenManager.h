//
//  OvenManager.h
//  HaierOven
//
//  Created by 刘康 on 14/12/19.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OvenCommandsDefine.h"
//#import <uSDKFramework/BaseMessage.h>
#import <uSDKFramework/uSDKBusinessMessage.h>
#import <uSDKFramework/uSDKConstantInfo.h>
#import <uSDKFramework/uSDKDevice.h>
#import <uSDKFramework/uSDKDeviceConfigInfo.h>
#import <uSDKFramework/uSDKDeviceManager.h>
#import <uSDKFramework/uSDKManager.h>
#import <uSDKFramework/uSDKNotificationCenter.h>

#import "OvenStatus.h"

#define BindDeviceSuccussNotification  @"Bind device success"
#define DeleteLocalOvenSuccessNotification @"Delete local oven success"

@interface OvenManager : NSObject

typedef void (^completion) (BOOL success, id obj, NSError* error);

typedef void (^run) (BOOL success, uSDKErrorConst errorCode);

typedef void (^result) (BOOL result);

/**
 *  当前订阅的烤箱
 */
@property (strong, nonatomic)uSDKDevice* subscribedDevice;

/**
 *  当前烤箱的状态，当接收到设备状态变化时会更新此属性
 */
@property (strong, nonatomic) OvenStatus* currentStatus;

/**
 *  烤箱的烘焙模式, 必须与烤箱控制面板顺序一一对应
 */
@property (strong, nonatomic) NSArray* bakeModes;


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
 *  获取当前wifi网络的ssid
 *
 *  @return ssid字符串
 */
- (NSString*)fetchSSID;

/**
 *  通过ssid和wifi password构建uSDKDeviceConfigInfo， 通过CONFIG_MODE_SMARTCONFIG方式绑定
 *
 *  @param ssid     wifi名称
 *  @param password wifi密码
 *  @param result   绑定结果
 */
- (void)bindDeviceWithSsid:(NSString*)ssid andApPassword:(NSString*)password bindResult:(result)result;

#pragma mark - 获取设备列表和设备信息

/**
 *  获取烤箱设备列表
 *
 *  @param callback 结果回调
 */
- (void)getDevicesCompletion:(completion)callback;


#pragma mark - usdk订阅通知流程：uSDKNotificationCenter

/**
 *  订阅设备消息，设备处于任何状态都可以进行订阅，订阅设备后，设备状态会改为就绪状态
 *
 *  @param device uSDKDevice对象
 */
- (void)subscribeDevice:(uSDKDevice*)device;

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
 *  订阅所有通知
 */
- (void)subscribeAllNotificationsWithDevice:(uSDKDevice*)device;

/**
 *  取消订阅设备
 */
- (void)unSubscribeDevice:(uSDKDevice*)device;

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

/**
 *  取消订阅所有通知，应该与subscribeAllNotifications成对出现
 */
- (void)unSubscribeAllNotifications:(uSDKDevice*)device;

#pragma mark - 命令执行流程

/**
 *  构建一个操作命令
 *
 *  @param cmdName  命令名称
 *  @param cmdValue 命令参数
 *
 *  @return 返回命令对象
 */
- (uSDKDeviceAttribute*)structureWithCommandName:(NSString*)cmdName commandAttrValue:(NSString*)cmdValue;

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
              callback:(run)completion;

/**
 *  设置烘焙模式
 *
 *  @param mode       烘焙模式指令
 *  @param completion 结果回调
 */
- (void)setBakeMode:(NSString*)mode callback:(run)completion;

/**
 *  设置烘焙时间
 *
 *  @param time       烘焙时长
 *  @param completion 结果回调
 */
- (void)setBakeTime:(NSString*)time callback:(run)completion;

/**
 *  设置烘焙温度
 *
 *  @param temperature 烘焙温度
 *  @param completion  结果回调
 */
- (void)setBakeTemperature:(NSString*)temperature callback:(run)completion;





#pragma mark -


@end



