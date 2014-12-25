//
//  MainViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@interface MainViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)NSArray *tags;
@end
