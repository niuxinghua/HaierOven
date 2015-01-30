//
//  UIButton+EnlargeTouchArea.h
//  酷学钢琴
//
//  Created by 刘康 on 14-9-30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

- (CGRect) enlargedRect;

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event;

@end
