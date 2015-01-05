//
//  PhoneRegisterView.h
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhoneRegisterView;
@protocol  PhoneRegisterViewDelegate<NSObject>

- (void)turnDealEmail;
- (void)RegisterWithEmail:(BOOL)isSucceed;
- (void)turnBackEmail;
- (void)alertErrorEmail:(NSString *)string;

@end
@interface PhoneRegisterView : UIView
@property (strong, nonatomic) IBOutlet UIView *tempHight;
@property (weak, nonatomic)id<PhoneRegisterViewDelegate>delegate;

@end
