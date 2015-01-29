//
//  DeviceEditController.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface DeviceEditController : BaseTableViewController

@property (strong, nonatomic) LocalOven* currentOven;

@property (strong, nonatomic) uSDKDevice* myOven;

@end
