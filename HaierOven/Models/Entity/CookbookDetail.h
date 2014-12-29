//
//  CookbookDetail.h
//  HaierOven
//
//  Created by 刘康 on 14/12/23.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cookbook.h"
#import "Food.h"
#import "Step.h"
#import "CookbookOven.h"

//{"status":1,"err":"","data":{"cookbookID":28,"cookbookName":"名称","cookbookDesc":"描述","cookbookCoverPhoto":"file/temp/64663631-31ab-4f9e-8e25-aa7765979d44.jpg","cookbookTip":"小贴士","status":1,"modifiedTime":1418910487000,"tags":[{"tagID":1,"tagName":"烘焙","isHot":null,"isDeleted":null},{"tagID":5,"tagName":"蒸菜","isHot":null,"isDeleted":null},{"tagID":6,"tagName":"微波","isHot":null,"isDeleted":null},{"tagID":7,"tagName":"巧克力","isHot":null,"isDeleted":null},{"tagID":8,"tagName":"饼干","isHot":null,"isDeleted":null}],"steps":[{"cookbookStepID":28,"stepIndex":0,"stepPhoto":"file/temp/c510943a-73b0-4ee3-8353-33649debf099.jpg","stepDesc":"步骤1","cookbookID":null},{"cookbookStepID":29,"stepIndex":1,"stepPhoto":"file/temp/c510943a-73b0-4ee3-8353-33649debf099.jpg","stepDesc":"步骤2","cookbookID":null}],"foods":[{"cookbookFoodsID":33,"cookbookFoodIndex":0,"cookbookID":null,"foodName":"牛肉","foodDesc":"500g"},{"cookbookFoodsID":34,"cookbookFoodIndex":1,"cookbookID":null,"foodName":"生姜","foodDesc":"20g"}],"ovens":[{"name":"烤箱1","id":null},{"name":"烤箱2","id":null}],"creator":{"id":4,"userName":"33","userAvatar":"file/temp/cff87d3e-8ccf-4a7d-bcad-6601cc6ecdd7.jpg"}}}








@interface CookbookDetail : NSObject

/**
 *  菜谱ID
 */
@property (copy, nonatomic) NSString* cookbookId;

/**
 *  菜谱名称
 */
@property (copy, nonatomic) NSString* name;

/**
 *  菜谱描述
 */
@property (copy, nonatomic) NSString* desc;

/**
 *  封面图片
 */
@property (copy, nonatomic) NSString* coverPhoto;

/**
 *  小贴士
 */
@property (copy, nonatomic) NSString* cookbookTip;

/**
 *  菜谱状态 0为草稿箱， 1为已发布
 */
@property (copy, nonatomic) NSString* status;

/**
 *  修改时间
 */
@property (copy, nonatomic) NSString* modifiedTime;

/**
 *  菜谱标签，里面放的是Tag对象
 */
@property (strong, nonatomic) NSArray* tags;

/**
 *  步骤，里面放的是Step对象
 */
@property (strong, nonatomic) NSArray* steps;

/**
 *  食材，里面放的时Food对象
 */
@property (strong, nonatomic) NSArray* foods;

/**
 *  Oven字典：{"name":"烤箱1","id":null}
 */
@property (strong, nonatomic) CookbookOven* oven;

/**
 *  菜谱创建人
 */
@property (strong, nonatomic) Creator* creator;

@end





















