//
//  AlertDatePicker.h
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertDatePicker;
@protocol AlertDatePickerDelegate <NSObject>
-(void)ChangeUserBrith:(NSString*)birthday;
-(void)UnEdit;
@end
@interface AlertDatePicker : UIView
@property (strong, nonatomic) UILabel *birthLabel;
@property (weak, nonatomic)id<AlertDatePickerDelegate>delegate;
@end
