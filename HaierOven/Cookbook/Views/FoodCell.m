//
//  FoodCell.m
//  HaierOven
//
//  Created by 刘康 on 14/12/30.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "FoodCell.h"

@interface FoodCell ()


@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *foodDescLabel;

@end

@implementation FoodCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setFood:(Food *)food
{
    _food = food;
    self.foodNameLabel.text = food.name;
    self.foodDescLabel.text = food.desc;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
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
    [path moveToPoint:CGPointMake(0, 1)];
    [path addLineToPoint:CGPointMake(self.right, 1)];
    path.lineWidth = 1;
    [[UIColor whiteColor] setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
    
}

@end








