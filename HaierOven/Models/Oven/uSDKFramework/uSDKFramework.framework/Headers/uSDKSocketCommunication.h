//
//  uSDKSocketCommunication.h
//  uSDK_iOS_v2
//
//  Created by Zono on 14-1-8.
//  Copyright (c) 2014年 haierubic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uSDKCommandPackage.h"

@interface uSDKSocketCommunication : NSObject
@property (nonatomic, assign) int socketFd;
@property (nonatomic, strong) NSOperationQueue* parseDataQueue;
@property (nonatomic, strong) NSThread* networkListenRunLoopThread;
@property (nonatomic, strong) NSMutableArray* cmdQueue;
@property (nonatomic, strong) NSMutableArray* statusSubscribedDeviceList;
@property (nonatomic, assign) uSDKPlatformNetTypeConst platformNetType;

/**
 *	@brief	订阅设备类型
 */
@property (nonatomic, strong) NSMutableArray* subscribeDeviceType;


/**
 *	@brief	远程服务器信息，临时存放
 */
@property (nonatomic, strong) uSDKRemoteServerInfo* remoteServerInfo;

+ (uSDKSocketCommunication*)getSingleInstance;
+ (unsigned int)getSN;
- (int)connectTouSDKServer;
- (void)disConnectWithuSDKServer;
- (void)parseDataFromSDKServer:(NSDictionary*)dict;
- (int)sendData:(uSDKCommandPackage*)cmdPackage;
- (void)conditionWait:(uSDKCommandPackage*)package;
- (void)conditionContinue:(uSDKCommandPackage*)package;
- (void)resendStatusSubscribedDeviceList;

@end
