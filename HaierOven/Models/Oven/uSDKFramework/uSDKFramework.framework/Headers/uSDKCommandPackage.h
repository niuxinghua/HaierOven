//
//  uSDKCommandPackage.h
//  uSDK_iOS_v2
//
//  Created by Zono on 14-1-7.
//  Copyright (c) 2014年 haierubic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uSDKDevice.h"
#import "uSDKConst.h"
#import "uSDKConstantInfo.h"
#import "uSDKDeviceConfigInfo.h"
#import "uSDKBusinessMessage.h"
#import "BaseMessage.h"

/*  inner
 *	@brief	uSDKCommandPackage
 */
@interface uSDKCommandPackage : NSObject

@property (nonatomic, assign) int sn;
@property (nonatomic, assign) int uSDKSn;
@property (nonatomic, assign) BOOL needAck;
@property (nonatomic, assign) BOOL waitFlag;
@property (nonatomic, strong) NSCondition* waitCondition;
@property (nonatomic, strong) NSData* sendDataBuf;
@property (nonatomic, strong) NSDictionary* recvDictBuf;
@property (nonatomic, strong) NSMutableDictionary* resultDict;
- (id)initWithDict:(NSDictionary*)cmdDict withSn:(int)cmdSn needAck:(BOOL)needAck withTimeout:(double)packageTimeout;
@end



/*  inner
 *	@brief	uSDKCommandProtocolProxy
 */
@interface uSDKCommandProtocolProxy : NSObject

+ (NSDictionary*)packCmdExeOperation:(NSString*)mac withGroupCmdName:(int)groupCmdName withCmdList:(NSMutableArray*)cmdList withType:(uSDKDeviceTypeConst)type;
+ (NSDictionary*)packCmdExeOperation:(uSDKComplexDevice*)complexDevice withGroupCmdName:(int)groupCmdName withCmdList:(NSMutableArray*)cmdList;
+ (NSDictionary*)packCmdSubscribeDevStatus:(NSArray*)macs;
+ (NSDictionary*)packCmdUnSubscribeDevStatus:(NSArray*)macs;
+ (NSDictionary*)packCmdGetServerVer:(uSDKPlatformNetTypeConst)netType;
+ (NSDictionary*)packCmdRptNetTypeChange:(uSDKPlatformNetTypeConst)netType;
+ (NSDictionary*)packCmdRptSystemEvent:(uSDKPlatformSystemEventConst)systemEvent;
+ (NSDictionary*)packCmdGetDevConfigInfo;
+ (NSDictionary*)packCmdSetDevConfigInfo:(uSDKDeviceConfigInfo*)configInfo withDeviceConfigMode:(uSDKDeviceConfigModeConst)deviceConfigMode withIsAnswer:(BOOL)isAnswer;
+ (NSDictionary*)packCmdSetDevSmartConfigInfo:(NSString*)ap_sid ap_password:(NSString*)ap_password is_answer:(BOOL)is_anwer;
+ (NSDictionary*)packCmdSetLogConfig:(uSDKLogLevelConst)level file_max_size:(NSInteger)file_max_size file_path:(NSString*)file_path;
+ (NSDictionary*)packCmdCheckDevice:(NSString*)mac;
+ (NSDictionary*)packCmdExeInfraredOperation:(NSString*)mac withData:(NSString*)data;
+ (NSDictionary*)packCmdRemoteLogin:(NSString*)session withRemoteDeviceList:(NSArray*)remoteDeviceList withDomain:(NSString*)domain withPort:(NSInteger)port;
+ (NSDictionary*)packCmdRemoteLogout:(NSString*)session;
+ (NSDictionary*)packCmdTriggerRptDevList;
+ (NSDictionary*)packCmdExitServer;


+ (NSDictionary*)parseCmdExeOperationAck:(uSDKCommandPackage*)package withSnDict:(NSMutableDictionary*)snDict;
+ (void)parseCmdExeComplexDevOperationAck:(uSDKCommandPackage*)package;
+ (NSDictionary*)parseCmdExeInfraredOperationAck:(uSDKCommandPackage*)package withSnDict:(NSMutableDictionary*)snDict;
+ (BOOL)parseCmdGetServerVerAck:(uSDKCommandPackage*)package;
+ (BOOL)parseCmdGetDevConfigInfoAck:(uSDKCommandPackage*)package;
+ (BOOL)parseCmdSetDevConfigInfoAck:(uSDKCommandPackage*)package;
+ (BOOL)parseCmdSetDevSmartConfigInfoAck:(uSDKCommandPackage*)package;
+ (BOOL)parseCmdSetLogConfigAck:(uSDKCommandPackage*)package;
+ (BOOL)parseCmdCheckDeviceAck:(uSDKCommandPackage*)package;
+ (BOOL)parseCmdRemoteLoginAck:(uSDKCommandPackage*)package;


+ (NSArray*)parseCmdRptDevList:(NSDictionary*)dict;
+ (NSDictionary*)parseCmdRptDevStatus:(NSDictionary*)dict;
+ (NSDictionary*)parseCmdRptDevIsOnline:(NSDictionary*)dict;
+ (NSDictionary*)parseCmdRptRemoteDeviceBindChange:(NSDictionary*)dict;
+ (uSDKBusinessMessage*)parseCmdRptDevBusiness:(NSDictionary*)dict;
+ (uSDKTransparentMessage*)parseCmdRptInfraredDevSignal:(NSDictionary*)dict;
+ (uSDKTransparentMessage*)parseCmdRptDevBigData:(NSDictionary*)dict;
+ (NSString*)parseCmdRptSessionChange:(NSDictionary*)dict;

+ (void)parseRptComplexDev:(NSDictionary*)dict;
+ (void)parseRptSubDevOffline:(NSDictionary*)dict;

+ (InnerErrorReportMessage*)parseCmdRptServerInnerErr:(NSDictionary*)dict;

+ (SmartConfigInfoReportMessage*)parseCmdSetDevSmartConfigInfo:(NSDictionary*)dict;

@end


/**
 *  class: uSDKJSONProxy
 */
@interface uSDKJSONProxy : NSObject

+ (NSDictionary*)JSONParseDataToDic:(NSData*)apData;
+ (NSData*)JSONParseDicToData:(NSDictionary*)apDic;
//+ (NSMutableData*)checkData:(NSData*)data;
@end
