//
//  BakedGroupController.h
//  HaierOven
//
//  Created by dongl on 15/1/8.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BackGroupType) {
    BackGroupTypeFollowed = 1,
    BackGroupTypeAdvice   = 2,
};
@interface BakedGroupController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BackGroupType backGroupType;
@end
