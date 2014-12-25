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
        
    }
    return self;
}

#pragma mark - uSDK管理

- (void)startSdkWithResult:(result)result
{
    uSDKManager* sdkManager = [uSDKManager getSingleInstance];
    [sdkManager initLog:USDK_LOG_DEBUG withWriteToFile:NO];
    
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
    CFArrayRef myArray = CNCopySupportedInterfaces();
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    NSLog(@"Connected at:%@",myDict);
    NSDictionary *myDictionary = (__bridge_transfer NSDictionary*)myDict;
    NSString * BSSID = [myDictionary objectForKey:@"BSSID"];
    NSLog(@"bssid is %@",BSSID);
    return myDictionary[@"SSID"];
}

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

- (void)bindDeviceWithDeviceConfigInfo:(uSDKDeviceConfigInfo*)configInfo bindResult:(result)result
{
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


#pragma mark - usdk订阅通知流程：uSDKNotificationCenter

- (void)subscribeDevice
{
    uSDKNotificationCenter* sdkNotificationCenter = [uSDKNotificationCenter defaultCenter];
    
    for (uSDKDevice* device in [[uSDKDeviceManager getSingleInstance] getDeviceList]) {
        NSArray* deviceMacs = @[device.mac];
        [sdkNotificationCenter subscribeDevice:device selector:@selector(deviceAttributeReport:) withMacList:deviceMacs];
    }

    
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



#pragma mark - usdk通知响应事件

/**
 *  设备状态改变
 *
 *  @param notification 通知
 */
- (void)deviceAttributeReport:(NSNotification*)notification
{
    NSLog(@"设备状态改变了");
    
}

/**
 *  设备列表变化
 *
 *  @param notification 通知
 */
- (void)receiveDeviceListChanged:(NSNotification*)notification
{
    NSLog(@"设备列表发生了变化");
}

/**
 *  发生了内部错误
 *
 *  @param notification 通知
 */
- (void)receiveInnerError:(NSNotification*)notification
{
    NSLog(@"发生了内部错误");
}

- (void)businessMessageReport:(NSNotification*)notification
{
    NSLog(@"收到了一个业务数据");
}

#pragma mark - 执行命令

- (void)executeCommands:(NSMutableArray*)commands toDevice:(uSDKDevice*)device andCommandSN:(int)cmdsn andGroupCommandName:(NSString*)groupCmdName andResult:(result)result
{
    uSDKDeviceManager* deviceManager = [uSDKDeviceManager getSingleInstance];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [device execDeviceOperation:commands withCmdSN:cmdsn withGroupCmdName:groupCmdName];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorConst == RET_USDK_OK) {
                NSLog(@"发送成功");
                result(YES);
            } else {
                NSLog(@"发送失败");
                result(NO);
            }
        });
    });
    
    
}

@end









