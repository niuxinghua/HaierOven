//
//  OvenOperator.h
//  HaierOven
//
//  Created by 刘康 on 15/3/25.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "OvenManager.h"
#import "LocalOven.h"

extern NSString* const DeviceWorkCompletedNotification;
extern NSString* const DeviceStartWorkNotification;

typedef NS_ENUM(NSInteger, CurrentDeviceStatus) {
    
    /**
     *  关机状态
     */
    CurrentDeviceStatusClosed,
    
    /**
     *  开机状态
     */
    CurrentDeviceStatusOpened,
    
    /**
     *  在线状态
     */
    CurrentDeviceStatusReady,
    
    /**
     *  离线状态
     */
    CurrentDeviceStatusOffline,
    
    /**
     *  预热状态
     */
    CurrentDeviceStatusPreheating,
    
    /**
     *  工作状态
     */
    CurrentDeviceStatusWorking,
    
    /**
     *  预约状态
     */
    CurrentDeviceStatusOrdering
    
    
};

@interface OvenOperator : OvenManager

/**
 *  当前本地设备信息对象
 */
@property (strong, nonatomic) LocalOven* currentLocalOven;

/**
 *  设备当前的工作状态
 */
@property (nonatomic) CurrentDeviceStatus deviceStatus;

/**
 *  初始的烘焙时长 格式："01:20"
 */
@property (copy, nonatomic) NSString* totalBakeTime;

/**
 *  当前烘焙的温度 格式: "120"
 */
@property (copy, nonatomic) NSString* currentBakeTemperature;

/**
 *  烘焙剩余时间
 */
@property (nonatomic) NSInteger bakeLeftSeconds;

/**
 *  烘焙倒计时
 */
@property (strong, nonatomic) NSTimer* bakeCountdownTimer;

/**
 *  当前的烘焙模式
 */
@property (strong, nonatomic) NSDictionary* currentBakeMode;

/**
 *  预约的烘焙模式
 */
@property (strong, nonatomic) NSDictionary* orderedBakeMode;

/**
 *  预约烘焙完成的时间
 */
@property (strong, nonatomic) NSDate* orderedDate;

/**
 *  预约烘焙的时长
 */
@property (copy, nonatomic) NSString* orderedBakeTime;

/**
 *  预约烘焙的温度
 */
@property (copy, nonatomic) NSString* orderedBakeTemperature;

/**
 *  检测是否预约结束，开始烘焙时间到
 */
@property (strong, nonatomic) NSTimer* orderingTimer;

/**
 *  预热10分钟是否完成，并检查是否能得到预热完成的属性
 */
@property (strong, nonatomic) NSTimer* preheatCountdownTimer;

/**
 *  预热计时
 */
@property (nonatomic) NSInteger preheatCountSeconds;


/**
 *  初始化实例（单例）
 *
 *  @return 返回实例对象
 */
+ (OvenOperator *)sharedOperator;

/**
 *  启动预热并开始烘焙
 *
 *  @param time        烘焙时间
 *  @param temperature 烘焙温度
 *  @param modeDict    烘焙模式
 *  @param callback    操作结果
 */
- (void)preheatToBakeWithTime:(NSString*)time temperature:(NSString *)temperature mode:(NSDictionary *)modeDict operateResult:(completion)callback;

/**
 *  启动烘焙功能
 *
 *  @param time        烘焙时间
 *  @param temperature 烘焙温度
 *  @param mode        烘焙模式
 *  @param callback    操作结果
 */
- (void)startBakeWithTime:(NSString*)time temperature:(NSString*)temperature mode:(NSDictionary*)modeDict operateResult:(completion)callback;

/**
 *  启动预约功能
 *
 *  @param orderedDate 预约完成时间
 *  @param time        烘焙时间
 *  @param temperature 烘焙温度
 *  @param modeDict    烘焙模式
 *  @param callback    操作结果
 */
- (void)startOrderWithDate:(NSDate*)orderedDate bakeTime:(NSString*)time temperature:(NSString*)temperature mode:(NSDictionary*)modeDict operateResult:(completion)callback;

@end









