//
//  CookbookOven.h
//  HaierOven
//
//  Created by 刘康 on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  此类描述了菜谱详情中烤箱的使用的状态信息
 */
@interface CookbookOven : NSObject

/**
 *  烘焙模式
 */
@property (copy, nonatomic) NSString* roastStyle;

/**
 *  烘焙温度
 */
@property (copy, nonatomic) NSString* roastTemperature;

/**
 *  烘焙时间
 */
@property (copy, nonatomic) NSString* roastTime;

/**
 *  烤箱类型：台式烤箱，嵌入式烤箱
 */
@property (copy, nonatomic) NSString* ovenType;

/**
 *  烤箱信息：{“name”:”OBT600-10G”}
 */
@property (strong, nonatomic) NSDictionary* ovenInfo;

/**
 *  初始化使用烤箱信息
 *
 *  @param roastStyle  烘焙模式
 *  @param temperature 温度
 *  @param time        时间
 @  @param ovenType    台式烤箱、嵌入式烤箱
 *  @param ovenInfo    烤箱信息 {“name”:”OBT600-10G”}
 *
 *  @return CookbookOven
 */
- (instancetype)initWithRoastStyle:(NSString*)roastStyle roastTemperature:(NSString*)temperature roastTime:(NSString*)time ovenType:(NSString*)ovenType ovenInfo:(NSDictionary*)ovenInfo;

@end


