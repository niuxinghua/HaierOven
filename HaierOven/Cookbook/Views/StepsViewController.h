//
//  StepsViewController.h
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithCookbookDetail:(CookbookDetail*)cookbookDetail;

@end
