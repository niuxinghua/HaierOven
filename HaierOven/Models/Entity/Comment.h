//
//  Comment.h
//  HaierOven
//
//  Created by 刘康 on 14/12/22.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

/**
 *  评论Id
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  评论内容
 */
@property (copy, nonatomic) NSString* content;

/**
 *  菜谱Id
 */
@property (copy, nonatomic) NSString* objectId;

/**
 *  评论者登录名
 */
@property (copy, nonatomic) NSString* creatorLoginName;

/**
 *  评论者真实姓名
 */
@property (copy, nonatomic) NSString* creatorName;

/**
 *  评论者头像
 */
@property (copy, nonatomic) NSString* creatorAvatar;

/**
 *  评论时间
 */
@property (copy, nonatomic) NSString* modifiedTime;


@end
