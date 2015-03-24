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
    if (oven.ovenType.length == 0) { //烤箱类型为空，表示非厨神菜谱
        NSString* ovenInfo = [oven.ovenInfo isKindOfClass:[NSNull class]] ? @"" : oven.ovenInfo[@"name"];
        
        self.ovenInfoLabel.text = ovenInfo;
        
        NSString* ovenSetting = @"";
        if (![oven.roastStyle isEqualToString:@""]) {
            ovenSetting = [ovenSetting stringByAppendingFormat:@"模式:%@ ", oven.roastStyle];
        }
        if (![oven.roastTemperature isEqualToString:@""]) {
            ovenSetting = [ovenSetting stringByAppendingFormat:@"温度:%@° ", oven.roastTemperature];
        }
        if (![oven.roastTime isEqualToString:@""]) {
            ovenSetting = [ovenSetting stringByAppendingFormat:@"时间:%@分钟", oven.roastTime];
        }
        
        self.ovenSettingLabel.text = ovenSetting;
    } else {
        self.ovenInfoLabel.text = oven.ovenType;
        self.ovenSettingLabel.text = @"";
    }
    
    
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
