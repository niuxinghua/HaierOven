//
//  Creator.h
//  HaierOven
//
//  Created by Admin on 14/12/24.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Creator : NSObject

/**
 *  菜谱创建人
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  创建人ID
 */
@property (copy, nonatomic) NSString* userBaseId;

/**
 *  姓名
 */
@property (copy, nonatomic) NSString* userName;

/**
 *  头像
 */
@property (copy, nonatomic) NSString* avatarPath;


@end
