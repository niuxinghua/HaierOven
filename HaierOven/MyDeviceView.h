//
//  MyDeviceView.h
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyDeviceView;
@protocol MyDeviceViewDelegate <NSObject>

-(void)SelectDevice;

@end
@interface MyDeviceView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *deviceImage;
@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *connectStatusImage;
@property (weak, nonatomic)id<MyDeviceViewDelegate>delegate;
@end
