//
//  InternetManager.h
//  追爱行动
//
//  Created by 刘康 on 14-10-3.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHNetworkUrls.h"
#import "AFNetworking.h"
//#import "UIKit+AFNetworking.h"
#import "User.h"
#import "CookbookDetail.h"
#import "Tag.h"
#import "ShoppingOrder.h"
#import "CookerStar.h"
#import "NoticeInfo.h"


typedef NS_ENUM(NSInteger, InternetErrorCode) {
    InternetErrorCodeConnectInternetFailed      = -100,      //网络连接失败
    InternetErrorCodeRequestFailed,                          //网络请求失败
    InternetErrorCodeErrorMessageReturned,                   //返回错误信息
    InternetErrorCodeLoginExpired,                           //登录过期
    InternetErrorCodeDefaultFailed,                          //其他错误
};

/**
 *  验证方式
 */
typedef NS_ENUM(NSInteger, ValidateType) {
    /**
     *  手机号
     */
    ValidateTypePhone   = 1,
    /**
     *  邮箱
     */
    ValidateTypeEmail
};

/**
 *  验证场景
 */
typedef NS_ENUM(NSInteger, ValidateScene) {
    /**
     *  激活用户
     */
    ValidateSceneActiveUser     = 1,
    /**
     *  密码重置
     */
    ValidateSceneResetPassword,
    /**
     *  修改邮箱
     */
    ValidateSceneChangeEmail,
    /**
     *  修改手机号
     */
    ValidateScenePhone
};

/**
 *  登录ID类型
 */
typedef NS_ENUM(NSInteger, AccType) {
    /**
     *  海尔官网
     */
    AccTypeHaier    = 0,
    /**
     *  QQ
     */
    AccTypeQQ,
    /**
     *  微信
     */
    AccTypeWeixin,
    /**
     *  新浪
     */
    AccTypeSina,
    /**
     *  豆瓣
     */
    AccTypeDouban,
    /**
     *  人人
     */
    AccTypeRenRen,
    /**
     *  uHome用户
     */
    AccTypeUhome    = 99
};

/**
 *  海尔官网用户的登录类型
 */
typedef NS_ENUM(NSInteger, LoginType) {
    /**
     *  用户名登录
     */
    LoginTypeUserName = 0,
    /**
     *  手机号登录
     */
    LoginTypeMobile,
    /**
     *  邮箱登录
     */
    LoginTypeEmail
};


#define ErrorDomain     @"cn.edaysoft.51keman"

/**
 *  分页请求每页的数量
 */
#define PageLimit   10


@interface InternetManager : NSObject

typedef void (^myCallback) (BOOL success, id obj, NSError* error);

+ (InternetManager*)sharedManager;

#pragma mark - 检查网络状态

/**
 * 检查是否能连接网站
 */
- (BOOL)canConnectInternet;

/**
 *  当前网络环境是不是Wifi
 */
@property (nonatomic) BOOL isWiFiConnected;

#pragma mark - 登录注册

/**
 *  用户注册，邮箱或者手机号注册，至少传一个
 *
 *  @param email      邮箱
 *  @param phone      手机号
 *  @param password   密码
 *  @param completion 调用结果回调，调用失败可从error中（NSLocalizedDescriptionKey）获取错误描述信息
 */
- (void)registerWithEmail:(NSString*)email andPhone:(NSString*)phone andPassword:(NSString*)password callBack:(myCallback)completion;

/**
 *  激活用户, 注册成功后海尔会发个验证码到注册的手机，然后需要通过app激活，app只需要传入收到的uvc（验证码）和用户名(注册用户名、手机号或邮箱)
 *
 *  @param loginName     手机号、邮箱
 *  @param validateType  验证方式：手机号/邮箱
 *  @param scene         验证场景：激活，密码重置等
 *  @param accType       登录ID类型
 *  @param transactionId 获取激活码回传的事件id
 *  @param uvc           验证码信息
 *  @param completion    结果回调
 */
- (void)activateUserWithLoginName:(NSString*)loginName
                  andValidateType:(ValidateType)validateType
                 andValidateScene:(ValidateScene)scene
                       andAccType:(AccType)accType
                 andTransactionId:(NSString*)transactionId
                           andUvc:(NSString*)uvc
                         callBack:(myCallback)completion;


/**
 *  用户登录
 *
 *  @param sequenceId            <#sequenceId description#>
 *  @param accType               <#accType description#>
 *  @param loginId               用户名
 *  @param password              密码
 *  @param thirdPartyAppId       第三方登录AppId
 *  @param thirdPartyAccessToken 第三方登录AccessToken
 *  @param loginType             <#loginType description#>
 *  @param completion            登录结果回调
 */
- (void)loginWithSequenceId:(NSString*)sequenceId
                 andAccType:(AccType)accType
                 andloginId:(NSString*)loginId
                andPassword:(NSString*)password
         andThirdpartyAppId:(NSString*)thirdPartyAppId
   andThirdpartyAccessToken:(NSString*)thirdPartyAccessToken
               andLoginType:(LoginType)loginType
                   callBack:(myCallback)completion;

/**
 *  第三方登录接口
 *
 *  @param sequenceId            流水号
 *  @param accType               接入类型
 *  @param loginId               用户名
 *  @param password              密码
 *  @param thirdPartyAppId       第三方登录AppId
 *  @param thirdPartyAccessToken 第三方登录AccessToken
 *  @param loginType             登录类型
 *  @param nickName              昵称
 *  @param userAvatar            头像
 *  @param completion            结果回调
 */
- (void)loginWithSequenceId:(NSString*)sequenceId
                 andAccType:(AccType)accType
                 andloginId:(NSString*)loginId
                andPassword:(NSString*)password
         andThirdpartyAppId:(NSString*)thirdPartyAppId
   andThirdpartyAccessToken:(NSString*)thirdPartyAccessToken
               andLoginType:(LoginType)loginType
                   nickName:(NSString*)nickName
                 userAvatar:(NSString*)userAvatar
                   callBack:(myCallback)completion;

/**
 *  获取动态验证码
 *
 *  @param loginName     用户名
 *  @param validateType  <#validateType description#>
 *  @param validateScene <#validateScene description#>
 *  @param accType       <#accType description#>
 *  @param completion    结果回调
 */
- (void)getVerCodeWithLoginName:(NSString*)loginName
                andValidateType:(ValidateType)validateType
               andValidateScene:(ValidateScene)scene
                     andAccType:(AccType)accType
                       callBack:(myCallback)completion;

/**
 *  第三方登录信息补全
 *
 *  @param phone      手机号
 *  @param email      邮箱
 *  @param userName   姓名
 *  @param nickName   昵称
 *  @param completion 结果回调
 */
- (void)completeThirdPartyWithPassword:(NSString*)password
                                 phone:(NSString*)phone
                                 email:(NSString*)email
                              userName:(NSString*)userName
                              nickName:(NSString*)nickName
                              callBack:(myCallback)completion;


/**
 *  退出登录
 *
 *  @param loginName  登录名
 *  @param completion 结果回调
 */
- (void)logoutWithLoginName:(NSString*)loginName callBack:(myCallback)completion;


#pragma mark - 个人信息

/**
 *  根据userBaseId获取个人信息
 *
 *  @param userBaseId userBaseId
 *  @param completion 结果回调
 */
- (void)getUserInfoWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  修改邮箱
 *
 *  @param userBaseId
 *  @param email      新邮箱
 *  @param completion 结果回调
 */
- (void)updateEmailUserBaseId:(NSString*)userBaseId andEmail:(NSString*)email callBack:(myCallback)completion;

/**
 *  修改手机号
 *
 *  @param userBaseId
 *  @param phone      新手机号
 *  @param completion 结果回调
 */
- (void)updatePhoneUserBaseId:(NSString*)userBaseId andPhone:(NSString*)phone callBack:(myCallback)completion;

/**
 *  修改其他用户信息
 *
 *  @param user       用户对象
 *  @param completion 结果回调
 */
- (void)updateUserInfo:(User*)user callBack:(myCallback)completion;

/**
 *  检查今日是否签到
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)checkSignInWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  每日签到
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)signInWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  增加积分
 *
 *  @param score      增加的积分
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)addPoints:(NSInteger)score userBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  用户绑定设备
 *
 *  @param userBaseId 用户ID
 *  @param mac        设备MAC地址
 *  @param completion 结果回调
 */
- (void)bindOvenWithUserBaseId:(NSString*)userBaseId deviceMac:(NSString*)mac callBack:(myCallback)completion;

/**
 *  添加关注
 *
 *  @param userBaseId 用户Id
 *  @param userBaseId 被关注用户Id
 *  @param completion 结果回调
 */
- (void)addFollowWithUserBaseId:(NSString*)userBaseId andFollowedUserBaseId:(NSString*)followdUserBaseId callBack:(myCallback)completion;

/**
 *  取消关注
 *
 *  @param userBaseId 用户Id
 *  @param userBaseId 被关注用户Id
 *  @param completion 结果回调
 */
- (void)deleteFollowWithUserBaseId:(NSString*)userBaseId andFollowedUserBaseId:(NSString*)followdUserBaseId callBack:(myCallback)completion;

/**
 *  获取关注的人列表
 *
 *  @param userBaseId 用户Id
 *  @param pageIndex  当前请求的页数
 *  @param completion 结果回调
 */
- (void)getFollowersWithUserBaseId:(NSString*)userBaseId andPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取粉丝列表
 *
 *  @param userBaseId 用户Id
 *  @param pageIndex  当前请求页数
 *  @param completion 结果回调
 */
- (void)getFansWithUserBaseId:(NSString*)userBaseId andPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取是否关注
 *
 *  @param currentUserId 当前用户
 *  @param userBaseId    对方用户
 *  @param completion    结果回调
 */
- (void)currentUser:(NSString*)currentUserId followedUser:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  搜索用户
 *
 *  @param keyword    关键词
 *  @param pageIndex  当前请求页数
 *  @param userId     用户id
 *  @param completion 结果回调
 */
- (void)searchUsersWithKeyword:(NSString*)keyword pageIndex:(NSInteger)pageIndex userBaseId:(NSString*)userId callBack:(myCallback)completion;


#pragma mark - 标签

/**
 *  获取所有标签
 *
 *  @param completion 结果回调
 */
- (void)getTagsCallBack:(myCallback)completion;

/**
 *  获取热门标签
 *
 *  @param completion 结果回调
 */
- (void)getHotTagsCallback:(myCallback)completion;

/**
 *  获取指定用户的标签
 *
 *  @param userBaseId 用户id
 *  @param completion 结果回调
 */
- (void)getUserTagsWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;


#pragma mark - 评论

/**
 *  添加菜谱评论
 *
 *  @param cookbookId 菜谱ID
 *  @param userBaseId 用户ID
 *  @param content    评论内容
 *  @param parentId   如果是回复某评论，则此字段为被回复的评论主键
 *  @param completion 结果回调
 */
- (void)addCommentWithCookbookId:(NSString*)cookbookId andUserBaseId:(NSString*)userBaseId andComment:(NSString*)content parentId:(NSString*)parentId callBack:(myCallback)completion;

/**
 *  获取指定菜谱的评论
 *
 *  @param cookbookId 菜谱Id
 *  @param pageIndex  当前请求页数
 *  @param completion 结果回调
 */
- (void)getCommentsWithCookbookId:(NSString*)cookbookId andPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;


#pragma mark - 菜谱

/**
 *  获取所有菜谱
 *
 *  @param pageIndex  当前请求页数
 *  @param completion 结果回调
 */
- (void)getAllCookbooksWithPageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取我发布的菜谱
 *
 *  @param userBaseId 用户ID
 *  @param status     菜谱状态：-1为所有状态的菜谱 0为草稿 1为已发布
 *  @param pageIndex  获取页数
 *  @param completion 结果回调
 */
- (void)getCookbooksWithUserBaseId:(NSString*)userBaseId cookbookStatus:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取我关注的人菜谱
 *
 *  @param userBaseId 用户ID
 *  @param pageIndex  获取的页数
 *  @param completion 结果回调
 */
- (void)getFriendCookbooksWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取我赞过的菜谱
 *
 *  @param userBaseId 用户ID
 *  @param pageIndex  获取的页数
 *  @param completion 结果回调
 */
- (void)getMyPraisedCookbooksWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  根据标签获取菜谱
 *
 *  @param tagIds     标签数组
 *  @param pageIndex  获取的页数
 *  @param completion 结果回调
 */
- (void)getCookbooksWithTagIds:(NSArray*)tagIds pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  根据标签获取某个人的菜谱
 *
 *  @param tagIds     标签数组
 *  @param userBaseId 用户ID
 *  @param pageIndex  获取的页数
 *  @param completion 结果回调
 */
- (void)getCookbooksWithTagIds:(NSArray*)tagIds userBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;


/**
 *  搜索菜谱
 *
 *  @param keyword    搜索关键字
 *  @param pageIndex  当前请求页数
 *  @param completion 结果回调
 */
- (void)searchCookbooksWithKeyword:(NSString*)keyword pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取菜谱详情
 *
 *  @param cookbookId 菜谱ID
 *  @param completion 结果回调
 */
- (void)getCookbookDetailWithCookbookId:(NSString*)cookbookId userBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  添加菜谱
 *
 *  @param cookbookDetail   菜谱对象
 *  @param completion       结果回调
 */
- (void)addCookbookWithCookbook:(CookbookDetail*)cookbookDetail callBack:(myCallback)completion;

/**
 *  修改菜谱
 *
 *  @param cookbookDetail 菜谱对象
 *  @param completion     结果回调
 */
- (void)modifyCookbook:(CookbookDetail*)cookbookDetail callBack:(myCallback)completion;

/**
 *  删除菜谱
 *
 *  @param cookbookId 菜谱ID
 *  @param completion 结果回调
 */
- (void)deleteCookbookWithCookbookId:(NSString*)cookbookId callBack:(myCallback)completion;

/**
 *  赞菜谱
 *
 *  @param cookbookId 菜谱ID
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)praiseCookbookWithCookbookId:(NSString*)cookbookId userBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  取消赞菜谱
 *
 *  @param cookbookId 菜谱ID
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)cancelPraiseCookbook:(NSString*)cookbookId userBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

#pragma mark - 购物清单

/**
 *  保存购物清单
 *
 *  @param shoppingOrder 购物清单, 包括creatorId
 *  @param completion    结果回调
 */
- (void)saveShoppingOrderWithShoppingOrder:(ShoppingOrder*)shoppingOrder callBack:(myCallback)completion;

/**
 *  删除购物清单
 *
 *  @param userBaseId  用户ID
 *  @param cookbookIds 删除的购物清单列表
 *  @param completion  结果回调
 */
- (void)deleteShoppingOrderWithUserBaseId:(NSString*)userBaseId cookbooks:(NSArray*)cookbooks callBack:(myCallback)completion;

/**
 *  获取购物清单详情
 *
 *  @param userBaseId 用户ID
 *  @param cookbookId 购物清单ID
 *  @param completion 结果回调
 */
- (void)getShoppingOrderWithUserBaseId:(NSString*)userBaseId cookbookId:(NSString*)cookbookId callBack:(myCallback)completion;

/**
 *  获取购物清单列表
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)getShoppingListWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;


#pragma mark - 烘焙圈

/**
 *  获取未关注、推荐厨师列表
 *
 *  @param userBaseId 用户ID
 *  @param pageIndex  请求页面
 *  @param completion 结果回调
 */
- (void)getRecommentCookersWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;



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
- (void)getProductsWithCategory:(NSInteger)category sortType:(NSInteger)sortType pageIndex:(NSInteger)pageIndex keyword:(NSString*)keyword callBack:(myCallback)completion;



#pragma mark - 厨神名人堂

/**
 *  获取厨神列表
 *
 *  @param userBaseId 用户id
 *  @param pageIndex  请求的页面
 *  @param completion 结果回调
 */
- (void)getCookerStarsWithUserBaseId:(NSString*)userBaseId pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取推荐厨神
 *
 *  @param completion 结果回调
 */
- (void)getRecommendCookerStarsCallback:(myCallback)completion;

#pragma mark - 私信

/**
 *  发送站内消息
 *
 *  @param message    消息内容
 *  @param userBaseId 消息接受者
 *  @param fromUser   发送者
 *  @param completion 结果回调
 */
- (void)sendMessage:(NSString*)message toUser:(NSString*)userBaseId fromUser:(NSString*)fromUser callBack:(myCallback)completion;

/**
 * 	更新指定用户消息为已读
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)updateReadStatusWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  获取未读消息数量
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)getMessageCountWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  获取指定消息接受者的消息列表
 *
 *  @param userBaseId 用户ID
 *  @param status     -1:获取所有，0：未读，1：已读
 *  @param pageIndex  请求页面
 *  @param completion 结果回调
 */
- (void)getMessagesListWithUserBaseId:(NSString*)userBaseId status:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

/**
 *  获取指定消息接受者和指定发送者互相发送的消息列表
 *
 *  @param fromUser   发送者ID, 自己
 *  @param toUser     接受者ID
 *  @param status     -1:获取所有，0：未读，1：已读
 *  @param pageIndex  请求页面
 *  @param completion 结果回调
 */
- (void)getChatMessagesFromUser:(NSString*)fromUser toUser:(NSString*)toUser status:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;

#pragma mark - 通知

/**
 *  更新指定用户ID所有通知状态为已读
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)updateNotificationReadStatusWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  获取指定用户未读通知数量
 *
 *  @param userBaseId 用户ID
 *  @param completion 结果回调
 */
- (void)getNotificationCountWithUserBaseId:(NSString*)userBaseId callBack:(myCallback)completion;

/**
 *  获取指定接受者通知列表
 *
 *  @param userBaseId 用户ID
 *  @param status     是否已读；-1获取所有；0获取未读；1获取已读
 *  @param pageIndex  请求页面
 *  @param completion 结果回调
 */
- (void)getNotificationListWithUserBaseId:(NSString*)userBaseId status:(NSInteger)status pageIndex:(NSInteger)pageIndex callBack:(myCallback)completion;


#pragma mark - 设置

/**
 *  意见反馈
 *
 *  @param content    反馈内容
 *  @param phone      联系电话
 *  @param completion 结果回调
 */
- (void)feedbackWithContent:(NSString*)content phone:(NSString*)phone callBack:(myCallback)completion;

/**
 *  获取App下载路径
 *  @param completion 结果回调
 */
- (void)getAppStoreUrlCallback:(myCallback)completion;




#pragma mark - 文件

/**
 *  文件上传 上传文件到服务器临时文件夹，并返回已上传文件路径。支持多个文件同时上传。
 *
 *  @param data       文件Data
 *  @param completion 结果回调
 */
- (void)uploadFile:(NSData*)data callBack:(myCallback)completion;

/**
 *  下载广告显示控制plist
 */
- (void)downloadAdControlFile;






#pragma mark - 测试API接口使用

- (void)testRegisterWithEmail:(NSString*)email andPhone:(NSString*)phone andPassword:(NSString*)password callBack:(myCallback)completion;

- (void)testLoginWithSequenceId:(NSString*)sequenceId
                     andAccType:(AccType)accType
                     andloginId:(NSString*)loginId
                    andPassword:(NSString*)password
             andThirdpartyAppId:(NSString*)thirdPartyAppId
       andThirdpartyAccessToken:(NSString*)thirdPartyAccessToken
                   andLoginType:(LoginType)loginType
                       callBack:(myCallback)completion;


@end

































