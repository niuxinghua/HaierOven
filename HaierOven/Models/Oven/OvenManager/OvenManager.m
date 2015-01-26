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
        _currentStatus = [[OvenStatus alloc] init];
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
    [sdkManager initLog:USDK_LOG_DEBUG withWriteToFile:NO];  //日志级别
    
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
        uSDKErrorConst errorConst = [deviceManager setDeviceConfigInfo:CONFIG_MODE_SMARTCONFIG watitingConfirm:NO deviceConfigInfo:configInfo];
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
    
    [sdkNotificationCenter subscribeDevice:self selector:@selector(deviceAttributeReport:) withMacList:@[device.mac]];
    
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

- (void)unSubscribeDevice:(uSDKDevice*)device;
{
    [[uSDKNotificationCenter defaultCenter] unSubscribeDevice:self withMacList:@[device.mac]];
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

- (void)unSubscribeAllNotifications:(uSDKDevice*)device
{
    [self unSubscribeDevice:device];
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
        [self updateCurrentOvenStatus];
        
    } else if ([notification.name isEqualToString:DEVICE_STATUS_CHANGED_NOTIFICATION]) {
        NSLog(@"设备状态上报通知");
        [self updateCurrentOvenStatus];
        
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

- (void)executeCommands:(NSMutableArray*)commands
               toDevice:(uSDKDevice*)device
           andCommandSN:(int)cmdsn
    andGroupCommandName:(NSString*)groupCmdName
               callback:(run)completion
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
                completion(YES, RET_USDK_OK);
            } else {
                NSLog(@"发送失败, errorCode:%d", errorConst);
                completion(NO, errorConst);
            }
        });
    });
    
    
}

- (void)setBakeMode:(NSString*)mode callback:(run)completion
{
    
    uSDKDeviceAttribute* command = [self structureWithCommandName:kBakeMode commandAttrValue:mode];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [self.subscribedDevice execDeviceOperation:[@[command] mutableCopy]
                                                                     withCmdSN:0
                                                              withGroupCmdName:@""];
        
        BOOL runSuccess = NO;
        for (int loop = 0; loop < 10; loop++) {
            if ([self.currentStatus.bakeMode isEqualToString:mode]) {
                NSLog(@"**********指令执行成功**********");
                runSuccess = YES;
                break;
            }
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (runSuccess) {
                completion(YES, errorConst);
            } else {
                NSLog(@"**********发送失败, errorCode:%d**********", errorConst);
                completion(NO, errorConst);
            }
        });
        
        
//        if (errorConst == RET_USDK_OK) {
//            NSLog(@"发送成功");
//            
//            BOOL runSuccess = NO;
//            for (int loop = 0; loop < 10; loop++) {
//                if ([self.currentStatus.bakeMode isEqualToString:mode]) {
//                    NSLog(@"**********指令执行成功**********");
//                    runSuccess = YES;
//                    break;
//                }
//                [NSThread sleepForTimeInterval:1];
//            }
//            if (runSuccess) {
//                completion(YES, errorConst);
//            } else {
//                NSLog(@"**********发送失败, errorCode:%d**********", errorConst);
//            }
//            
//            
//        } else {
//            NSLog(@"**********发送失败, errorCode:%d**********", errorConst);
//            completion(NO, errorConst);
//        }
        
        
        
    });
    
}


- (void)setBakeTime:(NSString*)time callback:(run)completion
{
    
    uSDKDeviceAttribute* command = [self structureWithCommandName:kBakeTime commandAttrValue:time];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [self.subscribedDevice execDeviceOperation:[@[command] mutableCopy]
                                                                     withCmdSN:0
                                                              withGroupCmdName:@""];
        
        BOOL runSuccess = NO;
        for (int loop = 0; loop < 10; loop++) {
            if ([self.currentStatus.bakeTime isEqualToString:time]) {
                NSLog(@"**********指令执行成功**********");
                runSuccess = YES;
                break;
            }
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (runSuccess) {
                completion(YES, errorConst);
            } else {
                NSLog(@"**********发送失败, errorCode:%d**********", errorConst);
                completion(NO, errorConst);
            }
        });
        
    });
    
}

- (void)setBakeTemperature:(NSString*)temperature callback:(run)completion
{
    
    uSDKDeviceAttribute* command = [self structureWithCommandName:kBakeTemperature commandAttrValue:temperature];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        uSDKErrorConst errorConst = [self.subscribedDevice execDeviceOperation:[@[command] mutableCopy]
                                                                     withCmdSN:0
                                                              withGroupCmdName:@""];
        
        BOOL runSuccess = NO;
        for (int loop = 0; loop < 10; loop++) {
            if (self.currentStatus.temperature == [temperature integerValue]) {
                NSLog(@"**********指令执行成功**********");
                runSuccess = YES;
                break;
            }
            [NSThread sleepForTimeInterval:1];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (runSuccess) {
                completion(YES, errorConst);
            } else {
                NSLog(@"**********发送失败, errorCode:%d**********", errorConst);
                completion(NO, errorConst);
            }
        });
        
    });
    
}



- (void)operationAplied:(NSNotification*)notification
{
    NSLog(@"设备操作应答消息通知：%@", notification.object);
}

//- (void)bootupToDevice:(uSDKDevice*)device result:(result)success
//{
//    uSDKDeviceAttribute* cmd = [self structureWithCommandName:kBootUp commandAttrValue:kBootUp];
// 
//    [self executeCommands:[@[cmd] mutableCopy] toDevice:device andCommandSN:0 andGroupCommandName:@"" callback:^(BOOL success, NSInteger errorCode) {
//        
//    }];
//}
//
//- (void)shutdownToDevice:(uSDKDevice*)device result:(result)success
//{
//    uSDKDeviceAttribute* cmd = [self structureWithCommandName:kShutDown commandAttrValue:kShutDown];
//    [self executeCommands:[@[cmd] mutableCopy]
//                 toDevice:device
//             andCommandSN:0
//      andGroupCommandName:@""
//                andResult:^(BOOL result) {
//                    if(result) {
//                        success(YES);
//                    } else {
//                        success(NO);
//                    }
//                }];
//}

- (NSError*)errorWithCode:(InternetErrorCode)errorCode andDescription:(NSString*)errorMsg
{
    if (errorMsg == nil) {
        errorMsg = [NSString stringWithFormat:@"Request error with code: %d", errorCode];
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorMsg};
    NSError *error = [NSError errorWithDomain:@"com.haier.usdk" code:errorCode userInfo:userInfo];
    return error;
}

#pragma mark - 获取订阅设备的状态

- (void)updateCurrentOvenStatus
{
    
    if (self.subscribedDevice == nil) {
        return;
    }
    
    [self getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        
        uSDKDevice* currentDevice;
        for (uSDKDevice* device in obj) {
            if ([self.subscribedDevice.mac isEqualToString:device.mac]) {
                currentDevice = device;
                break;
            }
        }
        // 更新连线状态
        _currentStatus.isReady = currentDevice.status == STATUS_READY ? YES : NO;
        
        NSMutableDictionary* attrDict = currentDevice.attributeDict;
        uSDKDeviceAttribute* statusAttr;
        
        // 是否开机
        statusAttr = attrDict[@"20v001"];
        _currentStatus.opened = [statusAttr.attrValue isEqualToString:@"20v001"] ? YES : NO;
        
        // 是否已关机
        statusAttr = attrDict[@"20v002"];
        _currentStatus.closed = [statusAttr.attrValue isEqualToString:@"20v002"] ? YES : NO;
        
        // 是否已启动
        statusAttr = attrDict[@"20v003"];
        _currentStatus.isWorking = [statusAttr.attrValue isEqualToString:@"20v003"] ? YES : NO;
        
        // 烘焙模式
        statusAttr = attrDict[@"20v00e"];
        _currentStatus.bakeMode = statusAttr.attrValue;
        
        // 烤箱温度
        statusAttr = attrDict[@"20v00g"];
        _currentStatus.temperature = [statusAttr.attrValue integerValue];
        
        // 烘焙时间
        statusAttr = attrDict[@"20v00f"];
        _currentStatus.bakeTime = statusAttr.attrValue;
        
        // 是否有感肉温度探针
        statusAttr = attrDict[@"60v003"];
        _currentStatus.hadTemperatureDetector = [statusAttr.attrValue isEqualToString:@"30v002"] ? YES : NO;
        
        
        
        
    }];
    
}

#pragma mark - getters

//NSArray *xz = @[@"icon_ssk_s", @"icon_sxsk_s", @"icon_xsk_s", @"icon_fj_s", @"icon_jd_s", @"icon_3Dhb_s",
//                @"icon_3Dsk_s", @"icon_psms_s", @"icon_cthb_s", @"icon_rfsk_s", @"icon_dlhb_s", @"icon_rfqsk_s"];
- (NSArray *)bakeModes
{
    if (_bakeModes == nil) {
        _bakeModes = @[@{@"30v0Me" :@"烧烤" }/*烧烤*/,
                       @{@"30v3Mj" :@"上下烧烤＋蒸汽"} /*纯蒸汽*/,
                       @{@"30v0Mg" :@"下烧烤" }/*下烧烤*/,
                       @{@"30v0Mb" :@"发酵功能" }/*发酵功能*/,
                       @{@"30v0Ma" :@"解冻功能" }/*解冻功能*/,
                       @{@"30v0Mc" :@"3D热风"} /*3D热风*/,
                       @{@"30v0M9" :@"3D烧烤" }/*3D烧烤*/,
                       @{@"30v0Md" :@"披萨模式" }/*披萨模式*/,
                       @{@"30v0M6" :@"传统烘焙"},
                       @{@"30v0M5" :@"热风烧烤" }/*热风烧烤*/,
                       @{@"30v0M8" :@"对流烘焙"} /*对流烘焙*/,
                       @{@"30v7Mn" :@"热分全烧烤"}
                       
                       
                       
                       
                       
//                       @{@"30v0Mf" :@"焙烤" }/*应该是焙烤，这里是传统烧烤*/,
//                       @{@"30V1Mh" :@"上烧烤＋蒸汽"} /*上烧烤＋蒸汽*/,
//                       @{@"30v2Mi" :@"传统烘焙" }/*上下烧烤＋蒸汽*/,
//                       @{@"30v4Mk" :@"消毒 1" }/*消毒 1*/,
//                       @{@"30v5Ml" :@"消毒 2" }/*消毒 2*/,
//                       @{@"30v6Mm" :@"全烧烤" }/*全烧烤*/,
//                       @{@"30v7Mn" :@"热分全烧烤"} /*热分全烧烤*/
                       ];
    }
    return _bakeModes;
}


@end
























