//
//  uSDKConstantInfo.h
//  uSDK_iOS_v2
//
//  Created by Zono on 14-1-7.
//  Copyright (c) 2014年 haierubic. All rights reserved.
//
#import "uSDKTools.h"
#import "uSDKManager.h"

#define USDK_CLIENT_VERSION "2.1.02_2014093019"

//#define USDKSERVER_ADDR "192.168.200.208"
//#define USDKSERVER_ADDR "192.168.1.104"
#define USDKSERVER_ADDR "127.0.0.1"
#define USDKSERVER_PORT 56907

#define ACCESS_GATEWAY_DOMAIN_DEFAULT   @"gw.haier.net"
#define ACCESS_GATEWAY_PORT_DEFAULT     56803

#define logFlag 1

#define GET_DEVICE_DESCRIPTION  @"getDeviceDescription"

typedef enum  {
    EXE_OPERATION = 101,            // 控制 101
    EXE_OPERATION_ACK,              // 控制ACK 102
    SUBSCRIBE_DEV_STATUS,           // 订阅设备	103
    SUBSCRIBE_DEV_STATUS_ACK,       // 订阅设备ACK	104
    UNSUBSCRIBE_DEV_STATUS,         // 取消订阅设备	105
    GET_SERVER_VER,                 // 获取版本信息	106
    GET_SERVER_VER_ACK,             // 获取版本信息ACK	 107
//    SUBSCRIBE_SESSION,              // 订阅session变化	108
//    RPT_SESSION_CHANGE,             // session变化通知	109
    GET_DEV_CONFIG_INFO = 110,            // 获取设备配置	110
    GET_DEV_CONFIG_INFO_ACK,        // 获取设备配置ACK 	111
    SET_DEV_CONFIG_INFO,            // 设定设备配置	112
    SET_DEV_CONFIG_INFO_ACK,        // 设定设备配置ACK	113
    SET_LOG_CONFIG,                 // 日志配置	114
    SET_LOG_CONFIG_ACK,             // 日志配置ACK	115
    CHECK_DEVICE,                   // 设备检测	116
    CHECK_DEVICE_ACK,               // 设备检测ACK	117
    SET_DEV_SMARTCONFIG_INFO,       // Smartconfig设备配置	118
    SET_DEV_SMARTCONFIG_INFO_ACK,   // Smartconfig设备配置ACK	119
    EXE_INFRARED_OPERATION,         // 红外信号控制	120
    EXE_INFRARED_OPERATION_ACK,     // 红外信号控制ACK	 121
    EXIT_SERVER,                    // 控制uSDKServer退出	122
    REMOTE_LOGIN,                   // 远程登陆  123
    REMOTE_LOGIN_ACK,               // 远程登入ACK	124
    REMOTE_LOGOUT,                  // 远程登出  125
    TRIGGER_RPT_DEV_LIST,           // 触发设备列表推送   126
    RPT_DEV_STATUS = 201,           // 设备状态通知	201
    RPT_DEV_BUSINESS,               // 设备业务通知	202
    RPT_INFRARED_DEV_SIGNAL,        // 红外设备信号推送	203
    RPT_DEV_LIST,                   // 设备列表推送	204
    RPT_NET_TYPE_CHANGE,            // 网络变化推送	205
    RPT_DEV_IS_ONLINE_STATUS,       // 设备离线在线推送 206
    RPT_SYSTEM_EVENT,               // 系统事件推送	207
    RPT_DEV_BIG_DATA,               // 设备大数据上报 208
    RPT_REMOTE_DEVICE_BIND_CHANGE,	// 远程设备解绑定，绑定消息推送	209
    RPT_SESSION_CHANGE,             // session变化通知	210
    RPT_SUB_DEV_OFFLINE = 213,      // 上报子设备离线	213
    
} uSDKPackageCmd;

typedef enum{
    PLATFORM_NET_TYPE_3G = 1,
    PLATFORM_NET_TYPE_WIFI,
    PLATFORM_NET_TYPE_NONE,
} uSDKPlatformNetTypeConst;

typedef enum{
    SYSTEM_EVENT_ENTER_FOREGROUND = 1,
    SYSTEM_EVENT_ENTER_BACKGROUND,
    SYSTEM_EVENT_ENTER_LOCK,
    SYSTEM_EVENT_ENTER_UNLOCK,
} uSDKPlatformSystemEventConst;



#define CMD_ACK_RESULT_OBJECT @"resultObject"
#define CMD_ACK_RESULT_ERROR @"resultError"
#define CMD_ACK_RESULT_ERROR_INFO_ID @"resultErrorInfoId"


#define __FILENAME__    ((strrchr(__FILE__, '/') ?: __FILE__ - 1) + 1)  //如果__FILE__编译为绝对路径（如xCode上），则只截取文件名

#define uSDKDebugLog(fmt, ...) {\
    uSDKLogLevelConst uSDKLogLevel=[uSDKManager getSingleInstance].logLevel;\
    if(uSDKLogLevel==9||uSDKLogLevel==1){\
        NSLog((@"[uSDKClient] [DEBUG] [%s:%d %s] [" fmt"]\n"), __FILENAME__, __LINE__, __FUNCTION__, ##__VA_ARGS__);\
    }\
}

#define uSDKErrorLog(fmt, ...) {\
    uSDKLogLevelConst uSDKLogLevel=[uSDKManager getSingleInstance].logLevel;\
    if(uSDKLogLevel==1){\
        NSLog((@"[uSDKClient] [ERROR] [%s:%d %s] [" fmt"]\n"), __FILENAME__, __LINE__, __FUNCTION__, ##__VA_ARGS__);\
    }\
}


//打印输出宏
//Xcode 区分编译版本 如果是 debug 版本打印日志，如果是发布与release 版本不打印
/*
 1、每个接口函数的入口处，必须要有日志输出：时间、文件名、代码行号、方法名、start；
 2、每个接口函数的出口处，必须要有日志输出：时间、文件名、代码行号、方法名、函数执行结果（用字符串表示）；
 3、操作函数日志输出，在1和2的基础上，还必须要有：设备mac、ip、在线状态、网络类型、下发的操作命令；
 4、异步socket处理中的日志输出，必须要有：socket发送之前的数据流、socket接收到的数据流；
 */
//[uSDKServer] [Thu Jan 16 18:38:08 2014] [DEBUG] [search.c:332  usdk_send_search_by_port] [send search broadcast to 192.168.2.255 success, fd 4, len 77]
//[uSDKServer] [Thu Jan 16 18:38:08 2014] [ERROR] [search.c:332  usdk_send_search_by_port] [send search broadcast to 192.168.2.255 success, fd 4, len 77]
/*
#define uSDK_DEBUG_NSLog(format,...){   \
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];\
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
        NSString* date = [formatter stringFromDate:[NSDate date]];\
        NSString * printLog=nil;\
        if (![format,##__VA_ARGS__ isKindOfClass:[NSString class]]) {\
            printLog=[NSString stringWithFormat:@"[uSDKClient] [%@] [DEBUG] [LINE:%d %s] [%s]",date,__LINE__,__FUNCTION__,"打印参数错误"];\
        }else{\
            printLog=[NSString stringWithFormat:@"[uSDKClient] [%@] [DEBUG] [LINE:%d %s] [%s]",date,__LINE__,__FUNCTION__,[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]];\
        }\
        const char* contentChars = [printLog cStringUsingEncoding:NSASCIIStringEncoding];\
        printf("%s\n", contentChars);\
}
#define uSDK_ERROR_NSLog(format,...){  \
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];\
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
        NSString* date = [formatter stringFromDate:[NSDate date]];\
        NSString * printLog=nil;\
        if (![format,##__VA_ARGS__ isKindOfClass:[NSString class]]) {\
        printLog=[NSString stringWithFormat:@"[uSDKClient] [%@] [ERROR] [LINE:%d %s] [%s]",date,__LINE__,__FUNCTION__,"打印参数错误"];\
        }else{\
        printLog=[NSString stringWithFormat:@"[uSDKClient] [%@] [ERROR] [LINE:%d %s] [%s]",date,__LINE__,__FUNCTION__,[[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]];\
        }\
        const char* contentChars = [printLog cStringUsingEncoding:NSASCIIStringEncoding];\
        printf("%s\n", contentChars);\
}
*/
/*
 USDK_LOG_DEBUG = 9,
 USDK_LOG_ERROR = 1,
 */

//# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

/*
#define uSDKDebugLog(fmt, ...) {\
    uSDKLogLevelConst uSDKLogLevel=[uSDKManager getSingleInstance].logLevel;\
    if(uSDKLogLevel==9&&uSDKLogLevel==1){\
        NSLog((@"[uSDKClient] [DEBUG] [%s:%d %s] ["fmt"]\n"), __FILENAME__, __LINE__, __FUNCTION__, ##__VA_ARGS__);\
    }\
}

#define uSDKErrorLog(fmt, ...) {\
    uSDKLogLevelConst uSDKLogLevel=[uSDKManager getSingleInstance].logLevel;\
    if(uSDKLogLevel==1){\
        NSLog((@"[uSDKClient] [ERROR] [%s:%d %s] ["fmt"]\n"), __FILENAME__, __LINE__, __FUNCTION__, ##__VA_ARGS__);\
    }\
}

#define uSDKNSLog(objectLevel,format,...){\
    uSDKLogLevelConst uSDKLogLevel=[uSDKManager getSingleInstance].logLevel;\
    if(objectLevel==1&&objectLevel==uSDKLogLevel){\
        uSDK_ERROR_NSLog(format,##__VA_ARGS__);\
    }else if(objectLevel==9&&objectLevel==uSDKLogLevel) {\
       uSDK_DEBUG_NSLog(format,##__VA_ARGS__);}\
    else if(objectLevel==0){\
       \
    };\
    if(objectLevel==1&&uSDKLogLevel==9){\
        uSDK_ERROR_NSLog(format,##__VA_ARGS__);\
    };\
}
#define uSDKLog(format,...) {\
    if(logFlag){\
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];\
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
        NSString* date = [formatter stringFromDate:[NSDate date]];\
        NSString * printLog=nil;\
        if (![format,##__VA_ARGS__ isKindOfClass:[NSString class]]) {\
        printLog=[NSString stringWithFormat:@"[uSDKClient] [%@] [DEBUG] [LINE:%d ] [%s]",date,__LINE__,"打印参数错误"];\
        }else{\
        printLog=[NSString stringWithFormat:@"[uSDKClient] [%@] [DEBUG] [LINE:%d ] [%s]",date,__LINE__,[[NSString stringWithFormat:format,##__VA_ARGS__] UTF8String]];\
        }\
        const char* contentChars = [printLog cStringUsingEncoding:NSASCIIStringEncoding];\
        printf("%s\n", contentChars);\
    };\
}

#else
#define uSDKNSLog(objectLevel,format,...);
#define uSDKLog(format,...);
#endif

*/


