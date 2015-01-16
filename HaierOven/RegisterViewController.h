//
//  RegisterViewController.h
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, RegisterType) {
    RegisterTypeEmail = 1,
    RegisterTypePhone = 2,

};

@interface RegisterViewController : BaseViewController
@property (nonatomic) RegisterType registerType;
@end
