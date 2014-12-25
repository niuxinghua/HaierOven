//
//  BaseTableViewController.h
//  众筹
//
//  Created by 刘康 on 14/11/13.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseTableViewController : UITableViewController
{
    //    NSMutableArray *_requests;
    UIWindow *_tipWindow;
}

@property (nonatomic, strong)MBProgressHUD *progressHUD;
@property (nonatomic, assign)BOOL isCancelButton;
@property (nonatomic, assign)BOOL isBackButton;

/**
 *  设置左侧BarButtonItem, 图片和标题有且仅能有一个，另一个传nil
 *
 *  @param imageName  图片名称
 *  @param title      标题
 *  @param customView 一般是按钮
 */
- (void)setLeftBarButtonItemWithImageName:(NSString*)imageName andTitle:(NSString*)title andCustomView:(UIView*)customView;

/**
 *  设置右侧BarButtonItem, 图片和标题有且仅能有一个，另一个传nil
 *
 *  @param imageName  图片名称
 *  @param title      标题
 *  @param customView 一般是按钮
 */
- (void)setRightBarButtonItemWithImageName:(NSString*)imageName andTitle:(NSString*)title andCustomView:(UIView*)customView;

/**
 *  提示网络加载
 *
 *  @param isShow 显示或者隐藏
 */
- (void)showLoading:(BOOL)isShow;

/**
 *  使用HUD
 *
 *  @param text          提示文字
 *  @param dimBackground
 */
- (void)showProgressHUDWithLabelText:(NSString *)text dimBackground:(BOOL)dimBackground;

/**
 *  完成时提示信息
 *
 *  @param text  提示文字
 *  @param delay 显示时长
 */
- (void)showProgressCompleteWithLabelText:(NSString *)text afterDelay:(NSTimeInterval)delay;

/**
 *  发生错误时提示信息
 *
 *  @param text  提示文字
 *  @param delay 显示时长
 */
- (void)showProgressErrorWithLabelText:(NSString *)text afterDelay:(NSTimeInterval)delay;

/**
 *  隐藏HUD
 */
- (void)hiddenProgressHUD;

/**
 *  状态栏上的提示
 *
 *  @param show  是否提示
 *  @param title 提示信息
 */
- (void)showStatusTip:(BOOL)show title:(NSString *)title;

@end
