//
//  DeviceWorkView.h
//  HaierOven
//
//  Created by dongl on 14/12/24.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineProgressView.h"
@interface DeviceWorkView : UIView
@property (strong, nonatomic)LineProgressView *lineProgressView;
@property (strong, nonatomic)UILabel *timeLabel;

@property (nonatomic, strong) NSString * leftTime;
@property (nonatomic)float animationDuration;
@end
