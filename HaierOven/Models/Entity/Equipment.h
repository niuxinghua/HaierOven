//
//  Equipment.h
//  HaierOven
//
//  Created by 刘康 on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Equipment : NSObject

/**
 *  分类
 */
@property (copy, nonatomic) NSString* category;

/**
 *  设备ID
 */
@property (copy, nonatomic) NSString* productId;

/**
 *  价格
 */
@property (copy, nonatomic) NSString* price;

/**
 *  名称
 */
@property (copy, nonatomic) NSString* name;

/**
 *  海尔商城的对应连接
 */
@property (copy, nonatomic) NSString* url;

/**
 *  图片n
 */
@property (copy, nonatomic) NSString* imagePath;






@end
