//
//  GenderAlertView.h
//  HaierOven
//
//  Created by dongl on 15/1/14.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GenderAlertView;
@protocol GenderAlertViewDelegate <NSObject>

-(void)chooseGender:(NSInteger)gender;

@end
@interface GenderAlertView : UIView
@property (weak, nonatomic)id<GenderAlertViewDelegate>delegate;
@end
