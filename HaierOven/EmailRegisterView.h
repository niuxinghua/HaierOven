//
//  EmailRegisterView.h
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmailRegisterView;
@protocol EmailRegisterViewDelegate <NSObject>

@required

- (void)turnDeal;

/**
 *  获取手机验证码
 *
 *  @param phone 手机号
 */
- (void)getVerifyCodeWithPhone:(NSString*)phone;

/**
 *  通过手机号注册
 *
 *  @param phone    手机号
 *  @param code     验证码
 *  @param password 密码
 */
- (void)RegisterWithPhone:(NSString*)phone andVerifyCode:(NSString*)code andPassword:(NSString*)password;

- (void)turnBack;

- (void)alertError:(NSString *)string;

@end
@interface EmailRegisterView : UIView
@property (weak, nonatomic)id<EmailRegisterViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *tempHight;

@end
