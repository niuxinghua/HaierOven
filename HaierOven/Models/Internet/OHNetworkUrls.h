//
//  OHNetworkUrls.h
//  酷学
//
//  Created by 刘康 on 14-9-4.
//  Copyright (c) 2014年 Edaysoft. All rights reserved.
//

#ifndef ___OHNetworkUrls_h
#define ___OHNetworkUrls_h


// Base url
#define BaseUrl         @"http://115.29.8.251:8080/haieroven/app"
#define BaseOvenUrl     @"http://115.29.8.251:8080/haieroven"

//#define BaseUhomeUrl    @"http://103.8.220.165:60000" //测试登录注册使用
#define BaseUhomeUrl    @"http://uhome.haier.net:6000/commonapp"




#pragma mark - 登录注册

/**
 *  用户注册
 */
#define UserRegister    [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/registerIn"]


/**
 *  用户激活
 */
#define UserActivate    [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/activate"]

/**
 *  用户登录
 */
#define UserLogin       [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/login"]

/**
 *  获取动态验证码
 */
#define GetVerifyCode       [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/vercode"]

/**
 *  用户退出登录
 */
#define UserLogout      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/exit"]


#pragma mark - 个人信息

/**
 *  获取用户信息
 */
#define GetUserInfo     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/get/userBaseID"]

/**
 *  修改邮箱
 */
#define UpdateEmail     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/update/email"]

/**
 *  修改手机号
 */
#define UpdatePhone     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/update/mobile"]

/**
 *  修改其他用户信息
 */
#define UpdateUserInfo     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/update"]

/**
 *  添加关注
 */
#define FollowAdd     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/follow/add"]

/**
 *  取消关注
 */
#define FollowDelete     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/follow/delete"]

/**
 *  获取关注列表
 */
#define GetFollows  [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/follow/get"]

/**
 *  获取粉丝列表
 */
#define GetFans  [NSString stringWithFormat:@"%@/%@", BaseUrl, @"user/fans/get"]


#pragma mark - 标签

/**
 *  获取所有标签
 */
#define GetTags  [NSString stringWithFormat:@"%@/%@", BaseUrl, @"tag/getTags"]

/**
 *  获取热门标签
 */
#define GetHotTags [NSString stringWithFormat:@"%@/%@", BaseUrl, @"tag/getHotTags"]

/**
 *  获取指定用户标签
 */
#define GetMyTags   [NSString stringWithFormat:@"%@/%@", BaseUrl, @"tag/getmytags"]


#pragma mark - 评论

/**
 *  添加菜谱评论
 */
#define AddCommentToCookBook    [NSString stringWithFormat:@"%@/%@", BaseUrl, @"comment/cookbook/add"]

/**
 *  获取菜谱评论
 */
#define GetCookbookComments     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"comment/cookbook/get/cookbookid"]


#pragma mark - 菜谱

/**
 *  获取所有菜谱
 */
#define GetAllCookbooks        [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/list"]

/**
 *  获取我的菜谱
 */
#define GetCookbooksByUserId        [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/myCookbooks"]

/**
 *  获取我关注的人菜谱
 */
#define GetFriendCookbooks      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/myfriends"]

/**
 *  根据标签获取菜谱
 */
#define GetCookbooksByTagIds      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/getbytagids"]

/**
 *  搜索菜谱
 */
#define SearchCookbook          [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/search"]

/**
 *  获取菜谱详情
 */
#define GetCookbookDetail          [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/get"]

/**
 *  添加菜谱
 */
#define AddCookbook         [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/add"]

/**
 *  修改菜谱
 */
#define UpdateCookbook      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/update"]

/**
 *  删除菜谱
 */
#define DeleteCookbook      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/delete"]

/**
 *  赞菜谱
 */
#define PraiseCookbook      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookbook/praise"]


#pragma mark - 购物车

/**
 *  保存购物车
 */
#define SaveShoppingOrder   [NSString stringWithFormat:@"%@/%@", BaseUrl, @"shoppingorder/save"]

/**
 *  批量删除购物车
 */
#define DeleteShoppingOrder     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"shoppingorder/batchdelete"]

/**
 *  获取购物车详情
 */
#define GetShoppingOrder    [NSString stringWithFormat:@"%@/%@", BaseUrl, @"shoppingorder/get/userbaseidandcookbookid"]

/**
 *  获取购物车列表
 */
#define GetShoppingList     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"shoppingorder/get/userbaseid"]


#pragma mark - 烘焙圈

/**
 *  获取未关注、推荐厨师列表
 */
#define GetRecommentCookerList  [NSString stringWithFormat:@"%@/%@", BaseUrl, @"cookcircle/getunfollow"]


#pragma mark - 厨神名人堂

#define GetCookerStars      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"marvellouschef/get"]


#pragma mark - 私信

/**
 *  发送站内消息
 */
#define SendMessage     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"message/send"]

/**
 *  更新消息状态为已读
 */
#define MessageHadRead      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"message/read"]

/**
 *  获取未读消息数量
 */
#define MessageCount        [NSString stringWithFormat:@"%@/%@", BaseUrl, @"message/count"]

/**
 *  获取指定消息接受者的消息列表
 */
#define GetMessageList      [NSString stringWithFormat:@"%@/%@", BaseUrl, @"message/getbytouser"]

/**
 *  获取指定消息接受者和指定发送者互相发送的消息列表
 */
#define GetChatMessages     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"message/getbytouserandfromuser"]


#pragma mark - 通知

/**
 *  更新指定用户ID所有通知状态为已读
 */
#define NotificationHadRead     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"noticfication/read"]

/**
 *  获取未读通知数量
 */
#define NotificationCount     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"noticfication/count"]

/**
 *  获取指定接受者的通知列表
 */
#define NotificationList     [NSString stringWithFormat:@"%@/%@", BaseUrl, @"noticfication/get"]





#pragma mark - 文件

#define DownloadFile    [NSString stringWithFormat:@"http://51keman.edaysoft.cn/%@", @"File/Download"]

#define UploadFile    [NSString stringWithFormat:@"%@", @"http://115.29.8.251:8080/haieroven/file/upload"]











// 个人信息隐私政策
#define GetPolicy       @"http://loveaction.qiniudn.com/Policy.html"

#endif



