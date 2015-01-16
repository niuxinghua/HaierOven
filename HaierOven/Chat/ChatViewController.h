//
//  ChatViewController.h
//  HaierOven
//
//  Created by 刘康 on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"

@interface ChatViewController : JSQMessagesViewController

/**
 *  聊天对象的userBaseId
 */
@property (copy, nonatomic) NSString* toUserId;

/**
 *  聊天对象的名字
 */
@property (copy, nonatomic) NSString* toUserName;


@end
