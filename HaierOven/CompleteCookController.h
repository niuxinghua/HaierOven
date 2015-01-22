//
//  CompleteCookController.h
//  HaierOven
//
//  Created by dongl on 14/12/26.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, CompleteTye) {
    CompleteTyeCook   = 1,
    CompleteTyeWarmUp = 2,
};
@interface CompleteCookController : BaseViewController
@property (nonatomic) CompleteTye completeTye;

@property (strong, nonatomic)uSDKDevice* myOven;

@end
