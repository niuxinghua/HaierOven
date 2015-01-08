//
//  CookbookDetailControllerViewController.h
//  HaierOven
//
//  Created by 刘康 on 14/12/27.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Cookbook.h"

@interface CookbookDetailControllerViewController : BaseTableViewController

@property (strong, nonatomic) Cookbook* cookbook;

/**
 *  是否是菜谱预览
 */
@property (nonatomic) BOOL isPreview;

/**
 *  菜谱预览传过来的对象
 */
@property (strong, nonatomic) CookbookDetail* cookbookDetail;

@end
