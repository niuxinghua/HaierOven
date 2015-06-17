//
//  DataCenter.h
//  追爱行动
//
//  Created by 刘康 on 14-11-13.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalOven.h"

#define MyOvensInfoHadChangedNotificatin    @"My ovens info had changed"

#define ModifiedUserInfoNotification    @"Had modified user info"

#define NotificationsHadReadNotification    @"Notifications had read"

#define LoginSuccussNotification        @"Login successfully"

#define LogoutSuccussNotification       @"Logout successfully"

#define MessageCountUpdateNotification  @"Message count update" //更新未读消息数量通知

#define ReceivedLocalNotification   @"Received local notification"

#define SubmitCookbookSuccessNotification   @"Submit cookbook success notification"

#define IsLogin     ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"])

#define CurrentUserBaseId   ([DataCenter sharedInstance].currentUserBaseId)

#define USER_DATA_PATH      ([[self getLibraryPath] stringByAppendingPathComponent:@"DataCenter/UserData"])      //保存plist文件的路径
#define DOWNLOAD_DATA_PATH  ([[self getLibraryPath] stringByAppendingPathComponent:@"DataCenter/DownloadData"])  //保存下载数据的路径

/**
 *  当前登录用户的Key值，此key对应的value保存在NSUserDefaults中
 */
extern NSString* const kCurrentLoginUserName;
extern NSString* const kRecommendProjectsFileName;


typedef NS_ENUM(NSInteger, LocalNotificationType) {
    LocalNotificationTypeWarmUp,      // 预热完成
    LocalNotificationTypeBakeComplete,  // 烘焙完成
    LocalNotificationTypeClockTimeUp,    // 闹钟时间到
    LocalNotificationTypeAlert  //异常报警
    
};


@interface DataCenter : NSObject

/**
 *  手机唯一标识，海尔格式是IMEI+MAC，这里我用deviceUUID代替
 */
@property (copy, nonatomic) NSString* clientId;

/**
 *  获取当前登录用户ID
 */
@property (copy, nonatomic) NSString* currentUserBaseId;

/**
 *  当前登录用户
 */
@property (strong, nonatomic) User* currentUser;

/**
 *  我已绑定的烤箱列表
 */
@property (strong, nonatomic) NSMutableArray* myOvens;

/**
 *  保存消息数量，所有controller均可访问
 */
@property (nonatomic) NSInteger messagesCount;

/**
 *  加载菜谱的预设图
 */
@property (strong, nonatomic) UIImage* placeHolder;

/**
 *  模型层单例
 *
 *  @return 返回DataCenter单例
 */
+ (DataCenter*)sharedInstance;

/**
 * 获取Library目录
 **/
- (NSString*)getLibraryPath;

/**
 * 获取plist文件目录
 **/
- (NSString*)getUserDataPath;

/**
 * 获取下载的文件目录
 **/
- (NSString*)getDownloadDataPath;

/**
 * 设置备份策略，所有文件都不进行iCloud备份
 **/
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

- (void)addSkipBackupAttributeToPath:(NSString*)path;

/**
 * 测试方法，检查某个文件是否会被iCloud备份
 **/
- (void)testFileAttributeWithUrl:(NSURL*)fileUrl;

#pragma mark - 用户签到信息

/**
 *  用户今日是否签到
 *
 *  @return 是否签到
 */
- (BOOL)getSignInFlag;

/**
 *  保存今日签到状态
 */
- (void)saveSignInFlag;

#pragma mark - 烤箱通知定义



/**
 *  发送本地通知
 *
 *  @param type      通知类型
 *  @param seconds   通知时间
 *  @param alertBody 通知内容
 */
- (void)sendLocalNotification:(LocalNotificationType)type fireTime:(NSTimeInterval)seconds alertBody:(NSString*)alertBody;


#pragma mark - 缓存文件 读取缓存文件

/**
 *  保存搜索关键字
 *
 *  @param keyword 关键字
 */
- (void)saveSearchedKeyword:(NSString*)keyword;

/**
 *  获取本地搜索关键字
 *
 *  @return 返回关键字列表
 */
- (NSMutableArray*)getSearchedKeywords;

/**
 *  缓存用户信息到本地
 *
 *  @param jsonObj json字典
 */
- (void)saveUserInfoWithObject:(id)jsonObj;

/**
 *  获取本地用户信息
 *
 *  @return json Dict对象
 */
- (id)getUserInfoObject;

/**
 *  缓存标签
 *
 *  @param jsonObj json 字典
 */
- (void)saveTagsWithObject:(id)jsonObj;

/**
 *  获取缓存的标签
 *
 *  @return json dict
 */
- (id)getTagsObject;

/**
 *  缓存菜谱列表
 *
 *  @param jsonObj 字典
 */
- (void)saveCookbooksWithObject:(id)jsonObj;





/**
 *  获取缓存的菜谱列表
 *
 *  @return json dict
 */
- (id)getCookbooksObject;

/**
 *  缓存推荐厨神
 *
 *  @param jsonObj 字典
 */
- (void)saveRecommendCookersWithObject:(id)jsonObj;

/**
 *  获取缓存推荐厨神
 *
 *  @return json dict
 */
- (id)getRecommendCookersObject;

/**
 *  保存烤箱信息到本地
 *
 *  @param oven 本地烤箱信息
 */
- (void)addOvenInfoToLocal:(LocalOven*)oven;

/**
 *  删除已绑定的设备
 *
 *  @param oven 本地烤箱信息
 */
- (void)removeOvenInLocal:(LocalOven*)oven;

/**
 *  更新本地烤箱信息
 *
 *  @param oven 本地烤箱对象
 */
- (void)updateOvenInLocal:(LocalOven*)oven;


#pragma mark - 设备操作的通知

/**
 *  添加到本地通知列表
 *
 *  @param info 结构：@{@“time”:@"2015-01-29 12:09", @"desc":@"设备“xx”已开机"}
 */
- (void)addOvenNotification:(NSDictionary*)info;

/**
 *  获取设备通知
 *
 *  @return 通知
 */
- (NSMutableArray*)loadOvenNotifications;

@end






























