//
//  Friend.h
//  HaierOven
//
//  Created by 刘康 on 15/1/23.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  描述粉丝或者关注的人的类
 */
@interface Friend : NSObject

/**
 *  菜谱数量
 */
@property (nonatomic) NSInteger cookbookAmount;

/**
 *  粉丝数量
 */
@property (nonatomic) NSInteger fansAmount;

/**
 *  是否已关注
 */
@property (nonatomic) BOOL isFollowed;

/**
 *  签名
 */
@property (copy, nonatomic) NSString* signature;

/**
 *  头像地址
 */
@property (copy, nonatomic) NSString* avatar;

/**
 *  用户ID
 */
@property (copy, nonatomic) NSString* userBaseId;

/**
 *  用户级别
 */
@property (copy, nonatomic) NSString* uerLevel;

/**
 *  姓名/昵称
 */
@property (copy, nonatomic) NSString* userName;


@end




