//
//  uSDKTools.h
//  uSDK_iOS_v2
//
//  Created by Zono on 14-1-21.
//  Copyright (c) 2014年 haierubic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uSDKConstantInfo.h"

//uSDKLogLevelConst uSDKManagerLogLevel();

@interface uSDKTools : NSObject

+ (NSArray*)combineDeviceDict:(NSArray*)newDeviceList;
+ (NSDictionary*)combineAttributeDict:(NSArray*)newAttributeList withinDevice:device;
+ (NSString*)getDeviceSSID;
+ (NSString*)getMacaddress;
+ (NSString*)getBundleID;
+ (NSString*)getAppVersion;
+ (NSString*)getTimeStamp;
+ (int)downloadCertification:(NSString*)pathString withAppId:(NSString*)appId withAppKey:(NSString*)appKey withVersion:(NSString*)version;
+(NSString*)getServerTimeWithAppId:(NSString*)appId AndVersion:(NSString*)version;
@end


/**
 *	@brief	控制服务器信息类
 */
@interface uSDKRemoteServerInfo : NSObject

/**
 *	@brief	控制服务器域名/IP
 */
@property (nonatomic, strong) NSString* accessGatewayDomain;

/**
 *	@brief	控制服务器端口
 */
@property (nonatomic, assign) NSInteger accessGatewayPort;

@end