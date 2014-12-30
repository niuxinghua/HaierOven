//
//  DrawedButton.m
//  追爱行动
//
//  Created by 刘康 on 14/11/5.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import "DrawedButton.h"

#define MARGIN_TB      1.0     // 气泡上下外边距
#define MARGIN_LR      1.0     // 气泡左右外边距
#define CORNER         3.0     // 气泡圆角半径

#define PADDING        20.0     // 气泡内边距

@implementation DrawedButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // 为按钮画蓝色的框
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(MARGIN_LR, MARGIN_TB + CORNER)];
    [path addArcWithCenter:CGPointMake(MARGIN_LR + CORNER, MARGIN_TB + CORNER)
                    radius:CORNER
                startAngle:M_PI
                  endAngle:M_PI*3/2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - MARGIN_LR - CORNER, MARGIN_TB)];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width - MARGIN_LR - CORNER, MARGIN_TB + CORNER)
                    radius:CORNER
                startAngle:M_PI*3/2
                  endAngle:M_PI*2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - MARGIN_LR, self.bounds.size.height - MARGIN_TB - CORNER)];
    [path addArcWithCenter:CGPointMake(self.bounds.size.width - MARGIN_LR - CORNER, self.bounds.size.height - MARGIN_TB - CORNER)
                    radius:CORNER
                startAngle:0.
                  endAngle:M_PI/2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(MARGIN_LR + CORNER, self.bounds.size.height - MARGIN_TB)];
    [path addArcWithCenter:CGPointMake(MARGIN_LR + CORNER, self.bounds.size.height - MARGIN_TB - CORNER)
                    radius:CORNER
                startAngle:M_PI/2
                  endAngle:M_PI
                 clockwise:YES];
    
    [path closePath];
    UIColor* strokeColor = GlobalRedColor;
    [strokeColor setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
    
//    [self.titleLabel setMyFontWithSize:16.0];
//    [self setTitleColor:GlobalColor forState:UIControlStateNormal];
//    [self setTitleColor:GlobalColor forState:UIControlStateHighlighted];
//    [self setTitleColor:GlobalColor forState:UIControlStateSelected];
    
    
    
}


@end
