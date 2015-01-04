//
//  Comment.h
//  HaierOven
//
//  Created by 刘康 on 14/12/22.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentUser.h"

extern const CGFloat kAvatarSize;
extern const CGFloat kReplyButtonWidth;
extern const CGFloat kLineSpacing;
extern const CGFloat kCharacterSpacing;

#define CommentFont [UIFont fontWithName:GlobalTitleFontName size:14]

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
 *  评论者
 */
@property (strong, nonatomic) CommentUser* fromUser;

/**
 *  评论的对象
 */
@property (strong, nonatomic) CommentUser* toUser;

/**
 *  评论时间
 */
@property (copy, nonatomic) NSString* commentTime;

/**
 *  获取评论高度
 *
 *  @return 评论高度
 */
- (CGFloat)getHeight;

@end
