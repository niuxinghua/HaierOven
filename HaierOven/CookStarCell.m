//
//  CookStarCell.m
//  HaierOven
//
//  Created by dongl on 15/1/5.
//  Copyright (c) 2015年 edaysoft. All rights reserved.
//

#import "CookStarCell.h"

@implementation CookStarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)follow:(UIButton *)sender {
    sender.selected = sender.selected == NO? YES:NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.avaterImageView.layer.cornerRadius = self.avaterImageView.height/2;
    self.avaterImageView.layer.masksToBounds = YES;
 }
@end
