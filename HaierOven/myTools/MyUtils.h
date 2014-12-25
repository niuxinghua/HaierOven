//
//  MyUtils.h
//  追爱行动
//
//  Created by 刘康 on 14-10-10.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtils : NSObject

/**
 *  计算文本的大小
 *
 *  @param text      文本内容
 *  @param attribute 文本属性
 *
 *  @return 返回文本的size
 */
+ (CGSize)getTextSizeWithText:(NSString*)text andTextAttribute:(NSDictionary*)attribute andTextWidth:(CGFloat)width;

@end
