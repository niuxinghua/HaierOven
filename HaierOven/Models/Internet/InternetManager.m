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
    } else {
        NSLog(@"网络已连接");
        self.canConnectToInternetFlag = YES;
    }
    
}

- (BOOL)canConnectInternet{
    BOOL canConnectWebsite = NO;
    for (int loop = 0; loop < 10; loop++) {
        
        if (self.canConnectToInternetFlag) {
            canConnectWebsite = YES;
            break;
        }
        
        Reachability *r = [Reachability reachabilityForInternetConnection];
        switch ([r currentReachabilityStatus]) {
            case NotReachable:
                // 没有网络连接
                NSLog(@"无法连接到网络");
                break;
            case ReachableViaWWAN:
                // 使用3G网络
                NSLog(@"3G网络连接到网络");
                canConnectWebsite = YES;
                break;
            case ReachableViaWiFi:
                // 使用WiFi网络
                NSLog(@"WiFi连接到网络");
                canConnectWebsite = YES;
                break;
        }
        
        if (canConnectWebsite) {
            canConnectWebsite = YES;
            break;
        } else {
            [NSThread sleepForTimeInterval:0.2];
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
    
    [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"appId"];
    [manager.requestSerializer setValue:AppKey forHTTPHeaderField:@"appKey"];
    [manager.requestSerializer setValue:AppVersion forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:[DataCenter sharedInstance].clientId forHTTPHeaderField:@"clientId"];
    
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    if (accessToken != nil) {
        [manager.requestSerializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
    }
    
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
    if ([predicate evaluateWithObject:password]) {
        completion(NO, nil, [self errorWithCode:InternetErrorCodeDefaultFailed andDescription:@"密码不合法，请输入5-16位数字和字母"]);
        return;
    }
    
    // 2. 将密码进行MD5加密
    NSString* md5Password = [MyTool stringToMD5:password];
    
    // 3. 序列化为字典
    NSDictionary* userDict = @{@"password":md5Password,
                               @"user":@{
                                        @"userBase":@{
                                                @"loginName":@"",
                                                @"email":email == nil ? @"" : email,
                                                @"mobile":phone == nil ? @"" : phone,
                                                @"accType":@0
                                                },
                                        @"userProfile":@{
                                                @"nickName":@"",
                                                @"userName":@"",
                                                @"points":@"0",
                                                @"focusCount":@"0",
                                                @"followCount":@"0"
                                                }
                                        }
                               };
    
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
                                    @"uvc" : uvc
                                    };
        
        // 2. 发送网络请求
        [[self manager] POST:UserActivate parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
        
        NSString* md5Password = [MyTool stringToMD5:password];
        
        // 1. 将参数序列化
        NSNumber* acctp = [NSNumber numberWithInteger:accType];
        NSNumber* logintp = [NSNumber numberWithInteger:loginType];
        NSDictionary* paramsDict = @{
                                     @"sequenceId" : sequenceId,
                                     @"accType": acctp,
                                     @"loginId" : loginId,
                                     @"password" : md5Password,
                                     @"thirdpartyAppId" : thirdPartyAppId,
                                     @"thirdpartyAccessToken" : thirdPartyAccessToken,
                                     @"loginType" : logintp
                                    };
        
        // 2. 发送网络请求，登录Header需要appId,appKey,appVersion,clientId, accessToken为空
        [[self manager] POST:UserLogin parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                // 3. 保存登录信息
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:responseObject[@"userBaseID"] forKey:@"userBaseId"];
                [userDefaults setObject:responseObject[@"accessToken"] forKey:@"accessToken"];
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

- (void)getVerCodeWithLoginName:(NSString*)loginName
                andValidateType:(ValidateType)validateType
               andValidateScene:(ValidateScene)scene
                     andAccType:(AccType)accType
               andTransactionId:(NSString*)transactionId
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
                                     @"transactionId" : transactionId
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
        
        [[self manager] GET:GetUserInfo parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
            if ([status isEqualToString:@"1"]) {
                
                // 3. 将个人信息缓存本地
                [[DataCenter sharedInstance] saveUserInfoWithObject:responseObject];
                
                // 4. 解析Json字典
                id user = [DataParser parseUserWithDict:responseObject];
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

#pragma mark - 添加菜谱评论

- (void)addCommentWithCookbookId:(NSString*)cookbookId andUserBaseid:(NSString*)userBaseId andComment:(NSString*)content callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : cookbookId,
                                     @"comment" : content,
                                     @"userBaseID" : userBaseId
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:GetFans parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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


- (void)getCookbooksWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion
{
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSNumber* currentPage = [NSNumber numberWithInteger:pageIndex];
        NSDictionary* paramsDict = @{
                                     @"userId" : userBaseId,     //UsrId
                                     @"limit" : @PageLimit,     //每页行数
                                     @"page" : currentPage,     //当前请求的页数
//                                     @"containsTotalCount" : @YES //是否包含总页数
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

- (void)getCookbookDetailWithCookbookId:(NSString*)cookbookId callBack:(myCallback)completion
{
    
    if ([self canConnectInternet]) {
        
        // 1. 将参数序列化
        NSDictionary* paramsDict = @{
                                     @"cookbookID" : cookbookId,     //关键字
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
            tagDict[@"tagID"] = tag.ID;
            [tags addObject:tagDict];
        }
        NSMutableArray* steps = [NSMutableArray array];
        for (Step* step in cookbookDetail.steps) {
            NSMutableDictionary* stepDict = [NSMutableDictionary dictionary];
            stepDict[@"stepPhoto"] = step.photo;
            stepDict[@"stepDesc"] = step.desc;
            stepDict[@"stepIndex"] = step.index;
            [steps addObject:stepDict];
        }
        NSMutableArray* foods = [NSMutableArray array];
        for (Food* food in cookbookDetail.steps) {
            NSMutableDictionary* foodDict = [NSMutableDictionary dictionary];
            foodDict[@"foodName"] = food.name;
            foodDict[@"foodDesc"] = food.desc;
            foodDict[@"cookbookFoodIndex"] = food.index;
            [foods addObject:foodDict];
        }
        NSMutableDictionary* creatorDict = [NSMutableDictionary dictionary];
        creatorDict[@"id"] = cookbookDetail.creator.ID;
        creatorDict[@"userName"] = cookbookDetail.creator.userName;
        creatorDict[@"userAvatar"] = cookbookDetail.creator.avatarPath;
        
        NSDictionary* paramsDict = @{@"cookbookName" : cookbookDetail.name,
                                     @"cookbookDesc" : cookbookDetail.desc,
                                     @"cookbookCoverPhoto" : cookbookDetail.coverPhoto,
                                     @"cookbookTip" : cookbookDetail.cookbookTip,
                                     @"tags" : tags,
                                     @"steps" : steps,
                                     @"foods" : foods,
                                     @"oven" : cookbookDetail.oven,
                                     @"creator" : creatorDict
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:AddCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
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
            tagDict[@"tagID"] = tag.ID;
            [tags addObject:tagDict];
        }
        NSMutableArray* steps = [NSMutableArray array];
        for (Step* step in cookbookDetail.steps) {
            NSMutableDictionary* stepDict = [NSMutableDictionary dictionary];
            stepDict[@"stepPhoto"] = step.photo;
            stepDict[@"stepDesc"] = step.desc;
            stepDict[@"stepIndex"] = step.index;
            [steps addObject:stepDict];
        }
        NSMutableArray* foods = [NSMutableArray array];
        for (Food* food in cookbookDetail.steps) {
            NSMutableDictionary* foodDict = [NSMutableDictionary dictionary];
            foodDict[@"foodName"] = food.name;
            foodDict[@"foodDesc"] = food.desc;
            foodDict[@"cookbookFoodIndex"] = food.index;
            [foods addObject:foodDict];
        }
        NSMutableDictionary* creatorDict = [NSMutableDictionary dictionary];
        creatorDict[@"id"] = cookbookDetail.creator.ID;
        creatorDict[@"userName"] = cookbookDetail.creator.userName;
        creatorDict[@"userAvatar"] = cookbookDetail.creator.avatarPath;
        
        NSDictionary* paramsDict = @{@"cookbookName" : cookbookDetail.name,
                                     @"cookbookDesc" : cookbookDetail.desc,
                                     @"cookbookCoverPhoto" : cookbookDetail.coverPhoto,
                                     @"cookbookTip" : cookbookDetail.cookbookTip,
                                     @"tags" : tags,
                                     @"steps" : steps,
                                     @"foods" : foods,
                                     @"oven" : cookbookDetail.oven,
                                     @"creator" : creatorDict
                                     };
        
        // 2. 发送网络请求
        [[self manager] POST:UpdateCookbook parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString* status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            
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



@end































