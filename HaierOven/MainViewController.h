//
//  MainViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "TOLAdViewController.h"

@interface MainViewController : TOLAdViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)NSArray *tags;

@end
