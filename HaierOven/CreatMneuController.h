//
//  CreatMneuController.h
//  HaierOven
//
//  Created by dongl on 14/12/29.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@class CreatMneuController;

@interface CreatMneuController : BaseTableViewController
@property (strong, nonatomic) NSMutableArray *tags;

@property (strong, nonatomic) UIImage* cookbookCoverPhoto;

@property (strong, nonatomic) CookbookDetail* cookbookDetail;

/**
 *  若是从草稿箱跳转过来，可通过此对象获取CookbookDetail
 */
@property (strong, nonatomic) Cookbook* cookbook;

/**
 *  是不是从草稿箱跳过来的
 */
@property (nonatomic) BOOL isDraft;

@end
