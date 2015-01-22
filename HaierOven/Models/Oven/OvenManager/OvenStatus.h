//
//  OvenStatus.h
//  HaierOven
//
//  Created by 刘康 on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OvenStatus : NSObject

/**
 *  是否在线，这个根据uSDKDevice的status获得
 */
@property (nonatomic) BOOL isReady;

/**
 *  是否已开机
 */
@property (nonatomic) BOOL opened;

/**
 *  是否已关机
 */
@property (nonatomic) BOOL closed;

/**
 *  是否已启动
 */
@property (nonatomic) BOOL isWorking;

/**
 *  烤箱当前温度
 */
@property (nonatomic) NSInteger temperature;

/**
 *  设置的烘焙时间
 */
@property (copy, nonatomic) NSString* bakeTime;

/**
 *  是否有感肉温度探针
 */
@property (nonatomic) BOOL hadTemperatureDetector;



@end





