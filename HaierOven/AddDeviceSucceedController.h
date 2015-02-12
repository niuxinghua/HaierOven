//
//  AddDeviceSucceedController.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddDeviceSucceedController : BaseViewController<UITextFieldDelegate>

/**
 *  绑定成功的设备
 */
@property (strong, nonatomic) uSDKDevice* bindedDevice;

@end
