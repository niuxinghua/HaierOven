//
//  DeviceConnectProgressView.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
@interface DeviceConnectProgressView : UIView
@property (strong, nonatomic)LDProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *wifiStatusImage;
@end
