//
//  UnderLineButton.m
//  HaierOven
//
//  Created by dongl on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "UnderLineButton.h"
#import "UIView+Sizes.h"
@implementation UnderLineButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.height - 4)];
    [path addLineToPoint:CGPointMake(self.width, self.height - 4)];
//    [path addLineToPoint:CGPointMake(self.right, self.bottom - 2)];
    
    path.lineWidth = 1;
    [UIColorFromRGB(0x0080FF) setStroke];
    [path stroke];
    
//    [[UIColor blueColor] setFill];
//    [path fill];
    
    CGContextRestoreGState(context);}


@end
