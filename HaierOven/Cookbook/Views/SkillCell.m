//
//  SkillCell.m
//  HaierOven
//
//  Created by 刘康 on 15/1/30.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "SkillCell.h"

@interface SkillCell ()




@end

@implementation SkillCell

- (void)awakeFromNib {
    // Initialization code
    self.startCookBtn.layer.masksToBounds = YES;
    self.startCookBtn.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (IBAction)startCookTapped:(UIButton *)sender
{
    [self.delegate startCook];
}


@end
