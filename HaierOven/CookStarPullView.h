//
//  CookStarPullView.h
//  HaierOven
//
//  Created by 刘康 on 15/1/31.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CookStarPullView;
@protocol CookStarPullViewDelegate <NSObject>

-(void)showMoreTags;

@end
@interface CookStarPullView : UIView
@property (weak, nonatomic)id<CookStarPullViewDelegate>delegate;
@end
