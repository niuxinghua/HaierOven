//
//  OvenInfoCell.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "OvenInfoCell.h"

@interface OvenInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *ovenInfoLabel;


@end

@implementation OvenInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOven:(CookbookOven *)oven
{
    _oven = oven;
    self.ovenInfoLabel.text = [oven.ovenInfo isKindOfClass:[NSNull class]] ? @"" : oven.ovenInfo[@"name"];
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(self.right, 1)];
    path.lineWidth = 1;
    [[UIColor whiteColor] setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
    
}

@end
