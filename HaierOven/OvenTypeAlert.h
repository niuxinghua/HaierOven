//
//  OvenTypeAlert.h
//  HaierOven
//
//  Created by 刘康 on 15/2/3.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OvenTypeAlertDelegate <NSObject>

@required
- (void)selectedOvenType:(NSString*)ovenType;

@end

@interface OvenTypeAlert : UIView

@property (weak, nonatomic) id <OvenTypeAlertDelegate> delegate;

@end
