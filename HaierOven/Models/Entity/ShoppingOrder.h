//
//  ShoppingOrder.h
//  HaierOven
//
//  Created by 刘康 on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseFood.h"

@interface ShoppingOrder : NSObject

/**
 *  所属菜谱ID
 */
@property (copy, nonatomic) NSString* cookbookID;

/**
 *  所属菜谱名称
 */
@property (copy, nonatomic) NSString* cookbookName;

/**
 *  购物清单创建人ID
 */
@property (copy, nonatomic) NSString* creatorId;

/**
 *  购物清单
 */
@property (strong, nonatomic) NSArray* foods;

@end
