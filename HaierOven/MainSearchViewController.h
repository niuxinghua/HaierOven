//
//  MainSearchViewController.h
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
#import "BaseViewController.h"

@interface MainSearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate, searchViewDelegate,UITextFieldDelegate>

@end
