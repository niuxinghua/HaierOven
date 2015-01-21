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
@property (strong, nonatomic) NSDate *orderDate;
@end
