//
//  CookbookSectionHeaderView.h
//  HaierOven
//
//  Created by 刘康 on 14/12/27.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CurrentContentType) {
    CurrentContentTypeFoods = 0,        //食材
    CurrentContentTypeMethods,     //做法
    CurrentContentTypeComment,       //评论
};

@interface CookbookSectionHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame andCurrentContentType:(CurrentContentType)type;

@end
