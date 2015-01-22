//
//  LeftMenuAlert.h
//  HaierOven
//
//  Created by dongl on 15/1/22.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftMenuAlert;
@protocol LeftMenuAlertDelegate <NSObject>

-(void)isGoingToLogin:(BOOL)goLogin;

@end
@interface LeftMenuAlert : UIView
@property (weak, nonatomic)id<LeftMenuAlertDelegate>delegate;
@end