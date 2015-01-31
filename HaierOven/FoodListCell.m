//
//  FoodListCell.m
//  HaierOven
//
//  Created by dongl on 14/12/18.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "FoodListCell.h"

@implementation FoodListCell

- (void)awakeFromNib {
    self.cookerAvater.layer.cornerRadius = self.cookerAvater.frame.size.height/2;
    self.cookerAvater.layer.masksToBounds = YES;
    self.cookerAvater.userInteractionEnabled = YES;
    //    [self.avaterImage.layer setBorderWidth:1]; //边框宽度
    [self.cookerAvater.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCookbook:(Cookbook *)cookbook
{
    _cookbook = cookbook;
    
    //[self.cookerAvater setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:cookbook.creator.avatarPath]];
    [self.cookerAvater setImageWithURL:[NSURL URLWithString:cookbook.creator.avatarPath]];
    self.foodNameLabel.text = cookbook.name;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@人赞过", cookbook.praises];
    [self.foodImage setImageWithURL:[NSURL URLWithString:cookbook.coverPhoto]];
    
}

@end
