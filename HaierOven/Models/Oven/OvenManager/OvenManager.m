//
//  OvenManager.m
//  HaierOven
//
//  Created by 刘康 on 14/12/19.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "OvenManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation OvenManager

#pragma mark - 初始化单例

+ (OvenManager *)sharedManager
{
    static OvenManager* _sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[OvenManager alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationAplied:) name:DEVICE_OPERATION_ACK_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - uSDK管理

- (void)startSdkWithResult:(result)result
{
    uSDKManager* sdkManager = [uSDKManager getSingleInstance];
//    [sdkManager initLog:USDK_LOG_NONE withWriteToFile:NO];  //日志级别
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [sdkManager startSDK];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorConst == RET_USDK_OK) {
                result(YES);
            } else {
                NSLog(@"Start SDK Error:%d", errorConst);
                result(NO);
            }
        });
    });
    
}

- (void)stopSdkWithResult:(result)result
{
    uSDKManager* sdkManager = [uSDKManager getSingleInstance];
    [sdkManager initLog:USDK_LOG_DEBUG withWriteToFile:NO];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [sdkManager stopSDK];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorConst == RET_USDK_OK) {
                result(YES);
            } else {
                NSLog(@"Stop SDK Error:%d", errorConst);
                result(NO);
            }
        });
    });
    
}


#pragma mark - 设备绑定流程：uSDKDeviceManager

- (NSString*)fetchSSID
{
    @try {
        CFArrayRef myArray = CNCopySupportedInterfaces();
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        NSLog(@"Connected at:%@",myDict);
        NSDictionary *myDictionary = (__bridge_transfer NSDictionary*)myDict;
        NSString * BSSID = [myDictionary objectForKey:@"BSSID"];
        NSLog(@"bssid is %@",BSSID);
        return myDictionary[@"SSID"];
    }
    @catch (NSException *exception) {
        NSLog(@"获取SSID出错");
        NSLog(@"我的WIFI");
    }
    @finally {
        
    }
    
}

/**
 *  smartLink连接方式，构建设备配置信息
 *
 *  @param ssid     WiFi SSID
 *  @param password WiFi密码
 *
 *  @return 配置信息实例
 */
- (uSDKDeviceConfigInfo*)getDeviceConfigInfoWithSsid:(NSString*)ssid andApPassword:(NSString*)password
{
    if (ssid == nil) {
        ssid = [self fetchSSID];
    }
    
    uSDKDeviceConfigInfo* configInfo = [[uSDKDeviceConfigInfo alloc] init];
    configInfo.apSsid = ssid;
    configInfo.apPassword = password;
    return configInfo;
}

- (void)bindDeviceWithSsid:(NSString*)ssid andApPassword:(NSString*)password bindResult:(result)result
{
    uSDKDeviceConfigInfo* configInfo = [self getDeviceConfigInfoWithSsid:ssid andApPassword:password];
    uSDKDeviceManager* deviceManager = [uSDKDeviceManager getSingleInstance];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [deviceManager setDeviceConfigInfo:CONFIG_MODE_SMARTCONFIG watitingConfirm:YES deviceConfigInfo:configInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorConst == RET_USDK_OK) {
                result(YES);
            } else {
                result(NO);
            }
        });
    });
}

#pragma mark - 获取设备列表和设备信息

- (void)getDevicesCompletion:(completion)callback
{
    uSDKDeviceManager* deviceManager = [uSDKDeviceManager getSingleInstance];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray* devices = [deviceManager getDeviceList:OVEN];     //获取烤箱列表
        dispatch_async(dispatch_get_main_queue(), ^{
//            uSDKDevice* device = [devices firstObject];
            callback(YES, devices, nil);
        });
    });
    
}


#pragma mark - usdk订阅通知流程：uSDKNotificationCenter

#pragma mark - 订阅通知

- (void)subscribeDevice:(uSDKDevice*)device
{
    uSDKNotificationCenter* sdkNotificationCenter = [uSDKNotificationCenter defaultCenter];
    
    [sdkNotificationCenter subscribeDevice:device selector:@selector(deviceAttributeReport:) withMacList:@[device.mac]];
    
}

- (void)subscribeDeviceListChanged
{
    uSDKNotificationCenter* sdkNotificationCenter = [uSDKNotificationCenter defaultCenter];
    
    [sdkNotificationCenter subscribeDeviceListChanged:self selector:@selector(receiveDeviceListChanged:) withDeviceType:ALL_TYPE];
}

- (void)subscribeInnerError
{
    [[uSDKNotificationCenter defaultCenter] subscribeInnerErrorMessage:self selector:@selector(receiveInnerError:)];
}

- (void)subscribeBusinessMessage
{
    [[uSDKNotificationCenter defaultCenter] subscribeBusinessMessage:self selector:@selector(businessMessageReport:)];
}

- (void)subscribeAllNotificationsWithDevice:(uSDKDevice*)device
{
    [self subscribeDevice:device];
    [self subscribeBusinessMessage];
    [self subscribeDeviceListChanged];
    [self subscribeInnerError];
}

#pragma mark - 取消订阅通知

- (void)unSubscribeDevice
{
    for (uSDKDevice* device in [[uSDKDeviceManager getSingleInstance] getDeviceList]) {
        NSArray* deviceMacs = @[device.mac];
        [[uSDKNotificationCenter defaultCenter] unSubscribeDevice:self withMacList:deviceMacs];
    }
    
}

- (void)unSubscribeDeviceListChanged
{
    [[uSDKNotificationCenter defaultCenter] unSubscribeDeviceListChanged:self];
}

- (void)unSubscribeInnerError
{
    [[uSDKNotificationCenter defaultCenter] unsubscribeInnerErrorMessage:self];
}

- (void)unSubscribeBusinessMeassage
{
    [[uSDKNotificationCenter defaultCenter] unSubscribeBusinessMessage:self];
}

- (void)unSubscribeAllNotifications
{
    [self unSubscribeDevice];
    [self unSubscribeDeviceListChanged];
    [self unSubscribeInnerError];
    [self unSubscribeBusinessMeassage];
}


#pragma mark - usdk通知响应事件

/**
 *  设备状态改变
 *
 *  @param notification 通知
 */
- (void)deviceAttributeReport:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:DEVICE_ONLINE_CHANGED_NOTIFICATION]) {
        NSLog(@"设备在线状态改变了");
        
    } else if ([notification.name isEqualToString:DEVICE_STATUS_CHANGED_NOTIFICATION]) {
        NSLog(@"设备状态上报通知");
        
    } else if ([notification.name isEqualToString:DEVICE_ALARM_NOTIFICATION]) {
        NSLog(@"设备报警");
        
    } else if ([notification.name isEqualToString:DEVICE_INFRAREDINFO_NOTIFICATION]) {
        NSLog(@"设备红外上报");
        
    } else if ([notification.name isEqualToString:BIGDATA_NOTIFICATION]) {
        NSLog(@"大数据上报");
        
    } else if ([notification.name isEqualToString:SESSION_EXCEPTION_NOTIFICATION]) {
        NSLog(@"Session失效");
        
    }
    
}

/**
 *  设备列表变化
 *
 *  @param notification 通知
 */
- (void)receiveDeviceListChanged:(NSNotification*)notification
{
    if ([notification.name isEqualToString:DEVICE_LIST_CHANGED_NOTIFICATION]) {
        NSLog(@"设备列表发生了变化");
        
    } else if ([notification.name isEqualToString:SESSION_EXCEPTION_NOTIFICATION]) {
        NSLog(@"Session失效");
        
    }
    
}

/**
 *  发生了内部错误
 *
 *  @param notification 通知
 */
- (void)receiveInnerError:(NSNotification*)notification
{
    if ([notification.name isEqualToString:INNER_ERROR_NOTIFICATION]) {
        NSLog(@"发生了内部错误");
        
    } else if ([notification.name isEqualToString:SESSION_EXCEPTION_NOTIFICATION]) {
        NSLog(@"Session失效");
        
    }
    
    
}

- (void)businessMessageReport:(NSNotification*)notification
{
    if ([notification.name isEqualToString:BUSINESS_MESSAGE_NOTIFICATION]) {
        NSLog(@"收到了一个业务数据");
        
    } else if ([notification.name isEqualToString:SESSION_EXCEPTION_NOTIFICATION]) {
        NSLog(@"Session失效");
        
    }
    
    
}

#pragma mark - 执行命令

- (uSDKDeviceAttribute*)structureWithCommandName:(NSString*)cmdName commandAttrValue:(NSString*)cmdValue
{
    return [[uSDKDeviceAttribute alloc] initWithAttrName:cmdName withAttrValue:cmdValue];
}

- (void)executeCommands:(NSMutableArray*)commands toDevice:(uSDKDevice*)device andCommandSN:(int)cmdsn andGroupCommandName:(NSString*)groupCmdName andResult:(result)result
{
//    uSDKDeviceManager* deviceManager = [uSDKDeviceManager getSingleInstance];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
//        NSMutableArray* cmds = [NSMutableArray array];
//        for (NSString* cmd in commands) {
//            uSDKDeviceAttribute* attr = [[uSDKDeviceAttribute alloc] initWithAttrName:cmd withAttrValue:cmd];
//            [cmds addObject:attr];
//        }
        
        uSDKErrorConst errorConst = [device execDeviceOperation:commands withCmdSN:cmdsn withGroupCmdName:groupCmdName];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorConst == RET_USDK_OK) {
                NSLog(@"发送成功");
                result(YES);
            } else {
                NSLog(@"发送失败, errorCode:%d", errorConst);
                result(NO);
            }
        });
    });
    
    
}

- (void)operationAplied:(NSNotification*)notification
{
    NSLog(@"设备操作应答消息通知：%@", notification.userInfo);
}

- (void)bootupToDevice:(uSDKDevice*)device result:(result)success
{
    uSDKDeviceAttribute* cmd = [self structureWithCommandName:kBootUp commandAttrValue:kBootUp];
    [self executeCommands: [@[cmd] mutableCopy]
                 toDevice:device
             andCommandSN:0
      andGroupCommandName:@""
                andResult:^(BOOL result) {
                    if(result) {
                        success(YES);
                    } else {
                        success(NO);
                    }
                }];
}

- (void)shutdownToDevice:(uSDKDevice*)device result:(result)success
{
    uSDKDeviceAttribute* cmd = [self structureWithCommandName:kShutDown commandAttrValue:kShutDown];
    [self executeCommands:[@[cmd] mutableCopy]
                 toDevice:device
             andCommandSN:0
      andGroupCommandName:@""
                andResult:^(BOOL result) {
                    if(result) {
                        success(YES);
                    } else {
                        success(NO);
                    }
                }];
}

@end
























