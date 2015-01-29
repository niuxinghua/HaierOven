//
//  DescCell.m
//  HaierOven
//
//  Created by 刘康 on 15/1/4.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "DescCell.h"

@implementation DescCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}


@end
