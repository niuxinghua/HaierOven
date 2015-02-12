//
//  OrderAlertView.h
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderAlertView;
@protocol OrderAlertViewDelegate <NSObject>

-(void)SettingOrder:(NSDate*)date;
-(void)OrderAlertViewHidden;

@end
@interface OrderAlertView : UIView
@property (weak, nonatomic)id<OrderAlertViewDelegate>delegate;

/**
 *  烘焙时长，根据此参数计算最小预约时间点
 */
@property (nonatomic) NSTimeInterval minimumInteval;

/**
 *  显示的时候一定要设置默认时间
 */
- (void)setDefaultDate;


@end
