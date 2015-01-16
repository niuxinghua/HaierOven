//
//  MyTool.h
//  众筹
//
//  Created by 刘康 on 14/11/17.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyTool : NSObject

/**
 *  字符串是否是整型
 *
 *  @param string 字符串
 *
 *  @return 是否为整型
 */
+ (BOOL)isPureInt:(NSString *)string;

/**
 *  字符串是否是float
 *
 *  @param string 字符串
 *
 *  @return 是否是float
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  字符串是否是电话号码
 *
 *  @param str 字符串
 *
 *  @return 是否是电话号码
 */
+ (BOOL)validateTelephone:(NSString *)str;

/**
 *  字符串是否是电子邮箱
 *
 *  @param candidate 字符串
 *
 *  @return 是否是邮箱
 */
+ (BOOL)validateEmail:(NSString *)candidate;

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
+ (NSString*)getCurrentTime;

/**
 *  金额小写转大写
 *
 *  @param numStr 输入金额
 *
 *  @return 返回大写
 */
+ (NSString *)converter:(NSString *)numStr;

/**
 *  将字符串进行MD5加密
 *
 *  @param str 普通字符串
 *
 *  @return 加密后的MD5字符串
 */
+ (NSString *)stringToMD5:(NSString *)str;

/**
 *  通过UIColor创建UIImage
 *
 *  @param color UIColor对象
 *
 *  @return 返回UIImage对象
 */
+ (UIImage*)createImageWithColor:(UIColor*)color;

/**
 *  根据文字获取UITextView的高度
 *
 *  @param textView
 *  @param strText
 *
 *  @return 高度
 */
+ (float)heightForTextView:(UITextView *)textView WithText:(NSString *)strText;

/**
 *  根据HTML string获取NSAttributedString 可能会耗时操作，需要放到子线程
 *
 *  @param htmlString
 *
 *  @return 返回结果
 */
+ (NSAttributedString*)getAttributedStringWithHTMLString:(NSString *)htmlString;

/**
 *  转换时间为距离现在多久
 *
 *  @param date NSDate
 *
 *  @return 返回转换结果
 */
+ (NSString *)formattedDateDescription:(NSDate*)date;


/**
 *  转换时间为距离现在多久
 *
 *  @param date NSDate
 *
 *  @return 返回转换结果
 */
+ (NSString *)intervalSinceNow:(NSDate *)theDate;


@end



