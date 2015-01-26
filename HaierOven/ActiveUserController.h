//
//  ActiveUserController.h
//  HaierOven
//
//  Created by 刘康 on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@interface ActiveUserController : BaseViewController

/**
 *  手机号, 邮箱
 */
@property (copy, nonatomic) NSString* activeMethod;

/**
 *  登录ID类型
 */
@property (nonatomic) AccType accType;

/**
 *  是不是注册时激活，如果是，则需自动登录
 */
@property (nonatomic) BOOL registerFlag;

/**
 *  登录密码
 */
@property (copy, nonatomic) NSString* password;

@end
