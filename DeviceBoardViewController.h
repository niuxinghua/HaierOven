//
//  DeviceBoardViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, DeviceBoardStatus)
{
    /**
     *  运行模式
     */
    DeviceBoardStatusWorking          = 1,
    /**
     *  关机模式
     */
    DeviceBoardStatusClosed          = 2,
    /**
     *  选择烘焙模式
     */
    DeviceBoardStatusSelectMode     = 3,
    /**
     *  开机模式
     */
    DeviceBoardStatusOpened           = 4,
    /**
     *  停止运行
     */
    DeviceBoardStatusStop           = 5,
    /**
     *  预约状态
     */
    DeviceBoardStatusOrdering       = 6

};


@interface DeviceBoardViewController : BaseTableViewController

@property (nonatomic) DeviceBoardStatus deviceBoardStatus;
/**
 *  本地当前烤箱对象，Model可根据此对象构建uSDKDevice对象，从而控制烤箱
 */
@property (strong, nonatomic) LocalOven* currentOven;


@end
