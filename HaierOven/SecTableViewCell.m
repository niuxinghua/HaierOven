//
//  SecTableViewCell.m
//  HaierOven
//
//  Created by dongl on 14/12/16.
//  Copyright (c) 2014年 edaysoft. All rights reserved.
//

#import "SecTableViewCell.h"

@implementation SecTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.rightButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGPoint center = CGPointZero;
    center = self.laftIconButton.center;
    center.y = self.height / 2;
    self.laftIconButton.center = center;
    
    center = self.centerLabel.center;
    center.y = self.height / 2;
    self.centerLabel.center = center;
    
    center = self.rightButton.center;
    center.x = self.width/2+50;
    center.y = self.height / 2;
    self.rightButton.center = center;
    

    self.bottomLineView.frame = CGRectMake(self.left, center.y*2-1, self.width,1);
}

- (IBAction)infoButtonTapped:(UIButton *)sender
{
    [self.delegate infoButtonTapped];
}



@end



