//
//  TimeOutView.h
//  HaierOven
//
//  Created by dongl on 15/1/21.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeOutView;
@protocol TimeOutViewDelegate <NSObject>

-(void)timeOutAlertHidden;

@end
@interface TimeOutView : UIView
@property (weak, nonatomic)id<TimeOutViewDelegate>delegate;
@end
