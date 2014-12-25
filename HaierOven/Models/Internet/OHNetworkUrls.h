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
#define BaseUrl   @"http://115.29.8.251:8080/haieroven/app"


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
















#pragma mark - 文件

#define DownloadFile    [NSString stringWithFormat:@"http://51keman.edaysoft.cn/%@", @"File/Download"]

#define UploadFile    [NSString stringWithFormat:@"http://51keman.edaysoft.cn/%@", @"File/Upload"]

// 个人信息隐私政策
#define GetPolicy       @"http://loveaction.qiniudn.com/Policy.html"

#endif



