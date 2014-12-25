//
//  Step.h
//  HaierOven
//
//  Created by Admin on 14/12/24.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Step : NSObject

/**
 *  步骤ID
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  步骤序号
 */
@property (copy, nonatomic) NSString* index;

/**
 *  步骤图片
 */
@property (copy, nonatomic) NSString* photo;

/**
 *  步骤描述
 */
@property (copy, nonatomic) NSString* desc;

/**
 *  所在菜谱的ID
 */
@property (copy, nonatomic) NSString* cookbookID;

@end
