//
//  CommentUser.h
//  HaierOven
//
//  Created by 刘康 on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentUser : NSObject

/**
 *  用户ID
 */
@property (copy, nonatomic) NSString* userBaseId;

/**
 *  用户名
 */
@property (copy, nonatomic) NSString* loginName;

/**
 *  昵称
 */
@property (copy, nonatomic) NSString* nickName;

/**
 *  真实姓名
 */
@property (copy, nonatomic) NSString* userName;

/**
 *  签名档
 */
@property (copy, nonatomic) NSString* signature;

/**
 *  用户级别
 */
@property (copy, nonatomic) NSString* userLevel;

/**
 *  用户头像
 */
@property (copy, nonatomic) NSString* userAvatar;

@end



