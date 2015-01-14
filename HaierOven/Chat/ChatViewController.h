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
 *  一定要在跳转此页面之前拿到留言信息，否则无法正确显示留言
 */
@property (strong, nonatomic) NSMutableArray* messages;


@end
