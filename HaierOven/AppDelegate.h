//
//  AppDelegate.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
#import "UMSocialQQHandler.h"

typedef NS_ENUM(NSUInteger, InterfaceOrientationState) {
    InterfaceOrientationStateLandscapeOnly = 1,
    InterfaceOrientationStatePortraitOnly,
    InterfaceOrientationStateNormal,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic)InterfaceOrientationState orientationState;

/**
 *  是否从通知点进app的
 */
@property (nonatomic) BOOL hadTappedNotification;

/**
 *  后台运行执行码
 */
@property (nonatomic) UIBackgroundTaskIdentifier bgTaskIdentifier;


@end

