//
//  CompleteCookController.h
//  HaierOven
//
//  Created by dongl on 14/12/26.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CompleteTye) {
    CompleteTyeCook   = 1,
    CompleteTyeWarmUp = 2,
};
@interface CompleteCookController : UIViewController
@property (nonatomic) CompleteTye completeTye;
@end
