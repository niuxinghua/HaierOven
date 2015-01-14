//
//  Cooker.h
//  HaierOven
//
//  Created by 刘康 on 15/1/12.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cookbook.h"


@interface Cooker : NSObject


@property (copy, nonatomic) NSString* userBaseId;


@property (copy, nonatomic) NSString* userName;

/**
 *  1：天子一号 2：厨神名人 3：推荐达人
 */
@property (nonatomic) NSInteger userLevel;

/**
 *  签名档
 */
@property (copy, nonatomic) NSString* signature;


@property (copy, nonatomic) NSString* fansAmount;


@property (nonatomic) BOOL isFollowed;

/**
 *  头像完整路径
 */
@property (copy, nonatomic) NSString* avatar;


/**
 *  Cookbook对象
 */
@property (strong, nonatomic) NSArray* cookbooks;



@end
