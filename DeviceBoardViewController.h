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
    DeviceBoardStatusStart          = 1,
    /**
     *  关机模式
     */
    DeviceBoardStatusClose          = 2,
    /**
     *  选择烘焙模式
     */
    DeviceBoardStatusChoseModel     = 3,
    /**
     *  开机模式
     */
    DeviceBoardStatusOpen           = 4,

};


@interface DeviceBoardViewController : BaseTableViewController

@property (nonatomic) DeviceBoardStatus deviceBoardStatus;
/**
 *  本地当前烤箱对象，Model可根据此对象构建uSDKDevice对象，从而控制烤箱
 */
@property (strong, nonatomic) LocalOven* currentOven;


@end
