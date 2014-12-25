//
//  ContainerView.m
//  HaierOven
//
//  Created by dongl on 14/12/17.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "ContainerView.h"
#define TOP 12

@implementation ContainerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, TOP)];
    [path addLineToPoint:CGPointMake(25,TOP)];
    [path addLineToPoint:CGPointMake(35,3)];
    [path addLineToPoint:CGPointMake(45,TOP)];
    [path addLineToPoint:CGPointMake(self.frame.size.width,TOP)];
    [path addLineToPoint:CGPointMake(self.frame.size.width,97)];
    [path addLineToPoint:CGPointMake(0,97)];
    [path addLineToPoint:CGPointMake(0, TOP)];
    
    [path closePath];
    //    path.lineWidth = 1;
    //    [[UIColor grayColor] setStroke];
    //    [path stroke];

    [GlobalOrangeColor setFill];
    [path fill];
    
    CGContextRestoreGState(context);

    // Drawing code
}


@end
