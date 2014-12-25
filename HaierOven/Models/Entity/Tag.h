//
//  Tag.h
//  HaierOven
//
//  Created by 刘康 on 14/12/22.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

/**
 *  tagID
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  标签名
 */
@property (copy, nonatomic) NSString* name;

/**
 *  是否热门标签
 */
@property (nonatomic) BOOL isHot;

/**
 *  是否已删除
 */
@property (nonatomic) BOOL isDeleted;


@end
