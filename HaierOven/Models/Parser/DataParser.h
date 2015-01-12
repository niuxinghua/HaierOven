//
//  DataParser.h
//  追爱行动
//
//  Created by 刘康 on 14-11-13.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "CookbookDetail.h"

@interface DataParser : NSObject

/**
 *  解析用户信息
 *
 *  @param dict json数据
 *
 *  @return 返回User对象
 */
+ (User*)parseUserWithDict:(NSDictionary*)dict;

/**
 *  解析关注/粉丝列表
 *
 *  @param dict        json数据
 *  @param hadNextPage 是否有下一页
 *
 *  @return 返回关注列表
 */
+ (NSMutableArray*)parseUsersWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage;


/**
 *  解析标签
 *
 *  @param dict json
 *
 *  @return 标签列表
 */
+ (NSMutableArray*)parseTagsWithDict:(NSDictionary*)dict;

/**
 *  解析评论
 *
 *  @param dict json
 *  @param hadNextPage 是否有下一页
 *
 *  @return 评论列表
 */
+ (NSMutableArray*)parseCommentsWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage;

/**
 *  解析菜谱
 *
 *  @param dict        json
 *  @param hadNextPage 是否有下一页
 *
 *  @return 菜谱列表
 */
+ (NSMutableArray*)parseCookbooksWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage;

/**
 *  解析菜谱详情
 *
 *  @param dict json
 *
 *  @return CookbookDetail
 */
+ (CookbookDetail*)parseCookbookDetailWithDict:(NSDictionary*)dict;

/**
 *  解析购物清单
 *
 *  @param dict json
 *
 *  @return 购物清单列表
 */
+ (NSMutableArray*)parseShoppingListWithDict:(NSDictionary*)dict;

/**
 *  解析推荐厨师列表
 *
 *  @param dict        json
 *  @param hadNextPage 是否有下一页
 *
 *  @return 推荐厨师列表
 */
+ (NSMutableArray*)parseCookersWithDict:(NSDictionary*)dict hadNextPage:(BOOL*)hadNextPage;

@end





















































