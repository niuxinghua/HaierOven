//
//  DeviceBoardViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/23.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceBoardViewController : UITableViewController

/**
 *  本地当前烤箱对象，Model可根据此对象构建uSDKDevice对象，从而控制烤箱
 */
@property (strong, nonatomic) LocalOven* currentOven;

@end
