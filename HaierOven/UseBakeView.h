//
//  UseBakeView.h
//  HaierOven
//
//  Created by dongl on 15/1/19.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UseBakeView;
@protocol UseBakeViewDelegate <NSObject>

-(void)getUseDeviceDataWithWorkModel:(NSString*)workmodel
                             andTime:(NSString*)time
                             andTemperature:(NSString*)temperature;
@end

@interface UseBakeView : UIView
@property (weak, nonatomic)id<UseBakeViewDelegate>delegate;
@end
