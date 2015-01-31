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

@property (weak, nonatomic) IBOutlet UILabel *ovenSettingLabel;

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
    NSString* ovenInfo = [oven.ovenInfo isKindOfClass:[NSNull class]] ? @"" : oven.ovenInfo[@"name"];
    
    self.ovenInfoLabel.text = ovenInfo;
    
    self.ovenSettingLabel.text = [NSString stringWithFormat:@"模式:%@ 温度:%@ 时间:%@分钟", oven.roastStyle, oven.roastTemperature, oven.roastTime];
    
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
