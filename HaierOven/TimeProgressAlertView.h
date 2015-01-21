//
//  TimeProgressAlertView.h
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeProgressAlertView;
@protocol TimeProgressAlertViewDelegate <NSObject>

-(void)HiddenClockAlert;
-(void)StopClock;
-(void)TimeOutAlertShow;
@end
@interface TimeProgressAlertView : UIView
@property (nonatomic) NSInteger seconds;
@property (nonatomic) BOOL start;
@property (weak, nonatomic)id<TimeProgressAlertViewDelegate>delegate;
@end
