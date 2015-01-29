//
//  LearnCookCell.m
//  HaierOven
//
//  Created by 刘康 on 15/1/29.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "LearnCookCell.h"

@implementation LearnCookCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.height - 1)];
    [path addLineToPoint:CGPointMake(self.width, self.height - 1)];
    path.lineWidth = 1;
    [RGB(230, 230, 230) setStroke];
    [path stroke];
    
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path appendPath:path2];
    [path2 moveToPoint:CGPointMake(0, 1)];
    [path2 addLineToPoint:CGPointMake(self.width, 1)];
    path2.lineWidth = 1;
    [RGB(230, 230, 230) setStroke];
    [path2 stroke];
    
    CGContextRestoreGState(context);
    
    
}

@end
