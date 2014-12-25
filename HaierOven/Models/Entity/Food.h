//
//  Food.h
//  HaierOven
//
//  Created by Admin on 14/12/24.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

/**
 *  食材ID
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  食材序号
 */
@property (copy, nonatomic) NSString* index;

/**
 *  所在菜谱ID
 */
@property (copy, nonatomic) NSString* cookbookID;

/**
 *  食材名称
 */
@property (copy, nonatomic) NSString* name;

/**
 *  食材描述："500g"
 */
@property (copy, nonatomic) NSString* desc;


@end
