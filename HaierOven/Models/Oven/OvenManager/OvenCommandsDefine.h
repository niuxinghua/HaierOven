//
//  OvenCommandsDefine.h
//  HaierOven
//
//  Created by 刘康 on 15/1/7.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#ifndef HaierOven_OvenCommandsDefine_h
#define HaierOven_OvenCommandsDefine_h

/**
 *  开机
 */

#define kBootUp     @"20v001" 

/**
 *  关机
 */
#define kShutDown       @"20v002" 

/**
 *  启动
 */
#define kStartUp          @"20v003" 

/**
 *  暂停
 */
#define kPause            @"20v004" 

/**
 *  继续
 */
#define  kContinue         @"20v005" 

/**
 *  待机
 */
#define kWaiting         @"20v006" 

/**
 *  童锁
 */
#define kLock                 @"20v007" 

/**
 *  解锁
 */
#define kUnlock               @"20v008" 

/**
 *  开启照明
 */
#define kLighting         @"20v009" 

/**
 *  关闭照明
 */
#define  kOffLighting          @"20v00a" 

/**
 *  开启清洁
 */
#define kCleaning         @"20v00b" 

/**
 *  结束清洁
 */
#define kStopCleaning     @"20v00c" 

/**
 *  开启风机
 */
#define kOpenAirFan         @"30v002"

/**
 *  关闭风机
 */
#define kCloseAirFan        @"30v001"

/**
 *  开启底盘旋转
 */
#define kOpenChassisRotation    @"30v002"

/**
 *  关闭底盘旋转
 */
#define kCloseChassisRotation   @"30v001"

/**
 *  烘焙时间 格式：小时:分钟
 *  小时取值范围：0~23，步长：1，单位：时
 *  分钟取值范围：0~59，步长：1，单位：分
 */
#define kBakeTime       @"20v00f"

/**
 *  烘焙温度 取值范围：0～250，步长：1，单位：摄氏度
 */
#define kBakeTemperature    @"20v00g"

/**
 *  烘焙模式：
 *  30v0Mc		3D热风
 *  30v0M9		3D 烧烤
 *  30v0Md		披萨模式
 *  30v0M6		传统烘焙
 *  30v0M5		热风烧烤
 *  30v0Me		烧烤
 *  30v0Mf		传统烧烤
 *  30v0M8		对流烘焙
 *  30v0M1		快速预热功能
 *  30v0Ma		解冻功能
 *  30v0Mb		发酵功能
 *  30v0Mg		下烧烤
 *  30v1Mh		上烧烤+蒸汽
 *  30v2Mi		上下烧烤+蒸汽
 *  30v3Mj		纯蒸汽
 *  30v4Mk		消毒1
 *  30v5Ml		消毒2
 *  30v6Mm		全烧烤
 *  30v7Mn		热风全烧烤
 */
#define kBakeMode       @"20v00e"

/**
 *  预约时间：格式：小时:分钟
 */
#define kOrderTime      @"20v00h"


#endif
































