//
//  BakedGroupController.h
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, BackGroupType) {
    BackGroupTypeFollowed = 1,
    BackGroupTypeAdvice   = 2,
};

typedef NS_ENUM(NSUInteger, ContentMode) {
    /**
     *  常规显示
     */
    ContentModeNormal,
    /**
     *  搜索结果显示
     */
    ContentModeSearch
};


@interface BakedGroupController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BackGroupType backGroupType;
@end
