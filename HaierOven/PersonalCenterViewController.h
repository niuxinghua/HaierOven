//
//  PersonalCenterViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) NSString* currentUserId;

@end
