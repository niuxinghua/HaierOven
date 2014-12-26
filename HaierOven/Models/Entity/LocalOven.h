//
//  LocalOven.h
//  HaierOven
//
//  Created by 刘康 on 14/12/26.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalOven : NSObject

/**
 *  烤箱名字，默认为"我的烤箱"
 */
@property (copy, nonatomic) NSString* name;

/**
 *  上次烤箱的IP地址
 */
@property (copy, nonatomic) NSString* ip;

/**
 *  烤箱Mac地址
 */
@property (copy, nonatomic) NSString* mac;

/**
 *  烤箱标识符
 */
@property (copy, nonatomic) NSString* typeIdentifier;

/**
 *  烤箱属性
 */
@property (strong, nonatomic) NSDictionary* attribute;

/**
 *  转为字典保存本地
 *
 *  @return 字典
 */
- (NSDictionary*)toDictionary;

/**
 *  用字典构建对象
 *
 *  @param dict 字典
 *
 *  @return LocalOven对象
 */
+ (LocalOven*)localOvenWithDictionary:(NSDictionary*)dict;

@end
















