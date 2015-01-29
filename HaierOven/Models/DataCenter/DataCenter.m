//
//  DataCenter.m
//  追爱行动
//
//  Created by 刘康 on 14-10-3.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "DataCenter.h"
#import "DataParser.h"
#import <sys/xattr.h>
#import "FCUUID.h"

NSString* const kRecommendProjectsFileName              = @"recommendProjects.plist";

NSString* const kCurrentLoginUserName                = @"Current login user name";


NSString* const kLocalUserInfoFileName          = @"currentUser.data";
NSString* const kLocalTagsFileName              = @"tags.data";
NSString* const kLocalCookbooksFileName         = @"cookbooks.data";
NSString* const kLocalOvensFileName             = @"myOvens.data";
NSString* const kLocalSearchedKeywordsFileName  = @"searchedKeywords.plist";
NSString* const kLocalSignInMessageFileName     = @"signInMessage.plist";
NSString* const kLocalOvenInfosFileName         = @"ovenNotifications.plist";

@interface DataCenter ()

/**
 *  预热完成通知
 */
@property (strong, nonatomic) UILocalNotification* warmUpNotification;

/**
 *  烘焙完成的通知
 */
@property (strong, nonatomic) UILocalNotification* bakeCompleteNotification;

/**
 *  闹钟时间到了通知
 */
@property (strong, nonatomic) UILocalNotification* clockTimeUpNotification;

@end

@implementation DataCenter


#pragma mark - 单例 实例化

+ (DataCenter *)sharedInstance
{
    static DataCenter* _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DataCenter alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createDirectories];
        self.clientId = [FCUUID uuidForDevice];
    }
    return self;
}

#pragma mark - 路径相关

- (void)createDirectories
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:USER_DATA_PATH]) {
        [fileManager createDirectoryAtPath:USER_DATA_PATH withIntermediateDirectories:YES attributes:nil error:nil];
        [self addSkipBackupAttributeToPath:USER_DATA_PATH];
    }
    if (![fileManager fileExistsAtPath:DOWNLOAD_DATA_PATH]) {
        [fileManager createDirectoryAtPath:DOWNLOAD_DATA_PATH withIntermediateDirectories:YES attributes:nil error:nil];
        [self addSkipBackupAttributeToPath:DOWNLOAD_DATA_PATH];
    }
}

- (NSString*)getLibraryPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

/**
 * 获取plist文件目录
 **/
- (NSString*)getUserDataPath;
{
    return USER_DATA_PATH;
}

/**
 * 获取下载的文件目录
 **/
- (NSString*)getDownloadDataPath
{
    return DOWNLOAD_DATA_PATH;
}

#pragma mark - 备份策略

/**
 * 设置备份策略，所有文件都不进行iCloud备份
 **/
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

- (void)addSkipBackupAttributeToPath:(NSString*)path
{
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

/**
 * 测试方法，检查某个文件是否会被iCloud备份
 **/
- (void)testFileAttributeWithUrl:(NSURL*)fileUrl
{
    NSError* error = nil;
    id flag = nil;
    [fileUrl getResourceValue: &flag
                       forKey: NSURLIsExcludedFromBackupKey error: &error];
    NSLog (@"NSURLIsExcludedFromBackupKey flag value is %@", flag);
}

#pragma mark - 用户签到信息


- (BOOL)getSignInFlag
{
    NSString* filePath = [USER_DATA_PATH stringByAppendingPathComponent:kLocalSignInMessageFileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableArray* signedDates = [NSMutableArray array];
    if (![fileManager fileExistsAtPath:filePath]) {
        return NO;
    } else {
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString* strDate = [formatter stringFromDate:date];
        signedDates = [NSMutableArray arrayWithContentsOfFile:filePath];
        NSString* userSignedMessage = [strDate stringByAppendingFormat:@":%@", CurrentUserBaseId];
        for (NSString* signedMsg in signedDates) {
            if ([signedMsg isEqualToString:userSignedMessage]) {
                return YES;
            }
        }
        
    }
    
    
    return NO;
}

/**
 *  结构：NSArray -> NSString: yyyy-MM-dd:userBaseId
 */
- (void)saveSignInFlag
{
    NSString* filePath = [USER_DATA_PATH stringByAppendingPathComponent:kLocalSignInMessageFileName];
    
    NSMutableArray* signedDates = [NSMutableArray array];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* strDate = [formatter stringFromDate:[NSDate date]];
    
    NSString* signMsg = [strDate stringByAppendingFormat:@":%@", CurrentUserBaseId];
    
    [signedDates addObject:signMsg];
    
    [signedDates writeToFile:filePath atomically:YES];
    
    
}

#pragma mark - 烤箱通知定义

/**
 *  发送本地通知
 *
 *  @param localNotification 本地通知
 */
- (void)sendLocalNotification:(LocalNotificationType)type fireTime:(NSTimeInterval)seconds alertBody:(NSString*)alertBody
{
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate =  [[NSDate date] dateByAddingTimeInterval:seconds]; //[NSDate dateWithTimeIntervalSinceNow:seconds];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = @"alertAction";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.userInfo = @{@"name": @"sansang", @"age": @99}; //給将来的此程序传参
    
    switch (type) {
        case LocalNotificationTypeWarmUp:
        {
            if (self.warmUpNotification != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:self.warmUpNotification];
            }
            self.warmUpNotification = localNotification;
            break;
        }
        case LocalNotificationTypeBakeComplete:
        {
            if (self.bakeCompleteNotification != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:self.bakeCompleteNotification];
            }
            self.bakeCompleteNotification = localNotification;
            break;
        }
        case LocalNotificationTypeClockTimeUp:
        {
            if (self.clockTimeUpNotification != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:self.clockTimeUpNotification];
            }
            self.clockTimeUpNotification = localNotification;
            break;
        }
        default:
            break;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}


#pragma mark - 缓存文件 读取缓存文件

- (void)saveSearchedKeyword:(NSString*)keyword
{
    NSString* filePath = [USER_DATA_PATH stringByAppendingPathComponent:kLocalSearchedKeywordsFileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableArray* keywords = [NSMutableArray array];
    if (![fileManager fileExistsAtPath:filePath]) {
        [keywords addObject:keyword];
        
    } else {
        //只保存10个关键词 不保存已有关键词
        keywords = [NSMutableArray arrayWithContentsOfFile:filePath];
        for (NSString* existKeyword in keywords) {
            if ([existKeyword isEqualToString:keyword]) {
                return;
            }
        }
        if (keywords.count > 10) {
            [keywords removeLastObject];
        }
        [keywords insertObject:keyword atIndex:0];
    }
    
    
    [keywords writeToFile:filePath atomically:YES];
    
}

- (NSMutableArray*)getSearchedKeywords
{
    NSMutableArray* keywords = [NSMutableArray array];
    
    NSString* filePath = [USER_DATA_PATH stringByAppendingPathComponent:kLocalSearchedKeywordsFileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        keywords = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    return keywords;
}

- (void)saveUserInfoWithObject:(id)jsonObj
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalUserInfoFileName];
    [data writeToFile:filePath atomically:YES];
}

- (id)getUserInfoObject
{
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalUserInfoFileName];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonObj;
}

- (void)saveTagsWithObject:(id)jsonObj
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalTagsFileName];
    [data writeToFile:filePath atomically:YES];
    
}

- (id)getTagsObject
{
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalTagsFileName];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonObj;
}

- (void)saveCookbooksWithObject:(id)jsonObj
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalCookbooksFileName];
    [data writeToFile:filePath atomically:YES];
}

- (id)getCookbooksObject
{
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalCookbooksFileName];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonObj;
}

- (void)addOvenInfoToLocal:(LocalOven*)oven
{
    NSMutableArray* ovens = self.myOvens;
    NSMutableArray* ovenArr = [NSMutableArray array]; //重新构建数组保存对象
    LocalOven* theOven;
    for (LocalOven* localOven in ovens) {
        if ([localOven.mac isEqualToString:oven.mac]) {
            theOven = localOven;
        } else {
            [ovenArr addObject:localOven];
        }
    }
    if (theOven != nil) { //如果本地已保存了此台设备，则删除后重新保存
        [ovens removeObject:theOven];
    }
    NSDictionary* ovenDict = [oven toDictionary];
    [ovenArr addObject:ovenDict];
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalOvensFileName];
    [ovenArr writeToFile:filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MyOvensInfoHadChangedNotificatin object:nil];
}

/**
 *  删除已绑定的设备
 *
 *  @param oven 本地烤箱信息
 */
- (void)removeOvenInLocal:(LocalOven*)oven
{
    NSMutableArray* ovens = self.myOvens;
    LocalOven* theOven;
    for (LocalOven* localOven in ovens) {
        if ([localOven.mac isEqualToString:oven.mac]) {
            theOven = localOven;
        }
    }
    if (theOven != nil) { //如果本地已保存了此台设备，则删除后重新保存
        [ovens removeObject:theOven];
    }
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalOvensFileName];
    [ovens writeToFile:filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MyOvensInfoHadChangedNotificatin object:nil];
}

/**
 *  更新本地烤箱信息
 *
 *  @param oven 本地烤箱对象
 */
- (void)updateOvenInLocal:(LocalOven*)oven
{
    NSMutableArray* ovens = self.myOvens;
    NSMutableArray* ovenArr = [NSMutableArray array]; //重新构建数组保存对象
    LocalOven* theOven;
    for (LocalOven* localOven in ovens) {
        if ([localOven.mac isEqualToString:oven.mac]) {
            theOven = localOven;
        } else {
            [ovenArr addObject:localOven];
        }
    }
    if (theOven != nil) { //如果本地已保存了此台设备，则删除后重新保存
        [ovens removeObject:theOven];
    }
    NSDictionary* ovenDict = [oven toDictionary];
    [ovenArr addObject:ovenDict];
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalOvensFileName];
    [ovenArr writeToFile:filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MyOvensInfoHadChangedNotificatin object:nil];
}


#pragma mark - setters

//- (void)setCurrentUser:(User *)currentUser
//{
//    _currentUser = currentUser;
////    NSLog(@"保存用户的信息：\n用户名：%@\n是否登录：%d\ncookieValue:%@\n", currentUser.userName, currentUser.hadLogin, currentUser.cookieValue);
//    NSLog(@"---------");
//    [[NSUserDefaults standardUserDefaults] setValue:currentUser.userName forKey:kCurrentLoginUserName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    // 对象->NSData
//    
//    // 1. 准备Data
//    NSMutableData * data = [NSMutableData data];
//    // 2. 准备工具
//    NSKeyedArchiver* keyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    // 3. encode
//    [keyedArchiver encodeObject:currentUser forKey:@"currentUser"];
//    // 4. 结束encode
//    [keyedArchiver finishEncoding];
//    
//    // 保存Data到Keychain
//    UICKeyChainStore* keyChainStore = [UICKeyChainStore keyChainStoreWithService:self.serviceForUser];
//    [keyChainStore setData:data forKey:@"currentUserData"];
//    [keyChainStore synchronize];
//}

#pragma mark - getters

//- (User *)currentUser
//{
//    // NSData -> 对象
//    
//    // 1. 准备Data
//    UICKeyChainStore* keyChainStore = [UICKeyChainStore keyChainStoreWithService:self.serviceForUser];
//    NSMutableData* data = [[keyChainStore dataForKey:@"currentUserData"] mutableCopy];
//    // 2. 准备工具
//    NSKeyedUnarchiver* keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    // 3. decode
//    _currentUser = [keyedUnarchiver decodeObjectForKey:@"currentUser"];
//    // 4. 结束decode
//    [keyedUnarchiver finishDecoding];
//    
//    if (data.bytes<=0) {
//        NSLog(@"本地没有存储用户信息，创建一个空的User对象返回");
//        _currentUser = [[User alloc] init];
//    }
//    
//    return _currentUser;
//}

- (NSMutableArray *)myOvens
{
    _myOvens = [NSMutableArray array];
    NSMutableArray* array;
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalOvensFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        array = [NSMutableArray arrayWithContentsOfFile:filePath];
    } else {
        array = [NSMutableArray array];
    }
    if (array.count != 0) {
        for (NSDictionary* ovenDict in array) {
            [_myOvens addObject:[LocalOven localOvenWithDictionary:ovenDict]];
        }
    }
    
    return _myOvens;
}

- (NSString *)currentUserBaseId
{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString* userId = IsLogin ? [[NSUserDefaults standardUserDefaults] valueForKey:@"userBaseId"] : @"0";
    return userId;
}


#pragma mark - 设备操作的通知

/**
 *  添加到本地通知列表
 *
 *  @param info 结构：@{@“time”:@"2015-01-29 12:09", @"desc":@"设备“xx”已开机"}
 */
- (void)addOvenNotification:(NSDictionary*)info
{
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalOvenInfosFileName];
    NSMutableArray* notifications = [NSMutableArray array];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        notifications = [NSMutableArray arrayWithContentsOfFile:filePath];
        if (notifications.count > 30) {
            [notifications removeLastObject];
        }
    }
    
    [notifications insertObject:info atIndex:0];
    
    [notifications writeToFile:filePath atomically:YES];
}

/**
 *  获取设备通知
 *
 *  @return 通知
 */
- (NSMutableArray*)loadOvenNotifications
{
    NSMutableArray* notifications = [NSMutableArray array];
    
    NSString* filePath = [[self getUserDataPath] stringByAppendingPathComponent:kLocalOvenInfosFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        notifications = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    return notifications;
}


@end
