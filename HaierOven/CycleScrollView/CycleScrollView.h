//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 刘康 on 14/11/16.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

@property (nonatomic , readonly) UIScrollView *scrollView;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 * 数据源：获取总的page个数，如果少于2个，不自动滚动，这之前需要设置pageControlMiddle的值，默认为否
 */
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);

/**
 *  pageControl是否是在中间显示
 */
@property (nonatomic) BOOL pageControlMiddle;

/**
 * 数据源：获取第pageIndex个位置的contentView
 */
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

/**
 * 当点击的时候，执行的block
 */
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

@end