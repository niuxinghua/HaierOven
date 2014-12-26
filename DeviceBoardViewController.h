//
//  DeviceBoardViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DeviceBoardStatus)
{
    DeviceBoardStatusStart          = 1,
    DeviceBoardStatusClose          = 2,
    DeviceBoardStatusChoseModel     = 3,
    DeviceBoardStatusOpen           = 4,

};


@interface DeviceBoardViewController : UITableViewController

@property (nonatomic) DeviceBoardStatus deviceBoardStatus;

@end
