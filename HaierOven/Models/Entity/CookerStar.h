//
//  CookerStar.h
//  HaierOven
//
//  Created by 刘康 on 15/1/13.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookerStar : NSObject

/**
 *  厨神ID
 */
@property (copy, nonatomic) NSString* userBaseId;

/**
 *  厨神头像
 */
@property (copy, nonatomic) NSString* avatar;

/**
 *  首页厨神背景
 */
@property (copy, nonatomic) NSString* chefBackgroundImageUrl;

/**
 *  姓名
 */
@property (copy, nonatomic) NSString* userName;

/**
 *  个性签名
 */
@property (copy, nonatomic) NSString* signature;

/**
 *  个人介绍
 */
@property (copy, nonatomic) NSString* introduction;

/**
 *  是否关注
 */
@property (nonatomic) BOOL isFollowed;

/**
 *  级别
 */
@property (nonatomic) NSInteger userLevel;

/**
 *  视频介绍连接
 */
@property (copy, nonatomic) NSString* videoPath;

/**
 *  视频封面
 */
@property (copy, nonatomic) NSString* videoCover;

/**
 *  菜谱数量
 */
@property (nonatomic) NSInteger cookbookAmount;

@end





