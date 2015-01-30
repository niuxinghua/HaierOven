//
//  Cookbook.h
//  HaierOven
//
//  Created by 刘康 on 14/12/23.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Creator.h"

//[{"cookbookID":5,"cookbookName":"菜谱名称aaa","cookbookDesc":"关于菜谱aaa","cookbookCoverPhoto":"file/temp/cff87d3e-8ccf-4a7d-bcad-6601cc6ecdd7.jpg","modifiedTime":1418733412000,"creator":{"id":4,"userName":"33","userAvatar":"file/temp/cff87d3e-8ccf-4a7d-bcad-6601cc6ecdd7.jpg"},"praises":0},{"cookbookID":18,"cookbookName":"菜谱名称aaa","cookbookDesc":"关于菜谱aaa","cookbookCoverPhoto":"file/temp/cff87d3e-8ccf-4a7d-bcad-6601cc6ecdd7.jpg","modifiedTime":1418733412000,"creator":{"id":4,"userName":"33","userAvatar":"file/temp/cff87d3e-8ccf-4a7d-bcad-6601cc6ecdd7.jpg"},"praises":0}]



@interface Cookbook : NSObject

/**
 *  菜谱ID
 */
@property (copy, nonatomic) NSString* ID;

/**
 *  名称
 */
@property (copy, nonatomic) NSString* name;

/**
 *  关于菜谱
 */
@property (copy, nonatomic) NSString* desc;

/**
 *  封面图片
 */
@property (copy, nonatomic) NSString* coverPhoto;

/**
 *  修改时间
 */
@property (copy, nonatomic) NSString* modifiedTime;

/**
 *  菜谱创建人
 */
@property (strong, nonatomic) Creator* creator;

/**
 *  赞的数量
 */
@property (copy, nonatomic) NSString* praises;


@property (nonatomic) BOOL isAuthority;


@end










































