//
//  Oven[OvenManager sharedManager].m
//  HaierOven
//
//  Created by 刘康 on 15/3/25.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "OvenOperator.h"

NSString* const DeviceWorkCompletedNotification = @"Device work completed notification";
NSString* const DeviceStartWorkNotification = @"Device start work notification";

@interface OvenOperator ()

@property (nonatomic) BOOL isPreheat;

@end

@implementation OvenOperator

#pragma mark - 初始化

+ (OvenOperator *)sharedOperator
{
    static OvenOperator* _sharedOperator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOperator = [[OvenOperator alloc] init];
    });
    return _sharedOperator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deviceStatus = CurrentDeviceStatusClosed;

    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - 执行烘焙

// 烘焙逻辑：先预热，预热完成判断条件：1. 烘焙预热10分钟 2. 收到uSDK的预热结束通知，满足其中一点即可。 然后根据设定的时间开始预热
- (void)preheatToBakeWithTime:(NSString*)time temperature:(NSString *)temperature mode:(NSDictionary *)modeDict operateResult:(completion)callback
{
    if (self.orderingTimer != nil) {
        [self.orderingTimer invalidate];
        self.orderingTimer = nil;
    }
    
    self.isPreheat = YES;
    self.totalBakeTime = time;
    self.currentBakeTemperature = temperature;
    
    // 预热烘焙10分钟
    [self startBakeWithTime:@"00:10"
                temperature:temperature
                       mode:modeDict
              operateResult:^(BOOL success, id obj, NSError *error) {
                  if (success) {
                      self.deviceStatus = CurrentDeviceStatusPreheating;
                      callback(YES, @"OK", nil);
                  } else {
                      callback(NO, nil, error);
                  }
              }];
    
}

- (void)startBakeWithTime:(NSString *)time temperature:(NSString *)temperature mode:(NSDictionary *)modeDict operateResult:(completion)callback
{
    NSString* mode = [[modeDict[@"bakeMode"] allKeys] firstObject];
    //NSString* modeStr = [[modeDict[@"bakeMode"] allValues] firstObject];
    self.currentBakeMode = modeDict;
    
    if (self.orderingTimer != nil) {
        [self.orderingTimer invalidate];
        self.orderingTimer = nil;
    }
    
    if (!self.isPreheat) { //不是预热 —> 开始烘焙的步骤, 快速预热，一键烘焙
        self.totalBakeTime = time;
        self.isPreheat = NO;
    }
    
    //调用顺序：检测是否已开机 - 设置模式 - 设置温度 - 设置时间 - 启动
    
    // 是否开机
    if (![OvenManager sharedManager].currentStatus.opened) {
        if ([OvenManager sharedManager].subscribedDevice == nil && !DebugOvenFlag) {
            callback(NO, nil, [self errorWithDescription:@"烤箱连接失败"]);
            return;
        }
        
        uSDKDeviceAttribute* cmd = [self structureWithCommandName:kBootUp commandAttrValue:kBootUp];
        [super executeCommands:[@[cmd] mutableCopy]
                     toDevice:[OvenManager sharedManager].subscribedDevice
                 andCommandSN:0
          andGroupCommandName:@""
                     callback:^(BOOL success, uSDKErrorConst errorCode) {
                         
                     }];
        [NSThread sleepForTimeInterval:1.0];
    }
    
    // 设置烘焙模式
    __unsafe_unretained typeof(self) operator = self;
    [[OvenManager sharedManager] setBakeMode:mode callback:^(BOOL success, uSDKErrorConst errorCode) {
        if (success) {
            
            // 设置时间
            [[OvenManager sharedManager] setBakeTime:time callback:^(BOOL success, uSDKErrorConst errorCode) {
                if (success) {
                    
                    //设置温度
                    [[OvenManager sharedManager] setBakeTemperature:temperature callback:^(BOOL success, uSDKErrorConst errorCode) {
                        if (success) {
                            
                            //启动烘焙
                            uSDKDeviceAttribute* command = [[OvenManager sharedManager] structureWithCommandName:kStartUp commandAttrValue:kStartUp];
                            [[OvenManager sharedManager] executeCommands:[@[command] mutableCopy]
                                             toDevice:[OvenManager sharedManager].subscribedDevice
                                         andCommandSN:0
                                  andGroupCommandName:@""
                                             callback:^(BOOL success, uSDKErrorConst errorCode) {
                                                 
                                                 operator.bakeLeftSeconds = [[time substringToIndex:2] integerValue] * 60 * 60 + [[time substringFromIndex:3] integerValue] * 60;
                                                 
                                                 //启动命令回调OK
                                                 callback(YES, @"OK", nil);
                                                 
                                             }];
                            
                            
                        } else {
                            callback(NO, nil, [operator errorWithDescription:@"设置烘焙温度失败"]);
                        }
                    }];
                    
                } else {
                    callback(NO, nil, [operator errorWithDescription:@"设置烘焙时间失败"]);
                }
            }];
            
        } else {
            callback(NO, nil, [operator errorWithDescription:@"设置烘焙模式失败"]);
        }
    }];
    
}

#pragma mark - 执行预约

- (void)startOrderWithDate:(NSDate*)orderedDate bakeTime:(NSString*)time temperature:(NSString*)temperature mode:(NSDictionary*)modeDict operateResult:(completion)callback
{
    self.deviceStatus = CurrentDeviceStatusOrdering;
    self.orderedDate = orderedDate;
    self.orderedBakeTime = time;
    self.orderedBakeTemperature = temperature;
    self.orderedBakeMode = modeDict;
    self.orderingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkOrderedTime) userInfo:nil repeats:YES];
    callback(YES, @"OK", nil);
}

/**
 *  检测预约时间是否结束，是否可以开始烘焙
 */
- (void)checkOrderedTime
{
    if (self.deviceStatus != CurrentDeviceStatusOrdering) {
        return;
    }
    // 1. 计算开始烘焙的时间: 结束烘焙的时间 - 烘焙时长
    NSTimeInterval bakeInteval = [[self.orderedBakeTime substringToIndex:2] integerValue] * 60 * 60 + [[self.orderedBakeTime substringFromIndex:3] integerValue] * 60;
    NSDate* startDate = [self.orderedDate dateByAddingTimeInterval:(0 - bakeInteval)];
    if ([[NSDate date] compare:startDate] == NSOrderedDescending) {
        [self.orderingTimer invalidate];
        self.orderingTimer = nil;
        
        [self startBakeWithTime:self.orderedBakeTime
                    temperature:self.orderedBakeTemperature
                           mode:self.orderedBakeMode
                  operateResult:^(BOOL success, id obj, NSError *error) {
                      self.deviceStatus = CurrentDeviceStatusWorking;
                  }];
    }
}

#pragma mark - 烤箱工作状态变化

- (void)setDeviceStatus:(CurrentDeviceStatus)deviceStatus
{
    _deviceStatus = deviceStatus;
    
    switch (deviceStatus) {
        case CurrentDeviceStatusClosed:
        {
            
            //break;
        }
        case CurrentDeviceStatusOpened:
        {
            
            //break;
        }
        case CurrentDeviceStatusReady:
        {
            // 停止运行会置为Ready
            if ([self.bakeCountdownTimer isValid]) {
                [self.bakeCountdownTimer invalidate];
            }
            if (self.orderingTimer != nil) {
                [self.orderingTimer invalidate];
                self.orderingTimer = nil;
            }
            break;
        }
        case CurrentDeviceStatusPreheating:
        {
            [self.preheatCountdownTimer invalidate];
            self.preheatCountSeconds = 0;
            self.preheatCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(preheatCountdownTimerAction:) userInfo:nil repeats:YES];
            break;
        }
        case CurrentDeviceStatusWorking:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceStartWorkNotification object:nil userInfo:@{@"DeviceMac" : self.currentLocalOven.mac}];
            [self.bakeCountdownTimer invalidate];
            self.bakeCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(bakeCountdownTimerAction:) userInfo:nil repeats:YES];
            break;
        }
        case CurrentDeviceStatusOrdering:
        {
            
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - 计时器工作事件

// 预热完成判断条件：1. 烘焙预热10分钟 2. 收到uSDK的预热结束通知，满足其中一点即可
- (void)preheatCountdownTimerAction:(NSTimer*)timer
{
    if (self.deviceStatus == CurrentDeviceStatusPreheating) {
        self.preheatCountSeconds++;
        if (self.preheatCountSeconds >= 10 * 60) {
            [self preheatComplete];
            return;
        }
        
        [[OvenManager sharedManager] getOvenStatus:self.currentLocalOven.mac status:^(BOOL success, id obj, NSError *error) {
            if (success) {
                OvenStatus* status = obj;
                
                if (status.preheatCompleted) {
                    [self preheatComplete];
                }
                
            }
        }];
    }
    
}

- (void)preheatComplete
{
    NSString* alertBody = [NSString stringWithFormat:@"设备\"%@\"预热完成，开始烘焙！", self.currentLocalOven.name];
    [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeWarmUp fireTime:1 alertBody:alertBody];
    NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                           @"desc" : alertBody};
    [[DataCenter sharedInstance] addOvenNotification:info];
    [[NSNotificationCenter defaultCenter] postNotificationName:PreheatCompleteNotification object:nil userInfo:@{@"info" : alertBody}];

    
    [self.preheatCountdownTimer invalidate];
    [self startBakeWithTime:self.totalBakeTime
                temperature:self.currentBakeTemperature
                       mode:self.currentBakeMode
              operateResult:^(BOOL success, id obj, NSError *error) {
                  
                  self.deviceStatus = CurrentDeviceStatusWorking;
                  
                  NSString* notificationBody = [NSString stringWithFormat:@"设备\"%@\"开始烘焙，模式：%@，时间：%ld，温度：%@°",self.currentLocalOven.name, [[self.currentBakeMode[@"bakeMode"] allValues] firstObject], self.bakeLeftSeconds/60,  self.currentBakeTemperature];
                  NSDictionary* info = @{@"time" : [MyTool getCurrentTime],
                                         @"desc" : notificationBody};
                  [[DataCenter sharedInstance] addOvenNotification:info];
                  
                  [[DataCenter sharedInstance] sendLocalNotification:LocalNotificationTypeBakeComplete fireTime:self.bakeLeftSeconds alertBody:notificationBody];
                  
              }];
}

- (void)bakeCountdownTimerAction:(NSTimer*)timer
{
    self.bakeLeftSeconds = self.bakeLeftSeconds == 0 ? 0 : self.bakeLeftSeconds - 1;
    
    // 工作过程中实时检测设备的状态
    if (self.deviceStatus == CurrentDeviceStatusWorking) {
        [[OvenManager sharedManager] getOvenStatus:[OvenManager sharedManager].subscribedDevice.mac status:^(BOOL success, id obj, NSError *error) {
            if (success) {
                OvenStatus* status = obj;
                if (!status.isWorking && status.isReady) {
                    self.deviceStatus = CurrentDeviceStatusReady;
                    [self workComplete];
                }
//                if (!status.isReady) {
//                    self.deviceStatus = CurrentDeviceStatusOffline;
//                    [self workComplete];
//                }
            }
        }];
    }
    
    if (self.bakeLeftSeconds == 0) {
        [self workComplete];
    }
}

- (void)workComplete
{
    [self.bakeCountdownTimer invalidate];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceWorkCompletedNotification object:nil userInfo:@{@"DeviceMac" : self.currentLocalOven.mac}];
}

#pragma mark - 其他方法

- (NSError*)errorWithDescription:(NSString*)errorMsg
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorMsg};
    NSError *error = [NSError errorWithDomain:@"com.haier.usdk" code:-1 userInfo:userInfo];
    return error;
}

//获取当前屏幕显示的viewcontroller

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end




