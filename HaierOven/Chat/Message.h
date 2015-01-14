//
//  Message.h
//  HaierOven
//
//  Created by 刘康 on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentUser.h"

@interface Message : NSObject

/**
 *  消息ID
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  发送时间
 */
@property (copy, nonatomic) NSString* createdTime;

/**
 *  是否已读
 */
@property (nonatomic) BOOL isRead;

/**
 *  消息内容
 */
@property (copy, nonatomic) NSString* content;

/**
 *  发送者
 */
@property (strong, nonatomic) CommentUser* fromUser;

/**
 *  发送的对象
 */
@property (strong, nonatomic) CommentUser* toUser;


@end












