//
//  PurchaseFood.h
//  HaierOven
//
//  Created by 刘康 on 15/1/9.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseFood : NSObject

/**
 *  购物清单食物index
 */
@property (copy, nonatomic) NSString* index;

/**
 *  物品名称
 */
@property (copy, nonatomic) NSString* name;

/**
 *  物品描述
 */
@property (copy, nonatomic) NSString* desc;

/**
 *  是否已购买
 */
@property (nonatomic) BOOL isPurchase;



@end
