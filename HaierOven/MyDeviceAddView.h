//
//  MyDeviceAddView.h
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyDeviceAddView;
@protocol MyDeviceAddViewDelegate <NSObject>

-(void)AddDevice;

@end
@interface MyDeviceAddView : UIView
@property (weak, nonatomic) id<MyDeviceAddViewDelegate> delegate;
- (IBAction)addDevice:(id)sender;

@end
