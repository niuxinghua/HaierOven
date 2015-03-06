//
//  CookStarDetailController.h
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@protocol cookStarDetailControllerDelegate <NSObject>

@required
- (void)cookerStarDidFollowd;

@end

@interface CookStarDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CookerStar* cookerStar;

@property (weak, nonatomic) id <cookStarDetailControllerDelegate> delegate;

@end
