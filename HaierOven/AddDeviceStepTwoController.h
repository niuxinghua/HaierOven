//
//  AddDeviceStepTwoController.h
//  HaierOven
//
//  Created by dongl on 14/12/22.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@interface AddDeviceStepTwoController : BaseViewController<UITextFieldDelegate>

/**
 *  如果是重新配置，currentMac为重新配置的设备的Mac
 */
@property (copy, nonatomic) NSString* currentMac;

@end
