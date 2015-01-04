//
//  RegisterViewController.h
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RegisterType) {
    RegisterTypeEmail = 0,
    RegisterTypePhone = 1,

};

@interface RegisterViewController : UIViewController
@property (nonatomic) RegisterType registerType;
@end
