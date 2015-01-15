//
//  AlertPsdView.h
//  HaierOven
//
//  Created by dongl on 15/1/15.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertPsdView;
@protocol AlertPsdViewDelegate <NSObject>

-(void)ChangePsdError:(NSString*)error;
-(void)ChangeWithOldPsd:(NSString*)oldpsd
              andNewPsd:(NSString*)newpsd;
-(void)CancelChangePsd;

@end
@interface AlertPsdView : UIView
@property (weak, nonatomic)id<AlertPsdViewDelegate>delegate;
@end
