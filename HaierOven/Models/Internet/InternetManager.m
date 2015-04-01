//
//  InternetManager.m
//  追爱行动
//
//  Created by 刘康 on 14-10-3.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "InternetManager.h"
#import "Reachability.h"
#import "DataCenter.h"
#import "DataParser.h"


@interface InternetManager ()

@property (strong, nonatomic) Reachability* hostReach;

@property (nonatomic) BOOL canConnectToInternetFlag;

@property (strong, nonatomic) NSOperationQueue* myQueue;

@property (copy, nonatomic) NSString* normalParams;



@end

@implementation InternetManager

#pragma mark - 实例化

+ (InternetManager*)sharedManager
{
    static InternetManager* _sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[InternetManager alloc] init];
    });
    return _sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        self.myQueue = [[NSOperationQueue alloc] init];
        
//        [self setCookies];
        
        /**
         *  监控网络状态通知
         *
         *  @param reachabilityChanged: 网络状态改变时调用方法
         *
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        _hostReach = [Reachability reachabilityForInternetConnection];
        [_hostReach startNotifier];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getters

- (NSString *)normalParams
{
    if (!_normalParams) {
        _normalParams = [NSString stringWithFormat:@"type=%d", 3];
    }
    return _normalParams;
}

#pragma mark - 监控网络状态

/*!
 * 检测网络状态的改变
 */
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        NSLog(@"无法连接到网络");
        self.canConnectToInternetFlag = NO;
        self.isWiFiConnected = NO;
    } else {
        NSLog(@"网络已连接");
        self.canConnectToInternetFlag = YES;
        
        if (status == ReachableViaWiFi) {
            self.isWiFiConnected = YES;
        } else {
            self.isWiFiConnected = NO;
        }
        
    }
    
}

- (BOOL)canConnectInternet{
    BOOL canConnectWebsite = NO;
    for (int loop = 0; loop < 4; loop++) {
        
        if (self.canConnectToInternetFlag) {
            canConnectWebsite = YES;
            break;
        }
        
        Reachability *r = [Reachability reachabilityForInternetConnection];
        switch ([r currentReachabilityStatus]) {
            case NotReachable:
                // 没有网络连接
                NSLog(@"无法连接到网络");
                self.isWiFiConnected = NO;
                break;
            case ReachableViaWWAN:
                // 使用3G网络
                NSLog(@"3G网络连接到网络");
                self.isWiFiConnected = NO;
                canConnectWebsite = YES;
                break;
            case ReachableViaWiFi:
                // 使用WiFi网络
                NSLog(@"WiFi连接到网络");
                self.isWiFiConnected = YES;
                canConnectWebsite = YES;
                break;
        }
        
        if (canConnectWebsite) {
            canConnectWebsite = YES;
            break;
        } else {
            [NSThread sleepForTimeInterval:0.1];
        }
        
    }
    
    return canConnectWebsite;
}

/**
 *  构建错误信息
 *
 *  @param errorCode 错误代码
 *
 *  @return NSError对象
 */
- (NSError*)errorWithCode:(InternetErrorCode)errorCode andDescription:(NSString*)errorMsg
{
    if (errorMsg == nil) {
        errorMsg = [NSString stringWithFormat:@"Request error with code: %d", errorCode];
    }
    if (errorCode == InternetErrorCodeConnectInternetFailed) {
        errorMsg = @"无法连接到网络";
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorMsg};
    NSError *error = [NSError errorWithDomain:ErrorDomain code:errorCode userInfo:userInfo];
    return error;
}

#pragma mark - AFN构建网络请求类

- (AFHTTPRequestOperationManager*)manager
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    // 这里配置Header信息和accessToken等
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"appId"];
    [manager.requestSerializer setValue:AppKey forHTTPHeaderField:@"appKey"];
    [manager.requestSerializer setValue:AppVersion forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:[DataCenter sharedInstance].clientId forHTTPHeaderField:@"clientId"];
    
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    if (accessToken != nil) {
        [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
//    [NSSet setWithObject:@"application/json"];
    
    return manager;
}

#pragma mark - 获取网络数据

#pragma mark - 登录和注册

- (void)registerWithEmail:(NSString*)email andPhone:(NSString*)phone andPassword:(NSString*)password callBack:(myCallback)completion
{
    // 1. 检查参数是否合法
    if (email.length == 0 && phone.length == 0) {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"手机号或邮箱不能为空"]);
        return;
    }
    if (email != nil) {
        if (![MyTool validateEmail:email]) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"请输入合法的邮箱"]);
            return;
        }
    }
    if (phone != nil) {
        if (![MyTool validateTelephone:phone]) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"请输入合法的手机号"]);
            return;
        }
    }
    NSString *regex = @"^[0-9a-zA-Z._!]{1}([a-zA-Z0-9]|[._!-@?]){5,16}$"; //只能输入5-20个以字母数字开头、可带数字、“_”、“.”、“!”、“@”、“?”的字串，长度为5-16
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:password]) {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"密码不合法，请输入5-16位数字和字母"]);
        return;
    }
    
    // 2. 将密码进行MD5加密
//    NSString* md5Password = [MyTool stringToMD5:password];
    
    // 3. 序列化为字典
    
    NSDictionary* userDict;
    if (email == nil) {
        userDict = @{@"password":password,
//                     @"sequenceId" : @"1234",
                     @"user":@{
                             @"userBase":@{
                                     @"mobile":phone == nil ? @"" : phone,
                                     @"accType":@0
                                     },
                             @"userProfile":@{
                                     
                                     }
                             }
                     };
    } else {
        userDict = @{@"password":password,
//                     @"sequenceId" : @"1234",
                     @"user":@{
                             @"userBase":@{
                                     @"email":email == nil ? @"" : email,
                                     @"accType":@0
                                     },
                             @"userProfile":@{
                                     
                                     }
                             }
                     };
    }
    
    
    // 4. 发送网络请求
    if ([self canConnectInternet]) {

        [[self manager] POST:UserRegister parameters:userDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                // 3. 保存登录信息
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:password forKey:@"password"];
                [userDefaults synchronize];
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];

    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}


- (void)activateUserWithLoginName:(NSString*)loginName
                  andValidateType:(ValidateType)validateType
                 andValidateScene:(ValidateScene)scene
                       andAccType:(AccType)accType
                 andTransactionId:(NSString*)transactionId
                           andUvc:(NSString*)uvc
                         callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* validateTp = [NSNumber numberWithInteger:validateType];
        NSNumber* validateScene = [NSNumber numberWithInteger:scene];
        NSNumber* acctp = [NSNumber numberWithInteger:accType];
        
        NSDictionary* paramsDict = @{
                                    @"loginName" : loginName,
                                    @"validateType" : validateTp,
                                    @"validateScene" : validateScene,
                                    @"accType" : acctp,
                                    @"transactionId" : transactionId,
//                                    @"uvc" : uvc
                                    };
        
        // 2. 发送网络请求 拼接字符串

        NSString* path = [[GetVerifyCode stringByAppendingPathComponent:uvc] stringByAppendingPathComponent:@"verify"];
        [[self manager] POST:path parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
            NSLog(@"%@", responseObject[@"retInfo"]);
            
            if ([status isEqualToString:@"00000"]) {
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
    
}

- (void)loginWithSequenceId:(NSString*)sequenceId
                 andAccType:(AccType)accType
                 andloginId:(NSString*)loginId
                andPassword:(NSString*)password
         andThirdpartyAppId:(NSString*)thirdPartyAppId
   andThirdpartyAccessToken:(NSString*)thirdPartyAccessToken
               andLoginType:(LoginType)loginType
                   callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
//        NSString* md5Password = [MyTool stringToMD5:password];
        
        // 1. 将参数序列化
        NSNumber* acctp = [NSNumber numberWithInteger:accType];
        NSNumber* logintp = [NSNumber numberWithInteger:loginType];
        NSDictionary* paramsDict = @{
                                     @"sequenceId" : sequenceId,
                                     @"accType": acctp,
                                     @"loginId" : loginId,
                                     @"password" : password,
                                     @"thirdpartyAppId" : thirdPartyAppId == nil ? [NSNull null] : thirdPartyAppId ,
                                     @"thirdpartyAccessToken" : thirdPartyAccessToken == nil ? [NSNull null] : thirdPartyAccessToken,
                                     @"loginType" : logintp
                                    };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        NSLog(@"login info:%@", paramsDict);
        [[self manager] POST:UserLogin parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            NSLog(@"%@", responseObject[@"err"]);
            
            if ([status isEqualToString:@"1"]) {
                // 3. 保存登录信息
                
                NSDictionary* dataDict = responseObject[@"data"];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                NSString* baseId = [NSString stringWithFormat:@"%@", dataDict[@"userBaseID"]];
                [userDefaults setObject:baseId forKey:@"userBaseId"];
                
                NSString* accToken = [NSString stringWithFormat:@"%@", dataDict[@"accessToken"]];
                [userDefaults setObject:accToken forKey:@"accessToken"];
                
                [userDefaults setObject:loginId forKey:@"loginId"];
                [userDefaults setObject:password forKey:@"password"];
                
                [userDefaults setBool:YES forKey:@"isLogin"];
                
                // 是不是手机号登录
                [userDefaults setBool:[MyTool validateTelephone:loginId] forKey:@"phoneLogin"];

                [userDefaults synchronize];
                completion(YES, responseObject, nil);
                
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                
                // 统计用户使用时长
                [uAnalysisManager onUserLogin:loginId];
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)loginWithSequenceId:(NSString*)sequenceId
                 andAccType:(AccType)accType
                 andloginId:(NSString*)loginId
                andPassword:(NSString*)password
         andThirdpartyAppId:(NSString*)thirdPartyAppId
   andThirdpartyAccessToken:(NSString*)thirdPartyAccessToken
               andLoginType:(LoginType)loginType
                   nickName:(NSString*)nickName
                 userAvatar:(NSString*)userAvatar
                   callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        //        NSString* md5Password = [MyTool stringToMD5:password];
        
        // 1. 将参数序列化
        NSNumber* acctp = [NSNumber numberWithInteger:accType];
        NSNumber* logintp = [NSNumber numberWithInteger:loginType];
        NSDictionary* paramsDict = @{
                                     @"sequenceId" : sequenceId,
                                     @"accType": acctp,
                                     @"loginId" : loginId,
                                     @"password" : password,
                                     @"thirdpartyAppId" : thirdPartyAppId == nil ? [NSNull null] : thirdPartyAppId ,
                                     @"thirdpartyAccessToken" : thirdPartyAccessToken == nil ? [NSNull null] : thirdPartyAccessToken,
                                     @"loginType" : logintp,
                                     @"nickName" : nickName,
                                     @"userAvatar" : userAvatar
                                     };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        NSLog(@"login info:%@", paramsDict);
        [[self manager] POST:UserLogin parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            NSLog(@"%@", responseObject[@"err"]);
            
            if ([status isEqualToString:@"1"]) {
                // 3. 保存登录信息
                
                NSDictionary* dataDict = responseObject[@"data"];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                NSString* baseId = [NSString stringWithFormat:@"%@", dataDict[@"userBaseID"]];
                [userDefaults setObject:baseId forKey:@"userBaseId"];
                
                NSString* accToken = [NSString stringWithFormat:@"%@", dataDict[@"accessToken"]];
                [userDefaults setObject:accToken forKey:@"accessToken"];
                
                [userDefaults setObject:loginId forKey:@"loginId"];
                [userDefaults setObject:password forKey:@"password"];
                
                [userDefaults setBool:YES forKey:@"isLogin"];
                
                // 是不是手机号登录
                [userDefaults setBool:[MyTool validateTelephone:loginId] forKey:@"phoneLogin"];
                
                [userDefaults synchronize];
                completion(YES, responseObject, nil);
                
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccussNotification object:nil];
                
                // 统计用户使用时长
                [uAnalysisManager onUserLogin:loginId];
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getVerCodeWithLoginName:(NSString*)loginName
                andValidateType:(ValidateType)validateType
               andValidateScene:(ValidateScene)scene
                     andAccType:(AccType)accType
                       callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* validateTp = [NSNumber numberWithInteger:validateType];
        NSNumber* validateScene = [NSNumber numberWithInteger:scene];
        NSNumber* acctp = [NSNumber numberWithInteger:accType];
        NSDictionary* paramsDict = @{
                                     @"loginName" : loginName,
                                     @"validateType" : validateTp,
                                     @"validateScene" : validateScene,
                                     @"accType" : acctp,
                                     @"sendTo" : loginName      //loginName是手机号
                                     };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        [[self manager] POST:GetVerifyCode parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
            
            if ([status isEqualToString:@"00000"]) {
                
                // 3. 保存登录信息
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)completeThirdPartyWithPassword:(NSString*)password phone:(NSString*)phone email:(NSString*)email userName:(NSString*)userName nickName:(NSString*)nickName callBack:(myCallback)completion
{
//    {"userBaseID":25,"passWord":"","email":"cjsyclt@163.com","mobile":"13621640580","userProfile":{"nickName":"cjsyclt","userName":"litao"}}
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : CurrentUserBaseId,
                                     @"password" : password,
                                     @"email" : email,
                                     @"mobile" : phone,
                                     @"userProfile" :
                                        @{
                                             @"nickName" : nickName,
                                             @"userName" : userName
                                         }
                                     };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        [[self manager] POST:GetVerifyCode parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)logoutWithLoginName:(NSString*)loginName callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化

        NSDictionary* paramsDict = @{
                                     @"loginName" : loginName
                                    };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        [[self manager] POST:UserLogout parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

#pragma mark - 个人信息

- (void)getUserInfoWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId
                                    };
        
        // 2. 发送网络请求
        
        [[self manager] POST:GetUserInfo parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                // 3. 将个人信息缓存本地
                [[DataCenter sharedInstance] saveUserInfoWithObject:responseObject];
                
                // 4. 解析Json字典
                id user = [DataParser parseUserWithDict:responseObject];
                [DataCenter sharedInstance].currentUser = user;
                completion(YES, user, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        // 如果没有网络，从本地缓存读取用户信息
        id userDict = [[DataCenter sharedInstance] getUserInfoObject];
        id user = [DataParser parseUserWithDict:userDict];
        [DataCenter sharedInstance].currentUser = user;
        completion(YES, user, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)updateEmailUserBaseId:(NSString*)userBaseId andEmail:(NSString*)email callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     @"email" : email    //新邮箱地址
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:UpdateEmail parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)updatePhoneUserBaseId:(NSString*)userBaseId andPhone:(NSString*)phone callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     @"mobile" : phone    //新邮箱地址
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:UpdatePhone parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)updateUserInfo:(User*)user callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
//        nickName：昵称
//        userName：真实姓名
//        sex：性别
//        birthday：生日
//        note简介
//        userAvatar：头像
//        其他全部输入null
        NSNull* null = [NSNull null];
        NSDictionary* paramsDict = @{@"userBaseID" : user.userBaseId,
                                     @"userID" : user.userId,
                                     @"userType" :null,
                                     @"loginName":null,
                                     @"passWord":null,
                                     @"email":null,
                                     @"mobile":null,
                                     @"accType":null,
                                     @"status":null,
                                     @"isDeleted":null,
                                     @"userProfile":@{
                                         @"id":null,
                                         @"userBaseID":null,
                                         @"nickName":user.nickName,
                                         @"userName":user.userName,
                                         @"sex":user.sex,
                                         @"birthday":user.birthday,
                                         @"address":user.address,
                                         @"accessToken":null,
                                         @"note":user.note,
                                         @"maritalStatus":null,
                                         @"occupation":null,
                                         @"monthlyIncome" : null,
                                         @"userAvatar":user.userAvatar,
                                         @"focusCount":null,
                                         @"followCount":null,
                                         @"points":null
                                         },
                                     @"userAttribute":null,
                                     @"marvellouschefInfo":null
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:UpdateUserInfo parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)checkSignInWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:CheckSignIn parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
    
}


- (void)signInWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:SignIn parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)addPoints:(NSInteger)score userBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     @"points" : [NSNumber numberWithInteger:score]
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:AddPoints parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)bindOvenWithUserBaseId:(NSString*)userBaseId deviceMac:(NSString*)mac callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     @"deviceMac" : mac
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:BindDevice parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)addFollowWithUserBaseId:(NSString*)userBaseId andFollowedUserBaseId:(NSString*)followdUserBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     @"followedUserBaseID" : followdUserBaseId    //关注用户ID
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:FollowAdd parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)deleteFollowWithUserBaseId:(NSString*)userBaseId andFollowedUserBaseId:(NSString*)followdUserBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,         //用户ID
                                     @"followedUserBaseID" : followdUserBaseId    //关注用户ID
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:FollowDelete parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)getFollowersWithUserBaseId:(NSString*)userBaseId andPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     @"userBaseID" : userBaseId //用户Id
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetFollows parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* follows = [DataParser parseUsersWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, follows, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)getFansWithUserBaseId:(NSString*)userBaseId andPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     @"userBaseID" : userBaseId //用户Id
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetFans parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* follows = [DataParser parseUsersWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, follows, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)searchUsersWithKeyword:(NSString*)keyword pageIndex:(NSInteger)pageIndex userBaseId:(NSString*)userId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     @"userBaseID" : userId, //用户Id
                                     @"key" : keyword
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:SearchUsers parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* follows = [DataParser parseUsersWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, follows, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)currentUser:(NSString*)currentUserId followedUser:(NSString*)userBaseId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : currentUserId,
                                     @"followedUserBaseID" : userBaseId == nil ? @"0" : userBaseId
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:CheckFollowed parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }

    
}


#pragma mark - 标签

/**
 *  获取所有标签
 *
 *  @param completion 结果回调
 */
- (void)getTagsCallBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 发送请求
        
        [[self manager] GET:GetTags parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 2. 缓存本地
                [[DataCenter sharedInstance] saveTagsWithObject:responseObject];
                
                // 3. 解析json字典
                NSMutableArray* tags = [DataParser parseTagsWithDict:responseObject];
                completion(YES, tags, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
                
                
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:nil]);
        }];
        
    } else {
        // 如果没有网络，从本地缓存读取用户信息
        id tagsDict = [[DataCenter sharedInstance] getTagsObject];
        NSMutableArray* tags = [DataParser parseTagsWithDict:tagsDict];
        completion(YES, tags, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getHotTagsCallback:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 发送请求
        
        [[self manager] GET:GetHotTags parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 2. 缓存本地
//                [[DataCenter sharedInstance] saveTagsWithObject:responseObject];
                
                // 3. 解析json字典
                NSMutableArray* tags = [DataParser parseTagsWithDict:responseObject];
                completion(YES, tags, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:nil]);
        }];
        
    } else {
        // 如果没有网络，从本地缓存读取用户信息
//        id tagsDict = [[DataCenter sharedInstance] getTagsObject];
//        NSMutableArray* tags = [DataParser parseTagsWithDict:tagsDict];
//        completion(YES, tags, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)getUserTagsWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId //用户Id
                                    };
        // 1. 发送请求
        
        [[self manager] POST:GetMyTags parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 2. 缓存本地
//                [[DataCenter sharedInstance] saveTagsWithObject:responseObject];
                
                // 3. 解析json字典
                NSMutableArray* tags = [DataParser parseTagsWithDict:responseObject];
                completion(YES, tags, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:nil]);
        }];
        
    } else {
        // 如果没有网络，从本地缓存读取用户信息
        //        id tagsDict = [[DataCenter sharedInstance] getTagsObject];
        //        NSMutableArray* tags = [DataParser parseTagsWithDict:tagsDict];
        //        completion(YES, tags, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

#pragma mark - 添加菜谱评论

- (void)addCommentWithCookbookId:(NSString*)cookbookId andUserBaseId:(NSString*)userBaseId andComment:(NSString*)content parentId:(NSString *)parentId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : [NSNumber numberWithInt:[cookbookId intValue]],
                                     @"comment" : content,
                                     @"userBaseID" : userBaseId,
                                     @"parentID" : parentId == nil ? [NSNull null] : [NSNumber numberWithInt:[parentId intValue]]    //如果是回复某评论，则此字段为被回复的评论主键
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:AddCommentToCookBook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getCommentsWithCookbookId:(NSString*)cookbookId andPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     @"cookbookID" : cookbookId //菜谱Id
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetCookbookComments parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* comments = [DataParser parseCommentsWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, comments, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}



#pragma mark - 菜谱

- (void)getAllCookbooksWithPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
//                                     @"containsTotalCount" : @YES //是否包含总页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetAllCookbooks parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 缓存本地
                [[DataCenter sharedInstance] saveCookbooksWithObject:responseObject];
                
                // 4. 结果回调
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        id cookbooksDict = [[DataCenter sharedInstance] getCookbooksObject];
        BOOL hadNextPage;
        NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:cookbooksDict hadNextPage:&hadNextPage];
        completion(YES, cookbooks, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
    
}


- (void)getCookbooksWithUserBaseId:(NSString*)userBaseId cookbookStatus:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,     //UsrId
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     @"status" : [NSNumber numberWithInteger:status] //菜谱状态：-1所有菜谱
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetCookbooksByUserId parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)getFriendCookbooksWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,     //UsrId
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:GetFriendCookbooks parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getMyPraisedCookbooksWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,     //UsrId
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetPraisedCookbooks parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getCookbooksWithTagIds:(NSArray*)tagIds pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"tagIDs" : tagIds,     //UsrId
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetCookbooksByTagIds parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)getCookbooksWithTagIds:(NSArray*)tagIds userBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"tagIDs" : tagIds,     //UsrId
                                     @"userBaseID" : userBaseId,
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetCookbooksByTagIds parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)searchCookbooksWithKeyword:(NSString*)keyword pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"key" : keyword,     //关键字
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
//                                     @"containsTotalCount" : @YES //是否包含总页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:SearchCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookbooks = [DataParser parseCookbooksWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookbooks, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
    
}

- (void)getCookbookDetailWithCookbookId:(NSString*)cookbookId userBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : cookbookId,     //关键字
                                     @"userBaseID" : userBaseId
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:GetCookbookDetail parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                id cookbookDetail = [DataParser parseCookbookDetailWithDict:responseObject];
                
                completion(YES, cookbookDetail, nil);

            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}

- (void)addCookbookWithCookbook:(CookbookDetail*)cookbookDetail callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSMutableArray* tags = [NSMutableArray array];
        for (Tag* tag in cookbookDetail.tags) {
            NSMutableDictionary* tagDict = [NSMutableDictionary dictionary];
            tagDict[@"tagID"] = [NSNumber numberWithInt:[tag.ID intValue]];
            [tags addObject:tagDict];
        }
        NSMutableArray* steps = [NSMutableArray array];
        for (Step* step in cookbookDetail.steps) {
            NSMutableDictionary* stepDict = [NSMutableDictionary dictionary];
            stepDict[@"stepPhoto"] = step.photo;
            stepDict[@"stepDesc"] = step.desc;
            stepDict[@"stepIndex"] = [NSNumber numberWithInt: [step.index intValue]];
            [steps addObject:stepDict];
        }
        NSMutableArray* foods = [NSMutableArray array];
        for (Food* food in cookbookDetail.foods) {
            NSMutableDictionary* foodDict = [NSMutableDictionary dictionary];
            foodDict[@"foodName"] = food.name;
            foodDict[@"foodDesc"] = food.desc;
            foodDict[@"cookbookFoodIndex"] = [NSNumber numberWithInt:[food.index intValue]];
            [foods addObject:foodDict];
        }
//        NSMutableDictionary* creatorDict = [NSMutableDictionary dictionary];
//        creatorDict[@"creatorID"] = cookbookDetail.creator.ID;
//        creatorDict[@"userName"] = cookbookDetail.creator.userName;
//        creatorDict[@"userAvatar"] = cookbookDetail.creator.avatarPath;
        
        if (cookbookDetail.desc == nil || [cookbookDetail.desc isEqualToString:@""]) {
            cookbookDetail.desc = @" ";
        }
        
        NSDictionary* paramsDict;
        NSMutableDictionary* cookbookOvenDict;
        if (cookbookDetail.oven != nil) {
            cookbookOvenDict = [NSMutableDictionary dictionary];
            cookbookOvenDict[@"roastStyle"] = cookbookDetail.oven.roastStyle == nil ? @"" : cookbookDetail.oven.roastStyle;
            cookbookOvenDict[@"roastTemperature"] = cookbookDetail.oven.roastTemperature == nil ? @"" : cookbookDetail.oven.roastTemperature;
            cookbookOvenDict[@"roastTime"] = cookbookDetail.oven.roastTime == nil ? @0 : [NSNumber numberWithInt:[cookbookDetail.oven.roastTime intValue]];
            cookbookOvenDict[@"oveninfo"] = cookbookDetail.oven.ovenInfo == nil ? @{@"name" : @""} : cookbookDetail.oven.ovenInfo;
            cookbookOvenDict[@"ovenType"] = cookbookDetail.oven.ovenType == nil ? @"" : cookbookDetail.oven.ovenType;
        }
        
            paramsDict = @{@"cookbookName" : cookbookDetail.name,
                           @"cookbookDesc" : cookbookDetail.desc,
                           @"cookbookCoverPhoto" : cookbookDetail.coverPhoto,
                           @"cookbookTip" : cookbookDetail.cookbookTip,
                           @"status" : [NSNumber numberWithInt:[cookbookDetail.status intValue]],
                           @"tags" : tags,
                           @"steps" : steps,
                           @"foods" : foods,
                           @"cookbookOven" : cookbookOvenDict == nil ? [NSNull null] : cookbookOvenDict,
                           @"creatorID" : [NSNumber numberWithInt:[cookbookDetail.creator.ID intValue]],
                           
                           };
        
        
//        } else {
//            
//            paramsDict = @{@"cookbookName" : cookbookDetail.name,
//                           @"cookbookDesc" : cookbookDetail.desc,
//                           @"cookbookCoverPhoto" : cookbookDetail.coverPhoto,
//                           @"cookbookTip" : cookbookDetail.cookbookTip,
//                           @"status" : [NSNumber numberWithInt:[cookbookDetail.status intValue]],
//                           @"tags" : tags,
//                           @"steps" : steps,
//                           @"foods" : foods,
//                           @"creatorID" : [NSNumber numberWithInt:[cookbookDetail.creator.ID intValue]],
//                           
//                           };
//            
//        }
        
        
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:paramsDict options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        
        // 2. 发送网络请求
        [[self manager] POST:AddCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            NSLog(@"err: %@", responseObject[@"err"]);
            if ([status isEqualToString:@"1"]) {
                // 3. 回调添加结果
                completion(YES, cookbookDetail, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}

- (void)modifyCookbook:(CookbookDetail*)cookbookDetail callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSMutableArray* tags = [NSMutableArray array];
        for (Tag* tag in cookbookDetail.tags) {
            NSMutableDictionary* tagDict = [NSMutableDictionary dictionary];
            tagDict[@"tagID"] = [NSNumber numberWithInt:[tag.ID intValue]];
            [tags addObject:tagDict];
        }
        NSMutableArray* steps = [NSMutableArray array];
        for (Step* step in cookbookDetail.steps) {
            NSMutableDictionary* stepDict = [NSMutableDictionary dictionary];
            stepDict[@"stepPhoto"] = step.photo;
            stepDict[@"stepDesc"] = step.desc;
            stepDict[@"stepIndex"] = [NSNumber numberWithInt: [step.index intValue]];
            [steps addObject:stepDict];
        }
        NSMutableArray* foods = [NSMutableArray array];
        for (Food* food in cookbookDetail.foods) {
            NSMutableDictionary* foodDict = [NSMutableDictionary dictionary];
            foodDict[@"foodName"] = food.name;
            foodDict[@"foodDesc"] = food.desc;
            foodDict[@"cookbookFoodIndex"] = [NSNumber numberWithInt:[food.index intValue]];
            [foods addObject:foodDict];
        }
        //        NSMutableDictionary* creatorDict = [NSMutableDictionary dictionary];
        //        creatorDict[@"creatorID"] = cookbookDetail.creator.ID;
        //        creatorDict[@"userName"] = cookbookDetail.creator.userName;
        //        creatorDict[@"userAvatar"] = cookbookDetail.creator.avatarPath;
        
        if (cookbookDetail.desc == nil || [cookbookDetail.desc isEqualToString:@""]) {
            cookbookDetail.desc = @" ";
        }
        
        NSDictionary* paramsDict;
        NSMutableDictionary* cookbookOvenDict;
        if (cookbookDetail.oven != nil) {
            cookbookOvenDict = [NSMutableDictionary dictionary];
            cookbookOvenDict[@"roastStyle"] = cookbookDetail.oven.roastStyle;
            cookbookOvenDict[@"roastTemperature"] = cookbookDetail.oven.roastTemperature;
            cookbookOvenDict[@"roastTime"] = [NSNumber numberWithInt:[cookbookDetail.oven.roastTime intValue]];
            cookbookOvenDict[@"oveninfo"] = cookbookDetail.oven.ovenInfo == nil ? @{@"name" : @""} : cookbookDetail.oven.ovenInfo;
            cookbookOvenDict[@"ovenType"] = cookbookDetail.oven.ovenType == nil ? @"" : cookbookDetail.oven.ovenType;
        }
            paramsDict = @{@"cookbookName" : cookbookDetail.name,
                           @"cookbookDesc" : cookbookDetail.desc,
                           @"cookbookCoverPhoto" : cookbookDetail.coverPhoto,
                           @"cookbookTip" : cookbookDetail.cookbookTip,
                           @"status" : [NSNumber numberWithInt:[cookbookDetail.status intValue]],
                           @"tags" : tags.count == 0 ? [NSNull null] : tags,
                           @"steps" : steps == 0 ? [NSNull null] : steps,
                           @"foods" : foods == 0 ? [NSNull null] : foods,
                           @"cookbookOven" : cookbookOvenDict == nil ? [NSNull null] : cookbookOvenDict,
                           @"creatorID" : [NSNumber numberWithInt:[cookbookDetail.creator.ID intValue]],
                           @"cookbookID" : cookbookDetail.cookbookId
                           };
            
            
//        } else {
//            
//            paramsDict = @{@"cookbookName" : cookbookDetail.name,
//                           @"cookbookDesc" : cookbookDetail.desc,
//                           @"cookbookCoverPhoto" : cookbookDetail.coverPhoto,
//                           @"cookbookTip" : cookbookDetail.cookbookTip,
//                           @"status" : [NSNumber numberWithInt:[cookbookDetail.status intValue]],
//                           @"tags" : tags,
//                           @"steps" : steps,
//                           @"foods" : foods,
//                           @"creatorID" : [NSNumber numberWithInt:[cookbookDetail.creator.ID intValue]],
//                           @"cookbookID" : cookbookDetail.cookbookId
//                           };
//        
//        }
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:paramsDict options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        // 2. 发送网络请求
        [[self manager] POST:UpdateCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            NSLog(@"%@", responseObject[@"err"]);
            
            if ([status isEqualToString:@"1"]) {
                // 3. 回调添加结果
                completion(YES, cookbookDetail, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}

- (void)deleteCookbookWithCookbookId:(NSString*)cookbookId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : cookbookId,     //关键字
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:DeleteCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
}

- (void)praiseCookbookWithCookbookId:(NSString*)cookbookId userBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : cookbookId,     //关键字
                                     @"userBaseID" : userBaseId
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:PraiseCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
}

- (void)cancelPraiseCookbook:(NSString*)cookbookId userBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : cookbookId,     //关键字
                                     @"userBaseID" : userBaseId
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:CancelPraiseCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}



#pragma mark - 购物清单

- (void)saveShoppingOrderWithShoppingOrder:(ShoppingOrder*)shoppingOrder callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSMutableArray* foods =[NSMutableArray array];
        for (PurchaseFood* food in shoppingOrder.foods) {
            NSMutableDictionary* foodDict = [NSMutableDictionary dictionary];
            foodDict[@"foodIndex"] = [NSNumber numberWithInteger:[food.index integerValue]];
            foodDict[@"foodName"] = food.name;
            foodDict[@"foodDesc"] = food.desc;
            foodDict[@"isPurchase"] = [NSNumber numberWithBool:food.isPurchase];
            [foods addObject:foodDict];
        }
        
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : shoppingOrder.cookbookID,     //菜谱ID
                                     @"cookbookName" : shoppingOrder.cookbookName,
                                     @"creatorID" : [NSNumber numberWithInteger:[shoppingOrder.creatorId integerValue]],
                                     @"foods" : foods
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:SaveShoppingOrder parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}

- (void)deleteShoppingOrderWithUserBaseId:(NSString*)userBaseId cookbooks:(NSArray*)cookbooks callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSMutableArray* deleteCookbookIds = [NSMutableArray array];
        for (ShoppingOrder* shoppingOrder in cookbooks) {
            NSNumber* cookbookId = [NSNumber numberWithInt:[shoppingOrder.cookbookID intValue]];
            [deleteCookbookIds addObject:cookbookId];
        }
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : [NSNumber numberWithInteger:[userBaseId integerValue]],     //用户ID
                                     @"cookbookIDs" : deleteCookbookIds
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:DeleteShoppingOrder parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
    
}

- (void)getShoppingOrderWithUserBaseId:(NSString*)userBaseId cookbookId:(NSString*)cookbookId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,     //用户ID
                                     @"cookbookID" : cookbookId
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:GetShoppingOrder parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}


- (void)getShoppingListWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,     //用户ID
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetShoppingList parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                NSMutableArray* shoppingList = [DataParser parseShoppingListWithDict:responseObject];
                
                completion(YES, shoppingList, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}


#pragma mark - 烘焙圈

- (void)getRecommentCookersWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     //                                     @"containsTotalCount" : @YES //是否包含总页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetRecommentCookerList parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookers = [DataParser parseCookersWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookers, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}


#pragma mark - 烘焙屋

/**
 *  获取商品分页列表
 *
 *  @param category   0：所有；1：模具；2食材；3成品
 *  @param sortType   1:按时间；2按热度；
 *  @param pageIndex  请求页面
 *  @param keyword    产品名称模糊查找
 *  @param completion 结果回调
 */
- (void)getProductsWithCategory:(NSInteger)category sortType:(NSInteger)sortType pageIndex:(NSInteger)pageIndex keyword:(NSString*)keyword callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化

        NSDictionary* paramsDict = @{
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : [NSNumber numberWithInteger:pageIndex],
                                     @"category" : [NSNumber numberWithInteger:category],
                                     @"sortType" : [NSNumber numberWithInteger:sortType],
                                     @"keyword" :  keyword == nil ? @"" : keyword
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:GetProducts parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                NSMutableArray* equipments = [DataParser parseEquipmentsWithDict:responseObject];
                completion(YES, equipments, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}


#pragma mark - 厨神名人堂

- (void)getRecommendCookerStarsCallback:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化

        NSDictionary* paramsDict = @{
                                     @"userBaseID" : @0,
                                     @"limit" : @100,     //每页行数
                                     @"page" : @1,     //当前请求的页数
                                     //                                     @"containsTotalCount" : @YES //是否包含总页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetRecommendCooker parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookers = [DataParser parseCookerStarsWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookers, nil);
                [[DataCenter sharedInstance] saveRecommendCookersWithObject:responseObject];
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        
        id recommendDict = [[DataCenter sharedInstance] getRecommendCookersObject];
        BOOL hadNextPage;
        NSMutableArray* cookers = [DataParser parseCookerStarsWithDict:recommendDict hadNextPage:&hadNextPage];
        completion(YES, cookers, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
    
}


- (void)getCookerStarsWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
                                     //                                     @"containsTotalCount" : @YES //是否包含总页数
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetCookerStars parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                BOOL hadNextPage;
                NSMutableArray* cookers = [DataParser parseCookerStarsWithDict:responseObject hadNextPage:&hadNextPage];
                completion(YES, cookers, nil);
                if (!hadNextPage) {
                    NSLog(@"没有更多了");
                }
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

#pragma mark - 私信

- (void)sendMessage:(NSString*)message toUser:(NSString*)userBaseId fromUser:(NSString*)fromUser callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化

        NSDictionary* paramsDict = @{
                                     @"messageFrom" : @{
                                             @"userBaseID" : fromUser
                                             },
                                     @"messageTo" : @{
                                             @"userBaseID" : userBaseId
                                             },
                                     @"messageContent" : message
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:SendMessage parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
    
}

- (void)updateReadStatusWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:MessageHadRead parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getMessageCountWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:MessageCount parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}

- (void)getMessagesListWithUserBaseId:(NSString*)userBaseId status:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSNumber* messageStatus = [NSNumber numberWithInteger:status];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,
                                     @"read" : messageStatus
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:GetMessageList parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getChatMessagesFromUser:(NSString*)fromUser toUser:(NSString*)toUser status:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSNumber* messageStatus = [NSNumber numberWithInteger:status];
        NSDictionary* paramsDict = @{
                                     @"toUserBaseID" : toUser,
                                     @"fromUserBaseID" : fromUser,
                                     @"limit" : @2000,         //@PageLimit,     //每页行数
                                     @"page" : currentPage,
                                     @"read" : messageStatus
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetChatMessages parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                NSMutableArray* messages = [DataParser parseMessagesWithDict:responseObject];
                completion(YES, messages, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}


#pragma mark - 通知

- (void)updateNotificationReadStatusWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:NotificationHadRead parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}


- (void)getNotificationCountWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:NotificationCount parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }

    
}


- (void)getNotificationListWithUserBaseId:(NSString*)userBaseId status:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage    = [NSNumber numberWithInteger:pageIndex];
        NSNumber* messageStatus  = [NSNumber numberWithInteger:status];
        NSDictionary* paramsDict = @{
                                     @"userBaseID" : userBaseId,
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,
                                     @"read" : messageStatus
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:NotificationList parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                NSMutableArray* notificationList = [DataParser parseNotificationListWithDict:responseObject];
                completion(YES, notificationList, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}


#pragma mark - 设置

/**
 *  意见反馈
 *
 *  @param content    反馈内容
 *  @param phone      联系电话
 *  @param completion 结果回调
 */
- (void)feedbackWithContent:(NSString*)content phone:(NSString*)phone callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version            = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

        NSDictionary* paramsDict     = @{
                                     @"mobile" : phone,
                                     @"feedback" : content,     //每页行数
                                     @"osType" : @"iOS",
                                     @"appVersion" : version
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:Feedback parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 解析
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}

- (void)getAppStoreUrlCallback:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 发送请求
        
        [[self manager] GET:GetAppStorePath parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 2. 缓存本地
                
                // 3. 解析json字典
                NSDictionary* data = responseObject[@"data"];
                
                completion(YES, data[@"iosAPP"], nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:nil]);
        }];
        
    } else {
        // 如果没有网络，从本地缓存读取用户信息
        id tagsDict = [[DataCenter sharedInstance] getTagsObject];
        NSMutableArray* tags = [DataParser parseTagsWithDict:tagsDict];
        completion(YES, tags, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}






#pragma mark - 文件

- (void)uploadFile:(NSData*)data callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        NSString* imagePath = [[[DataCenter sharedInstance] getLibraryPath] stringByAppendingPathComponent:@"photo.jpg"];
        
        [data writeToFile:imagePath atomically:YES];
        
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [self manager].responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [[self manager] POST:UploadFile parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if ([formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"photo.jpg" error:nil]) {
                NSLog(@"%@", formData);
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"上传成功");
            completion(YES, responseObject, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"上传失败");
            completion(NO, nil, error);
            
        }];
    } else {
        
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
        
    }
}



#pragma mark - 测试API接口使用

- (void)testRegisterWithEmail:(NSString*)email andPhone:(NSString*)phone andPassword:(NSString*)password callBack:(myCallback)completion
{
    // 1. 检查参数是否合法
    if (email.length == 0 && phone.length == 0) {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"手机号或邮箱不能为空"]);
        return;
    }
    if (email != nil) {
        if (![MyTool validateEmail:email]) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"请输入合法的邮箱"]);
            return;
        }
    }
    if (phone != nil) {
        if (![MyTool validateTelephone:phone]) {
            completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"请输入合法的手机号"]);
            return;
        }
    }
    NSString *regex = @"^[0-9a-zA-Z._!]{1}([a-zA-Z0-9]|[._!-@?]){5,16}$"; //只能输入5-20个以字母数字开头、可带数字、“_”、“.”、“!”、“@”、“?”的字串，长度为5-16
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:password]) {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"密码不合法，请输入5-16位数字和字母"]);
        return;
    }
    
    // 2. 将密码进行MD5加密
//    NSString* md5Password = [MyTool stringToMD5:password];
    
    // 3. 序列化为字典
//    NSDictionary* userDict = @{@"password":password,
//                               @"sequenceId" : @"1234",
//                               @"user":@{
//                                       @"userBase":@{
////                                               @"loginName":null,
////                                               @"email":email == nil ? @"" : email,
//                                               @"mobile":phone == nil ? @"" : phone,
//                                               @"accType":@0
//                                               },
//                                       @"userProfile":@{
////                                               @"nickName":@"origheart",
////                                               @"userName":@"kenny",
////                                               @"points":@"0",
////                                               @"focusCount":@"0",
////                                               @"followCount":@"0"
//                                               }
//                                       }
//                               };
    
    NSDictionary* userDict;
    if (email == nil) {
        userDict = @{@"password":password,
                     @"sequenceId" : @"1234",
                     @"user":@{
                             @"userBase":@{
                                     @"mobile":phone == nil ? @"" : phone,
                                     @"accType":@0
                                     },
                             @"userProfile":@{
                                     
                                     }
                             }
                     };
    } else {
        userDict = @{@"password":password,
                     @"sequenceId" : @"1234",
                     @"user":@{
                             @"userBase":@{
                                     @"email":email == nil ? @"" : email,
                                     @"accType":@0
                                     },
                             @"userProfile":@{
                                     
                                     }
                             }
                     };
    }
    
    // 4. 发送网络请求
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    // 这里配置Header信息和accessToken等
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"appId"];
    [manager.requestSerializer setValue:AppKey forHTTPHeaderField:@"appKey"];
    [manager.requestSerializer setValue:AppVersion forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:[DataCenter sharedInstance].clientId forHTTPHeaderField:@"clientId"];
    manager.requestSerializer.timeoutInterval = 120;
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    if (accessToken != nil) {
        [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
    }
    [manager.requestSerializer setValue:@"TGT3CVCJEYK9WJRB2Q5DNZFGOK9Y10" forHTTPHeaderField:@"accessToken"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString* path = @"http://103.8.220.166:40000/commonapp/users/register";
    
    if ([self canConnectInternet]) {
        
        [manager POST:path parameters:userDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
            
            if ([status isEqualToString:@"00000"]) {
                
                // 3. 保存登录信息
                
                completion(YES, responseObject, nil);
                
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
}


- (void)testLoginWithSequenceId:(NSString*)sequenceId
                     andAccType:(AccType)accType
                     andloginId:(NSString*)loginId
                    andPassword:(NSString*)password
             andThirdpartyAppId:(NSString*)thirdPartyAppId
       andThirdpartyAccessToken:(NSString*)thirdPartyAccessToken
                   andLoginType:(LoginType)loginType
                       callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
//        NSString* md5Password = [MyTool stringToMD5:password];
        
        // 1. 将参数序列化
        NSNumber* acctp = [NSNumber numberWithInteger:accType];
        NSNumber* logintp = [NSNumber numberWithInteger:loginType];
        NSDictionary* paramsDict = @{
                                     @"sequenceId" : sequenceId,
                                     @"accType": acctp,
                                     @"loginId" : loginId,
                                     @"password" : password,
                                     @"thirdpartyAppId" : thirdPartyAppId == nil ? [NSNull null] : thirdPartyAppId,
                                     @"thirdpartyAccessToken" : thirdPartyAccessToken == nil ? [NSNull null] : thirdPartyAccessToken,
                                     @"loginType" : logintp
                                     };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        
        // 这里配置Header信息和accessToken等
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        
        [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"appId"];
        [manager.requestSerializer setValue:AppKey forHTTPHeaderField:@"appKey"];
        [manager.requestSerializer setValue:AppVersion forHTTPHeaderField:@"appVersion"];
        [manager.requestSerializer setValue:[DataCenter sharedInstance].clientId forHTTPHeaderField:@"clientId"];
        manager.requestSerializer.timeoutInterval = 120;
        
        NSString* accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
        if (accessToken != nil) {
            [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
        }
        [manager.requestSerializer setValue:@"TGT3CVCJEYK9WJRB2Q5DNZFGOK9Y10" forHTTPHeaderField:@"accessToken"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        NSString* path = @"http://103.8.220.166:40000/security/userlogin";
        
        [manager POST:path parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
            NSLog(@"%@", responseObject[@"retInfo"]);
            if ([status isEqualToString:@"00000"]) {
                
                NSLog(@"%@", operation.response.allHeaderFields);
                
                
                // 3. 保存登录信息
//                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//                [userDefaults setObject:responseObject[@"userBaseID"] forKey:@"userBaseId"];
//                [userDefaults setObject:responseObject[@"accessToken"] forKey:@"accessToken"];
//                [userDefaults setObject:password forKey:@"password"];
//                [userDefaults synchronize];
                
                completion(YES, responseObject, nil);
            } else {
                completion(NO, responseObject, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:responseObject[@"err"]]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            completion(NO, nil, error);
            
        }];
        
    } else {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeConnectInternetFailed andDescription:nil]);
    }
    
}


-(void)getCookbookDetailWithTagIDs:(NSArray*)tagids
                           andPage:(NSInteger)page
                          andlimit:(NSInteger)limit{
}

@end































