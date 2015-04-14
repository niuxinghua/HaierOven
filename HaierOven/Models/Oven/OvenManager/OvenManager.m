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

/**
 *  通过ssid和wifi password构建uSDKDeviceConfigInfo， 通过CONFIG_MODE_SMARTCONFIG方式绑定
 *
 *  @param ssid      WiFi名称
 *  @param password  WiFi密码
 *  @param rebindMac 如果是重新绑定，则传此设备的Mac，否则传nil
 *  @param result    绑定结果，将返回绑定成功的usdkDevice对象
 */
- (void)bindDeviceWithSsid:(NSString*)ssid andApPassword:(NSString*)password rebindOvenMac:(NSString*)rebindMac bindResult:(completion)result
{
    uSDKDeviceConfigInfo* configInfo = [self getDeviceConfigInfoWithSsid:ssid andApPassword:password];
    uSDKDeviceManager* deviceManager = [uSDKDeviceManager getSingleInstance];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        uSDKErrorConst errorConst = [deviceManager setDeviceConfigInfo:CONFIG_MODE_SMARTCONFIG watitingConfirm:NO deviceConfigInfo:configInfo];
        
        [self getDevicesInSeconds:58 rebindMac:rebindMac completion:^(BOOL success, id obj, NSError *error) {
            
            if (success) {
                
                uSDKDevice* theDevice;
                DataCenter* dataCenter = [DataCenter sharedInstance];
                
                // 1. 根据不同的情况获取需要绑定的烤箱，每次只取一台不与已有烤箱重复的烤箱设备
                if (rebindMac) { // 重新绑定
                    // 从搜索到的周边烤箱中拿到此台设备
                    for (uSDKDevice* device in obj) {
                        if ([device.mac isEqualToString:rebindMac]) {
                            theDevice = device;
                            break;
                        }
                    }
                    
                } else { // 绑定不重复的新设备
                    
                    for (uSDKDevice* device in obj) {
                        if (dataCenter.myOvens.count == 0) {
                            theDevice = [obj firstObject];
                        } else {
                            
                            if (![self deviceExistWithMac:device.mac]) {
                                theDevice = device;
                            }
                            
                        }
                        if (theDevice != nil) break;
                    }
                }
                
                // 2. 订阅绑定的烤箱
                if (theDevice == nil) {
                    result(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"绑定失败"]);
                    return;
                }
                [self subscribeAllNotificationsWithDevice:@[theDevice.mac]];
                self.subscribedDevice = theDevice;
                
                // 3. 当指定烤箱在一段时间内变成在线状态内，则表示绑定成功
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    BOOL runSuccess = NO;
                    for (int loop = 0; loop < 10; loop++) {
                        if (self.currentStatus.isReady) {
                            NSLog(@"**********绑定成功**********");
                            runSuccess = YES;
                            break;
                        }
                        [NSThread sleepForTimeInterval:1];
                    }
                    
                    // 4. 取消订阅
                    [self unSubscribeAllNotifications:@[theDevice.mac]];
                    
                    // 5. 返回绑定结果
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (errorConst == RET_USDK_OK && runSuccess) {
                            
                            result(YES, theDevice, nil);
                        } else {
                            result(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"绑定失败"]);
                        }
                    });
                    
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"绑定失败"]);
                });
            }
            
        }];
        
    });
}

- (BOOL)deviceExistWithMac:(NSString*)mac
{
    DataCenter* dataCenter = [DataCenter sharedInstance];
    BOOL existFlag = false;
    for (LocalOven* localOven in dataCenter.myOvens) {
        if ([mac isEqualToString:localOven.mac]) {
            existFlag = true;
        }
    }
    return existFlag;
}

/**
 *  绑定设备时调用，smartlink方式发送配置信息后，在一定的时间内获取周边的设备，此方法应该在子线程调用
 *
 *  @param seconds  超时的秒数
 *  @param callback 结果回调
 */
- (void)getDevicesInSeconds:(NSInteger)seconds rebindMac:(NSString*)rebindMac completion:(completion)callback
{
    uSDKDeviceManager* deviceManager = [uSDKDeviceManager getSingleInstance];
    for (int loop = seconds; loop >= 0; loop--) {
        
        [NSThread sleepForTimeInterval:1.0];
        NSArray* devices = [deviceManager getDeviceList:OVEN];
        
        if (devices.count == 0) {
            
            if (loop <= 0) {
                callback(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"未获取到附近的烤箱列表"]);
                break;
            }
            
        } else {
            
            if (rebindMac) {
                BOOL hasTheDevice = NO;
                for (uSDKDevice* theDevice in devices) {
                    if ([self deviceExistWithMac:theDevice.mac]) {
                        callback(YES, devices, nil);
                        hasTheDevice = YES;
                        break;
                    }
                }
                if (hasTheDevice) {
                    break;
                }
                
            } else {
                
                BOOL hasNewDevice = NO;
                for (uSDKDevice* theDevice in devices) {
                    if (![self deviceExistWithMac:theDevice.mac]) {
                        callback(YES, @[theDevice], nil);
                        hasNewDevice = YES;
                        break;
                    }
                }
                
                if (hasNewDevice) {
                    break;
                }
                
            }
            
        }
    }
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
            if (devices.count == 0) {
                callback(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"获取失败"]);
            } else {
                callback(YES, devices, nil);
            }
            
        });
    });
    
}


#pragma mark - usdk订阅通知流程：uSDKNotificationCenter

#pragma mark - 订阅通知

- (void)subscribeDevice:(NSArray*)deviceMacs
{
    uSDKNotificationCenter* sdkNotificationCenter = [uSDKNotificationCenter defaultCenter];
    
    [sdkNotificationCenter subscribeDevice:self selector:@selector(deviceAttributeReport:) withMacList:deviceMacs];
    
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

- (void)subscribeAllNotificationsWithDevice:(NSArray*)deviceMacs
{
    [self subscribeDevice:deviceMacs];
    [self subscribeBusinessMessage];
    [self subscribeDeviceListChanged];
    [self subscribeInnerError];
}

#pragma mark - 取消订阅通知

- (void)unSubscribeDevice:(NSArray*)deviceMacs;
{
    [[uSDKNotificationCenter defaultCenter] unSubscribeDevice:self withMacList:deviceMacs];
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

- (void)unSubscribeAllNotifications:(NSArray*)deviceMacs
{
    [self unSubscribeDevice:deviceMacs];
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
        NSLog(@"%@", notification.userInfo);
        NSLog(@"%@", self.subscribedDevice.alarmList);
        [self updateCurrentOvenStatus];
        [self sendErrorNotification];
        
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
        //NSLog(@"*********设备列表发生了变化*********");
        
    } else if ([notification.name isEqualToString:SESSION_EXCEPTION_NOTIFICATION]) {
        //NSLog(@"Session失效");
        
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
        
        InnerErrorReportMessage * errnoInfo = notification.object;
        NSInteger errorNo = errnoInfo.errorNo;
        
        //3.针对目前统计,开发者需要过滤出来这几个错误码然后调用接口
        if (errorNo == 90105101 || errorNo == 90105102 || errorNo == 90105103 || errorNo == 90105107) {
            [uAnalysisManager onDeviceOnlineChangeEvent:[NSString stringWithFormat:@"%d", errorNo] withDeviceMac:[errnoInfo.message objectForKey:@"mac"]];
        }
        
        
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
    
    if (DebugOvenFlag) {
        completion(YES, RET_USDK_OK);
        return;
    }
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
    if (DebugOvenFlag) {
        completion(YES, RET_USDK_OK);
        return;
    }
    
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
    
    if (DebugOvenFlag) {
        completion(YES, RET_USDK_OK);
        return;
    }
    
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
    
    if (DebugOvenFlag) {
        completion(YES, RET_USDK_OK);
        return;
    }
    
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
        
        // 设置的烤箱温度
        statusAttr = attrDict[@"20v00g"];
        _currentStatus.temperature = [statusAttr.attrValue integerValue];
        
        // 剩余烘焙时间
        statusAttr = attrDict[@"20v00f"];
        _currentStatus.bakeTime = statusAttr.attrValue;
        
        // 是否有感肉温度探针
        statusAttr = attrDict[@"60v003"];
        _currentStatus.hadTemperatureDetector = [statusAttr.attrValue isEqualToString:@"30v002"] ? YES : NO;
        
        // 是否预热完成
        statusAttr = attrDict[@"50v009"];
        _currentStatus.preheatCompleted = statusAttr != nil;
        
    }];
    
}

- (void)getOvenStatus:(NSString*)deviceMac status:(completion)callback
{
    
    [self getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        
        OvenStatus * ovenStatus = [[OvenStatus alloc] init];
        
        if (success) {
            
            uSDKDevice* currentDevice;
            for (uSDKDevice* device in obj) {
                if ([deviceMac isEqualToString:device.mac]) {
                    currentDevice = device;
                    break;
                }
            }
            
            
            // 更新连线状态
            ovenStatus.isReady = currentDevice.status == STATUS_READY ? YES : NO;
            
            NSMutableDictionary* attrDict = currentDevice.attributeDict;
            uSDKDeviceAttribute* statusAttr;
            
            // 是否开机
            statusAttr = attrDict[@"20v001"];
            ovenStatus.opened = [statusAttr.attrValue isEqualToString:@"20v001"] ? YES : NO;
            
            // 是否已关机
            statusAttr = attrDict[@"20v002"];
            ovenStatus.closed = [statusAttr.attrValue isEqualToString:@"20v002"] ? YES : NO;
            
            // 是否已启动
            statusAttr = attrDict[@"20v003"];
            ovenStatus.isWorking = [statusAttr.attrValue isEqualToString:@"20v003"] ? YES : NO;
            
            // 烘焙模式
            statusAttr = attrDict[@"20v00e"];
            ovenStatus.bakeMode = statusAttr.attrValue;
            
            // 设置的烤箱温度
            statusAttr = attrDict[@"20v00g"];
            ovenStatus.temperature = [statusAttr.attrValue integerValue];
            
            // 剩余烘焙时间
            statusAttr = attrDict[@"20v00f"];
            ovenStatus.bakeTime = statusAttr.attrValue;
            
            // 是否有感肉温度探针
            statusAttr = attrDict[@"60v003"];
            ovenStatus.hadTemperatureDetector = [statusAttr.attrValue isEqualToString:@"30v002"] ? YES : NO;
            
            // 是否预热完成
            statusAttr = attrDict[@"50v009"];
            ovenStatus.preheatCompleted = statusAttr != nil;
            
            callback(YES, ovenStatus, nil);
            
        } else {
            
            callback(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"获取状态失败"]);
        }
        
    }];
    
}

- (void)sendErrorNotification
{
    [self getDevicesCompletion:^(BOOL success, id obj, NSError *error) {
        
        if (success) {
            
            uSDKDevice* currentDevice;
            for (uSDKDevice* device in obj) {
                if ([self.subscribedDevice.mac isEqualToString:device.mac]) {
                    currentDevice = device;
                    break;
                }
            }
            
            NSString* notificationBody;
            
            for (uSDKDeviceAlarm* deviceAlarm in self.subscribedDevice.alarmList) {
                // 报警信息
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v001"]) {
                    notificationBody = @"温馨提示：通过检测，您的烤箱存在异常，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v002"]) {
                    notificationBody = @"温馨提示：通过检测，您的烤箱存在异常，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v003"]) {
                    notificationBody = @"温馨提示：通过检测，您的烤箱预热已经超时，请检查烤箱门体是否关闭，烤箱工作后15min未达到设定温度";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v004"]) {
                    notificationBody = @"温馨提示：通过检测，您的烤箱存在异常，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v005"]) {
                    notificationBody = @"温馨提示：通过检测，您家的烤箱已多次使用，建议您方便的时候进行保养、清洁，以便于保证他的使用效果";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v006"]) {
                    notificationBody = @"温馨提示：通过检测，烤箱运行已经超过1个小时，已经超过一般烹饪所需时间，请查看烤箱及食物状态";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v007"]) {
                    notificationBody = @"温馨提示：通过检测，烤箱运行已经超过2个小时，已经超过一般烹饪所需时间，请查看烤箱及食物状态";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v008"]) {
                    notificationBody = @"温馨提示：此次烘培未设定烹饪时间，请随时关注烘培时间以及食物状态";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v009"]) {
                    
                    self.currentStatus.preheatCompleted = YES;
                    
                    notificationBody = @"温馨提示：烤箱预热完成，请将食物放入烤箱";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v00a"]) {
                    notificationBody = @"温馨提示：烤箱持续运行时间超过2个小时，仍未自动关机";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v00b"]) {
                    notificationBody = @"闹铃时间到，请进行下一步操作";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v00c"]) {
                    notificationBody = @"温馨提示：PCB板线路故障，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v00d"]) {
                    notificationBody = @"温馨提示：WIFI(通讯协议）故障，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v00e"]) {
                    notificationBody = @"温馨提示：电路板温度超标，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
                
                if ([deviceAlarm.alarmMessage isEqualToString:@"50v00f"]) {
                    notificationBody = @"温馨提示：显示屏幕温度超标，请将烤箱立即断电并联系海尔客服进行4006999999检修";
                    [self sendNotificationWithInfo:@{@"time" : [MyTool getCurrentTime],
                                                     @"desc" : notificationBody}
                                         alertBody:notificationBody];
                }
            }
            
            
        } else {
            
            
        }
        
    }];
}

- (void)sendNotificationWithInfo:(NSDictionary*)info alertBody:(NSString*)notificationBody
{
    [[DataCenter sharedInstance] addOvenNotification:info];
    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeAlert fireTime:1 alertBody:notificationBody];
}

#pragma mark - getters

//NSArray *cxz = @[@"icon_ssk_n", @"icon_qsk_n", @"icon_rfsk_n", @"icon_rfqsk_n", @"icon_3Dsk_n", @"icon_cthb_n",
//                 @"icon_dlhb_n", @"icon_rfbk_n", @"icon_bk_n", @"icon_3Drf_n", @"icon_psms_n", @"icon_jd_n",
//                 @"icon_fj_n", @"icon_jssk_n", @"icon_gwz_n", @"icon_cz_n"];
//
//NSArray *xz = @[@"icon_ssk_s", @"icon_qsk_s", @"icon_rfsk_s", @"icon_rfqsk_s", @"icon_3Dsk_s", @"icon_cthb_s",
//                @"icon_dlhb_s", @"icon_rfbk_s", @"icon_bk_s", @"icon_3Drf_s", @"icon_psms_s", @"icon_jd_s",
//                @"icon_fj_s", @"icon_jssk_s", @"icon_gwz_s", @"icon_cz_s"];
- (NSArray *)bakeModes
{
    if (_bakeModes == nil) {
        /**
         *  烧烤、3D烘焙
         */
        _bakeModes = @[
                       @{@"bakeMode"                : @{@"30v0Me" :@"上烧烤"},
                         @"defaultTemperature"      : @230,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @10,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_ssk_n",
                         @"selectedImage"           : @"icon_ssk_s",
                         @"supportedDevices"        : @[@"0291800018", @"0291800020", @"0291800017", @"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v6Mm" :@"全烧烤"},
                         @"defaultTemperature"      : @230,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @10,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_qsk_n",
                         @"selectedImage"           : @"icon_qsk_s",
                         @"supportedDevices"        : @[@""]},
                       
                       @{@"bakeMode"                : @{@"30v0M5" :@"热风烧烤"},
                         @"defaultTemperature"      : @230,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @10,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_rfsk_n",
                         @"selectedImage"           : @"icon_rfsk_s",
                         @"supportedDevices"        : @[@"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v7Mn" :@"热风全烧烤"},
                         @"defaultTemperature"      : @230,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @10,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_rfqsk_n",
                         @"selectedImage"           : @"icon_rfqsk_s",
                         @"supportedDevices"        : @[@""]},
                       
                       @{@"bakeMode"                : @{@"30v0M9" :@"3D烧烤"},
                         @"defaultTemperature"      : @230,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @10,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_3Dsk_n",
                         @"selectedImage"           : @"icon_3Dsk_s",
                         @"supportedDevices"        : @[@"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mf" :@"传统烘焙"},
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_cthb_n",
                         @"selectedImage"           : @"icon_cthb_s",
                         @"supportedDevices"        : @[@"0291800018", @"0291800020", @"0291800017", @"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0M6" :@"对流烘焙"},
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_dlhb_n",
                         @"selectedImage"           : @"icon_dlhb_s",
                         @"supportedDevices"        : @[@"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0M8" :@"热风焙烤"},
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_rfbk_n",
                         @"selectedImage"           : @"icon_rfbk_s",
                         @"supportedDevices"        : @[@"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mg" :@"焙烤"},
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_bk_n",
                         @"selectedImage"           : @"icon_bk_s",
                         @"supportedDevices"        : @[@"0291800018", @"0291800020", @"0291800017"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mc" :@"3D热风"},
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_3Drf_n",
                         @"selectedImage"           : @"icon_3Drf_s",
                         @"supportedDevices"        : @[@"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0Md" :@"披萨模式"} ,
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_psms_n",
                         @"selectedImage"           : @"icon_psms_s",
                         @"supportedDevices"        : @[@"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0Ma" :@"解冻"} ,
                         @"defaultTemperature"      : @60,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @120,
                         @"temperatureChangeble"    : @NO,
                         @"normalImage"             : @"icon_jd_n",
                         @"selectedImage"           : @"icon_jd_s",
                         @"supportedDevices"        : @[@"0291800018", @"0291800020", @"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mb" :@"发酵"} ,
                         @"defaultTemperature"      : @40,
                         @"defaultTime"             : @60,
                         @"defaultSelectTime"       : @60,
                         @"temperatureChangeble"    : @NO,
                         @"normalImage"             : @"icon_fj_n",
                         @"selectedImage"           : @"icon_fj_s",
                         @"supportedDevices"        : @[@"0291800018", @"0291800020", @"0291800017", @"0291800021"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mh" :@"加湿烧烤"},
                         @"defaultTemperature"      : @230,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_jssk_n",
                         @"selectedImage"           : @"icon_jssk_s",
                         @"supportedDevices"        : @[@"0291800020"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mi" :@"高温蒸"},
                         @"defaultTemperature"      : @180,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_gwz_n",
                         @"selectedImage"           : @"icon_gwz_s",
                         @"supportedDevices"        : @[@"0291800020"]},
                       
                       @{@"bakeMode"                : @{@"30v0Mj" :@"纯蒸"},
                         @"defaultTemperature"      : @100,
                         @"defaultTime"             : @120,
                         @"defaultSelectTime"       : @30,
                         @"temperatureChangeble"    : @YES,
                         @"normalImage"             : @"icon_cz_n",
                         @"selectedImage"           : @"icon_cz_s",
                         @"supportedDevices"        : @[@"0291800020"]}
                       
                       ];
    }
    
    return _bakeModes;
}

#pragma mark - 获取指定型号烤箱的烘焙模式

- (NSMutableArray*)bakeModesForType:(NSString*)typeIdentifier
{
    NSMutableArray* modes = [NSMutableArray array];
    
    if (typeIdentifier == nil) {    //默认型号
        typeIdentifier = @"0291800018";
    }
    
    for (NSDictionary* modeDict in self.bakeModes) {
        for (NSString* type in modeDict[@"supportedDevices"]) {
            NSRange range = [typeIdentifier rangeOfString:type];
            if (range.length != 0) {
                [modes addObject:modeDict];
                break;
            }
        }
    }
    
    return modes;
}

@end
























