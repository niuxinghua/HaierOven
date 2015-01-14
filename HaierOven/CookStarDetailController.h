//
//  CookStarDetailController.h
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@interface CookStarDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CookerStar* cookerStar;

@end
