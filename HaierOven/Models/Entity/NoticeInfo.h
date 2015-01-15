//
//  NoticeInfo.h
//  HaierOven
//
//  Created by 刘康 on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInfo : NSObject


@property (copy, nonatomic) NSString* createdTime;


@property (copy, nonatomic) NSString* ID;

/**
 *  通知类型。1：赞菜谱；2：评论菜谱；3：新的私信
 */
@property (nonatomic) NSInteger type;


@property (copy, nonatomic) NSString* objectID;


/**
 *  是否已读
 */
@property (nonatomic) BOOL isRead;


@property (strong, nonatomic) CommentUser* promoter;


@property (copy, nonatomic) NSString* relatedDesc;

@property (copy, nonatomic) NSString* relatedId;





@end
