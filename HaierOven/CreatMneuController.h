//
//  CreatMneuController.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreatMneuController;

@interface CreatMneuController : UITableViewController
@property (strong, nonatomic) NSArray *tags;

@property (strong, nonatomic) UIImage* cookbookCoverPhoto;

@property (strong, nonatomic) CookbookDetail* cookbookDetail;

@end
