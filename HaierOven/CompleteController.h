//
//  CompleteController.h
//  HaierOven
//
//  Created by 刘康 on 15/1/22.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@interface CompleteController : BaseViewController

/**
 *  第三方登录的openId, 登录时传的password与openid一致
 */
@property (copy, nonatomic) NSString* loginId;

@end
