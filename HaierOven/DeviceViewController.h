//
//  DeviceViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DeviceUnconnectController.h"

@interface DeviceViewController : UIViewController <DeviceUnconnectControllerDelegate>
@property (strong, nonatomic) NSArray *myDevices;
@end
