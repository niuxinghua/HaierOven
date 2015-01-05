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

- (void)turnDeal;
- (void)RegisterWithPhone:(BOOL)isSucceed;
- (void)turnBack;
- (void)alertError:(NSString *)string;

@end
@interface EmailRegisterView : UIView
@property (weak, nonatomic)id<EmailRegisterViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *tempHight;

@end
